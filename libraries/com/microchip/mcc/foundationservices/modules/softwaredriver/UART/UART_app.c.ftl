/**
\file
\addtogroup doc_driver_uart_code
\brief This file contains the function names of the operations that can be carried out by the UART Foundation Services .
\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
**/

/**
  Section: Included Files
 */

#include "uart.h"   


const uart_functions_t uart[] = {   
<#list configurationValues as items>
    {<#list items as item>${item}<#if item?has_next>,</#if> </#list>}<#if items?has_next>,</#if>
</#list>
};

/**
 End of File
 */
