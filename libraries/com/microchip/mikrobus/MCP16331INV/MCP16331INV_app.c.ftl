/*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "mcc.h"
#include "MCP16331INV.h"
#include "MCP4921.h"
#include <stdint.h>
#include "${ANOUTFunctions["adcheader"]}"
#include <math.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>
#ifdef __XC
#include <xc.h>
#endif


#define lowerLimit 2.7
#define upperLimit 5.4
#define vref_range 2.7 //2.7
#define constant 7.5 //9.75-2.25
#define dac_resolution 4096 //(2^12)
#define adc_vref 3.3
#define voltage_divider_constant 133/33
#define adc_resolution 1024

void MCP16331INV_Initialize(void) {
    MCP16331INV_SetVoltage(${InitVoltVal});   
}

void MCP16331INV_Enable(void) {
    ${ENPinSettings["setOutputLevelHigh"]}
}

void MCP16331INV_Disable(void) {
    ${ENPinSettings["setOutputLevelLow"]}
}

float MCP16331INV_GetOutputVoltage(void){
    uint16_t adcValue =((${ANOUTFunctions["getConversion"]}(${adc_channel})) >> 6);
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    float voltage = (adcValue*adc_vref/adc_resolution)*voltage_divider_constant;
    return voltage;
}

void MCP16331INV_SetVoltage(float voltage) {
    voltage = fabs(voltage);
    ${ENPinSettings["setOutputLevelLow"]}
    <#if (isAVR == "true")>
    _delay_ms(50);
    <#else>
    __delay_ms(50);
    </#if>
    if (voltage < lowerLimit){
       voltage = lowerLimit;
    } else if (voltage > upperLimit){
       voltage = upperLimit;
    }//vref_range
    float volt_ref = voltage - vref_range; 
    uint16_t dacVoltage = (uint16_t) ((dac_resolution*volt_ref)/3.3);
    DAC_Set(dacVoltage);
    <#if (isAVR == "true")>
    _delay_ms(50);
    <#else>
    __delay_ms(50);
    </#if>
    ${ENPinSettings["setOutputLevelHigh"]}
}
