/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef WIFIPLUS_DRIVER_H
#define	WIFIPLUS_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

<#if (WiFiPlus_HwResetPinKey != "")>
void WiFiPlus_SetHwReset(bool);
</#if>
<#if (WiFiPlus_Gpio0PinKey != "")>
void WiFiPlus_SetGPIO0(bool);
</#if>
<#if (WiFiPlus_Gpio1PinKey != "")>
void WiFiPlus_SetGPIO1(bool);
</#if>
<#if (WiFiPlus_Gpio2PinKey != "")>
void WiFiPlus_SetGPIO2(bool);
</#if>
<#if (WiFiPlus_CtsPinKey != "")>
void WiFiPlus_SetCTS(bool);
</#if>
<#if (WiFiPlus_RtsPinKey != "")>
bool WiFiPlus_GetRTS(void);
</#if>
void WiFiPlus_SendCommand(uint16_t, uint16_t, const uint8_t*);

#endif	/* WIFIPLUS_DRIVER_H */