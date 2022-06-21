/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef DIFFPRESSURE_CLICK
#define	DIFFPRESSURE_CLICK
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
typedef enum {NO_ERROR = 0, OVH = 1, OVL = 2} diffPressureError_t;

void DiffPressure_Initialize(void);
diffPressureError_t DiffPressure_Read(float *diffPressure);

#endif	/* DIFFPRESSURE_CLICK */