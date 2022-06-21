/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "airquality.h"

void AirQuality_example(void)
{
    printf("Air Quality PPM = %f\r\n", AirQuality_GetPPM());
}
