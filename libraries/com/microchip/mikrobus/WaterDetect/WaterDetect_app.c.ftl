/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "WaterDetect.h"
#include "${pinHeader}"


bool IsWaterDetected(void){
    return ${intPinSettings["PORT"]};
}

/**
 End of File
 */