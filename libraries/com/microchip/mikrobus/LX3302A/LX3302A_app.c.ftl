#ifdef __XC
#include <xc.h>
#endif
<#if (pwmCaptureEnable == "enabled")>
#include <stdbool.h>
#include "${pinHeader}"
#include "${CCPFunctions["CCPHeader"]}"
</#if>
<#if ANOUTFunctions?has_content>
#include "${ANOUTFunctions["adcheader"]}"
</#if>
#include "LX3302A.h"

<#if (pwmCaptureEnable == "enabled")>
#define dPWM_FALLING_EDGE               ${fallingEdge}
#define dPWM_RISING_EDGE                ${risingEdge}
</#if>
<#if ANOUTFunctions?has_content>
#define dADC_SAMPLES                    4
</#if>

<#if (pwmCaptureEnable == "enabled")>
static void LX3302A_CaptureCallback(uint16_t capturedValue);

volatile uint16_t LX3302A_globalCapturedpwmPeriodFromISR;
volatile uint16_t LX3302A_globalCapturedpwmDutyFromISR;
static uint16_t previousCapturedValueRising;
static uint8_t polaritySetting = dPWM_FALLING_EDGE;
</#if>
<#if ANOUTFunctions?has_content>
static uint16_t adcAverage;
</#if>

void LX3302A_Initialize(void) 
{
    <#if (pwmCaptureEnable == "enabled")>
    ${CCPFunctions["SetCaptureCallback"]}(LX3302A_CaptureCallback);
    ${captureModeSetting} = dPWM_FALLING_EDGE;
    </#if>
}
<#if (pwmCaptureEnable == "enabled")>
uint8_t LX3302A_GetPercentage(void) 
{
    uint16_t dutyRaw, periodRaw;
    bool hasBeenCorrupted;
    
    dutyRaw = LX3302A_globalCapturedpwmDutyFromISR;
    hasBeenCorrupted = (bool) (dutyRaw != LX3302A_globalCapturedpwmDutyFromISR);
 
    periodRaw = LX3302A_globalCapturedpwmPeriodFromISR;
    hasBeenCorrupted |= (bool) (periodRaw != LX3302A_globalCapturedpwmPeriodFromISR);
    
    return hasBeenCorrupted ? 255 : 100 * (uint32_t)dutyRaw / periodRaw;
}

static void LX3302A_CaptureCallback(uint16_t capturedValue) 
{
    if (polaritySetting == dPWM_RISING_EDGE) 
    {
        LX3302A_globalCapturedpwmPeriodFromISR = capturedValue - previousCapturedValueRising;
        previousCapturedValueRising = capturedValue;
        ${captureModeSetting} = dPWM_FALLING_EDGE;
        polaritySetting = dPWM_FALLING_EDGE;
    } 
    else 
    {
        LX3302A_globalCapturedpwmDutyFromISR = capturedValue - previousCapturedValueRising;
        ${captureModeSetting} = dPWM_RISING_EDGE;
        polaritySetting = dPWM_RISING_EDGE;
    }
}
</#if>

<#if ANOUTFunctions?has_content>
uint16_t LX3302A_getADCResult(void) 
{
    return ${ANOUTFunctions["getConversion"]}(${adc_channel});
}

// IIR L-point running average
uint16_t LX3302A_getAveragedADCResult(void) 
{
    uint16_t newReading;

    newReading = ${ANOUTFunctions["getConversion"]}(${adc_channel});    
    adcAverage -= (adcAverage / dADC_SAMPLES);
    adcAverage += newReading / dADC_SAMPLES;
    
    return adcAverage;
}
</#if>
