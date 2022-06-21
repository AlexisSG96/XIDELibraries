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
        Driver Version    :  2.02
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
         MPLAB 	          :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"

/**
  Section: Capture Module APIs:
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // Set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initRegisters_Capture as reg>
	
	// ${reg.comment}
	${reg.name} = ${reg.value};    
	</#list>
    
	<#if usesInterrupt>
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;

    // Enable the ${moduleNameUpperCase} interrupt
    ${interruptEnableBitName} = 1;
	</#if>
	
    <#if timerselpresence>
	// Selecting ${timerSelectStringName}
	${timerSelect} = ${timerSelectValue};
	</#if>
}
</#list>

<#if usesInterrupt>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    CCP${instanceNumber}_PERIOD_REG_T module;

    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;
    
    // Copy captured value.
    module.ccpr${instanceNumber}l = ${resultLow};
    module.ccpr${instanceNumber}h = ${resultHigh};
    
    // Return 16bit captured value
    ${moduleNameUpperCase}_CallBack(module.ccpr${instanceNumber}_16Bit);
}

void ${moduleNameUpperCase}_CallBack(uint16_t capturedValue)
{
    // Add your code here
}
<#else>
bool ${moduleNameUpperCase}_IsCapturedDataReady(void)
{
    // Check if data is ready to read from capture module by reading "CCPIF" flag.
    return (${interruptFlagName});
}

uint16_t ${moduleNameUpperCase}_CaptureRead(void)
{
    CCP${instanceNumber}_PERIOD_REG_T module;

    // Copy captured value.
    module.ccpr${instanceNumber}l = ${resultLow};
    module.ccpr${instanceNumber}h = ${resultHigh};
    
    // Return 16bit captured value
    return module.ccpr${instanceNumber}_16Bit;
}
</#if>
/**
 End of File
*/