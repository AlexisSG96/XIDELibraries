/**
\file
\defgroup doc_driver_uart_example UART Driver Example Source Code Reference
\ingroup doc_driver_uart
\brief This file contains the API that implements the UART Example functionalities.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _UART_EXAMPLE_H
#define _UART_EXAMPLE_H

#include "../drivers/uart.h"

<#if (genAll == "true")||(genBasicTX == "true")>
void UART_example_WRITE_STRING(char *str);
</#if>

<#if (genAll == "true")||(genPrintf == "true")>
void UART_example_PRINTF(void);
</#if>

<#if (genAll == "true")||(genBasicRX == "true")>
void UART_example_READ(void);
</#if>

<#if (genAll == "true")>
void UART_example_RUNALL(void);
</#if>

#endif	// _UART_EXAMPLE_H