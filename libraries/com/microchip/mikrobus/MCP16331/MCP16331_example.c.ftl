 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "MCP16331_example.h"
#include "MCP16331.h"
#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>
#ifdef __XC
#include <xc.h>
#endif
#include "mcc.h"

float MCP16331_Example(){
    float OutputVoltage;
    MCP16331_Initialize();
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    OutputVoltage = MCP16331_GetOutputVoltage();
    return OutputVoltage;
}
