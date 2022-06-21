/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RN4678_DRIVER_H
#define	RN4678_DRIVER_H

#include <stdint.h>
#include <stdbool.h>

<#if (rn4678_ResetPinKey!= "")>
void rn4678_ModuleWake(bool);
</#if>
<#if (rn4678_ResetPinKey!= "")>
void rn4678_SetHardwareReset(bool);
</#if>
<#if (rn4678_RtsPinKey != "")>
bool rn4678_GetRTS(void);
</#if>
<#if (rn4678_CtsPinKey != "")>
void rn4678_SetCTS(bool);
</#if>
void rn4678_SendString(const char*);

#endif	/* RN4678_DRIVER_H */