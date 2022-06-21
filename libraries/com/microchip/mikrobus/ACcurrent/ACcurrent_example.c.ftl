 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "ACcurrent_example.h"
#include "ACcurrent.h"
#include "mcc.h"

void ACcurrent_example(void) {
    while (1) {
        uint16_t milliAmps = ACcurrent_getCurrent();
        uint32_t output = (uint32_t) (milliAmps / 4);
        printf("%u\n", output);
        <#if (isAVR == "true")>
		_delay_ms(500);
		<#else>
		__delay_ms(500);
		</#if>
    }
}
