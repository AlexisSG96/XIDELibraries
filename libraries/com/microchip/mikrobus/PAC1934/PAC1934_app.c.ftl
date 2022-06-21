/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "mcc.h"
#include "${pinHeader}"
#include "${pac1934Functions["pac1934header"]}"
#include "PAC1934_Click.h"
<#if (isAVR == "true")>
#include "Config/clock_config.h"
#include <util/delay.h>
</#if>

#define ALT ${ALTPinSettings["getInputValue"]}

/**
  Section: Driver APIs
 */

void PAC1934_ClickInit(void){
<#if RST_Mode == "enabled">
    PAC1934_ClickEnable();
<#else>
    PAC1934_ClickDisable();
</#if>
    <#if (isAVR == "true")>
    _delay_ms(200);
<#else>
    __delay_ms(200);
</#if>
    ${pac1934Functions["Initialize"]}(BUS_ID,PAC1934_ADDRESS);
}

void PAC1934_ClickEnable(void){
    ${RSTPinSettings["setOutputLevelHigh"]}
}
 
void PAC1934_ClickDisable(void){
    ${RSTPinSettings["setOutputLevelLow"]}
}

bool PAC1934_ClickALT(void){
    return ALT;
}