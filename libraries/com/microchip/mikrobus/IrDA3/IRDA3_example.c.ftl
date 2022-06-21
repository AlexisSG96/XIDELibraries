/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "IRDA3.h"
#include "IRDA3_example.h"
#include "mcc.h"

void IRDA3_example(void) 
{
    <#if resetPinSettings.LAT?has_content>
    ${resetPinSettings["LAT"]} = 1; // Exit reset
    </#if>
    
    IRDA3_Write(0xAA);
    if (IRDA3_is_rx_ready()) {
        if (IRDA3_Read() == 0x55) {
            // Add your application code
            // LED_Toggle();
        }
    }

    <#if (isAVR == "true")>
	_delay_ms(50);
	<#else>
	__delay_ms(50);
	</#if>
}
