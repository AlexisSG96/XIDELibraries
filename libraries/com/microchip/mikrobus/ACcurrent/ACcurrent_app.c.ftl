 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "ACcurrent.h"
#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

uint16_t ACcurrent_getCurrent(void) {
    ${SPIFunctions["spiOpen"]}(CURRENT);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    uint8_t block[2];
    ${SPIFunctions["readBlock"]}(block, 2);
    uint16_t val = block[1] + (block[0] << 8);
    val *= 4.08;
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
    return val;
}
