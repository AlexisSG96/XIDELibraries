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
        Driver Version    :  2.11
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
<#if usesInterrupt>
<#if isVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>

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

void ${moduleNameUpperCase}_SetCompareCount(uint16_t compareCount)
{
    CCP${instanceNumber}_PERIOD_REG_T module;
    
    // Write the 16-bit compare value
    module.ccpr${instanceNumber}_16Bit = compareCount;
    
    ${resultLow} = module.ccpr${instanceNumber}l;
    ${resultHigh} = module.ccpr${instanceNumber}h;
}

bool ${moduleNameUpperCase}_OutputStatusGet(void)
{
    // Returns the output status
    return(${outputStatus});
}

<#if usesInterrupt>
<#if isVectoredInterruptEnabled>
<#if isHighPriority>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionName}()
<#else>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
</#if>
{
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;
    
    // Add user code here
}
<#else>

bool ${moduleNameUpperCase}_IsCompareComplete(void)
{
    // Check if compare is complete by reading "CCPIF" flag.
    bool status = ${interruptFlagName};
    if(status)
        ${interruptFlagName} = 0;
    return (status);
}
</#if>
/**
 End of File
*/