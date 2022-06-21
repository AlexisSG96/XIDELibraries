/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#ifndef ALCOHOL_H
#define	ALCOHOL_H

#define ADC_VREF                         (3.3)
#define ADC_RESOLUTION_IN_BITS            16
#define ADC_RANGE_VALUE                  (2^ADC_RESOLUTION_IN_BITS)

void ALCOHOL_Initialize(void);
double ALCOHOL_GetReadings(void);
double ALCOHOL_GetPPM(void);
double ALCOHOL_GetBACLevel(void);

#endif	/* ALCOHOL_H */