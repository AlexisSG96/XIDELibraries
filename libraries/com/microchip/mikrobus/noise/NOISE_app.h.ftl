/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef NOISE_H
#define	NOISE_H

#include <stdint.h>
#include <stdbool.h>

void NOISE_Initialize(void);

void NOISE_SetThreshold(uint16_t threshold);

bool NOISE_IsNoisy(void);

#endif	/* NOISE_H */
