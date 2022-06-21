/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

<#if (isPIC == "true")>
#include "device_config.h"
</#if>
#include "buck2.h"
#include "buck2_example.h"
<#if (isAVR == "true")>
#include "Config/clock_config.h"
#include <util/delay.h>
</#if>

<#macro delay value>
<#if (isAVR == "true")>
    _delay_ms(${value});
<#else>
    __delay_ms(${value});
</#if>  
</#macro>

/**
  Section: Example Code
 */

void BUCK2_Example(void) {
	BUCK2_setVoltage_700mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_800mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_900mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_1000mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_1200mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_1500mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_1800mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_2500mV();
<@delay value="3000"/> 
	BUCK2_setVoltage_3300mV();
<@delay value="3000"/> 
}
