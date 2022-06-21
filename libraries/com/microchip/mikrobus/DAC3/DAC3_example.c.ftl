/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "mcc.h"
#include "DAC3.h"
#include "DAC3_example.h"
#include <stdio.h>

void DAC3_example(void)
{
    float voltage;
    float readVoltage, readNonvolatileVoltage;
    
    uint16_t dacVoltage, dacNonvolatileVoltage;
    
    //Set volatile and nonvolatile voltage values to 1V
    voltage = 1;
    //Calculating dac value, see equation 4-1 in datasheet
    dacNonvolatileVoltage = (4096*voltage)/5;
    DAC3_SetNonvolatile(dacNonvolatileVoltage);
    
    printf("Set the non-volatile voltage to 1V \n");
    
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>  

    //Set volatile voltage value to 2V
    voltage = 2;
    dacVoltage = (4096*voltage)/5;
    DAC3_Set(dacVoltage);

    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    
    printf("Set the volatile voltage to 2V \n");

    dacVoltage = DAC3_Read(&dacNonvolatileVoltage);
    
    //Calculating voltage value, see equation 4-1 in datasheet, 819.2 = 4096/5
    readVoltage = dacVoltage / 819.2;
    readNonvolatileVoltage = dacNonvolatileVoltage / 819.2;
    
    printf("Read: non-volatile voltage value %f, and volatile voltage value %f", readNonvolatileVoltage, readVoltage);
    
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
}

