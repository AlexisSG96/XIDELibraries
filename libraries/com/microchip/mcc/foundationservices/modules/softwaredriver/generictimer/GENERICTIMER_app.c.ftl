/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
*/

#include <xc.h>
#include "generic_tmr.h"
#include "../${timerHeader}"

/**
  Section: TMR APIs
*/

void TMR_Initialize(void)
{
    ${Initialize}();
}

uint16_t TMR_ReadTimer(void)    
{
    ${ReadTimer}();
}

void TMR_WriteTimer(uint16_t timerVal)
{
    ${WriteTimer}(timerVal);
}

void TMR_Reload(void)
{
    ${Reload}();
}

void TMR_ISR(void)
{
    ${ISR}();
}

void TMR_SetInterruptHandler(interruptHandler handler)
{
   ${SetInterruptHandler}(handler)
}

/**
  End of File
*/
