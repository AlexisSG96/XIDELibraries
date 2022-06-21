/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.11
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
<#if useInterrupt>
<#if isVectoredInterrupt>
#include "interrupt_manager.h"
</#if>
</#if>

/**
  Section: ZCD Module APIs
*/

<#list initializers as initializer>
void ${moduleNameUpperCase}_${initializer} (void)
{
     // Set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initUIRegisters as reg>    
    
    // ${reg.comment}
<#-- MCCV3XX-2327: This special code supports the errors v1.35 compiler header files. -->
<#-- Specifically, the register "ZCD1CON" is named "ZCDCON" for 4 devices in the 16(L)F188xx family -->
<#if reg.name == "ZCD1CON" && isFamily16F188XX>
#if (__XC8_VERSION < 1360)
    ZCDCON = ${reg.value};
#else // __XC8_VERSION
    ${reg.name} = ${reg.value};
#endif // __XC8_VERSION
<#else>
    ${reg.name} = ${reg.value};
</#if>
    </#list>
    <#if useInterrupt>

    // Clearing IF flag before enabling the interrupt.
    ${interruptflagBitName} = 0;
    
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptenableBitName} = 1;
    </#if>
}
</#list>

bool ${moduleNameUpperCase}_IsLogicLevel(void)
{
    // Return ZCD logic level depending on the output polarity selected.
<#-- MCCV3XX-2327: This special code supports the errors v1.35 compiler header files. -->
<#-- Specifically, the register "ZCD1CON" is named "ZCDCON" for 4 devices in the 16(L)F188xx family -->
<#if isFamily16F188XX>
#if (__XC8_VERSION < 1360)
    return (ZCDCONbits.ZCDOUT);
#else // __XC8_VERSION
    return (${zcdOutRegister.name}bits.${zcdOutRegister.value});
#endif // __XC8_VERSION
<#else>
    return (${zcdOutRegister.name}bits.${zcdOutRegister.value});
</#if>
}

<#if useInterrupt>
<#if isVectoredInterrupt>
<#if isHighPriority>
void __interrupt(irq(${interruptIRQName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunction}()
<#else>  
void __interrupt(irq(${interruptIRQName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunction}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunction}(void)
    </#if>
{
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptflagBitName} = 0;
}
</#if>
/**
 End of File
*/
