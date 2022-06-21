/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "MCP3201.h"

uint16_t MCP3201_getConversionResult(void) {
    uint16_t res;
    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    res = ${SPIFunctions["exchangeByte"]}(0xFF);
    res <<= 8;
    res += ${SPIFunctions["exchangeByte"]}(0xFF);
    res &= 0x1FFF;
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();

    return (res >> 1);        // Remove duplicate bit
}
