/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef WIFLY_H
#define	WIFLY_H

#include <stdint.h>
#include "drivers/uart.h"
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

// Types

const char hardRebootStr[] = "READY";
const char softRebootStr[] = "Reboot";
const char cmdStr[] = "CMD";
const char endStr[] = "EXIT";
const char aokStr[] = "AOK";
const char openStr[] = "OPEN";
    
//Functions

void Clear_RX_Buffer(void);
char WiFly_ReadChar(void);
void WiFly_SendCMD_SingleArg(const char* cmdFormat, const char* arg);
void WiFly_SendCMD_DoubleArg(const char* cmdFormat, const char* arg1, const char* arg2);
void WiFly_SendCMD(const uint8_t* cmd);
void WiFly_SendString(const uint8_t* sendString);
void WiFly_CheckRecv(const char* chkString);
void WiFly_CheckInCMD(void);
void WiFly_FactoryReset(void);
void WiFly_SaveConfig(void);

bool inCMD; // Set this to false after connection initiated

#endif

