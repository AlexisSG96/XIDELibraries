#ifndef LX3302A_H
#define	LX3302A_H

<#if (pwmCaptureEnable == "enabled") || ANOUTFunctions?has_content>
#include <stdint.h>
</#if>

<#if (pwmCaptureEnable == "enabled")>
/* Please access atomically in application if needed */
extern volatile uint16_t LX3302A_globalCapturedpwmPeriodFromISR;
extern volatile uint16_t LX3302A_globalCapturedpwmDutyFromISR;
</#if>
void LX3302A_Initialize(void);

<#if (pwmCaptureEnable == "enabled")>
uint8_t LX3302A_GetPercentage(void);
</#if>
<#if ANOUTFunctions?has_content>
uint16_t LX3302A_getADCResult(void);
uint16_t LX3302A_getAveragedADCResult(void);
</#if>

#endif	/* LX3302A_H */
