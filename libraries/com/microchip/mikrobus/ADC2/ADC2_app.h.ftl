/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MIKROE_CLICK_ADC2_H
#define	MIKROE_CLICK_ADC2_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
uint32_t ADC2_GetConversion_Result(void);

#endif	/* MIKROE_CLICK_ADC2_H */
