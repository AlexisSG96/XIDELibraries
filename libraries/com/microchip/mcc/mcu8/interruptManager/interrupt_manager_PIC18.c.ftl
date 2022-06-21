/**
  Generated Interrupt Manager Header File

  @Company:
    Microchip Technology Inc.

  @File Name:
    interrupt_manager.h

  @Summary:
    This is the Interrupt Manager file generated using ${productName}

  @Description:
    This header file provides implementations for global interrupt handling.
    For individual peripheral handlers please see the peripheral driver for
    all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.12
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#include "interrupt_manager.h"
#include "mcc.h"

void  INTERRUPT_Initialize (void)
{
    <#if IPENData??>
    // ${IPENData.comment}
    ${IPENData.name} = ${IPENData.value};
    </#if>

    // Assign peripheral interrupt priority vectors

    <#list highInterrupts as interrupt>
    <#if interrupt.priorityBitName??>
    // ${interrupt.name} - high priority
    ${interrupt.priorityBitName} = 1;
    <#else>
    // Interrupt ${interrupt.name} has no priority bit. It will always be called from the High Interrupt Vector
    </#if>

    </#list>

    <#list lowInterrupts as interrupt>
    <#if interrupt.priorityBitName??>
    // ${interrupt.name} - low priority
    ${interrupt.priorityBitName} = 0;    
    <#else>
    // Interrupt ${interrupt.name} has no priority bit. It will always be called from the High Interrupt Vector
    </#if>

    </#list>
}

<#if hasHighInterrupts>
void __interrupt() INTERRUPT_InterruptManagerHigh (void)
{
   // interrupt handler
   <#list highInterrupts as interrupt>
   <#if interrupt.first || !preemptiveHigh>
        <#assign if_cmd = "if">
   <#elseif preemptiveHigh>
        <#assign if_cmd = "else if">
   </#if>
    ${if_cmd}(${interrupt.enableBitName} == 1 && ${interrupt.flagName} == 1)
    {
        <#if interrupt.isISRSupported>
        ${interrupt.APIFunctionName}();
        <#else>
        //${interrupt.APIFunctionName}();
        </#if>
    }
    </#list>
    <#if preemptiveHigh>
    else
    {
        //Unhandled Interrupt
    }
    </#if>
}
</#if>

<#if hasLowInterrupts>
void __interrupt(low_priority) INTERRUPT_InterruptManagerLow (void)
{
    // interrupt handler
    <#list lowInterrupts as interrupt>
    <#if interrupt.first || !preemptiveLow>
        <#assign if_cmd = "if">
    <#elseif preemptiveLow>
        <#assign if_cmd = "else if">
    </#if>
    ${if_cmd}(${interrupt.enableBitName} == 1 && ${interrupt.flagName} == 1)
    {
        <#if interrupt.isISRSupported>
        ${interrupt.APIFunctionName}();
        <#else>
        //${interrupt.APIFunctionName}();
        </#if>
    }
    </#list>
    <#if preemptiveLow>
    else
    {
        //Unhandled Interrupt
    }
    </#if>
}
</#if>
/**
 End of File
*/
