/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "I2C_functions.h"
#include "i2c_types.h"
#include "i2c_master.h"


i2c_operations_t wr1ByteCompleteHandler(void *p)
{
    ${I2CFunctions["setBuffer"]}(p,1);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["continue"]};
}

i2c_operations_t rd1ByteCompleteHandler(void *p)
{
    ${I2CFunctions["setBuffer"]}(p,1);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["restart_read"]};
}

i2c_operations_t writeData(void *payload)
{
    pageWriteSize_t *pgData = payload;
    ${I2CFunctions["setBuffer"]}(pgData->data,*pgData->dataSize);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["continue"]};
}
// writes a page
__bit writePage(EERAM5V_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount)
{
    pageWriteSize_t pgData = {0};
    pgData.data = dataBlock;
    pgData.dataSize = &dataBlockByteCount;
    
    // Since it is little endian, to send the MSB first, swapping the bytes are required  
    address = (address << 8) | (address >> 8);
    
    while(!${I2CFunctions["open"]}(EERAM5V_7BITS_SRAM_ADDRESS)); // sit here until we get the bus..
    ${I2CFunctions["setDataCompleteCallback"]}(writeData,&pgData);
    ${I2CFunctions["setBuffer"]}(&address,2);
    ${I2CFunctions["setAddressNACKCallback"]}(i2c_restart_write,NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
    
    return (eeram5v_lastError = 0);
}

i2c_operations_t rdBlockCompleteHandler(void *payload)
{
    pageWriteSize_t *pgData = payload;
    ${I2CFunctions["setBuffer"]}(pgData->data,*pgData->dataSize);
    ${I2CFunctions["setDataCompleteCallback"]}(NULL,NULL);
    return ${I2CFunctions["restart_read"]};
}
/**
 End of File
 */ 
