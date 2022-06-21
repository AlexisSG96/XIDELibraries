/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "hdc1000_example.h"
#include "hdc1000.h"

void HDC1000_example(void){
<#if (isAVR == "true")>
    float temp = HDC1000_GetTemp()*100;
    int8_t tempInt = (int8_t)(temp/100);
    int8_t tempDecimal = ((uint8_t)(temp))%100;
    printf("The temperature is: %d.%d degrees C, ", tempInt, tempDecimal);
<#else>
    printf("The temperature is: %f degrees C, ", HDC1000_GetTemp());
</#if>
    printf("The humidity is: %d percent RH\r\n", HDC1000_GetHumidity());
}
