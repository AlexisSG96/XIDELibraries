/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */
#include <xc.h>
#include <stdbool.h>

#include "SPIEEPROM_app.h"
#include "../mssp_driver.h"
#include "../spi_types.h"


/**
  Section: Driver APIs
 */ 

#define assert 0
#define deassert 1
#define chip_select LATE2

eeprom_ErrNo_t   eeprom_lastError;

static inline void writeEnable(void)
{
    chip_select = assert;
    ${exchangeByte}(0x06);
    chip_select = deassert;
}

static inline void writeAddress(EEPROM_ADDRESS_t address)
{
    ${exchangeByte}(address>>8);
    ${exchangeByte}(address);    
}

void SPIEEPROM_WriteByte(EEPROM_ADDRESS_t address, uint8_t data) {
   eeprom_lastError = fail_busy;
    if(${initHardware}(SPI_MODE00,SPI_FASTEST))
    {
        writeEnable();
        chip_select = assert;
        ${exchangeByte}(0x02);
        writeAddress(address);
        ${exchangeByte}(data);
        chip_select = deassert;
        ${close}();
        eeprom_lastError = noError;
    }
}

uint8_t SPIEEPROM_ReadByte(EEPROM_ADDRESS_t address) {
    
    uint8_t  data = 0;
    eeprom_lastError = fail_busy;
    if(${initHardware}(SPI_MODE00,SPI_FASTEST))
    {
        chip_select = assert;
        ${exchangeByte}(0x03);
        writeAddress(address);
        data = ${exchangeByte}(0);
        chip_select = deassert;
        ${close}();
        eeprom_lastError = noError;
    }
    return data;
}

void SPIEEPROM_WriteBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount) {   
    eeprom_lastError = fail_busy;
    if(${initHardware}(SPI_MODE00,SPI_FASTEST))
    {
        writeEnable();
        chip_select = assert;
        ${exchangeByte}(0x02);
        writeAddress(address);
        ${writeBlock}(dataBlock,dataBlockByteCount);
        chip_select = deassert;
        ${close}();
        eeprom_lastError = noError;
    }  
}

void SPIEEPROM_ReadBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount) {
    eeprom_lastError = fail_busy;
    if(${initHardware}(SPI_MODE00,SPI_FASTEST))
    {
        chip_select = assert;
        ${exchangeByte}(0x03);
        writeAddress(address);
        ${readBlock}(dataBlock,dataBlockByteCount);
        chip_select = deassert;
        ${close}();
        eeprom_lastError = noError;
    }
}

/**
 End of File
 */ 
