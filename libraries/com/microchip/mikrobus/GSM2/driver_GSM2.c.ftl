/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include <stdbool.h>
#include "GSM2_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (GSM2_PowerKeyPinKey != "")>
void GSM2_SetHardwareReset(bool state)
{
    ${GSM2_PowerKey_LAT} = state;
}
</#if>
<#if (GSM2_StatusPinKey != "")>
bool GSM2_GetStatus(void)
{
    return ${GSM2_Status_PORT};
}
</#if>
<#if (GSM2_RingIndicatorPinKey != "")>
bool GSM2_GetRingIndication(void)
{
    return ${GSM2_RingIndicator_PORT};
}
</#if>
<#if (GSM2_RtsPinKey != "")>
bool GSM2_GetRTS(void)
{
    return ${GSM2_RTS_PORT};
}
</#if>
<#if (GSM2_CtsPinKey != "")>
void GSM2_SetCTS(bool state)
{
    ${GSM2_CTS_LAT} = state;
}
</#if>
void GSM2_SendString(const char* command)
{
    while (*command != '\0')
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(*command++);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');
}
/**
 End of File
 */