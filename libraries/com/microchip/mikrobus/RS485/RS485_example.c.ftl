/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "RS485_example.h"
#include "RS485.h"

void RS485_example(void){
    printf("The received ASCII character is: %c \n", RS485_UART_Read());
}
