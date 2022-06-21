/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "EEPROM3_driver.h"
#include "mcc.h"

#define PAGESIZE    256
#define MIN(a,b) (a<b?a:b)

typedef struct
{
    uint8_t *data;
    uint16_t *dataSize;
} block_t;
    
static uint16_t eeprom_flipAddress(uint16_t address)
{
    return (address << 8) | (address >> 8);
}

static uint8_t getMSBAddress(uint32_t address)
{
    uint8_t deviceAddress;
    deviceAddress = (address & 0xF0000) >> 16;
    return (deviceAddress);
}

static void setDeviceAddress(uint8_t MSBAddress)
{
    switch(MSBAddress)
    {
        case 0x0:
            EEPROM_DEVICE_ADDRESS = (0xA8 >> 1);
            break;
        case 0x1:
            EEPROM_DEVICE_ADDRESS = (0xAA >> 1);
            break;
        case 0x2:
            EEPROM_DEVICE_ADDRESS = (0xAC >> 1);
            break;
        case 0x3:
            EEPROM_DEVICE_ADDRESS = (0xAE >> 1);
            break;
        default:
            break;
        
    }
}

static void resetDeviceAddress()
{
    switch(EEPROM_DEVICE_ADDRESS)
    {
        case 0x54:
            EEPROM_DEVICE_ADDRESS = (0xAA >> 1);
            break;
        case 0x55:
            EEPROM_DEVICE_ADDRESS = (0xAC >> 1);
            break;
        case 0x56:
            EEPROM_DEVICE_ADDRESS = (0xAE >> 1);
            break;
        case 0x57:
            EEPROM_DEVICE_ADDRESS = (0xA8 >> 1);
            break;
        default:
            break;
        
    }
}

static ${I2CFunctions["operations"]} write1ByteHandler(void *p)
{
    ${I2CFunctions["setBuffer"]}(p,1);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["continue"]};
}

static ${I2CFunctions["operations"]} read1ByteHandler(void *p)
{
    ${I2CFunctions["setBuffer"]}(p,1);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["restart_read"]};
}

void EEPROM3_WriteOneByte(uint32_t address, uint8_t data)
{
    uint8_t MSBAddress = getMSBAddress(address);
    setDeviceAddress(MSBAddress);
    while(!${I2CFunctions["open"]}(EEPROM_DEVICE_ADDRESS)); // sit here until we get the bus..
    address = eeprom_flipAddress(address); 
    ${I2CFunctions["setDataCompleteCallback"]}(write1ByteHandler,&data);
    ${I2CFunctions["setBuffer"]}(&address,2);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
    NOP();
}

uint8_t EEPROM3_ReadOneByte(uint32_t address)
{
    uint8_t readData = 0;
    uint8_t MSBAddress = getMSBAddress(address);
    setDeviceAddress(MSBAddress);
    while(!${I2CFunctions["open"]}(EEPROM_DEVICE_ADDRESS)); // sit here until we get the bus..
    address = eeprom_flipAddress(address); 
    ${I2CFunctions["setDataCompleteCallback"]}(read1ByteHandler,&readData);
    ${I2CFunctions["setBuffer"]}(&address,2);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
    return readData;
}

static ${I2CFunctions["operations"]} writeBlockHandler(void *payload)
{
    block_t *pgData = payload;
    ${I2CFunctions["setBuffer"]}(pgData->data,*pgData->dataSize);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["continue"]};
}

static void EEPROM3_WritePage(uint16_t address, uint8_t* data, uint16_t count)
{
    while(!${I2CFunctions["open"]}(EEPROM_DEVICE_ADDRESS)); // sit here until we get the bus..
    address = eeprom_flipAddress(address); 

    block_t blk = {0};
    blk.data = data;
    blk.dataSize = &count;

    ${I2CFunctions["setDataCompleteCallback"]}(writeBlockHandler,&blk);
    ${I2CFunctions["setBuffer"]}(&address,2);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
    NOP();

}

void EEPROM3_WriteBlock(uint32_t address, void *dataBlock, uint16_t dataBlockByteCount)
{   
    uint8_t MSBAddress = getMSBAddress(address);
    setDeviceAddress(MSBAddress);
    uint16_t wordAddress = (address & 0x00FFFF);
    uint16_t pageAddress = wordAddress & 0xFF00;
    uint32_t byte2write = PAGESIZE - (wordAddress - pageAddress);
    uint8_t *block = dataBlock;
    do
    {
        byte2write = MIN(byte2write,dataBlockByteCount);
        EEPROM3_WritePage(wordAddress,block,byte2write);
        wordAddress = wordAddress + byte2write;
        if(wordAddress == 0){
            resetDeviceAddress();
        }
        block = block + byte2write;
        dataBlockByteCount = dataBlockByteCount - byte2write;
        byte2write = PAGESIZE;
        <#if (isAVR == "true")>
		_delay_ms(5);
		<#else>
		__delay_ms(5);
		</#if><#if (isAVR == "true")>
		_delay_ms(5);
		<#else>
		__delay_ms(5);
		</#if>
    } while(dataBlockByteCount);
}

static ${I2CFunctions["operations"]} readBlockHandler(void *payload)
{
    block_t *pgData = payload;
    ${I2CFunctions["setBuffer"]}(pgData->data,*pgData->dataSize);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["restart_read"]};
}

void EEPROM3_ReadBlock(uint32_t address, void* data, uint16_t count)
{
    uint8_t MSBAddress = getMSBAddress(address);
    setDeviceAddress(MSBAddress);
    uint16_t wordAddress = (address & 0x00FFFF);
    while(!${I2CFunctions["open"]}(EEPROM_DEVICE_ADDRESS)); // sit here until we get the bus..
    wordAddress = eeprom_flipAddress(wordAddress); 
    block_t blk = {0};
    blk.data = data;
    blk.dataSize = &count;
    ${I2CFunctions["setDataCompleteCallback"]}(readBlockHandler,&blk);
    ${I2CFunctions["setBuffer"]}(&wordAddress,2);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
    
}