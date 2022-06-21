/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "TempLog.h"
#include "TempLog_example.h"
<#if (isAVR == "true")>
#include "Config/clock_config.h"
#include <util/delay.h>
<#else>
#include <xc.h>
#include "device_config.h"
</#if>
#include <stdint.h>
#include <stdio.h>

/**
  Section: Example
 */

void TempLog_example(void){
    float Tempvalue;
    Tempvalue = TempLog_readTemperature(${InitReso});
    printf("Temperature Value= %4.4f\n\r", Tempvalue);
    <#if (InitReso == "r_9bits")>
    <#if (isAVR == "true")>
    _delay_ms(25);
    <#else>
    __delay_ms(25);
    </#if>
    <#elseif (InitReso == "r_10bits")>
    <#if (isAVR == "true")>
    _delay_ms(50);
    <#else>
    __delay_ms(50);
    </#if>
    <#elseif (InitReso == "r_11bits")>
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    <#else>
    <#if (isAVR == "true")>
    _delay_ms(200);
    <#else>
    __delay_ms(200);
    </#if>
    </#if>
}