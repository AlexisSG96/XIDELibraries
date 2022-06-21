/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */
#include <xc.h>
#include <stdbool.h>

#include "I2CEEPROM_app.h"
#include "../mcc.h"
#include "../mssp_driver.h"
#include "../drivers/i2c_types.h"
#include "../drivers/i2c_master.h"


/**
  Section: Driver APIs
 */ 

#define PAGESIZE 128
#define EEPROM_ADDRESS 0x50
#define MIN(a,b) (a<b?a:b)

typedef struct
{
    uint8_t *data;
    uint8_t *dataSize;
} pageWriteSize_t;

eeprom_ErrNo_t   eeprom_lastError = 0; // 0 represents no error

// Private function prototypes
static EEPROM_ADDRESS_t eeprom_flipAddress(EEPROM_ADDRESS_t address);
static i2c_operations_t wr1ByteCompleteHandler(void *p);
static i2c_operations_t rd1ByteCompleteHandler(void *p);
static __bit writePage(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
static i2c_operations_t rdBlockCompleteHandler(void *payload);


void I2CEEPROM_WriteByte(EEPROM_ADDRESS_t address, uint8_t data)
{
    address = eeprom_flipAddress(address);  //reverse address bytes here
    
    while(!${open}(EEPROM_ADDRESS)); // sit here until we get the bus..
     
    ${setDataCompleteCallback}(wr1ByteCompleteHandler,&data);
    ${setBuffer}(&address,2);
    ${setAddressNACKCallback}(i2c_restart_write,NULL); //NACK polling?
    ${masterWrite}();
    IO_RA2_SetLow();
    while(eeprom_lastError = ${close}(EEPROM_ADDRESS)); // sit here until finished.
    IO_RA2_SetHigh();
}

uint8_t I2CEEPROM_ReadByte(EEPROM_ADDRESS_t address)
{
    uint8_t data;
    
    address = eeprom_flipAddress(address);  //reverse address bytes here

    while(!${open}(EEPROM_ADDRESS)); // sit here until we get the bus..

    ${setDataCompleteCallback}(rd1ByteCompleteHandler,&data);
    ${setBuffer}(&address,2);
    ${setAddressNACKCallback}(i2c_restart_write,NULL); //NACK polling?
    ${masterWrite}();
    IO_RA2_SetLow();
    while(eeprom_lastError = ${close}(EEPROM_ADDRESS)); // sit here until finished.
    IO_RA2_SetHigh();
    return data;
}

i2c_operations_t writeData(void *payload)
{
    pageWriteSize_t *pgData = payload;
    ${setBuffer}(pgData->data,*pgData->dataSize);
    ${setDataCompleteCallback}(NULL,NULL);
    return i2c_continue;
}

void I2CEEPROM_WriteBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{   
    EEPROM_ADDRESS_t pageAddress = address & 0xFFC0;
    int byte2write = PAGESIZE - (address - pageAddress);
    
    do
    {
        byte2write = MIN(byte2write,dataBlockByteCount);
        writePage(address,dataBlock,byte2write);
        if (eeprom_lastError)
            break;
        address += byte2write;
        dataBlock += byte2write;
        dataBlockByteCount -= byte2write;
        byte2write = PAGESIZE;
    } while(dataBlockByteCount);
}

void I2CEEPROM_ReadBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{
    address = eeprom_flipAddress(address);  //reverse address bytes here
    
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;
    
    while(!${open}(EEPROM_ADDRESS));
    ${setDataCompleteCallback}(rdBlockCompleteHandler,&pgData);
    ${setBuffer}(&address,2);
    ${setAddressNACKCallback}(i2c_restart_write,NULL); //NACK polling?
    ${masterWrite}();
    while(eeprom_lastError = ${close}(EEPROM_ADDRESS));
}

static EEPROM_ADDRESS_t eeprom_flipAddress(EEPROM_ADDRESS_t address)
{
    return (address << 8) | (address >> 8);
}

static i2c_operations_t wr1ByteCompleteHandler(void *p)
{
    ${setBuffer}(p,1);
    ${setDataCompleteCallback}(NULL,NULL);
    return i2c_continue;
}

static i2c_operations_t rd1ByteCompleteHandler(void *p)
{
    ${setBuffer}(p,1);
    ${setDataCompleteCallback}(NULL,NULL);
    return i2c_restart_read;
}

// writes a page
static __bit writePage(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{
    address = eeprom_flipAddress(address);  //reverse address bytes here
    
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;

    while(!${open}(EEPROM_ADDRESS)); // sit here until we get the bus..
    ${setDataCompleteCallback}(writeData,&pgData);
    ${setBuffer}(&address,2);
    ${setAddressNACKCallback}(i2c_restart_write,NULL); //NACK polling?
    ${masterWrite}();
    while(eeprom_lastError = ${close}(EEPROM_ADDRESS)); // sit here until finished. 
    
    return (eeprom_lastError == 0);
}

static i2c_operations_t rdBlockCompleteHandler(void *payload)
{
    pageWriteSize_t *pgData = payload;
    ${setBuffer}(pgData->data,*pgData->dataSize);
    ${setDataCompleteCallback}(NULL,NULL);
    return i2c_restart_read;
}
/**
 End of File
 */ 
