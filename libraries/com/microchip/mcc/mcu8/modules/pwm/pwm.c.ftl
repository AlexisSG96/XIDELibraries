 /**
   ${moduleNameUpperCase} Generated Driver File
 
   @Company
     Microchip Technology Inc.
 
   @File Name
     ${moduleNameLowerCase}.c
 
   @Summary
     This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}
 
   @Description
     This source file provides implementations for driver APIs for ${moduleNameUpperCase}.
     Generation Information :
         Product Revision  :  ${productName} - ${productVersion}
         Device            :  ${selectedDevice}
         Driver Version    :  2.01
     The generated drivers are tested against the following:
         Compiler          :  ${compiler} or later
         MPLAB             :  ${tool}
 */ 

 ${disclaimer}
 
 /**
   Section: Included Files
 */

 #include <xc.h>
 #include "pwm${instanceNumber}.h"

 /**
   Section: PWM Module APIs
 */

 <#list initializers as initializer>
 void ${initializer}(void)
 {
    // Set the PWM to the options selected in the ${productName}.
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};   

    </#list>
    <#if timerselpresence == "timerselpresent">
    // Select timer
    <#if selectedDevice?contains("65K40") || selectedDevice?contains("66K40") || selectedDevice?contains("67K40")>
    <#if CTSELvalue == "0">
    ${CCPTMRSregname}bits.${CTSELsettingname}0 = 0;
    ${CCPTMRSregname}bits.${CTSELsettingname}1 = 0;
    </#if>
    <#if CTSELvalue == "1">
    ${CCPTMRSregname}bits.${CTSELsettingname}0 = 0;
    ${CCPTMRSregname}bits.${CTSELsettingname}1 = 1;
    </#if>
    <#if CTSELvalue == "2">
    ${CCPTMRSregname}bits.${CTSELsettingname}0 = 1;
    ${CCPTMRSregname}bits.${CTSELsettingname}1 = 0;
    </#if>
    <#if CTSELvalue == "3">
    ${CCPTMRSregname}bits.${CTSELsettingname}0 = 1;
    ${CCPTMRSregname}bits.${CTSELsettingname}1 = 1;
    </#if>
    <#else>
    ${CCPTMRSregname}bits.${CTSELsettingname} = ${CTSELvalue};
    </#if>   
    </#if>
 }
 </#list> 

 void PWM${instanceNumber}_LoadDutyValue(uint16_t dutyValue)
 {
     // Writing to 8 MSBs of PWM duty cycle in PWMDCH register
     PWM${instanceNumber}DCH = (dutyValue & 0x03FC)>>2;
     
     // Writing to 2 LSBs of PWM duty cycle in PWMDCL register
     PWM${instanceNumber}DCL = (dutyValue & 0x0003)<<6;
 }
 /**
  End of File
 */
