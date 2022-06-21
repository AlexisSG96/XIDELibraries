/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <stdbool.h>
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "ThumbStick_driver.h"

//********************************************
// Actions Channels
//********************************************
// Select MCP3204
// SPI communication using 8-bit segments
// Bits 7 & 6 define ADC input
// Get first 8 bits of ADC value
// Shift ADC value by 8
// Get remaining 4 bits of ADC value, and form 12-bit ADC value
// Deselect MCP3204
// Returns 12-bit ADC value

//********************************************
// MCP3402 Driver Function 
//********************************************
uint16_t ThumbStick_MCP3402ReadChannel(MCP3204_MeasurementTypes_t measurementType, MCP3204_Channels_t readChannel)
{
    uint16_t thumbStickValue = 0;

    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }	
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(measurementType);
    thumbStickValue = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(readChannel) & 0x0F;
    thumbStickValue = thumbStickValue << 8;
    thumbStickValue = thumbStickValue |  ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x00);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();

    return thumbStickValue;
}
<#if (thumbStickPressPinKey != "")>
//********************************************
// GPIO Driver Function 
//********************************************
bool ThumbStick_isPressed(void)
{
    return ${stickPressPinSetting["getInputValue"]};
}
</#if>
/**
 End of File
*/