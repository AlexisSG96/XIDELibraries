/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MA420R_DRIVER_H
#define	MA420R_DRIVER_H

#include <stdint.h>

// Function Prototypes
void ME_Click_420mAR_Initialize(void);
uint16_t mA420R_RawADC(void);
uint16_t mA420R_RawADCAvg(void);
float mA420R_Single(void);
float mA420R_Avg(void);

#endif /*MA420R_DRIVER_H*/
