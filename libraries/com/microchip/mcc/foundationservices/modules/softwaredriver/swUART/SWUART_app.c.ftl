/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "swuart.h"
#include "${pinHeader}"
#include "${timerHeader}"

// Constant definitions to compensate for hardware- and software- introduced delays
#define ONE_BIT_DELAY_COMP   21      // TODO: Modify based on oscillator accuracy
#define HALF_BIT_DELAY_COMP  60      // TODO: Modify based on oscillator accuracy

// Defines for SWUART FIFO buffer
#define ${moduleNameUpperCase}_RX_BUFFER_SIZE   ${rxBufferSize}
#define ${moduleNameUpperCase}_TX_BUFFER_SIZE   ${txBufferSize}

// Variable declarations for SWUART TX buffer
static uint8_t ${moduleNameLowerCase}TxHead = 0;
static uint8_t ${moduleNameLowerCase}TxTail = 0;
static uint8_t ${moduleNameLowerCase}TxBuffer[${moduleNameUpperCase}_TX_BUFFER_SIZE];
volatile uint8_t ${moduleNameLowerCase}TxBufferRemaining;
static uint8_t ${moduleNameLowerCase}TxBitCount, ${moduleNameLowerCase}TxData;

// Variable declarations for SWUART RX buffer
static uint8_t ${moduleNameLowerCase}RxHead = 0;
static uint8_t ${moduleNameLowerCase}RxTail = 0;
static uint8_t ${moduleNameLowerCase}RxBuffer[${moduleNameUpperCase}_RX_BUFFER_SIZE];
volatile uint8_t ${moduleNameLowerCase}RxCount;
static volatile uint8_t ${moduleNameLowerCase}RxBitCount, ${moduleNameLowerCase}RxData; 

// Variable declaration for break reception
static volatile uint8_t brkCount;

<#if (enableAutobaud=="enabled")>
// Variable declaration for autobaud detection
static volatile uint8_t overflowCount;
</#if>

// Declarations for timer reload
static uint8_t oneBitReload, halfBitReload;

// Declarations for serial states
static volatile serial_state_t serialState;
<#if (enableAutobaud=="enabled")>
static volatile serial_rcv_state_t serialRcvState;
</#if>

// Extern declaration
extern volatile uint8_t timer0ReloadVal;

// Pointer declaration
volatile uint8_t *tmrReload;

// Initialization code for SWUART
void ${moduleNameUpperCase}_Initialize (void){
    ${moduleNameUpperCase}_SetTimerInterruptHandler();
    ${moduleNameUpperCase}_SetIOCNHandler();
<#if (enableAutobaud=="enabled")>
    serialRcvState = RCV_UART_DATA;
</#if>
    serialState = SERIAL_IDLE;
    serialFlag.SERIAL_FLAGS = 0x00;
    serialFlag.SW_TRMT = 1;
<#if (enableAutobaud=="enabled")>
    // Autobaud enabled
    serialFlag.SW_ABDEN = 1;
<#else>
    // Autobaud disabled
    serialFlag.SW_ABDEN = 0;
</#if>
    
    SW_TX_LAT = HIGH;
    
    ${moduleNameLowerCase}TxBufferRemaining = sizeof(${moduleNameLowerCase}TxBuffer);
    ${moduleNameLowerCase}RxCount = 0;
    
    tmrReload = &timer0ReloadVal;  
    oneBitReload = ${moduleNameUpperCase}_CalcOneBitReload();
    halfBitReload = ${moduleNameUpperCase}_CalcHalfBitReload();
    
    ${moduleNameUpperCase}_EnableRx();
<#if (enableAutobaud=="enabled")>
    IOCP_DISABLE();
</#if>
}

// Checks if there is still space in the transmit FIFO
bool ${moduleNameUpperCase}_is_tx_ready(void){
    if(${moduleNameLowerCase}TxBufferRemaining != 0){
        return true;
    }
    else{
        return false;
    }
}

// Checks if the Rx FIFO is not empty
bool ${moduleNameUpperCase}_is_rx_ready(void){
    if(${moduleNameLowerCase}RxCount != 0){
        return true;
    }
    else{
        return false;
    }
}

// Checks if all characters have been shifted out of the Tx shift register
bool ${moduleNameUpperCase}_is_tx_done(void){
    return serialFlag.SW_TRMT;
}

