/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <stdbool.h>
#include "${portHeader}"
#include "${DELAYFunctions.delayHeader}"
#include "Thermo5Drivers/Thermo5.h"

static void ExampleHandler(struct INTERRUPTS status)
{
    if(status.high_limit.internal)
    {
        printf("High limit flag triggered\r\n");
    }
}

void Thermo5_Example(void) 
{
    Thermo5_SetCallback(&ExampleHandler);
    Thermo5_SetHighLimit(INTERNAL_DIODE, 25);

    while (1) 
    {
        float data;
        bool nAlert;
        
        ${DELAYFunctions.delayMs}(1000);
        data = Thermo5_ReadTemperature(INTERNAL_DIODE);
        
        printf("Value is: %3.2f\r\n", data);
        
        nAlert = ${alertPinSettings["getInputValue"]};
        if(!nAlert)
        {
            Thermo5_ISR();
        }
    }
}
