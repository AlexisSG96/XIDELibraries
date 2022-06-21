/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "canspi.h"
#include "MCP2515.h"

/**
Local Function Prototypes
*/  
uint32_t convertReg2ExtendedCANid(uint8_t tempRXBn_EIDH, uint8_t tempRXBn_EIDL, uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL);
uint32_t convertReg2StandardCANid(uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL) ;
void convertCANid2Reg(uint32_t tempPassedInID, uint8_t canIdType, id_reg_t *passedIdReg);

/**
Local Variables
*/ 
ctrl_status_t ctrlStatus;
ctrl_error_status_t errorStatus;
id_reg_t idReg;

/**
CAN SPI APIs
*/ 

void CANSPI_Sleep(void){
    MCP2515_Bit_Modify(MCP2515_CANINTF, 0x40, 0x00);        //clear CAN bus wakeup interrupt
    MCP2515_Bit_Modify(MCP2515_CANINTE, 0x40, 0x40);        //enable CAN bus activity wakeup
    MCP2515_SetTo_Sleep_Mode();
}

void CANSPI_Initialize(void){
    RXF0 RXF0reg;
    RXF1 RXF1reg;
    RXF2 RXF2reg;
    RXF3 RXF3reg;
    RXF4 RXF4reg;
    RXF5 RXF5reg;
    RXM0 RXM0reg;
    RXM1 RXM1reg;

    ${canAddressTable}

    // Initialize Rx Mask values
    RXM0reg.RXM0SIDH = ${rxm0sidh};
    RXM0reg.RXM0SIDL = ${rxm0sidl};
    RXM0reg.RXM0EID8 = ${rxm0eidh};
    RXM0reg.RXM0EID0 = ${rxm0eidl};
    
    RXM1reg.RXM1SIDH = ${rxm1sidh};
    RXM1reg.RXM1SIDL = ${rxm1sidl};
    RXM1reg.RXM1EID8 = ${rxm1eidh};
    RXM1reg.RXM1EID0 = ${rxm1eidl};
    
    // Initialize Rx Filter values
    RXF0reg.RXF0SIDH = ${rxf0sidh};
    RXF0reg.RXF0SIDL = ${rxf0sidl};
    RXF0reg.RXF0EID8 = ${rxf0eidh};
    RXF0reg.RXF0EID0 = ${rxf0eidl};
    
    RXF1reg.RXF1SIDH = ${rxf1sidh};
    RXF1reg.RXF1SIDL = ${rxf1sidl};
    RXF1reg.RXF1EID8 = ${rxf1eidh};
    RXF1reg.RXF1EID0 = ${rxf1eidl};
    
    RXF2reg.RXF2SIDH = ${rxf2sidh};
    RXF2reg.RXF2SIDL = ${rxf2sidl};
    RXF2reg.RXF2EID8 = ${rxf2eidh};
    RXF2reg.RXF2EID0 = ${rxf2eidl};
       
    RXF3reg.RXF3SIDH = ${rxf3sidh};
    RXF3reg.RXF3SIDL = ${rxf3sidl};
    RXF3reg.RXF3EID8 = ${rxf3eidh};
    RXF3reg.RXF3EID0 = ${rxf3eidl};
    
    RXF4reg.RXF4SIDH = ${rxf4sidh};
    RXF4reg.RXF4SIDL = ${rxf4sidl};
    RXF4reg.RXF4EID8 = ${rxf4eidh};
    RXF4reg.RXF4EID0 = ${rxf4eidl};
        
    RXF5reg.RXF5SIDH = ${rxf5sidh};
    RXF5reg.RXF5SIDL = ${rxf5sidl};
    RXF5reg.RXF5EID8 = ${rxf5eidh};
    RXF5reg.RXF5EID0 = ${rxf5eidl};
   
    MCP2515_Initialize();
    MCP2515_SetTo_ConfigMode();
    
    // Write Filter and Mask values to CAN controller
    MCP2515_Write_ByteSequence(MCP2515_RXM0SIDH, MCP2515_RXM0EID0, &(RXM0reg.RXM0SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXM1SIDH, MCP2515_RXM1EID0, &(RXM1reg.RXM1SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXF0SIDH, MCP2515_RXF0EID0, &(RXF0reg.RXF0SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXF1SIDH, MCP2515_RXF1EID0, &(RXF1reg.RXF1SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXF2SIDH, MCP2515_RXF2EID0, &(RXF2reg.RXF2SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXF3SIDH, MCP2515_RXF3EID0, &(RXF3reg.RXF3SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXF4SIDH, MCP2515_RXF4EID0, &(RXF4reg.RXF4SIDH));
    MCP2515_Write_ByteSequence(MCP2515_RXF5SIDH, MCP2515_RXF5EID0, &(RXF5reg.RXF5SIDH));
    
    // Initialize CAN Timings 

    ${canBaudRate}

    MCP2515_Write_Byte(MCP2515_CNF1, ${cnf1});
    MCP2515_Write_Byte(MCP2515_CNF2, ${cnf2});
    MCP2515_Write_Byte(MCP2515_CNF3, ${cnf3});
    
    MCP2515_SetTo_NormalMode();
}

uint8_t CANSPI_Transmit(uCAN_MSG *tempCanMsg) {
    uint8_t returnValue = 0;
       
    idReg.tempSIDH = 0;
    idReg.tempSIDL = 0;
    idReg.tempEID8 = 0;
    idReg.tempEID0 = 0;
    
    ctrlStatus.ctrl_status = MCP2515_Read_Status();

    if (ctrlStatus.TXB0REQ != 1){
        convertCANid2Reg(tempCanMsg->frame.id, tempCanMsg->frame.idType, &idReg);
        
        MCP2515_Load_TxSequence(MCP2515_LOAD_TXB0SIDH, &(idReg.tempSIDH), tempCanMsg->frame.dlc, &(tempCanMsg->frame.data0));
        MCP2515_RequestToSend(MCP2515_RTS_TX0);
 
        returnValue = 1;
    }else if (ctrlStatus.TXB1REQ != 1){
        convertCANid2Reg(tempCanMsg->frame.id, tempCanMsg->frame.idType, &idReg);

        MCP2515_Load_TxSequence(MCP2515_LOAD_TXB1SIDH, &(idReg.tempSIDH), tempCanMsg->frame.dlc, &(tempCanMsg->frame.data0));
        MCP2515_RequestToSend(MCP2515_RTS_TX1);
        
        returnValue = 1;
    }else if (ctrlStatus.TXB2REQ != 1){
        convertCANid2Reg(tempCanMsg->frame.id, tempCanMsg->frame.idType, &idReg);

        MCP2515_Load_TxSequence(MCP2515_LOAD_TXB2SIDH, &(idReg.tempSIDH), tempCanMsg->frame.dlc, &(tempCanMsg->frame.data0));
        MCP2515_RequestToSend(MCP2515_RTS_TX2);
        
        returnValue = 1;
    }
    
    return (returnValue);
}

uint8_t CANSPI_Receive(uCAN_MSG *tempCanMsg) {
    uint8_t returnValue = 0;
    rx_reg_t rxReg;
    ctrl_rx_status_t rxStatus;

    rxStatus.ctrl_rx_status = MCP2515_Get_RxStatus();
    
    //check to see if we received a CAN message
    if (rxStatus.rxBuffer != 0){
            //check which buffer the CAN message is in
            if ((rxStatus.rxBuffer == MSG_IN_RXB0)|(rxStatus.rxBuffer == MSG_IN_BOTH_BUFFERS)){
                MCP2515_Read_RxbSequence(MCP2515_READ_RXB0SIDH, sizeof(rxReg.rx_reg_array), rxReg.rx_reg_array);
            }
            else if (rxStatus.rxBuffer == MSG_IN_RXB1){
                MCP2515_Read_RxbSequence(MCP2515_READ_RXB1SIDH, sizeof(rxReg.rx_reg_array), rxReg.rx_reg_array);
            }
            
            if (rxStatus.msgType == dEXTENDED_CAN_MSG_ID_2_0B){
                tempCanMsg->frame.idType = (uint8_t) dEXTENDED_CAN_MSG_ID_2_0B;
                tempCanMsg->frame.id = convertReg2ExtendedCANid(rxReg.RXBnEID8, rxReg.RXBnEID0, rxReg.RXBnSIDH, rxReg.RXBnSIDL);
            } else {
                tempCanMsg->frame.idType = (uint8_t) dSTANDARD_CAN_MSG_ID_2_0B;
                tempCanMsg->frame.id = convertReg2StandardCANid(rxReg.RXBnSIDH, rxReg.RXBnSIDL);
            }

            tempCanMsg->frame.dlc   = rxReg.RXBnDLC;
            tempCanMsg->frame.data0 = rxReg.RXBnD0;
            tempCanMsg->frame.data1 = rxReg.RXBnD1;
            tempCanMsg->frame.data2 = rxReg.RXBnD2;
            tempCanMsg->frame.data3 = rxReg.RXBnD3;
            tempCanMsg->frame.data4 = rxReg.RXBnD4;
            tempCanMsg->frame.data5 = rxReg.RXBnD5;
            tempCanMsg->frame.data6 = rxReg.RXBnD6;
            tempCanMsg->frame.data7 = rxReg.RXBnD7;
            
            returnValue = 1;
    }
    return (returnValue);
}

uint8_t CANSPI_messagesInBuffer(void){
    uint8_t messageCount = 0;
   
    ctrlStatus.ctrl_status = MCP2515_Read_Status();
    if(ctrlStatus.RX0IF != 0){
        messageCount++;
    }
    if(ctrlStatus.RX1IF != 0){
        messageCount++;
    }
    
    return (messageCount);
}

uint8_t CANSPI_isBussOff(void){
    uint8_t returnValue = 0;
    
    errorStatus.error_flag_reg = MCP2515_Read_Byte(MCP2515_EFLG);
    
    if(errorStatus.TXBO == 1){
        returnValue = 1;
    }
    
    return (returnValue);
}

uint8_t CANSPI_isRxErrorPassive(void){
    uint8_t returnValue = 0;
    
    errorStatus.error_flag_reg = MCP2515_Read_Byte(MCP2515_EFLG);
    
    if(errorStatus.RXEP == 1){
        returnValue = 1;
    }
    
    return (returnValue);
}

uint8_t CANSPI_isTxErrorPassive(void){
    uint8_t returnValue = 0;
    
    errorStatus.error_flag_reg = MCP2515_Read_Byte(MCP2515_EFLG);
    
    if(errorStatus.TXEP == 1){
        returnValue = 1;
    }
    
    return (returnValue);
}

uint32_t convertReg2ExtendedCANid(uint8_t tempRXBn_EIDH, uint8_t tempRXBn_EIDL, uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL) {
    uint32_t returnValue = 0;
    uint32_t ConvertedID = 0;
    uint8_t CAN_standardLo_ID_lo2bits;
    uint8_t CAN_standardLo_ID_hi3bits;

    CAN_standardLo_ID_lo2bits = (tempRXBn_SIDL & 0x03);
    CAN_standardLo_ID_hi3bits = (tempRXBn_SIDL >> 5);
    ConvertedID = (tempRXBn_SIDH << 3);
    ConvertedID = ConvertedID + CAN_standardLo_ID_hi3bits;
    ConvertedID = (ConvertedID << 2);
    ConvertedID = ConvertedID + CAN_standardLo_ID_lo2bits;
    ConvertedID = (ConvertedID << 8);
    ConvertedID = ConvertedID + tempRXBn_EIDH;
    ConvertedID = (ConvertedID << 8);
    ConvertedID = ConvertedID + tempRXBn_EIDL;
    returnValue = ConvertedID;    
    return (returnValue);
}

uint32_t convertReg2StandardCANid(uint8_t tempRXBn_SIDH, uint8_t tempRXBn_SIDL) {
    uint32_t returnValue = 0;
    uint32_t ConvertedID;

    ConvertedID = (tempRXBn_SIDH << 3);
    ConvertedID = ConvertedID + (tempRXBn_SIDL >> 5);
    returnValue = ConvertedID;
    
    return (returnValue);
}


void convertCANid2Reg(uint32_t tempPassedInID, uint8_t canIdType, id_reg_t *passedIdReg) {
    uint8_t wipSIDL = 0;

    if (canIdType == dEXTENDED_CAN_MSG_ID_2_0B) {
        //EID0
        passedIdReg->tempEID0 = 0xFF & tempPassedInID;
        tempPassedInID = tempPassedInID >> 8;

        //EID8
        passedIdReg->tempEID8 = 0xFF & tempPassedInID;
        tempPassedInID = tempPassedInID >> 8;

        //SIDL
        wipSIDL = 0x03 & tempPassedInID;
        tempPassedInID = tempPassedInID << 3;
        wipSIDL = (0xE0 & tempPassedInID) + wipSIDL;
        wipSIDL = wipSIDL + 0x08;
        passedIdReg->tempSIDL = 0xEB & wipSIDL;

        //SIDH
        tempPassedInID = tempPassedInID >> 8;
        passedIdReg->tempSIDH = 0xFF & tempPassedInID;
    } else{
        passedIdReg->tempEID8 = 0;
        passedIdReg->tempEID0 = 0;
        tempPassedInID = tempPassedInID << 5;
        passedIdReg->tempSIDL = 0xFF & tempPassedInID;
        tempPassedInID = tempPassedInID >> 8;
        passedIdReg->tempSIDH = 0xFF & tempPassedInID;
    }
}
