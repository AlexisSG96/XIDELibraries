/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
<#if RS485_STDIO == "Enabled">
#include <stdio.h>
</#if>

void RS485_Initialize(void);
uint8_t RS485_UART_Read(void);
void RS485_UART_Write(uint8_t writeChar);
