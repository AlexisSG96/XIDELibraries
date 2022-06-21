 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include <stdint.h>
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"

// Receiving in the form abcdefg.
// want to transform to the form gfedcab.
static uint8_t transform(uint8_t from)
{
    uint8_t i = 0;
    uint8_t to;
    
    to = from & 0x01;           // . in correct spot
    to += (from >> 5) & 0x06;   // Move AB to the right spot
    from = from >> 1;

    for(i = 0; i < 5; i++)
    { 
        // Get CDEFG in the right spots
        to |= ((from & 0x01) << (8-i-1));
        from = from >> 1;
    }
    return to;
}

void LED7seg_Write(uint8_t tens, uint8_t ones)
{
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }
    ${latchPinSetting["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(transform(ones));
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(transform(tens));
    ${latchPinSetting["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}
