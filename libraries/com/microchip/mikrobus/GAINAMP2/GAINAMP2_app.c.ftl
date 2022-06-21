/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "GAINAMP2.h"

void GAINAMP2_setGain(GAINAMP_gain_t gain) {
    ${SPIFunctions["spiOpen"]}(GAINAMP2);
    ${spiSSPinSettings["LAT"]} = 0;
    ${SPIFunctions["exchangeByte"]}(0x40);
    ${SPIFunctions["exchangeByte"]}(gain);
    ${spiSSPinSettings["LAT"]} = 1;
    ${SPIFunctions["spiClose"]}();
}

void GAINAMP2_selectChannel(uint8_t channel) {
    if (channel < 6) {
        ${SPIFunctions["spiOpen"]}(GAINAMP2);
        ${spiSSPinSettings["LAT"]} = 0;
        ${SPIFunctions["exchangeByte"]}(0x41);
        ${SPIFunctions["exchangeByte"]}(channel);
        ${spiSSPinSettings["LAT"]} = 1;
        ${SPIFunctions["spiClose"]}();
    }
}

// Device exits shutdown when any other valid command is sent
void GAINAMP2_shutdown(void) {
    ${SPIFunctions["spiOpen"]}(GAINAMP2);
    ${spiSSPinSettings["LAT"]} = 0;
    ${SPIFunctions["exchangeByte"]}(0x20);
    ${SPIFunctions["exchangeByte"]}(0xFF);
    ${spiSSPinSettings["LAT"]} = 1;
    ${SPIFunctions["spiClose"]}();
}
