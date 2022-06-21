/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (WiFi3_PowerDownPinKey != "")>
void WiFi3_SetPowerDown(bool state)
{
    ${WiFi3_PowerDown_LAT} = state;
}
</#if>
<#if (WiFi3_GPIO15PinKey != "")>
void WiFi3_SetGPIO15(bool state)
{
    ${WiFi3_GPIO15_LAT} = state;
}
</#if>
void WiFi3_SendString(const char* command)
{
    while (*command != '\0')
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(*command++);
}
/**
 End of File
 */