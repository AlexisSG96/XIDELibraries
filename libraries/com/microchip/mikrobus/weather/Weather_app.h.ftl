/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _WEATHER_H
#define	_WEATHER_H

/**
  Section: Included Files
 */

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>

/**
  Section: Weather Click Driver APIs
 */

/* 
 * Called to read sensor data   
 */
void Weather_readSensors(void);

/* 
 * Return compensated values in deg. Celsius, 
 * kPascals, & %Relative Humidity   
 */
float Weather_getTemperatureDegC(void);
float Weather_getPressureKPa(void);
float Weather_getHumidityRH(void);

void Weather_gotoSleep(void);

#endif // _WEATHER_H
