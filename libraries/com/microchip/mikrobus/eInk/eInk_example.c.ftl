 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "mcc.h"

void eInk_example(void){
    eInk_startDisplayWrite();
    int i;

    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(3, 3, 3, 3);
    }
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(2, 2, 2, 2);
    }
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(1, 1, 1, 1);
    }
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(0, 0, 0, 0);
        ;
    }
    eInk_stopDisplayWrite();
    <#if (isAVR == "true")>
	_delay_ms(5000);
	<#else>
	__delay_ms(5000);
	</#if>

    eInk_startDisplayWrite();
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(0, 0, 0, 0);
    }
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(1, 1, 1, 1);
    }
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(2, 2, 2, 2);
    }
    for (i = 0; i < 3096 / 4; i++) {
        eInk_displayWrite(3, 3, 3, 3);
    }
    eInk_stopDisplayWrite();
    <#if (isAVR == "true")>
	_delay_ms(5000);
	<#else>
	__delay_ms(5000);
	</#if>
}
