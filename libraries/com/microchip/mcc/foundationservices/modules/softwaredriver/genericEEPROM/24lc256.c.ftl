/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "24lc256.h"
#include "i2c_types.h"
#include "i2c_master.h"
#include "../mcc.h"

/**
  Section: Macro Declarations
*/

#define PAGESIZE 64
#define LC256_ADDRESS 0x50
#define MIN(a,b) (a<b?a:b)

/**
  Section: Data Types Definitions
*/

typedef struct
{
    uint8_t *data;
    uint8_t *dataSize;
} pageWriteSize_t;

LC256_ErrNo_t   LC256_lastError = 0; // 0 represents no error

/**
  Section: Private Function Prototypes
 */ 

static LC256_ADDRESS_t LC256_flipAddress(LC256_ADDRESS_t address);
static i2c_operations_t LC256_wr1ByteCompleteHandler(void *p);
static i2c_operations_t LC256_rd1ByteCompleteHandler(void *p);
static bit writePage(LC256_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
static i2c_operations_t LC256_rdBlockCompleteHandler(void *payload);

/**
  Section: Driver APIs
 */ 

void LC256_writeByte(LC256_ADDRESS_t address, uint8_t data)
{
    address = LC256_flipAddress(address);  //reverse address bytes here
    
    while(!i2c1_open(LC256_ADDRESS)); // sit here until we get the bus..
     
    i2c1_setDataCompleteCallback(LC256_wr1ByteCompleteHandler,&data);
    i2c1_setBuffer(&address,2);
    i2c1_setAddressNACKCallback(i2c_restart_write,NULL); //NACK polling?
    i2c1_masterWrite();
    while(LC256_lastError = i2c1_close(LC256_ADDRESS)); // sit here until finished.
}

uint8_t LC256_readByte(LC256_ADDRESS_t address)
{
    uint8_t data;
    
    address = LC256_flipAddress(address);  //reverse address bytes here
    while(!i2c1_open(LC256_ADDRESS)); // sit here until we get the bus..
    i2c1_setDataCompleteCallback(LC256_rd1ByteCompleteHandler,&data);
    i2c1_setBuffer(&address,2);  
    i2c1_setAddressNACKCallback(i2c_restart_write,NULL); //NACK polling?
    i2c1_masterWrite();    
    while(LC256_lastError = i2c1_close(LC256_ADDRESS)); // sit here until finished. 
    return data;
}

i2c_operations_t writeData(void *payload)
{
    pageWriteSize_t *pgData = payload;
    i2c1_setBuffer(pgData->data,*pgData->dataSize);
    i2c1_setDataCompleteCallback(NULL,NULL);
    return i2c_continue;
}

void LC256_writeBlock(LC256_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{   
    LC256_ADDRESS_t pageAddress = address & 0xFFC0;
    int byte2write = PAGESIZE - (address - pageAddress);
    
    do
    {
        byte2write = MIN(byte2write,dataBlockByteCount);
        writePage(address,dataBlock,byte2write);
        if (LC256_lastError)
            break;
        address += byte2write;
        dataBlock += byte2write;
        dataBlockByteCount -= byte2write;
        byte2write = PAGESIZE;
    } while(dataBlockByteCount);
}

void LC256_readBlock(LC256_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{
    address = LC256_flipAddress(address);  //reverse address bytes here
    
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;
    
    while(!i2c1_open(LC256_ADDRESS));
    i2c1_setDataCompleteCallback(LC256_rdBlockCompleteHandler,&pgData);
    i2c1_setBuffer(&address,2);
    i2c1_setAddressNACKCallback(i2c_restart_write,NULL); //NACK polling?
    i2c1_masterWrite();
    while(LC256_lastError = i2c1_close(LC256_ADDRESS));
}

static LC256_ADDRESS_t LC256_flipAddress(LC256_ADDRESS_t address)
{
    return (address << 8) | (address >> 8);
}

static i2c_operations_t LC256_wr1ByteCompleteHandler(void *p)
{
    i2c1_setBuffer(p,1);
    i2c1_setDataCompleteCallback(NULL,NULL);
    return i2c_continue;
}

static i2c_operations_t LC256_rd1ByteCompleteHandler(void *p)
{
    i2c1_setBuffer(p,1);
    i2c1_setDataCompleteCallback(NULL,NULL);
    return i2c_restart_read;
}

// writes a page
static bit writePage(LC256_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{
    address = LC256_flipAddress(address);  //reverse address bytes here
    
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;
    while(!i2c1_open(LC256_ADDRESS)); // sit here until we get the bus..
    i2c1_setDataCompleteCallback(writeData,&pgData);
    i2c1_setBuffer(&address,2);
    i2c1_setAddressNACKCallback(i2c_restart_write,NULL); //NACK polling?
    i2c1_masterWrite();
    while(LC256_lastError = i2c1_close(LC256_ADDRESS)); // sit here until finished. 
    
    return (LC256_lastError == 0);
}

static i2c_operations_t LC256_rdBlockCompleteHandler(void *payload)
{
    pageWriteSize_t *pgData = payload;
    i2c1_setBuffer(pgData->data,*pgData->dataSize);
    i2c1_setDataCompleteCallback(NULL,NULL);
    return i2c_restart_read;
}

/**
 End of File
 */ 
