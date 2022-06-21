/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include <stdbool.h>
#include "bme280.h"
#include "weather.h"
#include "${DELAYFunctions.delayHeader}"

/**
  Section: Macro Declarations
 */

<#--Value of defTsb as "0.5" and "62.5" creats build error when appended to a C Macro, -->
<#--Therefore changing defTsb to an acceptable format -->
<#if defTsb == "62.5">
    <#assign defTsb = "62P5">
<#elseif defTsb == "0.5">
    <#assign defTsb = "HALF">
</#if>

#define DEFAULT_STANDBY_TIME    BME280_STANDBY_${defTsb}MS
#define DEFAULT_FILTER_COEFF    BME280_FILTER_COEFF_${defCoeff}
#define DEFAULT_TEMP_OSRS       BME280_OVERSAMP_${defTemp}
#define DEFAULT_PRESS_OSRS      BME280_OVERSAMP_${defPress}
#define DEFAULT_HUM_OSRS        BME280_OVERSAMP_${defHum}
#define DEFAULT_SENSOR_MODE     BME280_${defMode}_MODE

/**
  Section: Variable Definitions
 */

static bool weather_initialized = false;

/**
  Section: Private functions
 */

static void Weather_initializeClick(void)
{
    BME280_reset();
    
    ${DELAYFunctions.delayMs}(5);    //Startup delay for BME280 sensor
    
    BME280_readFactoryCalibrationParams();

    BME280_setStandbyTime(DEFAULT_STANDBY_TIME);
    BME280_setFilterCoefficient(DEFAULT_FILTER_COEFF);
    BME280_setOversamplingTemperature(DEFAULT_TEMP_OSRS);
    BME280_setOversamplingPressure(DEFAULT_PRESS_OSRS);
    BME280_setOversamplingHumidity(DEFAULT_HUM_OSRS);
    BME280_setSensorMode(DEFAULT_SENSOR_MODE);
    BME280_initializeSensor();

    weather_initialized = true;
}

/**
  Section: Driver APIs
 */

void Weather_readSensors(void)
{
    if (!weather_initialized)
    {
        Weather_initializeClick();
    }

    if (DEFAULT_SENSOR_MODE == BME280_FORCED_MODE)
    {
        BME280_startForcedSensing();
    }

    while(BME280_isMeasuring())
    {
        // Wait until the results have been transferred to the data registers
    }
    BME280_readMeasurements();
}

float Weather_getTemperatureDegC(void)
{
    return BME280_getTemperature();
}

float Weather_getPressureKPa(void)
{
    return BME280_getPressure();
}

float Weather_getHumidityRH(void)
{
    return BME280_getHumidity();
}

void Weather_gotoSleep(void)
{
    BME280_sleep();
    weather_initialized = false;
}
