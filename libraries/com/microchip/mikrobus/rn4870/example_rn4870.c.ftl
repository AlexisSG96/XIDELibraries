/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <string.h>
#include "mcc.h"
#include "example_rn4870.h"
#include "rn4870_click.h"
#include "drivers/${UARTFunctions["uartheader"]}"

/**
  Section: RN4870 Click Example Code
 */

void RN4870_Example()
{
    char Name[] = "RN4870";
    static uint8_t RN4870_Initialized = 0;

    if (!RN4870_Initialized) {
        RN4870_InitLED_Set(true);
        RN4870_Setup(Name);
        RN4870_Initialized = 1;
        RN4870_InitLED_Set(false);
    }
    RN4870_SendString("\r\nHello World...!!!");    
}