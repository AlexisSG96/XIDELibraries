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
	<#-- MCCV3XX-4462: This special code supports the errors v1.38 compiler header files in CCPTMRS registers. -->
	<#if selectedDevice?contains("PIC18F65K40") || selectedDevice?contains("PIC18F66K40") || selectedDevice?contains("PIC18F67K40") || selectedDevice?contains("PIC18LF65K40") || selectedDevice?contains("PIC18LF66K40") || selectedDevice?contains("PIC18LF67K40")>
	#if (__XC8_VERSION == 1380)
	<#if timerSelectValue == "0x0">
	${timerSelect}0 = 0x0;
	${timerSelect}1 = 0x0;
	</#if>
	<#if timerSelectValue == "0x1">
	${timerSelect}0 = 0x1;
	${timerSelect}1 = 0x0;
	</#if>
	<#if timerSelectValue == "0x2">
	${timerSelect}0 = 0x0;
	${timerSelect}1 = 0x1;
	</#if>
	<#if timerSelectValue == "0x3">
	${timerSelect}0 = 0x1;
	${timerSelect}1 = 0x1;
	</#if>
	#else
	// Selecting ${timerSelectStringName}
	${timerSelect} = ${timerSelectValue};
	#endif
	<#else>
	// Selecting ${timerSelectStringName}
	${timerSelect} = ${timerSelectValue};
	</#if>
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
    dutyValue &= 0x03FF;
    
    // Load duty cycle value
    if(${pulseWidthAlignment})
    {
        dutyValue <<= 6;
        ${resultHigh} = dutyValue >> 8;
        ${resultLow} = dutyValue;
    }
    else
    {
        ${resultHigh} = dutyValue >> 8;
        ${resultLow} = dutyValue;
    }
}

bool PWM${instanceNumber}_OutputStatusGet(void)
{
    // Returns the output status
    return(${outputStatus});
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

