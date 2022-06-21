/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "MCP3551.h"
#include "slider.h"

// 16-bit right-justified ADC result
uint16_t SLIDER_getPosition(void) {
    uint32_t pos = MCP3551_getSingleConversion();
    pos = pos * 42 / 17; // R3 - R4 divider
    pos >>= 4;
    return pos;
}

void SLIDER_setLEDS(uint16_t val) {
    ${outputEnablePinSettings["LAT"]} = 0;

    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    ${SPIFunctions["exchangeByte"]}(val >> 8);
    ${SPIFunctions["exchangeByte"]}(val);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
    
    // Update LEDS
    ${latchEnablePinSettings["LAT"]} = 1;     
    ${latchEnablePinSettings["LAT"]} = 0;
}

// Displays a bar representation of the input value
void SLIDER_setBar(uint16_t val) {
    uint16_t bar = 1;
    val >>= 12;
    for (uint8_t i = 1; i <= val; i++) {
        bar = (bar << 1) | 1;
    }
    
    SLIDER_setLEDS(bar);
}