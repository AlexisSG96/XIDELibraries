/**
  LIN Master Driver
	
  Company:
    Microchip Technology Inc.

  File Name:
    lin_master.c

  Summary:
    LIN Master Driver

  Description:
    This source file provides the driver for LIN master nodes

 */

/*
    (c) 2016 Microchip Technology Inc. and its subsidiaries. You may use this
    software and any derivatives exclusively with Microchip products.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE, OR ITS INTERACTION WITH MICROCHIP PRODUCTS, COMBINATION
    WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
    BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
    FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
    ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
    THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF THESE
    TERMS.
*/

#include "lin_master.h"
#include "../${uartFunctions["uartheader"]}"
#include "../${timerFunctions["timerHeader"]}"

static void (*LIN_processData)(void);

static lin_packet_t LIN_packet;
static lin_rxpacket_t LIN_rxPacket;
bool LIN_txReady = false;
const lin_cmd_packet_t* schedule;
uint8_t scheduleLength;

static uint8_t LIN_timeout = 10;
static uint8_t LIN_period = 0;
static bool LIN_timerRunning = false;
static bool LIN_enablePeriodTx = false;
static volatile uint8_t LIN_timerCallBack = 0;
static volatile uint8_t LIN_periodCallBack = 0;


void LIN_init(uint8_t tableLength, const lin_cmd_packet_t* const table, void (*processData)(void)){
    schedule = table;
    scheduleLength = tableLength;
    LIN_processData = processData;
    LIN_stopTimer();
    LIN_setTimerHandler();

    LIN_startPeriod();
}

void LIN_queuePacket(uint8_t cmd, uint8_t* data){
    const lin_cmd_packet_t* tempSchedule = schedule;    //copy table pointer so we can modify it

    for(uint8_t i = 0; i < scheduleLength; i++){
        if(cmd == tempSchedule->cmd){
            break;
        }
        tempSchedule++;    //go to next entry
    }
    
    //clear previous data
    memset(LIN_packet.rawPacket, 0, sizeof(LIN_packet.rawPacket));
    
    //Add ID
    LIN_packet.PID = LIN_calcParity(tempSchedule->cmd);

    if(tempSchedule->type == TRANSMIT){
        //Build Packet - User defined data
        //add data
        if(tempSchedule->length > 0){
            LIN_packet.length = tempSchedule->length;
            memcpy(LIN_packet.data, data, tempSchedule->length);
        } else {
            LIN_packet.length = 1; //send dummy byte for checksum
            LIN_packet.data[0] = 0xAA;
        }

        //Add Checksum
<#if (checksumSetting=="Classic")>
        LIN_packet.checksum = LIN_getChecksum(LIN_packet.length, LIN_packet.data);
<#else>
        LIN_packet.checksum = LIN_getChecksum(LIN_packet.length, LIN_packet.PID, LIN_packet.data);
</#if>

    } else { //Rx packet
        LIN_rxPacket.rxLength = tempSchedule->length; //data length for rx data processing
        LIN_rxPacket.cmd = tempSchedule->cmd; //command for rx data processing
        LIN_rxPacket.timeout = tempSchedule->timeout;
    }
    
    LIN_txReady = true;
}

lin_state_t LIN_handler(void){
    static lin_state_t LIN_state = LIN_IDLE;
    
    //State Machine
    switch(LIN_state){
        case LIN_IDLE:
            if(LIN_txReady == true){
                LIN_txReady = false;
                LIN_disableRx();   //disable EUSART rx
                //Send Transmission
                LIN_sendPacket();
                LIN_state = LIN_TX_IP;
            } else {
                //No Transmission to send
            }
            break;
        case LIN_TX_IP:
            //Transmission currently in progress.
            if(${uartFunctions["TXIE"]} == 0){
                if(${uartFunctions["TRMT"]} == 1){
                    //Packet transmitted
                    if(LIN_rxPacket.rxLength > 0){
                        //Need data returned?
                        LIN_startTimer(LIN_rxPacket.timeout);
                        LIN_enableRx();   //enable EUSART rx
                        LIN_state = LIN_RX_IP;
                    } else {
                        LIN_state = LIN_IDLE;
                    }
                }
            }
            break;
        case LIN_RX_IP:
            //Receiving Packet within window
            if(LIN_timerRunning == false){
                //Timeout
                LIN_state = LIN_IDLE;
                memset(LIN_rxPacket.rawPacket, 0, sizeof(LIN_rxPacket.rawPacket));  //clear receive data
            } else if(${uartFunctions["DataReady"]}()){
                if(LIN_receivePacket() == true){
                    //All data received and verified
                    LIN_disableRx();   //disable EUSART rx
                    LIN_state = LIN_RX_RDY;
                }
            }
            break;
        case LIN_RX_RDY:
            //Received Transmission
            LIN_processData();
            LIN_state = LIN_IDLE;
            break;
    }
    return LIN_state;
}

bool LIN_receivePacket(void){
    static uint8_t rxIndex = 0;

    if(rxIndex < LIN_rxPacket.rxLength){
        //save data
        LIN_rxPacket.data[rxIndex++] = ${uartFunctions["Read"]}();
        NOP();
    } else {
        rxIndex = 0;
        //calculate checksum
<#if (checksumSetting=="Classic")>
        if(${uartFunctions["Read"]}() == LIN_getChecksum(LIN_rxPacket.rxLength, LIN_rxPacket.data))
<#else>
        if(${uartFunctions["Read"]}() == LIN_getChecksum(LIN_rxPacket.rxLength, LIN_packet.PID, LIN_rxPacket.data))
</#if>        
            return true;
            
    }
    //still receiving
    return false;
}

