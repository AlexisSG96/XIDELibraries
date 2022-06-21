/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "WiFiPlus_driver.h"
#include "drivers/${UARTFunctions["uartheader"]}"

<#if (WiFiPlus_HwResetPinKey != "")>
void WiFiPlus_SetHwReset(bool state)
{
    ${WiFiPlus_HwReset_LAT} = state;
}
</#if>
<#if (WiFiPlus_Gpio0PinKey != "")>
void WiFiPlus_SetGPIO0(bool state)
{
     ${WiFiPlus_Gpio0_LAT} = state;
}
</#if>
<#if (WiFiPlus_Gpio1PinKey != "")>
void WiFiPlus_SetGPIO1(bool state)
{
    ${WiFiPlus_Gpio1_LAT} = state;
}
</#if>
<#if (WiFiPlus_Gpio2PinKey != "")>
void WiFiPlus_SetGPIO2(bool state)
{
    ${WiFiPlus_Gpio2_LAT} = state;
}
</#if>
<#if (WiFiPlus_CtsPinKey != "")>
void WiFiPlus_SetCTS(bool state)
{
    ${WiFiPlus_CTS_LAT} = state;
}
</#if>
<#if (WiFiPlus_RtsPinKey != "")>
bool WiFiPlus_GetRTS(void)
{
    return ${WiFiPlus_RTS_PORT};
}
</#if>

void WiFiPlus_SendCommand(uint16_t messageType, uint16_t messageDataLength, const uint8_t* data)
{
    uint8_t messageTypeMSB = messageType << 8;
    uint8_t messageTypeLSB = messageType;
    uint8_t dataLengthMSB = messageDataLength << 8;
    uint8_t dataLengthLSB = messageDataLength;
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(0x55);            // Always
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(0xAA);            // Always
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(messageTypeLSB);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(messageTypeMSB);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(dataLengthLSB);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(dataLengthMSB);
    for (uint16_t dataSize = 0; dataSize < messageDataLength; dataSize++)
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(*data++);
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(0x45);            // Always
}
/**
 End of File
 */