/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "USBI2C_app.h"
#include "${I2CFunctions["slaveheader"]}"

volatile uint8_t data;

void USBI2C_Initialize(void){
    PIE3bits.SSP1IE = 1;
    ${I2CFunctions["open"]}();
}
