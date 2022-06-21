/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "${PWMFunctions["pwmHeader"]}"
#include "MCP1664.h"
#include <math.h>

/**
  Section: Macro Declarations
 */

#define MAX 100
#define MIN 0
#define RESO_MULTI 70

/**
  Section: MCP1664 Click Driver APIs
 */

void MCP1664_Initialize(void){
    MCP1664_setBrightness(${InitBrVal});
}

void MCP1664_setBrightness(uint16_t Brightness){
    uint16_t dutycycle;
    if(Brightness <= MIN){
        dutycycle = MIN;
    }
    else if (Brightness > MIN && Brightness < MAX){
        dutycycle = floor((Brightness + RESO_MULTI)/2);
    }
    else if (Brightness > MAX){
        dutycycle = MAX;
    }
    ${PWMFunctions["LoadDutyValue"]}(dutycycle);
}
