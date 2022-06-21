/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _HZ2V_H
#define _HZ2V_H

/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: V to Hz Click Driver APIs
 */

void hz2v_Initialize(void);
void hz2v_Enable(void);
void hz2v_Disable(void);
void hz2v_setOutputVoltage(float voltage);

#endif // _HZ2V_H
