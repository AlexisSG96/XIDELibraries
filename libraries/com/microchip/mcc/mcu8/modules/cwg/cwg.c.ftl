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
<#if interruptEnabled>
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
    // Set the ${moduleNameUpperCase} to the options selected in ${productName}
    <#list initRegisters as reg>

	// ${reg.comment}
	${reg.name} = ${reg.value};
    </#list>

    <#if interruptEnabled>
    // Clearing IF flag before enabling the interrupt.
    ${interruptFlagName} = 0;
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;
    </#if>
}
</#list>

<#if bridgeEnabled>
void ${moduleNameUpperCase}_LoadRiseDeadbandCount(uint8_t dutyValue)
{
    ${CWGDBRRegName} = dutyValue;
}

void ${moduleNameUpperCase}_LoadFallDeadbandCount(uint8_t dutyValue)
{
    ${CWGDBFRegName} = dutyValue;
}

void ${moduleNameUpperCase}_LoadBufferEnable(void)
{
    ${CWGLDSettingName} = 1;
}

bool ${moduleNameUpperCase}_IsModuleEnabled()
{
    return (${CWGENSettingName});
}
</#if>

void ${moduleNameUpperCase}_AutoShutdownEventSet()
{
    ${CWGSHUTDOWNSettingName} = 1;
}

void ${moduleNameUpperCase}_AutoShutdownEventClear()
{
    ${CWGSHUTDOWNSettingName} = 0;
}

<#if interruptEnabled>
<#if isVectoredInterruptEnabled>
<#if isHighPriority>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress})) ${isrName}()
<#else>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress}),low_priority) ${isrName}()
</#if>
<#else>
void ${moduleNameUpperCase}_ISR(void)
</#if>
{
    /* TODO : Add interrupt handling code */
    ${interruptFlagName} = 0;
}
</#if>

/**
 End of File
*/