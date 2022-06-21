/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _TEMPLOG_H
#define	_TEMPLOG_H

/**
  Section: Included Files
 */

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

/**
  Section: Macro Declarations
 */

typedef enum {
    normal = 0,
    oneShot,
} mode;

typedef enum {
    r_9bits = 0,
    r_10bits,
    r_11bits,
    r_12bits,
} resolution;

typedef enum {
    ft_1 = 0,
    ft_2,
    ft_3,
    ft_4,
} fault_tolerance;

typedef enum {
    active_low = 0,
    active_high,
} alert_polarity;

typedef enum {
    comparator_mode = 0,
    interrupt_mode,
} thermostat_mode;

typedef enum {
    active = 0,
    shutdown,
} shutdown_mode;

/**
  Section: Temp Log Driver APIs
 */

uint16_t TempLog_getAlert(void);

/**
 *  Resolution (bits)   Time to wait before getting an updated reading (ms)
 *  9                   25
 *  10                  50
 *  11                  100
 *  12                  200
 */
float TempLog_readTemperature(resolution r);

void TempLog_setLimit(float upper,float lower);
void TempLog_Initialize(void);
void TempLog_setMode(mode m);

void TempLog_readEEPROM(uint16_t address);
void TempLog_writeEEPROM(uint16_t address,uint8_t data);

void TempLog_saveConfiguration(void);
void TempLog_reloadConfiguration(void);

#endif // _TEMPLOG_H