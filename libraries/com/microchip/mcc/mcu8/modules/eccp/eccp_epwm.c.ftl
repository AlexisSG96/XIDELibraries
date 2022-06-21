/**
  EPWM${instanceNumber} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    epwm${instanceNumber}.c

  @Summary
    This is the generated driver implementation file for the EPWM${instanceNumber} driver using ${productName}

  @Description
    This source file provides implementations for driver APIs for EPWM${instanceNumber}.
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
#include "epwm${instanceNumber}.h"

/**
  Section: Macro Declarations
*/

#define PWM${instanceNumber}_INITIALIZE_DUTY_VALUE    ${pwmCCPRDisplayValue}

/**
  Section: EPWM Module APIs
*/

<#list initializers as initializer>
void EPWM${instanceNumber}_Initialize(void)
{
    // Set the EPWM${instanceNumber} to the options selected in the User Interface
    <#list initRegisters_Pwm as reg>
	
	// ${reg.comment}
	${reg.name} = ${reg.value};    
	</#list>

    <#if timerselpresence>
	// Selecting ${timerSelectStringName}
	${timerSelect} = ${timerSelectValue};
	</#if>
}
</#list>

void EPWM${instanceNumber}_LoadDutyValue(uint16_t dutyValue)
{
   // Writing to 8 MSBs of pwm duty cycle in CCPRL register
    ${resultLow} = ((dutyValue & 0x03FC)>>2);
    
   // Writing to 2 LSBs of pwm duty cycle in CCPCON register
    ${ccpControlRegister1} = ((uint8_t)(${ccpControlRegister1} & 0xCF) | ((dutyValue & 0x0003)<<4));
}
/**
 End of File
*/

