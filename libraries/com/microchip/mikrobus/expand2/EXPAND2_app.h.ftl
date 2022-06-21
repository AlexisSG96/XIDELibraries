/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXPAND2_H
#define	EXPAND2_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EXPAND2_Initialize(void);

void EXPAND2_SetDirectionGPIOA(uint8_t dir);
void EXPAND2_SetDirectionGPIOB(uint8_t dir);

void EXPAND2_SetGPIOA(uint8_t value);
void EXPAND2_SetGPIOB(uint8_t value);

uint8_t EXPAND2_ReadGPIOA(void);
uint8_t EXPAND2_ReadGPIOB(void);

#endif	/* EXPAND2_H */