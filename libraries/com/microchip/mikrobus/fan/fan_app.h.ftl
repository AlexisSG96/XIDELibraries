 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef FAN_H
#define	FAN_H

#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "../config/clock_config.h"
#include "util/delay.h"
</#if>

void fan_Initialize(void);

<#if RPM_Mode == "enabled">
void fan_setSpeed(uint16_t speed);
<#else>
void fan_setPWM(uint8_t pwm);
</#if>

bool fan_isStalled();
bool fan_spinUpFailed();
bool fan_driveFailed();

void fan_setValidTachCount(uint8_t count);
<#if RPM_Mode == "enabled">
void fan_setMaxStep(uint8_t step);
void fan_setMinimumDrive(uint8_t minimum);

void fan_setFailBand(uint16_t band);

</#if>
void fan_softwareLock(void);

uint16_t fan_readTach(void);

#endif