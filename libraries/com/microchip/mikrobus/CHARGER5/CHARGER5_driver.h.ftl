/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef CHARGER5_DRIVER_H
#define CHARGER5_DRIVER_H 

#include <stdint.h>

void CHARGER5_SetCurrent(uint16_t currentValue);
void CHARGER5_IncrementWiper(uint8_t numberOfSteps);
void CHARGER5_DecrementWiper(uint8_t numberOfSteps);

#endif	/* CHARGER5_DRIVER_H */