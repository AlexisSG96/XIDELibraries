/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef WIFI3_DRIVER_H
#define	WIFI3_DRIVER_H

#include <stdint.h>
#include <stdbool.h>
<#if (WiFi3_PowerDownPinKey != "")>
void WiFi3_SetPowerDown(bool);
</#if>
<#if (WiFi3_GPIO15PinKey != "")>
void WiFi3_SetGPIO15(bool);
</#if>
void WiFi3_SendString(const char*);

#endif	/* WIFI3_DRIVER_H */

