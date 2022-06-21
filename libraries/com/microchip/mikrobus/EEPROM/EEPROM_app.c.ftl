/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdbool.h>

#include "EEPROM_app.h"
#include "${I2CFunctions["typeheader"]}"

/**
  Section: Driver APIs
 */ 

void EEPROM_WriteByte(EEPROM_ADDRESS_t address, uint8_t data)
{   
    while(!${I2CFunctions["open"]}(EEPROM_ADDRESS)); // sit here until we get the bus..
     
    ${I2CFunctions["setDataCompleteCallback"]}(wr1ByteCompleteHandler,&data);
    ${I2CFunctions["setBuffer"]}(&address,1);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}());  // sit here until finished.

}

uint8_t EEPROM_ReadByte(EEPROM_ADDRESS_t address)
{
    uint8_t data;

    while(!${I2CFunctions["open"]}(EEPROM_ADDRESS)); // sit here until we get the bus..

    ${I2CFunctions["setDataCompleteCallback"]}(rd1ByteCompleteHandler,&data);
    ${I2CFunctions["setBuffer"]}(&address,1);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished
    return data;
}

void EEPROM_WriteBlock(EEPROM_ADDRESS_t address, void *dataBlock, uint8_t dataBlockByteCount)
{   
    int byte2write = PAGESIZE;
    
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

void EEPROM_ReadBlock(EEPROM_ADDRESS_t address, void *dataBlock, uint8_t dataBlockByteCount)
{
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;
    
    while(!${I2CFunctions["open"]}(EEPROM_ADDRESS));
    ${I2CFunctions["setDataCompleteCallback"]}(rdBlockCompleteHandler,&pgData);
    ${I2CFunctions["setBuffer"]}(&address,1);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
}

/**
 End of File
 */ 
