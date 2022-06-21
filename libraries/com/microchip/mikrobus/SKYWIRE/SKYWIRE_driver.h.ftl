/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SKYWIRE_DRIVER_H
#define SKYWIRE_DRIVER_H 

#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void SKYWIRE_Initialize(void);
void SKYWIRE_PinSetEnable(bool state);
void SKYWIRE_PinSetReset(bool state);
void SKYWIRE_SendCmd(const char cmd);
void SKYWIRE_SendCmdString(const char *cmd);
void SKYWIRE_SendSms(char *phoneNumber, char *text);

#endif	/* SKYWIRE_DRIVER_H */