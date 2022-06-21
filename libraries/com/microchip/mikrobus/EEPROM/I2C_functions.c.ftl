/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "I2C_functions.h"
#include "../${I2CFunctions["typeheader"]}"


${I2CFunctions["operations"]} wr1ByteCompleteHandler(void *p)
{
    ${I2CFunctions["setBuffer"]}(p,1);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["continue"]};
}

${I2CFunctions["operations"]} rd1ByteCompleteHandler(void *p)
{
    ${I2CFunctions["setBuffer"]}(p,1);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["restart_read"]};
}

${I2CFunctions["operations"]} writeData(void *payload)
{
    pageWriteSize_t *pgData = payload;
    ${I2CFunctions["setBuffer"]}(pgData->data,*pgData->dataSize);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["continue"]};
}
// writes a page
__bit writePage(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;

    while(!${I2CFunctions["open"]}(EEPROM_ADDRESS)); // sit here until we get the bus..
    ${I2CFunctions["setDataCompleteCallback"]}(writeData,&pgData);
    ${I2CFunctions["setBuffer"]}(&address,1);
    ${I2CFunctions["setAddressNACKCallback"]}(${I2CFunctions["restartWrite"]},NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
    
    return (eeprom_lastError = 0);
}

${I2CFunctions["operations"]} rdBlockCompleteHandler(void *payload)
{
    pageWriteSize_t *pgData = payload;
    ${I2CFunctions["setBuffer"]}(pgData->data,*pgData->dataSize);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["restart_read"]};
}
/**
 End of File
 */ 
