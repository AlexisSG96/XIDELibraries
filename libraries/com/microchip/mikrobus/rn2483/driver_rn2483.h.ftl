/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef LORA_DRIVER_H
#define	LORA_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

<#if (rn2483_ResetPinKey!= "")>
void LoRa_SetHardwareReset(bool);
</#if>
<#if (rn2483_RtsPinKey != "")>
bool LoRa_GetRTS(void);
</#if>
<#if (rn2483_CtsPinKey != "")>
void LoRa_SetCTS(bool);
</#if>
void LoRa_SendString(const char*);

#endif	/* LORA_DRIVER_H */