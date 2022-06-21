/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${SPIFunctions["spiHeader"]}"
#include "MCP25625.h"
#include "${pinHeader}"


/**
Static variables
*/
static uint8_t readDummy;
static uint8_t writeDummy = 0x00;


/**
Initialize CAN controller
*/
void MCP25625_Controller_Initialize(void){
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${resetPinSettings["setOutputLevelHigh"]}
}

/**
Set CAN contoller to config mode
*/
void MCP25625_SetTo_ConfigMode(void){
    MCP25625_Write_Byte(MCP25625_CANCTRL, 0x80);
    while(0x80 != (MCP25625_Read_Byte(MCP25625_CANSTAT) & 0xE0)); // Wait until MCP25625 is in config mode
}

/**
Set CAN controller to normal mode
*/
void MCP25625_SetTo_NormalMode(void){
    ${standbyPinSettings["setOutputLevelLow"]}
    MCP25625_Write_Byte(MCP25625_CANCTRL, 0x00);
    while(0x00 != (MCP25625_Read_Byte(MCP25625_CANSTAT) & 0xE0)); // Wait until MCP25625  is in normal mode
}

/**
Set CAN controller to sleep mode
*/
void MCP25625_SetTo_Sleep_Mode(void){
    MCP25625_Write_Byte(MCP25625_CANCTRL, 0x20);
    while(0x20 != (MCP25625_Read_Byte(MCP25625_CANSTAT) & 0xE0)); // Wait until MCP25625  is in normal mode
}

/**
Checks if the controller is awake from sleep
*/
bool MCP25625_is_Awake(void){
    uint8_t canintReg;
    
    canintReg = MCP25625_Read_Byte(MCP25625_CANINTF);
    canintReg &= 0x40;
    if (canintReg == 0x40){
        return true;
    }else{
        return false;
    }
}

/**
Reset CAN controller
*/
void MCP25625_Reset(void){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_RESET);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Read one byte from given CAN controller address
*/
uint8_t MCP25625_Read_Byte (uint8_t readAddress){
    uint8_t addressData;
    
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_READ);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(readAddress);
    addressData = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeDummy);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    
    return addressData;
}

/**
Read RX buffer using Read Rx Buffer instruction
*/
uint8_t MCP25625_Read_RxBuffer(uint8_t readRxBuffInst){
    uint8_t rxBufferData;
    
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(readRxBuffInst);
    rxBufferData = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeDummy);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    
    return rxBufferData;
}

/**
readRxBuffInst = instruction for the first Rx buffer to read
rxLength = number of byte addresses to read from the set rx buffer to RXBnD7
*rxData = pointer to the first rx buffer to read
*/
void MCP25625_Read_RxbSequence(uint8_t readRxBuffInst, uint8_t rxLength, uint8_t *rxData){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(readRxBuffInst);
    for(uint8_t i = 0; i < rxLength; i++){
        *(rxData++) = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeDummy);
    }
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Write a single byte to the given register address
writeAddress = address where the data will be written
writeData = data to write to writeAddress
*/
void MCP25625_Write_Byte (uint8_t writeAddress, uint8_t writeData){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_WRITE);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeAddress);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeData);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Write a sequence of bytes from the given startAddress to the endAddress
startAddress = first address to write
endAddress = last address to write
*data = pointer to the starting address
*/
void MCP25625_Write_ByteSequence (uint8_t startAddress, uint8_t endAddress, uint8_t *data){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_WRITE);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(startAddress);
    do{
        readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(*(data++));
    }while(startAddress++ != endAddress);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Write messages starting from the given txBnSIDH up to TXBnD7
loadtxBnSidhInst = instruction to load to a TXBnSIDH buffer
*idReg = pointer to the address of data to load to the four tx id buffers
dlc = data length
*txData = pointer to the address of data to load to the 8 tx data buffers
*/
void MCP25625_Load_TxSequence(uint8_t loadtxBnSidhInst, uint8_t *idReg, uint8_t dlc, uint8_t *txData){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(loadtxBnSidhInst);
    for(uint8_t i = 0; i < 4; i++){
        readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(*(idReg++));      // Write id from the four id registers
    }
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(dlc);
    for(uint8_t i = 0; i < 8; i++){
        readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(*(txData++));     // Write 8 data bytes
    }
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Write one byte to a tx buffer
loadTxBuffInst = instruction to load to a TXBnSIDH or TXBnD0 buffer
loadTxData = data to load to the given buffer
*/
void MCP25625_Load_TxBuffer (uint8_t loadTxBuffInst, uint8_t txBufferData){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(loadTxBuffInst);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(txBufferData);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Message request to send using the RTS instruction for a TX buffer
*/
void MCP25625_RequestToSend (uint8_t rtsTxBuffInst){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(rtsTxBuffInst);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

/**
Returns the controller status using the READ STATUS instruction
*/
uint8_t MCP25625_Read_Status (void){
    uint8_t ctrlStat;
    
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_READ_STATUS);
    ctrlStat = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeDummy);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();

    return ctrlStat;
}

/**
Returns the controller RX status using the RX STATUS instruction
*/
uint8_t MCP25625_Get_RxStatus (void){
    uint8_t rxStatus;
    
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_RX_STATUS);
    rxStatus = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(writeDummy);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    
    return rxStatus;
}

/**
Modify one bit from the given register
regAddress = address of the register that contains the bit to modify
*/
void MCP25625_Bit_Modify (uint8_t regAddress, uint8_t maskByte, uint8_t dataByte){
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen());
    ${spiSSPinSettings["setOutputLevelLow"]}
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(MCP25625_BIT_MOD);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(regAddress);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(maskByte);
    readDummy = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(dataByte);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}
