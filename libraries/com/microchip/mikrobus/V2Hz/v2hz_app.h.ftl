/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _V2HZ_H
#define _V2HZ_H

/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: V to Hz Click Driver APIs
 */

void v2hz_Initialize(void);
void v2hz_Enable(void);
void v2hz_Disable(void);
void v2hz_setOutputFrequency(uint16_t frequency);

#endif // _V2HZ_H
