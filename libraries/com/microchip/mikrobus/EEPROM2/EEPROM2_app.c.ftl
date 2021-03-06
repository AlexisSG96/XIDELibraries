/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdint.h>
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "EEPROM2_app.h"

#define EEPROM2_READ         0x03                // read data from memory
#define EEPROM2_WREN         0x06                // set the write enable latch
#define EEPROM2_WRITE        0x02                // write data to memory array
#define EEPROM2_RDSR         0x05                // read STATUS register
#define EEPROM2_ADDRBYTES    3


static void EEPROM2_AddressAssign(uint8_t *addressBuffer, uint32_t byteAddr);
static void EEPROM2_WriteEnable(void);
static void EEPROM2_CheckStatusRegister(void);

static uint8_t EEPROM2_ReadStatusRegister(void);


void EEPROM2_WriteByte (uint8_t byteData, uint32_t byteAddr)
{
    uint8_t addressBuffer[EEPROM2_ADDRBYTES];

    EEPROM2_AddressAssign(addressBuffer, byteAddr);
    
    EEPROM2_WriteEnable();

    EEPROM2_CheckStatusRegister();
    
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen();
    ${spiSSPinSettings["setOutputLevelLow"]}
    
    //Send Write Command
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(EEPROM2_WRITE);
    //Send address byte/s
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(addressBuffer,EEPROM2_ADDRBYTES);
    //Send data byte
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(byteData);
    
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    
}

uint8_t EEPROM2_ReadByte (uint32_t address)
{
    uint8_t readByte;
    uint8_t addressBuffer[EEPROM2_ADDRBYTES];
    
    //Wait for write cycle to complete
    EEPROM2_WritePoll();

    EEPROM2_AddressAssign(addressBuffer, address);
    
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen();
    ${spiSSPinSettings["setOutputLevelLow"]}
    
    //Send Read Command
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(EEPROM2_READ);
    //Send address bytes
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(addressBuffer,EEPROM2_ADDRBYTES);
    //Send Dummy data to clock out data byte from slave
    readByte = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x00);
    
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    
    //return data byte read
    return(readByte);
}

void EEPROM2_WriteBlock(uint8_t *writeBuffer, uint8_t buflen, uint32_t startAddr)
{
    uint8_t addressBuffer[EEPROM2_ADDRBYTES];
    
    EEPROM2_AddressAssign(addressBuffer, startAddr);
    
    EEPROM2_WriteEnable();

    EEPROM2_CheckStatusRegister();
    
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen();
    ${spiSSPinSettings["setOutputLevelLow"]}
    
    //Send Write Command
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(EEPROM2_WRITE);
    //Send address bytes
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(addressBuffer,EEPROM2_ADDRBYTES);
    //Send data bytes to be written
    ${SPIFunctions["functionName"]}[${spi_configuration}].writeBlock(writeBuffer,buflen);
    
    //Toggle CS line to end operation
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
       
}

void EEPROM2_ReadBlock(uint8_t *readBuffer, uint8_t buflen, uint32_t startAddr)
{
    uint8_t addressBuffer[EEPROM2_ADDRBYTES];
    
    //Wait for write cycle to complete
    EEPROM2_WritePoll();
    
    EEPROM2_AddressAssign(addressBuffer,startAddr);
    
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen();
    ${spiSSPinSettings["setOutputLevelLow"]}
    
    //Send Read Command
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(EEPROM2_READ);
    //Send Address bytes
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(addressBuffer,EEPROM2_ADDRBYTES);
    //Send dummy/NULL data to clock out data bytes from slave
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(readBuffer,buflen);
    
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

static void EEPROM2_AddressAssign(uint8_t *addressBuffer, uint32_t byteAddr)
{
    uint8_t i = 0;
    uint8_t j = EEPROM2_ADDRBYTES - 1;
    uint32_t address = byteAddr;
    
    while(address > 0)
    {
        addressBuffer[j-i] = address & 0xFF;
        i++;
        address >>= 8;
    }
}

static void EEPROM2_WriteEnable(void)
{    
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen();
    ${spiSSPinSettings["setOutputLevelLow"]}

    //Send Write Enable command
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(EEPROM2_WREN);
    
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

static void EEPROM2_CheckStatusRegister(void)
{
    uint8_t check;
    //Check if WEL bit is set
    while(check != 2)
    {
        check = EEPROM2_ReadStatusRegister();
    }
}

static uint8_t EEPROM2_ReadStatusRegister(void)
{
    uint8_t statusByte;
    
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen();
    ${spiSSPinSettings["setOutputLevelLow"]}
    
    //Send Read Status Register Operation
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(EEPROM2_RDSR);
    //Send Dummy data to clock out data byte from slave
    statusByte = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x00);
    
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    
    //return data byte read
    return(statusByte);
}

uint8_t EEPROM2_WritePoll(void)
{
    uint8_t pollByte;
    
    //Read the Status Register
    pollByte = EEPROM2_ReadStatusRegister();
    
    //pollByte = SSP1BUF;
    //Check if WEL and WIP bits are still set
    while(pollByte == 3)
    {
       pollByte = EEPROM2_ReadStatusRegister();
    }
    
    //return 1 if WEL and WIP bits are cleared and the write cycle is finished
    return(1);
}
