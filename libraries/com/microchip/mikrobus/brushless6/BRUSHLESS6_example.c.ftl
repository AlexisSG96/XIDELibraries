/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "device_config.h"
#include "brushless6_example.h"
#include "brushless6.h"

void BRUSHLESS6_example(void) {
    
    int8_t checkRangeWidth = 64;
    for (int8_t speed = -checkRangeWidth; speed <= checkRangeWidth; speed++) {
        BRUSHLESS6_setSpeed(speed);
        <#if (isAVR == "true")>
		_delay_ms(50);
		<#else>
		__delay_ms(50);
		</#if>
    }
    
    BRUSHLESS6_setSpeed(${speedValue});
}
