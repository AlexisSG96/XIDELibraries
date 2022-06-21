/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "TX420mA.h"
#include "${SPIFunctions.spiHeader}"
#include "${pinHeader}"

// Control register values
#define CTRL_DACA	0x00
#define CTRL_UNBUFFERED	0x00
#define CTRL_BUFFERED	0x40
#define CTRL_GAIN_1X	0x20
#define CTRL_GAIN_2X	0x00
#define CTRL_ENABLED	0x10
#define CTRL_DISABLED	0x00

void TX420mA_Set(uint16_t value)
{
    uint8_t ctrl_byte = CTRL_DACA | CTRL_UNBUFFERED | CTRL_GAIN_1X | CTRL_ENABLED;
	
    ${SPIFunctions.spiOpen}(${spi_configuration});
    ${spiSSPinSettings.setOutputLevelLow}

    ${SPIFunctions.exchangeByte}(((uint8_t)(value >> 8) & 0x0F) | (ctrl_byte & 0xF0));
    ${SPIFunctions.exchangeByte}((uint8_t) (value & 0x00FF));

    ${spiSSPinSettings.setOutputLevelHigh}
    ${SPIFunctions.spiClose}();
}