// Routine to read the top unread character from the Rx FIFO buffer
uint8_t ${moduleNameUpperCase}_Read(void){
    uint8_t readValue = 0;
    
    // Automatically clear framing error bit
    if(serialFlag.SW_FERR){
        serialFlag.SW_FERR = 0;
    }
    
    // Nothing to read
    while(0 == ${moduleNameLowerCase}RxCount){
    }

    readValue = ${moduleNameLowerCase}RxBuffer[${moduleNameLowerCase}RxTail++];
    
    if (sizeof(${moduleNameLowerCase}RxBuffer) <= ${moduleNameLowerCase}RxTail){
       ${moduleNameLowerCase}RxTail = 0;
    }
    ${moduleNameLowerCase}RxCount--;
    
    if (sizeof(${moduleNameLowerCase}RxBuffer) >= ${moduleNameLowerCase}RxCount){
        // Clear overrun error bit
        if (serialFlag.SW_OERR){
            ${moduleNameUpperCase}_EnableRx();
            serialFlag.SW_OERR = 0;
        }
    }

    return readValue;
}

// Routine to write a byte to the Transmit Shift Register
void ${moduleNameUpperCase}_Write(uint8_t txdata){
    IOCN_DISABLE();
    
    while(0 == ${moduleNameLowerCase}TxBufferRemaining){   
    }
    
    if(serialFlag.SW_TRMT){
        // Break transmission
        if(serialFlag.SW_SENDB){
            ${moduleNameUpperCase}_SendBreak();
        }
        else{
            ${moduleNameLowerCase}TxData = txdata;
            serialState = SERIAL_SEND_BYTE;
        }          
        serialFlag.SW_TRMT = 0;
        ${moduleNameUpperCase}_SetTimerReload(oneBitReload);
        SW_TX_LAT = LOW;
        ${moduleNameLowerCase}TxBitCount = 0;
    }
    else{
        ${moduleNameLowerCase}TxBuffer[${moduleNameLowerCase}TxHead++] = txdata;
        if(sizeof(${moduleNameLowerCase}TxBuffer) <= ${moduleNameLowerCase}TxHead){
            ${moduleNameLowerCase}TxHead = 0;
        }
        ${moduleNameLowerCase}TxBufferRemaining--;
    } 
}

<#if (redirectStdio=="enabled")>
char getch(void){
    return ${moduleNameUpperCase}_Read();
}

void putch(char txData)
{
    ${moduleNameUpperCase}_Write(txData);
}
</#if>

// Enable reception of next byte
void ${moduleNameUpperCase}_EnableRx (void){
    TIMER_INTERRUPT_DISABLE();
    IOCN_ENABLE();
}

// Check if a stop bit or break is received; Or if a framing error occurred
void ${moduleNameUpperCase}_CheckRx (void){
    if(SW_RX_PORT){
        serialFlag.SW_FERR = 0;
        ${moduleNameUpperCase}_RxOverrunControl();
    }
    else{
        serialFlag.SW_FERR = 1;
        if(${moduleNameLowerCase}RxData == 0x00){
            // Break is received
            serialState = SERIAL_RCV_BREAK;
            brkCount = 9;
        }
        else{
            // Framing error; Continue with reception of next byte
            ${moduleNameUpperCase}_EnableRx();
        }
    }
}

// Halts additional receive if overrun is detected
void ${moduleNameUpperCase}_RxOverrunControl (void){
    if (sizeof(${moduleNameLowerCase}RxBuffer) < ${moduleNameLowerCase}RxCount){
        // Overrun error
        serialFlag.SW_OERR = 1;                
        IOCN_DISABLE();
        TIMER_INTERRUPT_DISABLE();
    }
    else{
        ${moduleNameUpperCase}_EnableRx();
    }
}

