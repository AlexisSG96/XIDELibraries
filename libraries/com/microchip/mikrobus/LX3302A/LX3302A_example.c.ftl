/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <xc.h>
<#if (pwmCaptureEnable == "enabled")>
#include "interrupt_manager.h"
</#if>
#include "LX3302A.h"
#include "LX3302A_example.h"

void LX3302A_example(void) 
{
    <#if (pwmCaptureEnable == "enabled")>
    uint16_t pwmPeriodRaw;
    uint16_t pwmDutyRaw;
    uint8_t percentage;
    </#if>
    <#if ANOUTFunctions?has_content>
    uint16_t adcResult;
    </#if>
    
    <#if (pwmCaptureEnable == "enabled")>
    INTERRUPT_GlobalInterruptDisable();
    pwmPeriodRaw = LX3302A_globalCapturedpwmPeriodFromISR;
    pwmDutyRaw = LX3302A_globalCapturedpwmDutyFromISR;
    percentage = LX3302A_GetPercentage();
    INTERRUPT_GlobalInterruptEnable();
    
    printf("Percentage: %d, Period raw: %d, Duty raw: %d\r\n", 
            percentage, pwmPeriodRaw, pwmDutyRaw);
    </#if>
    <#if ANOUTFunctions?has_content>
    adcResult = LX3302A_getAveragedADCResult();
    printf("ADC result: %d\r\n", adcResult);
    </#if>
    
    printf("\r\n");
}
