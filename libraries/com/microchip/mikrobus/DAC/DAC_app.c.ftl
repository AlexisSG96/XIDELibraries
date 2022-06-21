/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"

// Control register values
#define CTRL_DACA	0x00
#define CTRL_UNBUFFERED	0x00
#define CTRL_BUFFERED	0x40
#define CTRL_GAIN_1X	0x20
#define CTRL_GAIN_2X	0x00
#define CTRL_ENABLED	0x10
#define CTRL_DISABLED	0x00

void DAC_Set(uint16_t dacValue)
{
    uint8_t ctrl_byte = CTRL_DACA | CTRL_${buffered} | CTRL_GAIN_${gain} | CTRL_ENABLED;
	
    if(${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
        ${spiSSPinSettings["setOutputLevelLow"]}
        ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(((uint8_t)(dacValue >> 8) & 0x0F) | (ctrl_byte & 0xF0));
        ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte((uint8_t) (dacValue & 0x00FF));
        ${spiSSPinSettings["setOutputLevelHigh"]}
        ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    }
}