// Handling code for Timer0 interrupt
void ${moduleNameUpperCase}_TimerInterruptHandler(void){
    switch(serialState){
        case SERIAL_SEND_START_BIT:
            SW_TX_LAT = LOW;
            serialState = SERIAL_SEND_BYTE;
            ${moduleNameLowerCase}TxBitCount = 0;   
            break;
        case SERIAL_SEND_BYTE:
            if(${moduleNameLowerCase}TxBitCount < 8){
                if(${moduleNameLowerCase}TxData & SERIAL_TX_MASK){
                    SW_TX_LAT = HIGH;
                }
                else{
                    SW_TX_LAT = LOW;
                }
                ${moduleNameLowerCase}TxData >>= 1;
                ${moduleNameLowerCase}TxBitCount++;
            }
            else{
                SW_TX_LAT = HIGH;      
                serialState = SERIAL_SEND_STOP_BIT;
            }
            break;
        case SERIAL_SEND_STOP_BIT:     
            if(sizeof(${moduleNameLowerCase}TxBuffer)> ${moduleNameLowerCase}TxBufferRemaining){
                ${moduleNameLowerCase}TxData = ${moduleNameLowerCase}TxBuffer[${moduleNameLowerCase}TxTail++];
                if(sizeof(${moduleNameLowerCase}TxBuffer)<= ${moduleNameLowerCase}TxTail){
                    ${moduleNameLowerCase}TxTail = 0;
                }
                ${moduleNameLowerCase}TxBufferRemaining++;
                serialState = SERIAL_SEND_START_BIT;
            }
            else{
                ${moduleNameUpperCase}_EnableRx();
                serialFlag.SW_TRMT = 1;
            }
            break;
        case SERIAL_SEND_BREAK:
            if(${moduleNameLowerCase}TxBitCount < 10){
                ${moduleNameLowerCase}TxBitCount++;
            }
            else{
                SW_TX_LAT = HIGH;
                serialState = SERIAL_SEND_STOP_BIT;
            }
            break;
        case SERIAL_RCV_START_BIT:
            ${moduleNameUpperCase}_SetTimerReload(oneBitReload);
            
            if(SW_RX_PORT == 0){
                serialState = SERIAL_RCV_BYTE;
            }
            else{
                ${moduleNameUpperCase}_EnableRx();
                serialState = SERIAL_IDLE;
            }
            break;
        case SERIAL_RCV_BYTE:
            if(${moduleNameLowerCase}RxBitCount < 8){
                
                ${moduleNameLowerCase}RxBitCount++;
                ${moduleNameLowerCase}RxData >>= 1;
                
                if(SW_RX_PORT != 0){
                    ${moduleNameLowerCase}RxData |= SERIAL_RX_MASK;
                }
            }
            if(${moduleNameLowerCase}RxBitCount == 8){
                ${moduleNameLowerCase}RxBuffer[${moduleNameLowerCase}RxHead++] = ${moduleNameLowerCase}RxData;
                ${moduleNameLowerCase}RxCount++;
                serialState = SERIAL_RCV_STOP_BIT;
            }
            break;
        case SERIAL_RCV_STOP_BIT:   
            if(sizeof(${moduleNameLowerCase}RxBuffer) <= ${moduleNameLowerCase}RxHead){
                ${moduleNameLowerCase}RxHead = 0;
            }
            ${moduleNameUpperCase}_CheckRx();
            break;
        case SERIAL_RCV_BREAK:
            if(SW_RX_PORT == 0){
                brkCount++;
                if(brkCount > 11){
                    <#if (enableAutobaud=="enabled")>
                    if(serialFlag.SW_ABDEN == 1){
                        serialRcvState = RCV_SYNC_CHAR;                        
                    }
                    else{
                        serialRcvState = RCV_UART_DATA; 
                    }
                    </#if>
                    serialState = SERIAL_IDLE;
                }
            }
            break;
        <#if (enableAutobaud=="enabled")>
        case SERIAL_RCV_SYNC_CHAR:
            overflowCount++;
            break;
        </#if>
        case SERIAL_IDLE:
            ${moduleNameUpperCase}_EnableRx();
            break;
    }
}

void ${moduleNameUpperCase}_SetTimerInterruptHandler (void){
    ${SetInterruptHandler} (${moduleNameUpperCase}_TimerInterruptHandler);
}

// Set Timer0 reload value
void ${moduleNameUpperCase}_SetTimerReload (uint8_t reload){
    TIMER_INTERRUPT_FLAG = 0;
    ${WriteTimer}(reload);
    *tmrReload = reload;
    TIMER_INTERRUPT_ENABLE();
}

// Adjust Timer0 reload value for one bit period based on delays introduced by hardware and software
uint8_t ${moduleNameUpperCase}_CalcOneBitReload (void){
    uint8_t tmrAdj, oneBit;
    
    tmrAdj = ONE_BIT_DELAY_COMP >> PRESCALE_FACTOR;
    tmrAdj &= MSB_MASK;
    
    if(OPTION_REGbits.PSA == 1){
        oneBit = *tmrReload + ONE_BIT_DELAY_COMP;
    }
    else{
        oneBit = *tmrReload + tmrAdj;
    }
   
    return oneBit;
}

// Adjust Timer0 reload value for half bit period based on delays introduced by hardware and software
uint8_t ${moduleNameUpperCase}_CalcHalfBitReload (void){
    uint8_t tmrAdj, halfPeriod, halfBit;
    
    halfPeriod = *tmrReload >> 1;
    halfPeriod &= MSB_MASK;
    halfBit = 128 + halfPeriod;
    
    tmrAdj = HALF_BIT_DELAY_COMP >> PRESCALE_FACTOR;
    tmrAdj &= MSB_MASK;
    
    if(OPTION_REGbits.PSA == 1){   
        halfBit += HALF_BIT_DELAY_COMP;
    }
    else{
        halfBit += tmrAdj;
    }
    
    return halfBit;
}

