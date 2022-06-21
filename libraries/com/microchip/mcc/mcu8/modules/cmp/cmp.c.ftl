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
         Compiler          :  ${compiler} or later
         MPLAB             :  ${tool}
 */ 

 ${disclaimer}
 
 /**
   Section: Included Files
 */


#include <xc.h>
#include "${moduleNameLowerCase}.h"
<#if useInterrupt>
<#if isVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>
/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${moduleNameUpperCase}_Initialize(void)
{
<#if useInterrupt>
    /* Disable ${moduleNameUpperCase} interrupt before configuring the ${moduleNameUpperCase}
       control register. Although a comparator is disabled, an interrupt can be
       generated by changing the output polarity with the CxPOL bit of the
       CMxCON0 register,or by switching the comparator on or off with the CxON
       bit of the CMxCON0 register.*/
    ${InterruptEnableBit} = 0;
</#if>

    <#list initRegisters as reg>
	// ${reg.comment}                         
    ${reg.name} = ${reg.value};
	
    </#list>	
<#if useInterrupt>
    // Clearing IF flag before enabling the interrupt.
    ${InterruptFlag} = 0;

    // Enabling ${moduleNameUpperCase} interrupt.
    ${InterruptEnableBit} = 1;
 </#if>   
}

</#list>
bool ${moduleNameUpperCase}_GetOutputStatus(void)
{
	return (${OutputBit});
}

<#if useInterrupt>
<#if isVectoredInterruptEnabled>
<#if isInterruptHiPrio>
void __interrupt(irq(${InterruptIRQName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionName}()
<#else>
void __interrupt(irq(${InterruptIRQName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
</#if>
{
    // clear the ${moduleNameUpperCase} interrupt flag
    ${InterruptFlag} = 0;
}
</#if>

/**
 End of File
*/
