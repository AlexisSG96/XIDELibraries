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
#include "${TMRFunctions["timerHeader"]}"
#include "hz2v.h"


/**
  Section: Hz to V Driver APIs
 */
 
 void hz2v_Initialize(void){
<#if Enable_Val == "enabled">
     hz2v_Enable();
<#else>
     hz2v_Disable();
</#if>
    hz2v_setOutputVoltage(${InitVOLTVal});
 }

 void hz2v_Enable(void){
	${ENPinSettings["LAT"]} = 1;
 }

 void hz2v_Disable(void){
	${ENPinSettings["LAT"]} = 0; 
 }
 
 void hz2v_setOutputVoltage(float voltage){     //mV
     float frequency = voltage*3.03;    //Hz
     if (frequency <= 122){ //minimum possible frequency for up to 10k Hz
         frequency = 122;
     }
     uint8_t period = ((((125000)/((int)frequency))/4)-1);
     ${TMRFunctions["LoadPeriodRegister"]}(period);
 }