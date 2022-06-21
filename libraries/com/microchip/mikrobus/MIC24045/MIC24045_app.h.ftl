 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef MIC24045_H
#define	MIC24045_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

uint8_t MIC_ReadStatus(void);

void MIC_Setting1(uint8_t ilim, uint8_t freq0);
void MIC_Setting2(uint8_t sudly, uint8_t mrg, uint8_t ss);

void MIC_StepToVout(uint8_t vout_desired, uint8_t delayMs);
void MIC_GoToVout(uint8_t vout_desired);

void MIC_ClearInterrupts(void);

#endif	/* XC_HEADER_TEMPLATE_H */
