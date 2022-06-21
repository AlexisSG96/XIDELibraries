 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LightRanger_Example.h"
#include "LightRanger.h"
#include "mcc.h"

void Example_ReadRange(void){
    while(1){
        LR_StartRange(SINGLE_SHOT);
        <#if (isAVR == "true")>
		_delay_ms(105);
		<#else>
		__delay_ms(105);
		</#if>
        uint16_t als = LR_ReadRange();
        printf("Range is %d\r\n", als);
    }
}