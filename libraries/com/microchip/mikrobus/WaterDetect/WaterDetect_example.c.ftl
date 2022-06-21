/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "WaterDetect.h"
#include "WaterDetect_example.h"

void WaterDetect_example(){
    if (IsWaterDetected() == true){
        LED_SetHigh();
    }
    else if (IsWaterDetected() == false){
        LED_SetLow();
    }
}

/**
 End of File
 */