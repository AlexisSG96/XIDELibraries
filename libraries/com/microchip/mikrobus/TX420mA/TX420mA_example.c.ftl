/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "TX420mA.h"
#include "${DELAYFunctions.delayHeader}"
#include <stdio.h>
#include <stdint.h>

void TX420mA_example(void)
{
    float voltage = 0;
    
    uint16_t dacVoltage;
    
    printf("Ramping our voltage UP");
    while(voltage < 3)
    {
        dacVoltage = (uint16_t) ((4096*voltage)/3.3);
        TX420mA_Set(dacVoltage);
        ${DELAYFunctions.delayMs}(100);
        voltage += 0.5;
    }

    printf("Ramping our voltage DOWN\r\n");

    while(voltage > 0)
    {
        dacVoltage = (uint16_t) ((4096*voltage)/3.3);
        TX420mA_Set(dacVoltage);
        ${DELAYFunctions.delayMs}(100);
        voltage -= 0.5;
    }
}

