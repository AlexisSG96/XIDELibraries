 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "fanDrivers/fan.h"

void fan_example(){
<#if RPM_Mode == "enabled">
    fan_setSpeed(6000);
<#else>
    fan_setPWM(0xAA);
</#if>
}