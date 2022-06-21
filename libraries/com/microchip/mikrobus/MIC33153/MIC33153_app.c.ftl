 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "MIC33153.h"
#include "MCP4921.h"
#include "mcc.h"
#include <stdio.h>
#include "${ANOUTFunctions["adcheader"]}"
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>
#ifdef __XC
#include <xc.h>
#endif

#define upperLimit 3.5
#define lowerLimit 0.8
#define vref_range 2.7 //3.5-0.8
#define constant 1.9 //2.7-0.8
#define dac_resolution 4095 //(2^12)-1
#define adc_vref 3.3
#define voltage_divider_constant 147/100
#define adc_resolution 1023
#define pgRead ${PGPinSettings["getInputValue"]}

uint16_t dacVoltage;

void MIC33153_Initialize(void){
    <#if EN_Mode == "enabled">
    MIC33153_Enable();
<#else>
    MIC33153_Disable();
</#if>
    MIC33153_SetVoltage(${InitVoltVal});
}

void MIC33153_Enable(void){
    ${ENPinSettings["setOutputLevelHigh"]}
}
 
void MIC33153_Disable(void){
    ${ENPinSettings["setOutputLevelLow"]}
}
 
bool IsPowerGood(void){
    if (pgRead == 0){
       return false;
    } else{
       return true;
    }
}
 
float GetOutputVoltageCondition(void){
    uint16_t adcValue =((${ANOUTFunctions["getConversion"]}(${adc_channel})) >> 6);
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    float voltage = (adcValue*adc_vref/adc_resolution)*voltage_divider_constant;
    return voltage;
}

void MIC33153_SetVoltage(float voltage){
    if (voltage < lowerLimit){
       voltage = lowerLimit;
    } else if (voltage > upperLimit){
       voltage = upperLimit;
    }
    float volt_ref = vref_range-((voltage + constant) - vref_range); 
    dacVoltage = (uint16_t) ((dac_resolution * volt_ref) / vref_range);
    DAC_Set(dacVoltage);
}

