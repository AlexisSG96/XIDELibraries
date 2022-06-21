/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "USBUART_example.h"
#include "drivers/${UARTFunctions["uartheader"]}"

void USBUART_example(void){
    printf("The received ASCII character is: %c \n", ${UARTFunctions["functionName"]}[${uart_configuration}].Read());
}

