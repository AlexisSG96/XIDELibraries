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
  Section: Compare Module APIs:
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // Set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initRegisters_Compare as reg>
	
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

void ${moduleNameUpperCase}_SetCompareCount(uint16_t compareCount)
{
    CCP${instanceNumber}_PERIOD_REG_T module;
    
    // Write the 16-bit compare value
    module.ccpr${instanceNumber}_16Bit = compareCount;
    
    ${resultLow} = module.ccpr${instanceNumber}l;
    ${resultHigh} = module.ccpr${instanceNumber}h;
}
<#if usesInterrupt>

void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;
}
<#else>

bool ${moduleNameUpperCase}_IsCompareComplete(void)
{
    // Check if compare is complete by reading "CCPIF" flag.
    return (${interruptFlagName});
}
</#if>
/**
 End of File
*/