/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#ifndef CO_H
#define	CO_H

#define ADC_VREF                         (3.3)
#define ADC_RESOLUTION_IN_BITS            16
#define ADC_RANGE_VALUE                  (2^ADC_RESOLUTION_IN_BITS)

void CO_Initialize(void);
double CO_GetReadings(void);
double CO_GetPPM(void);


#endif	/* CO_H */
