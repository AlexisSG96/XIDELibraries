/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef __STEPPER2_H
#define __STEPPER2_H

#include "../mcc.h"

void stepper_Initialize(void);
void stepper_step(void);
void stepper_setDirectionCW(void);
void stepper_setDirectionCCW(void);
void stepper_sleep(void);
void stepper_wake(void);

#endif // __STEPPER2_H
