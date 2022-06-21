/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "drivers/uart.h"

void RS232_example(void)
{
    uint8_t data = ${UARTFunctions.functionName}[${uart_configuration}].Read();
    
    //echo back typed data + 1 (e.g. a typed "a" will echo back "b")
    ${UARTFunctions.functionName}[${uart_configuration}].Write(data + 1);
}
