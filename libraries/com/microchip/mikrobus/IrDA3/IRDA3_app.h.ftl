/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef IRDA3_H
#define	IRDA3_H

#include "drivers/${UARTFunctions["uartheader"]}"

#define IRDA3_is_tx_ready()     ${UARTFunctions["functionName"]}[${uart_configuration}].TransmitReady()
#define IRDA3_is_rx_ready()     ${UARTFunctions["functionName"]}[${uart_configuration}].DataReady()
#define IRDA3_is_tx_done()      ${UARTFunctions["functionName"]}[${uart_configuration}].TransmitDone()
#define IRDA3_Read()            ${UARTFunctions["functionName"]}[${uart_configuration}].Read()
#define IRDA3_Write(x)          ${UARTFunctions["functionName"]}[${uart_configuration}].Write(x)


#endif	/* IRDA3_H */

