/**
  @Generated ${productName} Source File

  @Company:
    Microchip Technology Inc.

  @File Name:
    mcc.c

  @Summary:
    This is the mcc.c file generated using ${productName}

  @Description:
    This header file provides implementations for driver APIs for all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.00
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#include "mcc.h"

<#if (selectedDevice == "PIC10F320") || (selectedDevice == "PIC10LF320")>
#if (__XC8_VERSION < 1430)
asm("psect functab,global,class=CODE,reloc=0x1,delta=2");
#endif // __XC8_VERSION
</#if>

void SYSTEM_Initialize(void)
{

<#if useInterruptManager>
    <#if ifPIC18>
    INTERRUPT_Initialize();
    </#if>
</#if>
<#list moduleInitializers as initializer>
    ${initializer}();
</#list>
}

void OSCILLATOR_Initialize(void)
{
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    <#if isPLLEnabled>
    // Wait for PLL to stabilize
    while(${pllrBitName} == 0)
    {
    }
    </#if>
}

<#if includeWDTInitialiser>
void WDT_Initialize(void)
{
    <#list WDTregisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
}
</#if>

<#if PMDavailable>
void PMD_Initialize(void)
{
    <#list PMDregisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
}
</#if>
/**
 End of File
*/
