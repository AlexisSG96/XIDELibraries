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
         Compiler          :  ${compiler}
         MPLAB             :  ${tool}
 */ 

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // Reset double buffered register ${COGCON0regName}
    ${COGCON0regName} = 0x00;

    // Set the COG to the options selected in ${productName}
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>
    <#if interruptEnabled>
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBit} = 1;
    </#if>
}
</#list>

void ${moduleNameUpperCase}_AutoShutdownEventSet()
{
    // Setting the GxASDE bit of COGxASD register
    ${COGASDregName}bits.${GASDESettingName} = 1;
}

void ${moduleNameUpperCase}_AutoShutdownEventClear()
{
    // Clearing the GxASDE bit of COGxASD register
    ${COGASDregName}bits.${GASDESettingName} = 0;
}
<#if interruptEnabled>

void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptflagBitName} = 0;
}
</#if>
/**
 End of File
*/

