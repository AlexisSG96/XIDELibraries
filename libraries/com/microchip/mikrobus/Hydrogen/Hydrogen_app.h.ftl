/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#ifndef HYDROGEN_H
#define	HYDROGEN_H

#define ADC_VREF                         (3.3)
#define ADC_RESOLUTION_IN_BITS            16
#define ADC_RANGE_VALUE                  (2^ADC_RESOLUTION_IN_BITS)

void HYDROGEN_Initialize(void);
double HYDROGEN_GetReadings(void);
double HYDROGEN_GetPPM(void);


#endif	/* HYDROGEN_H */