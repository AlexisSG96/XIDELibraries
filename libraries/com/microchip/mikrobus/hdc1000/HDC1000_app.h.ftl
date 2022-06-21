/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef HDC1000_H
#define	HDC1000_H

#include <stdbool.h>
#include <stdint.h>
<#if (isAVR == "true")>
#define uint24_t __uint24
</#if>

float HDC1000_GetTemp();

uint8_t HDC1000_GetHumidity();

void HDC1000_EnableHeater(bool enable);

#endif	/* HDC1000_H */