void LIN_sendPacket(void){
    //Build Packet - LIN required data
    //Add Break
    LIN_sendBreak();
    ${uartFunctions["Write"]}(0x00); //send dummy transmission
    //Add Preamble
    ${uartFunctions["Write"]}(0x55);
    //Add ID
    ${uartFunctions["Write"]}(LIN_packet.PID);

    if(LIN_rxPacket.rxLength == 0){ //not receiving data
        //Build Packet - User defined data
        //add data
        for(uint8_t i = 0; i < LIN_packet.length; i++){
            ${uartFunctions["Write"]}(LIN_packet.data[i]);
        }
        //Add Checksum
        ${uartFunctions["Write"]}(LIN_packet.checksum);
    }
}

uint8_t LIN_getPacket(uint8_t* data){
    uint8_t cmd = LIN_rxPacket.cmd & 0x3F;
    
    memcpy(data, LIN_rxPacket.data, sizeof(LIN_rxPacket.data));
    memset(LIN_rxPacket.rawPacket, 0, sizeof(LIN_rxPacket.rawPacket));  //clear receive data

    return cmd;
}

uint8_t LIN_calcParity(uint8_t CMD){
    lin_pid_t PID;
    PID.rawPID = CMD;

    //Workaround for compiler bug - CAE_MCU8-200:
//    PID.P0 = PID.ID0 ^ PID.ID1 ^ PID.ID2 ^ PID.ID4;
//    PID.P1 = ~(PID.ID1 ^ PID.ID3 ^ PID.ID4 ^ PID.ID5);
    PID.P0 = PID.ID0 ^ PID.ID1;
    PID.P0 = PID.P0 ^ PID.ID2;
    PID.P0 = PID.P0 ^ PID.ID4;
    PID.P1 = PID.ID1 ^ PID.ID3;
    PID.P1 = PID.P1 ^ PID.ID4;
    PID.P1 = PID.P1 ^ PID.ID5;
    PID.P1 = ~PID.P1;
    
    return PID.rawPID;
}

<#if (checksumSetting=="Classic")>
uint8_t LIN_getChecksum(uint8_t length, uint8_t* data){
    uint16_t checksum = 0;
    
    for (uint8_t i = 0; i < length; i++){
        checksum = checksum + *data++;
        if(checksum > 0xFF)
            checksum -= 0xFF;
    }
    checksum = ~checksum;
    
    return (uint8_t)checksum;
}
<#else>
uint8_t LIN_getChecksum(uint8_t length, uint8_t pid, uint8_t* data){
    uint16_t checksum = pid;
    
    for (uint8_t i = 0; i < length; i++){
        checksum = checksum + *data++;
        if(checksum > 0xFF)
            checksum -= 0xFF;
    }
    checksum = ~checksum;
    
    return (uint8_t)checksum;
}
</#if> 

void LIN_startTimer(uint8_t timeout){
    LIN_timeout = timeout;
    ${timerFunctions["WriteTimer"]}(0);
    ${timerFunctions["StartTimer"]}();
    LIN_timerRunning = true;
}

void LIN_timerHandler(void){

    if(LIN_timerRunning == true){
        if (++LIN_timerCallBack >= LIN_timeout){
            // ticker function call
            LIN_stopTimer();
        }
    }
    if(LIN_enablePeriodTx == true){
        if(++LIN_periodCallBack >= LIN_period){
            LIN_sendPeriodicTx();
        }
    }
        
}

void LIN_setTimerHandler(void){
    ${timerFunctions["SetInterruptHandler"]}(LIN_timerHandler);
}

void LIN_stopTimer(void){
    // reset ticker counter
    LIN_timerCallBack = 0;
    LIN_timerRunning = false;
}

void LIN_startPeriod(void){
    LIN_enablePeriodTx = true;
}

void LIN_stopPeriod(void){
    // reset ticker counter
    LIN_periodCallBack = 0;
    LIN_enablePeriodTx = false;
}

void LIN_enableRx(void){
    ${uartFunctions["CREN"]} = 1;
    ${uartFunctions["RCIE"]} = 1;
}

void LIN_disableRx(void){
    ${uartFunctions["CREN"]} = 0;
    ${uartFunctions["RCIE"]} = 0;
}

void LIN_sendBreak(void){
    ${uartFunctions["SENDB"]} = 1;
}

void LIN_sendPeriodicTx(void){
    static volatile uint8_t scheduleIndex = 0;
    const lin_cmd_packet_t* periodicTx;    //copy table pointer so we can modify it
    
    LIN_periodCallBack = 0;
    periodicTx = schedule + scheduleIndex;
    
    if(periodicTx->period > 0){
        LIN_queuePacket(periodicTx->cmd, periodicTx->data);
    }
    
    do{ //Go to next valid periodic command
        if(++scheduleIndex >= scheduleLength){
            scheduleIndex = 0;
        }
        periodicTx = schedule + scheduleIndex;
    } while(periodicTx->period == 0);
    
    LIN_period = periodicTx->period;
}