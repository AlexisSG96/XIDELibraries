/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "drivers/${UARTFunctions["uartheader"]}"
#include "touchkey2_driver.h"

uint8_t TOUCHKEY2_getButton(void) {
    uint8_t buff = 0xFE;
    buff = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    return buff;
}
