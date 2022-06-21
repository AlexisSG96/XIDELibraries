/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "MCP3551.h"

void MCP3551_startConversion(void) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
}

void MCP3551_stopConversion(void) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1; 
}

uint32_t MCP3551_getConversionResult(void) {
    uint32_t result;
    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    result = ${SPIFunctions["exchangeByte"]}(0xFF);
    result <<= 8;
    result += ${SPIFunctions["exchangeByte"]}(0xFF);
    result <<= 8;
    result += ${SPIFunctions["exchangeByte"]}(0xFF);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
    return result;
}

bool MCP3551_isSingleConversionDone(void) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    return !SDI${SPIFunctions["msspInstance"]}_GetValue();
}

uint32_t MCP3551_getSingleConversion(void) {
    MCP3551_stopConversion();
    MCP3551_startConversion();
    while(!MCP3551_isSingleConversionDone());
    return MCP3551_getConversionResult();
}
