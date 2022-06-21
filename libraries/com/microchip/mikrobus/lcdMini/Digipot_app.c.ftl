 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "digipot.h"
#include <stdint.h>
#include "../${pinHeader}"
#include "../${SPIFunctions["spiHeader"]}"


void digipot_setWiper(uint8_t val){
    ${SPIFunctions["spiOpen"]}(LCD);
    ${led7SegnCS2PinSetting["setOutputLevelLow"]}
    uint8_t cmd[2];
    cmd[0] = 0;
    cmd[1] = val;
    ${SPIFunctions["writeBlock"]}(cmd, 2);
    ${led7SegnCS2PinSetting["setOutputLevelHigh"]}
    ${SPIFunctions["spiClose"]}();
}
