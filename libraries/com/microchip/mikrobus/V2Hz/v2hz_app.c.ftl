/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */
#ifdef __XC
#include <xc.h>
#endif  
#include "${pinHeader}"
#include "${PWMFunctions["pwmHeader"]}"
#include "v2hz.h"

/**
  Section: Macro Declarations
 */

#define STEPS	10

/**
  Section: V to Hz Driver APIs
 */
 
 void v2hz_Initialize(void){
<#if BREVal == "enabled">
    v2hz_Enable();
<#else>
    v2hz_Disable();
</#if>
    v2hz_setOutputFrequency(${InitFREQVal});
 }

 void v2hz_Enable(void){
	${BREPinSettings["LAT"]} = 1;
 }

 void v2hz_Disable(void){
	${BREPinSettings["LAT"]} = 0; 
 }
 
 void v2hz_setOutputFrequency(uint16_t frequency){
	 uint16_t dutyCycle = ((frequency/STEPS)+1);
	 ${PWMFunctions["LoadDutyValue"]}(dutyCycle);
 }