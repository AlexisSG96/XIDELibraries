 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "MCP16331INV_example.h"
#include "MCP16331INV.h"
#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>
#ifdef __XC
#include <xc.h>
#endif
#include "mcc.h"

float MCP16331INV_Example(){
    float OutputVoltage;
    MCP16331INV_Initialize();
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    OutputVoltage = MCP16331INV_GetOutputVoltage();
    return OutputVoltage;
}