/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef LORA2_DRIVER_H
#define	LORA2_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

<#if (rn2903_ResetPinKey!= "")>
void LoRa2_SetHardwareReset(bool);
</#if>
<#if (rn2903_RtsPinKey != "")>
bool LoRa2_GetRTS(void);
</#if>
<#if (rn2903_CtsPinKey != "")>
void LoRa2_SetCTS(bool);
</#if>
void LoRa2_SendString(const char*);

#endif	/* LORA2_DRIVER_H */