 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include <stdint.h>
#include "../${pinHeader}"
#include "../${SPIFunctions["spiHeader"]}"


#define IODIRB 0x01
#define OLATB 0x15
#define WRITE_BYTE 0b01000000

void expander_sendByte(uint8_t addr, uint8_t byte){
    ${SPIFunctions["spiOpen"]}(LCD);
    ${spiSSPinSettings["setOutputLevelLow"]}
    uint8_t cmd[3];
    cmd[0] = WRITE_BYTE;
    cmd[1] = addr;
    cmd[2] = byte;
    ${SPIFunctions["writeBlock"]}(cmd, 3);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["spiClose"]}();
}

void expander_setup(void){
    expander_sendByte(IODIRB, 0);
}

void expander_setOutput(uint8_t output){
    expander_sendByte(OLATB, output);
}
