/*
<#include "MicrochipDisclaimer.ftl">
*/
<#if (isPIC == "true")>
#include "device_config.h"
</#if>
<#if (isAVR == "true")>
#include <stdbool.h>
#include "mcc.h"
#include "Config/clock_config.h"
#include <util/delay.h>
</#if>
#include "buck2.h"

/**
  Section: Macro Declarations
 */
<#macro V0hiZ>
<#if (isAVR == "true")>
${vs0Pin["setOutput"]} ${vs0Pin["setOutputLevelLow"]} ${vs0Pin["disableWeakPullup"]} ${vs0Pin["disableAnyEdgeInterrupt"]}
<#else>
${vs0Pin["setInput"]} ${vs0Pin["setOutputLevelLow"]}
</#if>  
</#macro>

<#macro V1hiZ>
<#if (isAVR == "true")>
${vs1Pin["setOutput"]} ${vs1Pin["setOutputLevelLow"]} ${vs1Pin["disableWeakPullup"]} ${vs1Pin["disableAnyEdgeInterrupt"]}
<#else>
${vs1Pin["setInput"]} ${vs1Pin["setOutputLevelLow"]}
</#if>  
</#macro>

<#macro FQhiZ>
<#if (isAVR == "true")>
${fqPin["setOutput"]} ${fqPin["setOutputLevelLow"]} ${fqPin["disableWeakPullup"]} ${fqPin["disableAnyEdgeInterrupt"]}
<#else>
${fqPin["setInput"]} ${fqPin["setOutputLevelLow"]}
</#if>  
</#macro>

#define BUCK2_VOSET0_1()    ${vs0Pin["setOutput"]} ${vs0Pin["setOutputLevelHigh"]}
#define BUCK2_VOSET0_0()    ${vs0Pin["setOutput"]} ${vs0Pin["setOutputLevelLow"]}
#define BUCK2_VOSET0_HiZ()  <@V0hiZ/><#rt>
#define BUCK2_VOSET1_1()    ${vs1Pin["setOutput"]} ${vs1Pin["setOutputLevelHigh"]}
#define BUCK2_VOSET1_0()    ${vs1Pin["setOutput"]} ${vs1Pin["setOutputLevelLow"]}
#define BUCK2_VOSET1_HiZ()  <@V1hiZ/><#rt>
#define BUCK2_FREQ_1()      ${fqPin["setOutput"]} ${fqPin["setOutputLevelHigh"]}
#define BUCK2_FREQ_0()      ${fqPin["setOutput"]} ${fqPin["setOutputLevelLow"]}
#define BUCK2_FREQ_HiZ()    <@FQhiZ/><#rt>

<#macro delay value>
<#if (isAVR == "true")>
    _delay_ms(${value});
<#else>
    __delay_ms(${value});
</#if>  
</#macro>

/**
  Section: Driver APIs
 */

void BUCK2_setVoltage_700mV(void) {
    BUCK2_disable();
<@delay value="50"/>    
    BUCK2_VOSET1_HiZ();
    BUCK2_VOSET0_HiZ();
    BUCK2_FREQ_HiZ();
    BUCK2_enable();
}

void BUCK2_setVoltage_800mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_HiZ();
    BUCK2_VOSET0_1();
    BUCK2_FREQ_HiZ();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_900mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_1();
    BUCK2_VOSET0_HiZ();
    BUCK2_FREQ_HiZ();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_1000mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_HiZ();
    BUCK2_VOSET0_0();
    BUCK2_FREQ_HiZ();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_1200mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_0();
    BUCK2_VOSET0_HiZ();
    BUCK2_FREQ_HiZ();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_1500mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_1();
    BUCK2_VOSET0_1();
    BUCK2_FREQ_0();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_1800mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_1();
    BUCK2_VOSET0_0();
    BUCK2_FREQ_0();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_2500mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_0();
    BUCK2_VOSET0_1();
    BUCK2_FREQ_1();
    BUCK2_enable(); 
}

void BUCK2_setVoltage_3300mV(void) {
    BUCK2_disable();
<@delay value="50"/> 
    BUCK2_VOSET1_0();
    BUCK2_VOSET0_0();
    BUCK2_FREQ_1();
    BUCK2_enable(); 
}
