/**
  PWM${instanceNumber} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    pwm${instanceNumber}.c

  @Summary
    This is the generated driver implementation file for the PWM${instanceNumber} driver using ${productName}

  @Description
    This source file provides implementations for driver APIs for PWM${instanceNumber}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
         MPLAB 	          :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "pwm${instanceNumber}.h"

/**
  Section: Macro Declarations
*/

#define PWM${instanceNumber}_INITIALIZE_DUTY_VALUE    ${pwmCCPRDisplayValue}

/**
  Section: PWM Module APIs
*/

<#list initializers as initializer>
void PWM${instanceNumber}_Initialize(void)
{
    // Set the PWM${instanceNumber} to the options selected in the User Interface
    <#list initRegisters_Pwm as reg>
	
	// ${reg.comment}
	${reg.name} = ${reg.value};    
	</#list>

    <#if timerselpresence>
	// Selecting ${timerSelectStringName}
	${timerSelect} = ${timerSelectValue};
	</#if>
    
	<#if usesInterrupt>
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;

    // Enable the ${moduleNameUpperCase} interrupt
    ${interruptEnableBitName} = 1;
    </#if>    
}
</#list>

void PWM${instanceNumber}_LoadDutyValue(uint16_t dutyValue)
{
   // Writing to 8 MSBs of pwm duty cycle in CCPRL register
    ${resultLow} = ((dutyValue & 0x03FC)>>2);
    
   // Writing to 2 LSBs of pwm duty cycle in CCPCON register
    ${ccpControlRegister1} = ((uint8_t)(${ccpControlRegister1} & 0xCF) | ((dutyValue & 0x0003)<<4));
}

<#if usesInterrupt>

void PWM${instanceNumber}_${interruptFunctionName}(void)
{
    // Clear the PWM${instanceNumber} interrupt flag
    ${interruptFlagName} = 0;
	
    // Add user code here
}
</#if>
/**
 End of File
*/

