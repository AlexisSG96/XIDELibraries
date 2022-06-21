/**
  Generated Interrupt Manager Source File

  @Company:
    Microchip Technology Inc.

  @File Name:
    interrupt_manager.c

  @Summary:
    This is the Interrupt Manager file generated using ${productName}

  @Description:
    This header file provides implementations for global interrupt handling.
    For individual peripheral handlers please see the peripheral driver for
    all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.04
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#include "interrupt_manager.h"
#include "mcc.h"

<#if IPENData??>
void  INTERRUPT_Initialize (void)
{
    // ${IPENData.comment}
    ${IPENData.name} = ${IPENData.value};
}

</#if>
void __interrupt() INTERRUPT_InterruptManager (void)
{
    <#assign isIfCondUsedBefore = false>
    <#assign isPieInterruptConfigured = false>
    // interrupt handler
    <#list highInterrupts as interrupt>
        <#if isIfCondUsedBefore && preemptiveHigh>
                <#assign if_cmd = "else if">
        <#else>
                <#assign if_cmd = "if">
        </#if>
        <#if (!interrupt.isPeripheralInterrupt || !pieAvailable)>
            <#assign isIfCondUsedBefore = true>
    ${if_cmd}(${interrupt.enableBitName} == 1 && ${interrupt.flagName} == 1)
    {
        <#if interrupt.isISRSupported>
        ${interrupt.APIFunctionName}();
        <#else>
        //${interrupt.APIFunctionName}();
        </#if>
    }
        <#else>
            <#assign isPieInterruptConfigured = true>
        </#if>
    </#list>  
    <#if isPieInterruptConfigured>
        <#if isIfCondUsedBefore && preemptiveHigh>
                <#assign if_cmd = "else if">
        <#else>
                <#assign if_cmd = "if">
        </#if>  
    ${if_cmd}(${INTCON}bits.PEIE == 1)
    {
        <#assign isIfCondUsedBefore = false>
        <#list highInterrupts as interrupt>
            <#if isIfCondUsedBefore && preemptiveHigh>
                    <#assign if_cmd = "else if">
            <#else>
                    <#assign if_cmd = "if">
            </#if> 
            <#if (interrupt.isPeripheralInterrupt && pieAvailable)>
                <#assign isIfCondUsedBefore = true>
        ${if_cmd}(${interrupt.enableBitName} == 1 && ${interrupt.flagName} == 1)
        {
            <#if interrupt.isISRSupported>
            ${interrupt.APIFunctionName}();
            <#else>
            //${interrupt.APIFunctionName}();
            </#if>
        } 
            </#if>
        </#list>  
        <#if preemptiveHigh>
        else
        {
            //Unhandled Interrupt
        }
        </#if>
    }      
    </#if>    
    <#if preemptiveHigh>
    else
    {
        //Unhandled Interrupt
    }
    </#if>
}
/**
 End of File
*/
