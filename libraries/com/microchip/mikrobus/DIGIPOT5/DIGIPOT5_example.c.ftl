#include <stdint.h>
#include "DIGIPOT5.h"
#include "DIGIPOT5_example.h"

#define RAB             10000
#define RW              75                      // Wiper internal resistance

uint16_t DIGIPOT5_toWiper(uint16_t resistance);

void DIGIPOT5_example(void) {
    DIGIPOT_set(DIGIPOT5_toWiper(${resistanceChannel0}));
    <#if (saveChannel0 == "enabled")>
    DIGIPOT_save();
    </#if>
    DIGIPOT_setChannel(1);
    DIGIPOT_set(DIGIPOT5_toWiper(${resistanceChannel1}));
    <#if (saveChannel1 == "enabled")>
    DIGIPOT_save();
    </#if>
    DIGIPOT_setChannel(2);
    DIGIPOT_set(DIGIPOT5_toWiper(${resistanceChannel2}));
    <#if (saveChannel2 == "enabled")>
    DIGIPOT_save();
    </#if>
    DIGIPOT_setChannel(3);
    DIGIPOT_set(DIGIPOT5_toWiper(${resistanceChannel3}));
    <#if (saveChannel3 == "enabled")>
    DIGIPOT_save();
    </#if>
}

uint16_t DIGIPOT5_toWiper(uint16_t resistance) {
    uint16_t wiperVal;
    
    if (resistance <= RW) {
        wiperVal = 0;
    } else if (resistance >= RAB) {
        wiperVal = 0x100;
    } else {
        wiperVal = ((resistance - RW) * 256UL) / RAB;
    }
    
    <#if (comboSettings=="Left-justified")>
    return wiperVal << 7;
    <#elseif (comboSettings=="Right-justified")>
    return wiperVal;
    </#if>
}