// Handling code for interrupt on negative edge of RX pin
void ${moduleNameUpperCase}_IOCNHandler (void){ 
    IOCN_DISABLE();
<#if (enableAutobaud=="enabled")>
    switch(serialRcvState){
        case RCV_UART_DATA:
            ${moduleNameUpperCase}_SetTimerReload(halfBitReload);
            serialState = SERIAL_RCV_START_BIT;
            ${moduleNameLowerCase}RxBitCount = 0;
            break;
        case RCV_SYNC_CHAR:
            IOCP_ENABLE();
            ${moduleNameUpperCase}_SetIOCPHandler();
            serialState = SERIAL_RCV_SYNC_CHAR;
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_8);
            break;
    }
<#else>
    ${moduleNameUpperCase}_SetTimerReload(halfBitReload);
    serialState = SERIAL_RCV_START_BIT;
    ${moduleNameLowerCase}RxBitCount = 0;
</#if>
}

void ${moduleNameUpperCase}_SetIOCNHandler (void){                                  
    ${moduleNameUpperCase}_${RxPin_IOCN}_SetInterruptHandler(${moduleNameUpperCase}_IOCNHandler);
}

<#if (enableAutobaud=="enabled")>
// Handling code for interrupt on change on positive edge during Sync reception
void ${moduleNameUpperCase}_IOCPHandler (void){
    static uint8_t syncCount = 0;
    
    syncCount++;
    
    if (syncCount == 1){
        ${moduleNameUpperCase}_SetTimerReload (MIN_RELOAD);
    }    
    // Capture TMR0 value after the fifth rising edge
    else if (syncCount == 5){
        TIMER_INTERRUPT_DISABLE();
        ${moduleNameUpperCase}_SetAutoBaud();
        syncCount = 0;
        serialRcvState = RCV_UART_DATA;
        IOCN_ENABLE();
        IOCP_DISABLE();
        ${moduleNameUpperCase}_SetIOCNHandler();
    }
}

void ${moduleNameUpperCase}_SetIOCPHandler (void){                                  
    ${moduleNameUpperCase}_${RxPin_IOCP}_SetInterruptHandler(${moduleNameUpperCase}_IOCPHandler);
}

// Routine to enable/disable and set prescale value
void ${moduleNameUpperCase}_SetTimerPrescaler (uint8_t prescaleEnable, uint8_t prescaleVal){
    if (!prescaleEnable){
        OPTION_REGbits.PSA = 1;
    }else{
        OPTION_REGbits.PSA = 0;
    }
    OPTION_REGbits.PS = prescaleVal;
}

// Routine for autobaud calibration
void ${moduleNameUpperCase}_SetAutoBaud (void){
    uint8_t timerCapturedVal;
    
    timerCapturedVal = ${ReadTimer}();
    ${moduleNameUpperCase}_CalcBaudRate(timerCapturedVal);
    
    // For compatibility with the MCC LIN Slave driver
    ${moduleNameLowerCase}RxBuffer[${moduleNameLowerCase}RxHead++] = 0x55;
                           
    if(sizeof(${moduleNameLowerCase}RxBuffer) <= ${moduleNameLowerCase}RxHead){
        ${moduleNameLowerCase}RxHead = 0;
    }               
    ${moduleNameLowerCase}RxCount++;
    
    // Autobaud complete
    serialFlag.SW_ABDEN = 0;
    overflowCount = 0;
}

// Assign new one bit and half bit reload values
void ${moduleNameUpperCase}_CalcBaudRate (uint8_t timerCapture){
    
    uint16_t timerCapturedPeriod;
    
    timerCapturedPeriod = timerCapture + (overflowCount*256);    
    
    // Max overflowCount = 255
    switch (overflowCount){
        case 0:
            *tmrReload = 256 - (uint8_t) timerCapturedPeriod;
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_DIS, PRESCALE_2);
            break;
        case 1:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 1);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_2);
            break;
        case 2 ... 3:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 2);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_4);
            break;
        case 4 ... 7:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 3);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_8);
            break;
        case 8 ... 15:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 4);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_16);
            break;
        case 16 ... 31:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 5);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_32);
            break;
        case 32 ... 63:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 6);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_64);
            break;
        case 64 ... 127:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 7);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_128);
            break;
        case 128 ... 255:
            *tmrReload = 256 - (uint8_t) (timerCapturedPeriod >> 8);
            ${moduleNameUpperCase}_SetTimerPrescaler (PRESCALE_EN, PRESCALE_256);
            break;
        default:
            // Baud rate detection limit exceeded
            break;            
    }
   
    // Calculate reload values based on sampled period value
    oneBitReload = ${moduleNameUpperCase}_CalcOneBitReload();
    halfBitReload = ${moduleNameUpperCase}_CalcHalfBitReload();
}
</#if>

// Initialize and wait for transmission of break character
void ${moduleNameUpperCase}_SendBreak (void){
    serialState = SERIAL_SEND_BREAK;
    serialFlag.SW_SENDB = 0;
}
