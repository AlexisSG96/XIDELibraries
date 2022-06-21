/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   SOFTWARE_Uart.h
 */
#ifndef SOFTWARE_UART_H
#define SOFTWARE_UART_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void SOFTWARE_UartInitialize(void);
void SOFTWARE_UartPutString (const char*);
void SOFTWARE_UartPutChar (uint8_t);
void SOFTWARE_UartFormateUI8ToStr(uint8_t , char []);
void SOFTWARE_UartFormateHdgToSt(uint16_t , char []);

#endif	/* SOFTWARE_UART_H */