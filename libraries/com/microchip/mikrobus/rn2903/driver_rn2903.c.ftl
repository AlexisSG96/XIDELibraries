/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <string.h>
#include "LoRa2_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (rn2903_ResetPinKey!= "")>
void LoRa2_SetHardwareReset(bool state)
{
    ${rn2903_HwReset_LAT} = state;
}
</#if>
<#if (rn2903_RtsPinKey != "")>
bool LoRa2_GetRTS(void)
{
    return ${rn2903_RTS_PORT};
}
</#if>
<#if (rn2903_CtsPinKey != "")>
void LoRa2_SetCTS(bool state)
{
    ${rn2903_CTS_LAT} = state;
}
</#if>
void LoRa2_SendString(const char* command)
{
    while (*command != '\0')
        uart[${uart_configuration}].Write(*command++);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\r');
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write('\n');
}

