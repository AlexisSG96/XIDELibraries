/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef LPG_H
#define	LPG_H

#define ADC_VREF                         (3.3)
#define ADC_RESOLUTION_IN_BITS            16
#define ADC_RANGE_VALUE                  (2^ADC_RESOLUTION_IN_BITS)

void LPG_Initialize(void);
double LPG_GetReadings(void);
double LPG_GetPPM(void);


#endif	/* LPG_H */