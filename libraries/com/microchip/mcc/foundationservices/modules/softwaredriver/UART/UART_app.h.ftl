/**
\file
\defgroup doc_driver_uart_code UART Driver Source Code Reference
\ingroup doc_driver_uart
\brief This file contains the UART configurations selected by the user in the UART Foundation Services MCC Interface.
\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
**/

#ifndef _UART_H
#define _UART_H


#include <stdint.h>
#include <stddef.h>
<#list uartHeaders as item>
#include "../${item}"
</#list>

/**
*   \ingroup doc_driver_uart_code
*   \enum uart_configurations_t uart.h
*/
typedef enum { 
<#list configurationNames as item>
    ${item} /**<UART Name */<#if item?has_next>,</#if>
</#list>
} uart_configurations_t;

/**
*   \ingroup doc_driver_uart_code
*   \struct uart_functions_t uart.h
*/
typedef struct { <#list uartFunctionNames as item>${item}; </#list> } uart_functions_t;

extern const uart_functions_t uart[];

#endif	// _UART_H