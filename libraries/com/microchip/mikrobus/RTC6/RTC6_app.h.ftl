 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef RTC6_H
#define	RTC6_H

#include <time.h>
#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

typedef struct {
    int sec, min, hr;
    int year, month, date, day;
} DateTime_t;

void rtc6_Initialize(void);

void rtc6_EnableAlarms(bool alarm0, bool alarm1);
void rtc6_SetAlarm0(struct tm tm_t, bool almpol, uint8_t mask);
void rtc6_SetAlarm1(struct tm tm_t, bool almpol, uint8_t mask);

void rtc6_ClearAlarm0(void);
void rtc6_ClearAlarm1(void);

void rtc6_SetTime(time_t);
time_t rtc6_GetTime(void);

uint8_t rtc6_ReadByteEEPROM(uint8_t addr);
void rtc6_WriteByteEEPROM(uint8_t addr, uint8_t data);

#endif
