/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "EEPROM4_app.h"
#include "${SPIFunctions["spiHeader"]}"

#define EEPROM4_READ         0x03                // read data from memory
#define EEPROM4_WREN         0x06                // set the write enable latch
#define EEPROM4_WRITE        0x02                // write data to memory array
#define EEPROM4_RDSR         0x05                // read STATUS register
#define EEPROM4_ADDRBYTES    3                   // 24 bit address

static void addressAssign(uint8_t *addressBuffer, unsigned long byteAddr)
{
    int i = 0;
    int j = EEPROM4_ADDRBYTES - 1;
    unsigned long address = byteAddr;
    
    while(address > 0)
    {
        addressBuffer[j-i] = address & 0xFF;
        i++;
        address >>= 8;
    }
}

static void CS_SELECT(void)
{
    ${spiSSPinSettings["setOutputLevelLow"]}
}

static void CS_DESELECT(void)
{
    ${spiSSPinSettings["setOutputLevelHigh"]}
}

static void writeEnable(void)
{    
    ${SPIFunctions["spiOpen"]}(EEPROM4);
    CS_SELECT();

    //Send Write Enable command
    ${SPIFunctions["exchangeByte"]}(EEPROM4_WREN);
    
    CS_DESELECT();
    ${SPIFunctions["spiClose"]}();
}

static uint8_t EEPROM4_ReadStatusRegister(void)
{
    uint8_t statusByte;
    
    ${SPIFunctions["spiOpen"]}(EEPROM4);
    CS_SELECT();
    
    //Send Read Status Register Operation
    ${SPIFunctions["exchangeByte"]}(EEPROM4_RDSR);
    //Send Dummy data to clock out data byte from slave
    statusByte = ${SPIFunctions["exchangeByte"]}(0x00);
    
    CS_DESELECT();
    ${SPIFunctions["spiClose"]}();
    
    //return data byte read
    return(statusByte);
}

static void checkStatusRegister(void)
{
    uint8_t check;
    //Check if WEL bit is set
    while(check != 2)                  
        check = EEPROM4_ReadStatusRegister();
}

void EEPROM4_WriteByte (uint8_t byteData, unsigned long byteAddr)
{
    uint8_t addressBuffer[EEPROM4_ADDRBYTES];

    addressAssign(addressBuffer, byteAddr);
    
    writeEnable();

    checkStatusRegister();
    
    ${SPIFunctions["spiOpen"]}(EEPROM4);
    CS_SELECT();
    
    //Send Write Command
    ${SPIFunctions["exchangeByte"]}(EEPROM4_WRITE);
    //Send address byte/s
    ${SPIFunctions["exchangeBlock"]}(addressBuffer,EEPROM4_ADDRBYTES);
    //Send data byte
    ${SPIFunctions["exchangeByte"]}(byteData);
    
    CS_DESELECT();
    ${SPIFunctions["spiClose"]}();
    
}

uint8_t EEPROM4_ReadByte (unsigned long address)
{
    uint8_t readByte;
    uint8_t addressBuffer[EEPROM4_ADDRBYTES];
    
    //Wait for write cycle to complete
    EEPROM4_WritePoll();

    addressAssign(addressBuffer, address);
    
    ${SPIFunctions["spiOpen"]}(EEPROM4);
    CS_SELECT();
    
    //Send Read Command
    ${SPIFunctions["exchangeByte"]}(EEPROM4_READ);
    //Send address bytes
    ${SPIFunctions["exchangeBlock"]}(addressBuffer,EEPROM4_ADDRBYTES);
    //Send Dummy data to clock out data byte from slave
    readByte = ${SPIFunctions["exchangeByte"]}(0x00);
    
    CS_DESELECT();
    ${SPIFunctions["spiClose"]}();
    
    //return data byte read
    return(readByte);
}

void EEPROM4_WriteBlock(uint8_t *writeBuffer, uint8_t buflen, unsigned long startAddr)
{
    uint8_t addressBuffer[EEPROM4_ADDRBYTES];
    
    addressAssign(addressBuffer, startAddr);
    
    writeEnable();

    checkStatusRegister();
    
    ${SPIFunctions["spiOpen"]}(EEPROM4);
    CS_SELECT();
    
    //Send Write Command
    ${SPIFunctions["exchangeByte"]}(EEPROM4_WRITE);
    //Send address bytes
    ${SPIFunctions["exchangeBlock"]}(addressBuffer,EEPROM4_ADDRBYTES);
    //Send data bytes to be written
    ${SPIFunctions["exchangeBlock"]}(writeBuffer,buflen);
    
    //Toggle CS line to end operation
    CS_DESELECT();
    ${SPIFunctions["spiClose"]}();
       
}

void EEPROM4_ReadBlock(uint8_t *readBuffer, uint8_t buflen, unsigned long startAddr)
{
    uint8_t addressBuffer[EEPROM4_ADDRBYTES];
    
    //Wait for write cycle to complete
    EEPROM4_WritePoll();
    
    addressAssign(addressBuffer,startAddr);
    
    ${SPIFunctions["spiOpen"]}(EEPROM4);
    CS_SELECT();
    
    //Send Read Command
    ${SPIFunctions["exchangeByte"]}(EEPROM4_READ);
    //Send Address bytes
    ${SPIFunctions["exchangeBlock"]}(addressBuffer,EEPROM4_ADDRBYTES);
    //Send dummy/NULL data to clock out data bytes from slave
    ${SPIFunctions["exchangeBlock"]}(readBuffer,buflen);
    
    CS_DESELECT();
    ${SPIFunctions["spiClose"]}();
}

uint8_t EEPROM4_WritePoll(void)
{
    uint8_t pollByte;
    
    //Read the Status Register
    pollByte = EEPROM4_ReadStatusRegister();    
    
    //Check if WEL and WIP bits are still set
    while((pollByte & 0x01) || (pollByte & 0x02))
    {
        pollByte = EEPROM4_ReadStatusRegister();
    }
    
    //return 1 if WEL and WIP bits are cleared and the write cycle is finished
    return(1);
}
