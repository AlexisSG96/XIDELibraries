/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef GSM2_DRIVER_H
#define	GSM2_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

<#if (GSM2_PowerKeyPinKey != "")>
void GSM2_SetHardwareReset(bool);
</#if>
<#if (GSM2_StatusPinKey != "")>
bool GSM2_GetStatus(void);
</#if>
<#if (GSM2_RingIndicatorPinKey != "")>
bool GSM2_GetRingIndication(void);
</#if>
<#if (GSM2_RtsPinKey != "")>
bool GSM2_GetRTS(void);
</#if>
<#if (GSM2_CtsPinKey != "")>
void GSM2_SetCTS(bool);
</#if>
void GSM2_SendString(const char*);

#endif	/* GSM2_DRIVER_H */