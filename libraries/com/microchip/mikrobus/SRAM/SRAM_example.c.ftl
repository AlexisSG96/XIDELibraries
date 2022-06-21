 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "SRAM_example.h"
#include "SRAM.h"

void SRAM_Example(void){
    uint8_t val = 0;
    while (1) {
        SRAM_ByteWrite(0xAA, val);
        val = SRAM_ByteRead(0xAA) + 1;
    }
}
