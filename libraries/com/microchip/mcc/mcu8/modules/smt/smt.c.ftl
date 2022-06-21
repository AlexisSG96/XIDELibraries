/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
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
<#if usesOverflowInterrupt>
<#if isVectoredOverflowInterruptEnabled>
#include "interrupt_manager.h"
</#if>
<#elseif usesPWAcquInterrupt>
<#if isVectoredPWAcquInterruptEnabled>
#include "interrupt_manager.h"
</#if>
<#elseif usesPRAcquInterrupt>
<#if isVectoredPRAcquInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>


/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>
    <#if usesOverflowInterrupt>
    // Enabling ${moduleNameUpperCase} overflow interrupt.
    ${overflowInterruptEnableBitName} = 1;
    
    </#if>
    <#if usesPWAcquInterrupt>
    // Enabling ${moduleNameUpperCase} pulse width acquisition interrupt.
    ${PWAcquInterruptEnableBitName} = 1;

    </#if>
    <#if usesPRAcquInterrupt>
    // Enabling ${moduleNameUpperCase} period acquisition interrupt.
    ${PRAcquInterruptEnableBitName} = 1;

    </#if>
    <#if SMTGO == "enabled">
    // Start the SMT module by writing to SMTxGO bit
    ${SMTGO_Bit} = 1;
    
    </#if>
}
</#list>
        
void ${moduleNameUpperCase}_DataAcquisitionEnable(void)
{
    // Start the SMT module by writing to SMTxGO bit
    ${SMTGO_Bit} = 1;
}

void ${moduleNameUpperCase}_DataAcquisitionDisable(void)
{
    // Start the SMT module by writing to SMTxGO bit
    ${SMTGO_Bit} = 0;
}

void ${moduleNameUpperCase}_HaltCounter(void)
{
    ${SMTSTP_Bit} = 1;
}

void ${moduleNameUpperCase}_SetPeriod(uint32_t periodVal)
{
    // Write to the ${moduleNameUpperCase} Period registers
    ${SMTPRU} = (uint8_t)(periodVal >> 16);
    ${SMTPRH} = (uint8_t)(periodVal >> 8);
    ${SMTPRL} = (uint8_t)periodVal;
}

uint32_t ${moduleNameUpperCase}_GetPeriod()
{
    return (${moduleNameUpperCase}PR);
}

void ${moduleNameUpperCase}_SingleDataAcquisition(void)
{
    ${SMTREPEAT_Bit} = 0;
}

void ${moduleNameUpperCase}_RepeatDataAcquisition(void)
{
    ${SMTREPEAT_Bit} = 1;
}

void ${moduleNameUpperCase}_ManualPeriodBufferUpdate(void)
{
    ${SMTCPRUP_Bit} = 1;
}

void ${moduleNameUpperCase}_ManualPulseWidthBufferUpdate(void)
{
    ${SMTCPWUP_Bit} = 1;
}

void ${moduleNameUpperCase}_ManualTimerReset(void)
{
    ${SMTRST_Bit} = 1;
}

bool ${moduleNameUpperCase}_IsWindowOpen(void)
{
    return (${SMTWS_Bit});
}

bool ${moduleNameUpperCase}_IsSignalAcquisitionInProgress(void)
{
    return (${SMTAS_Bit});
}

bool ${moduleNameUpperCase}_IsTimerIncrementing(void)
{
    return (${SMTTS_Bit});
}

uint32_t ${moduleNameUpperCase}_GetCapturedPulseWidth()
{
    return (${moduleNameUpperCase}CPW);
}

uint32_t ${moduleNameUpperCase}_GetCapturedPeriod()
{
    return (${moduleNameUpperCase}CPR);
}

uint32_t ${moduleNameUpperCase}_GetTimerValue()
{
    return (${moduleNameUpperCase}TMR);
}
<#if usesPRAcquInterrupt>

<#if isVectoredPRAcquInterruptEnabled>
<#if PRAcquHighPriorityInterrupt>
void __interrupt(irq(${interruptIRQPRAcquName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${PRAcquInterruptFunctionName}()
<#else>
void __interrupt(irq(${interruptIRQPRAcquName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${PRAcquInterruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${PRAcquInterruptFunctionName}(void)
</#if>
{
    
    // Disabling ${moduleNameUpperCase} period acquisition interrupt flag bit.
    ${PRAcquInterruptFlagName} = 0;
}
</#if>
<#if usesPWAcquInterrupt>

<#if isVectoredPWAcquInterruptEnabled>
<#if PWAcquHighPriorityInterrupt>
void __interrupt(irq(${interruptIRQPWAcquName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${PWAcquInterruptFunctionName}()
<#else>
void __interrupt(irq(${interruptIRQPWAcquName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${PWAcquInterruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${PWAcquInterruptFunctionName}(void)
</#if>
{
 
    // Disabling ${moduleNameUpperCase} pulse width acquisition interrupt flag bit.
    ${PWAcquInterruptFlagName} = 0;
}
</#if>
<#if usesOverflowInterrupt>

<#if isVectoredOverflowInterruptEnabled>
<#if overflowHighPriorityInterrupt>
void __interrupt(irq(${interruptIRQOverflowName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${overflowInterruptFunctionName}()
<#else>
void __interrupt(irq(${interruptIRQOverflowName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${overflowInterruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${overflowInterruptFunctionName}(void)
</#if>
{
  
    // Disabling ${moduleNameUpperCase} overflow interrupt flag bit.
    ${overflowInterruptFlagName} = 0;
}
</#if>
/**
 End of File
*/
