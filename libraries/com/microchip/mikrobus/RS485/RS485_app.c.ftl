/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "RS485.h"
#include "drivers/${UARTFunctions["uartheader"]}"

void RS485_Initialize(void){
    ${RS485TxEnPin["setOutput"]};
    ${RS485TxEnPin["setOutputLevelLow"]};
}

uint8_t RS485_UART_Read(void){
     return ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
}

void RS485_UART_Write(uint8_t writeChar){
    ${RS485TxEnPin["setOutputLevelHigh"]};
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(writeChar);
    ${RS485TxEnPin["setOutputLevelLow"]};
}

<#if RS485_STDIO == "Enabled">
char getch(void){
    return RS485_UART_Read();
}

void putch(char txData){
    RS485_UART_Write(txData);
}

</#if>