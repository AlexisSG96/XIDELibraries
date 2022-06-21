/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include "LoRa_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (rn2483_ResetPinKey!= "")>
void LoRa_SetHardwareReset(bool state)
{
    ${rn2483_HwReset_LAT} = state;
}
</#if>
<#if (rn2483_RtsPinKey != "")>
bool LoRa_GetRTS(void)
{
    return ${rn2483_RTS_PORT};
}
</#if>
<#if (rn2483_CtsPinKey != "")>
void LoRa_SetCTS(bool state)
{
    ${rn2483_CTS_LAT} = state;
}
</#if>
void LoRa_SendString(const char* command)
{
    while (*command != '\0')
        uart[${uart_configuration}].Write(*command++);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\n');
}
