/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "driver_rn4871.h"
#include "drivers/${UARTFunctions["uartheader"]}"

void rn4871_ClearResetPin(void)
{
    ${resetPinSettings["LAT"]} = 0;
}

void rn4871_SetResetPin()
{
    ${resetPinSettings["LAT"]} = 1;
}

void rn4871_SendString(const char *command)
{
    rn4871_SendBuffer(command, strlen(command));
}

void rn4871_SendBuffer(const char *buffer, uint8_t length)
{
    while (length--)
        rn4871_SendByte(*buffer++);
}

void rn4871_SendByte(uint8_t data)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(data);
}