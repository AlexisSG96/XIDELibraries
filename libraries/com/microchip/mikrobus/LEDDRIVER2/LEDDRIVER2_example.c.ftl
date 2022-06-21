/*
<#include "MicrochipDisclaimer.ftl">
*/
#include "mcc.h"
#include "LEDDRIVER2_example.h"
#include "LEDDRIVER2_driver.h"

/**
 * @brief  This is an Example function for reading LED DRIVER 2 click
 * @param  None
 * @return None
 */
void  LEDDRIVER2_Example(void) 
{
    //Set 0% PWM Duty cycle,Example considered 4 bits resolution
    LEDDRIVER2_SetBrightness(0);
     <#if (isAVR == "true")>
	 _delay_ms(1000);
	 <#else>
	 __delay_ms(1000);
	 </#if>
    //Set 25% PWM Duty cycle,Example considered 4 bits resolution
     LEDDRIVER2_SetBrightness(3);
     <#if (isAVR == "true")>
	 _delay_ms(1000);
	 <#else>
	 __delay_ms(1000);
	 </#if>  
    //Set 50% PWM Duty cycle,Example considered 4 bits resolution
     LEDDRIVER2_SetBrightness(7);
     <#if (isAVR == "true")>
	 _delay_ms(1000);
	 <#else>
	 __delay_ms(1000);
	 </#if>  
    //Set 75% PWM Duty cycle,Example considered 4 bits resolution
     LEDDRIVER2_SetBrightness(11);
     <#if (isAVR == "true")>
	 _delay_ms(1000);
	 <#else>
	 __delay_ms(1000);
	 </#if>  
    //Set 100% PWM Duty cycle,Example considered 4 bits resolution
     LEDDRIVER2_SetBrightness(15);
    <#if (isAVR == "true")>
	_delay_ms(1000);
	<#else>
	__delay_ms(1000);
	</#if>
}