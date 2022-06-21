/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#ifndef METHANE_H
#define	METHANE_H

#define ADC_VREF                         (3.3)
#define ADC_RESOLUTION_IN_BITS            16
#define ADC_RANGE_VALUE                  (2^ADC_RESOLUTION_IN_BITS)

void METHANE_Initialize(void);
double METHANE_GetReadings(void);
double METHANE_GetPPM(void);

#endif	/* METHANE_H */