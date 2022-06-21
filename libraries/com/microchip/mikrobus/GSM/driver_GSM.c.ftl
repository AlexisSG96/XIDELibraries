/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include "GSM_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (GSM_ResetPinKey != "")>
void GSM_SetHardwareReset(bool state)
{
    ${GSM_Reset_LAT} = state;
}
</#if>
<#if (GSM_RtsPinKey != "")>
bool GSM_GetRTS(void)
{
    return ${GSM_RTS_PORT};
}
</#if>
<#if (GSM_CtsPinKey != "")>
void GSM_SetCTS(bool state)
{
    ${GSM_CTS_LAT} = state;
}
</#if>
<#if (GSM_PowerPinKey != "")>
bool GSM_GetPower(void)
{
    return ${GSM_Power_PORT};
}
</#if>
<#if (GSM_GP2PinKey != "")>
bool GSM_GetGP2(void)
{
    return ${GSM_GP2_PORT};
}
</#if>
void GSM_SendString(const char* command)
{
    while (*command != '\0')
         ${UARTFunctions["functionName"]}[${uart_configuration}].Write(*command++);
     ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');
}
/**
 End of File
 */