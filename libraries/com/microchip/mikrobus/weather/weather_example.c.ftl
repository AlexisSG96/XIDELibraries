/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include <stdio.h>
#include "weather.h"

/**
  Section: Example Code
 */

void Weather_example(void)
{
    // Read the sensor data registers
    Weather_readSensors();

    // Print the compensated measurement readings of each sensor
    printf("Temperature = %3.2f C \tPressure = %3.2f kPa \tHumidity = %3.2f %%RH \n\r",
           Weather_getTemperatureDegC(), Weather_getPressureKPa(), Weather_getHumidityRH());
}
