/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "mcc.h"
#include "WiFly.h"
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool inCMD;

// Local function prototypes
void initWaitingFunction(void);
void WiFly_EnterCMDDelay(void);
void WiFly_EnterCMDMode(void);
void WiFly_ExitCMDMode(void);
void WiFly_SendCMD(const uint8_t* cmd);
void WiFly_RebootCMD(void);

void initWaitingFunction(void) {

}

/**
 * Waits for the @chkString to be received before continuing
 * 
 * Calls the waitingFN callback while waiting for @chkString
 * @param chkString
 */

void WiFly_Send(char* command) {
    while (*command != '\0')
        ${UARTFunctions["functionName"]}[${uart_configuration}].Write(*command++);
}

void Clear_RX_Buffer(void) {
    while (${UARTFunctions["functionName"]}[${uart_configuration}].DataReady()) {
        ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    }
}

void WiFly_CheckInCMD(void) {
    if (!inCMD) {
        WiFly_EnterCMDMode();
    }
}

void WiFly_SendString(const uint8_t* sendString) {
    Clear_RX_Buffer();
    WiFly_CheckInCMD();
    Clear_RX_Buffer();
    WiFly_Send(sendString);
}

char WiFly_ReadChar(void) {
    while (!${UARTFunctions["functionName"]}[${uart_configuration}].DataReady()) {
        NOP();
    }
    return ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
}

void WiFly_CheckRecv(const char* chkString) {
    size_t length = strlen(chkString);
    size_t i = 0;

    while (i < length) {
        while (${UARTFunctions["functionName"]}[${uart_configuration}].DataReady()) {
            if (${UARTFunctions["functionName"]}[${uart_configuration}].Read() == chkString[i]) {
                i++;
            } else {
                i = 0;
            }
        }
    }

}

// Public Functions

void WiFly_EnterCMDMode(void) {
    Clear_RX_Buffer();
    <#if (isAVR == "true")>
	_delay_ms(275);
	<#else>
	__delay_ms(275);
	</#if>
    WiFly_Send("$$$");
    WiFly_CheckRecv(cmdStr);
    <#if (isAVR == "true")>
	_delay_ms(275);
	<#else>
	__delay_ms(275);
	</#if>
    inCMD = true;
}

void WiFly_ExitCMDMode(void) {
    if (!inCMD) {
        return;
    }
    WiFly_SendString("exit\r\n");
    WiFly_CheckRecv(endStr);
    inCMD = false;
}

void WiFly_SendCMD_SingleArg(const char* cmdFormat, const char* arg) {
    WiFly_CheckInCMD();
    Clear_RX_Buffer();
    char txBuffer[40];
    sprintf(txBuffer, cmdFormat, arg);
    WiFly_Send(txBuffer);
    WiFly_CheckRecv(aokStr);
}

void WiFly_SendCMD_DoubleArg(const char* cmdFormat, const char* arg1, const char* arg2) {

    WiFly_CheckInCMD();
    Clear_RX_Buffer();
    char txBuffer[40];
    sprintf(txBuffer, cmdFormat, arg1, arg2);
    WiFly_Send(txBuffer);
}

void WiFly_SendCMD(const uint8_t* cmd) {

    WiFly_CheckInCMD();
    WiFly_SendString(cmd);
    WiFly_CheckRecv(aokStr);
}

void WiFly_RebootCMD(void) {

    WiFly_CheckInCMD();
    WiFly_SendString("reboot\r\n");
    WiFly_CheckRecv(softRebootStr);
    WiFly_CheckRecv(hardRebootStr);
    inCMD = false;
}

void WiFly_SaveConfig(void) {

    WiFly_SendString("save\r\n");
    WiFly_RebootCMD();
}

void WiFly_FactoryReset(void) {

    WiFly_HwReset_SetLow(); //Reset RN41
    inCMD = false;
    <#if (isAVR == "true")>
	_delay_ms(50);
	<#else>
	__delay_ms(50);
	</#if>
    WiFly_HwReset_SetHigh();
    WiFly_CheckRecv(hardRebootStr);

    WiFly_SendString("factory RESET\r\n");
    WiFly_RebootCMD();
    WiFly_SendCMD("set uart mode 0x11\r\n");
    WiFly_SaveConfig();
}