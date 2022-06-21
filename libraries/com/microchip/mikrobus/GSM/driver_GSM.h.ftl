/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef GSM_DRIVER_H
#define	GSM_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

<#if (GSM_ResetPinKey != "")>
void GSM_SetHardwareReset(bool);
</#if>
<#if (GSM_RtsPinKey != "")>
bool GSM_GetRTS(void);
</#if>
<#if (GSM_CtsPinKey != "")>
void GSM_SetCTS(bool);
</#if>
<#if (GSM_PowerPinKey != "")>
bool GSM_GetPower(void);
</#if>
<#if (GSM_GP2PinKey != "")>
bool GSM_GetGP2(void);
</#if>
void GSM_SendString(const char*);

#endif	/* GSM_DRIVER_H */

