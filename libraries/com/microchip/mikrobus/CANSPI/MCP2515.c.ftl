/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"
#include "MCP2515.h"
#include "${pinHeader}"

/**
Defines for chip select
*/
#define MCP2515_CS_HIGH()   do{${spiSSPinSettings["spiSlaveSelectLat"]} = 1;}while(0)
#define MCP2515_CS_LOW()    do{${spiSSPinSettings["spiSlaveSelectLat"]} = 0;}while(0)

/**
Static variables
*/
static uint8_t readDummy;
static uint8_t writeDummy = 0x00;


/**
Initialize CAN controller
*/
void MCP2515_Initialize(void){
    MCP2515_CS_HIGH();
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
}

/**
Set CAN contoller to config mode
*/
void MCP2515_SetTo_ConfigMode(void){
    MCP2515_Write_Byte(MCP2515_CANCTRL, 0x80);
    while(0x80 != (MCP2515_Read_Byte(MCP2515_CANSTAT) & 0xE0)); // Wait until MCP2515 is in config mode
}

/**
Set CAN controller to normal mode
*/
void MCP2515_SetTo_NormalMode(void){
    MCP2515_Write_Byte(MCP2515_CANCTRL, 0x00);
    while(0x00 != (MCP2515_Read_Byte(MCP2515_CANSTAT) & 0xE0)); // Wait until MCP2515  is in normal mode
}

/**
Set CAN controller to sleep mode
*/
void MCP2515_SetTo_Sleep_Mode(void){
    MCP2515_Write_Byte(MCP2515_CANCTRL, 0x20);
    while(0x20 != (MCP2515_Read_Byte(MCP2515_CANSTAT) & 0xE0)); // Wait until MCP2515  is in normal mode
}

/**
Reset CAN controller
*/
void MCP2515_Reset(void){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_RESET);
    MCP2515_CS_HIGH();
}

/**
Read one byte from given CAN controller address
*/
uint8_t MCP2515_Read_Byte (uint8_t readAddress){
    uint8_t addressData;
    
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_READ);
    readDummy = ${SPIFunctions["exchangeByte"]}(readAddress);
    addressData = ${SPIFunctions["exchangeByte"]}(writeDummy);
    MCP2515_CS_HIGH();
    
    return addressData;
}

/**
Read RX buffer using Read Rx Buffer instruction
*/
uint8_t MCP2515_Read_RxBuffer(uint8_t readRxBuffInst){
    uint8_t rxBufferData;
    
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(readRxBuffInst);
    rxBufferData = ${SPIFunctions["exchangeByte"]}(writeDummy);
    MCP2515_CS_HIGH();
    
    return rxBufferData;
}

/**
readRxBuffInst = instruction for the first Rx buffer to read
rxLength = number of byte addresses to read from the set rx buffer to RXBnD7
*rxData = pointer to the first rx buffer to read
*/
void MCP2515_Read_RxbSequence(uint8_t readRxBuffInst, uint8_t rxLength, uint8_t *rxData){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(readRxBuffInst);
    for(uint8_t i = 0; i < rxLength; i++){
        *(rxData++) = ${SPIFunctions["exchangeByte"]}(writeDummy);
    }
    MCP2515_CS_HIGH();
}

/**
Write a single byte to the given register address
writeAddress = address where the data will be written
writeData = data to write to writeAddress
*/
void MCP2515_Write_Byte (uint8_t writeAddress, uint8_t writeData){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_WRITE);
    readDummy = ${SPIFunctions["exchangeByte"]}(writeAddress);
    readDummy = ${SPIFunctions["exchangeByte"]}(writeData);
    MCP2515_CS_HIGH();
}

/**
Write a sequence of bytes from the given startAddress to the endAddress
startAddress = first address to write
endAddress = last address to write
*data = pointer to the starting address
*/
void MCP2515_Write_ByteSequence (uint8_t startAddress, uint8_t endAddress, uint8_t *data){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_WRITE);
    readDummy = ${SPIFunctions["exchangeByte"]}(startAddress);
    do{
        readDummy = ${SPIFunctions["exchangeByte"]}(*(data++));
    }while(startAddress++ != endAddress);
    MCP2515_CS_HIGH();
}

/**
Write messages starting from the given txBnSIDH up to TXBnD7
loadtxBnSidhInst = instruction to load to a TXBnSIDH buffer
*idReg = pointer to the address of data to load to the four tx id buffers
dlc = data length
*txData = pointer to the address of data to load to the 8 tx data buffers
*/
void MCP2515_Load_TxSequence(uint8_t loadtxBnSidhInst, uint8_t *idReg, uint8_t dlc, uint8_t *txData){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(loadtxBnSidhInst);
    for(uint8_t i = 0; i < 4; i++){
        readDummy = ${SPIFunctions["exchangeByte"]}(*(idReg++));      // Write id from the four id registers
    }
    readDummy = ${SPIFunctions["exchangeByte"]}(dlc);
    for(uint8_t i = 0; i < 8; i++){
        readDummy = ${SPIFunctions["exchangeByte"]}(*(txData++));     // Write 8 data bytes
    }
    MCP2515_CS_HIGH();
}

/**
Write one byte to a tx buffer
loadTxBuffInst = instruction to load to a TXBnSIDH or TXBnD0 buffer
loadTxData = data to load to the given buffer
*/
void MCP2515_Load_TxBuffer (uint8_t loadTxBuffInst, uint8_t txBufferData){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(loadTxBuffInst);
    readDummy = ${SPIFunctions["exchangeByte"]}(txBufferData);
    MCP2515_CS_HIGH();
}

/**
Message request to send using the RTS instruction for a TX buffer
*/
void MCP2515_RequestToSend (uint8_t rtsTxBuffInst){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(rtsTxBuffInst);
    MCP2515_CS_HIGH();
}

/**
Returns the controller status using the READ STATUS instruction
*/
uint8_t MCP2515_Read_Status (void){
    uint8_t ctrlStat;
    
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_READ_STATUS);
    ctrlStat = ${SPIFunctions["exchangeByte"]}(writeDummy);
    MCP2515_CS_HIGH();

    return ctrlStat;
}

/**
Returns the controller RX status using the RX STATUS instruction
*/
uint8_t MCP2515_Get_RxStatus (void){
    uint8_t rxStatus;
    
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_RX_STATUS);
    rxStatus = ${SPIFunctions["exchangeByte"]}(writeDummy);
    MCP2515_CS_HIGH();
    
    return rxStatus;
}

/**
Modify one bit from the given register
regAddress = address of the register that contains the bit to modify
*/
void MCP2515_Bit_Modify (uint8_t regAddress, uint8_t maskByte, uint8_t dataByte){
    MCP2515_CS_LOW();
    readDummy = ${SPIFunctions["exchangeByte"]}(MCP2515_BIT_MOD);
    readDummy = ${SPIFunctions["exchangeByte"]}(regAddress);
    readDummy = ${SPIFunctions["exchangeByte"]}(maskByte);
    readDummy = ${SPIFunctions["exchangeByte"]}(dataByte);
    MCP2515_CS_HIGH();
}
