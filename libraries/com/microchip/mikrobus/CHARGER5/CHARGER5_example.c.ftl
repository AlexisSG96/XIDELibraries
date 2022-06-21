/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "CHARGER5_example.h"
#include "CHARGER5_driver.h"
#include "device_config.h"
#ifdef __XC
#include <xc.h>
#endif

/**
 * @brief  this is an example function for CHARGER5 click
 * @param  None
 * @return None
 */
void CHARGER5_Example(void)
{
    uint16_t data =0x0000;
    CHARGER5_SetCurrent(data);
    while(data++ < 0x03FF)
    {    
        CHARGER5_IncrementWiper(1);
        <#if (isAVR == "true")>
		_delay_ms(10);
		<#else>
		__delay_ms(10);
		</#if>
    }  
    data =0x0000;
    while(data++ < 0x03FF)
    {    
        CHARGER5_DecrementWiper(1);
        <#if (isAVR == "true")>
		_delay_ms(10);
		<#else>
		__delay_ms(10);
		</#if>
    }
}    