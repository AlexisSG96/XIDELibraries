 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "MIC33153_example.h"
#include "MIC33153.h"
#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>
#ifdef __XC
#include <xc.h>
#endif
#include "mcc.h"

void MIC33153_Example(){
    float feedback;
    MIC33153_Initialize();
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    if(IsPowerGood() == 1){  
        feedback = GetOutputVoltageCondition();
        MIC33153_SetVoltage(feedback);
    }
}
