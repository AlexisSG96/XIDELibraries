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
         Driver Version    :  1.11
     The generated drivers are tested against the following:
         Compiler          :  ${compiler}
         MPLAB             :  ${tool}
 */ 

 /**
   Section: Includes
 */
#include <xc.h>
#include "${moduleNameLowerCase}.h"
<#if vectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>

<#list allocatedPins as intPin>
void (*${intPin.functionName}_InterruptHandler)(void);
</#list>

<#list allocatedPins as intPin>
<#if vectoredInterruptEnabled>
<#if intPin.isHighPriority()>
void __interrupt(irq(${intPin.getIRQname()}),base(${IVTBaseAddress})) ${intPin.functionName}_ISR()
<#else>
void __interrupt(irq(${intPin.getIRQname()}),base(${IVTBaseAddress}),low_priority) ${intPin.functionName}_ISR()
</#if>
<#else>
void ${intPin.functionName}_ISR(void)
</#if>
{
    ${intPin.customName}_InterruptFlagClear();

    // Callback function gets called everytime this ISR executes
    ${intPin.functionName}_CallBack();    
}


void ${intPin.functionName}_CallBack(void)
{
    // Add your custom callback code here
    if(${intPin.functionName}_InterruptHandler)
    {
        ${intPin.functionName}_InterruptHandler();
    }
}

void ${intPin.functionName}_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${intPin.functionName}_InterruptHandler = InterruptHandler;
}

void ${intPin.functionName}_DefaultInterruptHandler(void){
    // add your ${intPin.functionName} interrupt custom code
    // or set custom function using ${intPin.functionName}_SetInterruptHandler()
}
</#list>

<#list initializers as initializer>
void ${initializer}(void)
{
<#list allocatedPins as pin>
    
    // Clear the interrupt flag
    // Set the external interrupt edge detect
    ${pin.customName}_InterruptFlagClear();   
    ${pin.customName}_${pin.edge}EdgeSet();    
    // Set Default Interrupt Handler
    ${pin.functionName}_SetInterruptHandler(${pin.functionName}_DefaultInterruptHandler);
    <#if pin.interruptEnabled>
    ${pin.customName}_InterruptEnable();      
    </#if>

</#list>   
}

</#list>
