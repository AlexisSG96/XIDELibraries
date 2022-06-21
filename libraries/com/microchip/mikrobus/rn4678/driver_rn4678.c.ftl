/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include "RN4678_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (rn4678_WakePinKey!= "")>
void rn4678_ModuleWake(bool state)
{
    ${rn4678WakePinSettings["LAT"]} = state;
}
</#if>
<#if (rn4678_ResetPinKey!= "")>
void rn4678_SetHardwareReset(bool state)
{
    ${rn4678ResetPinSettings["LAT"]} = state;
}
</#if>
<#if (rn4678_RtsPinKey != "")>
bool rn4678_GetRTS(void)
{
    return ${rn4678RtsPinSettings["PORT"]};
}
</#if>
<#if (rn4678_CtsPinKey != "")>
void rn4678_SetCTS(bool state)
{
    ${rn4678CtsPinSettings["LAT"]} = state;
}
</#if>
void rn4678_SendString(const char* command)
{
    while (*command != '\0')
        uart[${uart_configuration}].Write(*command++);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\n');
}
