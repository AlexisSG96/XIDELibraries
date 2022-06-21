 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "mcc.h"
#include "BTA_example.h"
#include "BTA.h"

void BTA_Example(void) {

    BTA_SetSpeakerGain(0xA);

    while(1){
        BTA_PausePlay();
        <#if (isAVR == "true")>
		_delay_ms(5000);
		<#else>
		__delay_ms(5000);
		</#if>
        BTA_PausePlay();
        <#if (isAVR == "true")>
		_delay_ms(5000);
		<#else>
		__delay_ms(5000);
		</#if>
    }
}
