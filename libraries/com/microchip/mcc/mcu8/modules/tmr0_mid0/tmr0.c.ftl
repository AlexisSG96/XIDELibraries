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
        Driver Version    :  3.10
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
<#if useInterrupt>
<#if isVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>

<#if timer0mode16bit>
/**
  Section: Global Variables Definitions
*/

volatile uint16_t timer${instanceNumber}ReloadVal16bit;
</#if>

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#if useInterrupt>
void (*${moduleNameUpperCase}_InterruptHandler)(void);
</#if>

<#list initializers as initializer>
void ${initializer}(void)
{
    // Set ${moduleNameUpperCase} to the options selected in the User Interface

    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>
    <#if T0CON0bits_T016BIT>
    // Load TMR${instanceNumber} value to the 16-bit reload variable
    timer${instanceNumber}ReloadVal16bit = (${TMRH} << 8) | ${TMRL};

    </#if>
    <#if useInterrupt>
    // Clear Interrupt flag before enabling the interrupt
    ${interruptFlagName} = 0;

    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;

    // Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>
    // Clearing IF flag
    ${interruptFlagName} = 0;
    </#if>
    <#list tmrConReg as data >

    // ${data.comment}
    ${data.name} = ${data.value};
    </#list>
}
</#list>

void ${moduleNameUpperCase}_StartTimer(void)
{
    // Start the Timer by writing to TMR${instanceNumber}ON bit
    ${TCONbits_TMRON} = 1;
}

void ${moduleNameUpperCase}_StopTimer(void)
{
    // Stop the Timer by writing to TMR0ON bit
    ${TCONbits_TMRON} = 0;
}

<#if timer0mode16bit>
uint16_t ${moduleNameUpperCase}_ReadTimer(void)
{
    uint16_t readVal;
    uint8_t readValLow;
    uint8_t readValHigh;

    readValLow  = ${TMRL};
    readValHigh = ${TMRH};
    readVal  = ((uint16_t)readValHigh << 8) + readValLow;

    return readVal;
}

void ${moduleNameUpperCase}_WriteTimer(uint16_t timerVal)
{
    // Write to the Timer${instanceNumber} register
    ${TMRH} = timerVal >> 8;
    ${TMRL} = (uint8_t) timerVal;
}

void ${moduleNameUpperCase}_Reload(void)
{
    // Write to the Timer${instanceNumber} register
    ${TMRH} = timer${instanceNumber}ReloadVal16bit >> 8;
    ${TMRL} = (uint8_t) timer${instanceNumber}ReloadVal16bit;
}
</#if>
<#if timer0mode8bit>
uint8_t ${moduleNameUpperCase}_ReadTimer(void)
{
    uint8_t readVal;

    // read Timer0, low register only
    readVal = ${TMRL};

    return readVal;
}

void ${moduleNameUpperCase}_WriteTimer(uint8_t timerVal)
{
    // Write to Timer0 registers, low register only
    ${TMRL} = timerVal;
 }

void ${moduleNameUpperCase}_Reload(uint8_t periodVal)
{
   // Write to Timer0 registers, high register only
   ${TMRH} = periodVal;
}
</#if>

<#if useInterrupt>
<#if isVectoredInterruptEnabled>
<#if isHighPriority>
void __interrupt(irq(${interruptIRQName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionName}()
<#else>
void __interrupt(irq(${interruptIRQName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
</#if>
{
    <#if (tickerFactor != "0") && (tickerFactor != "1")>
    static volatile uint16_t CountCallBack = 0;

    </#if>
    // clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;
<#if timer0mode8bit && timer0mode16bit>

    // reload ${moduleNameUpperCase}
    if(T${instanceNumber}CON0bits.T016BIT)
    {
        // Write to the Timer${instanceNumber} register
        ${TMRH} = timer${instanceNumber}ReloadVal16bit >> 8;
        ${TMRL} = (uint8_t) timer${instanceNumber}ReloadVal16bit;
    }
<#elseif timer0mode8bit>
<#elseif timer0mode16bit>
    // Write to the Timer${instanceNumber} register
    ${TMRH} = timer${instanceNumber}ReloadVal16bit >> 8;
    ${TMRL} = (uint8_t) timer${instanceNumber}ReloadVal16bit;

</#if>
    <#if tickerFactor == "1">
    // ticker function call;
    // ticker is 1 -> Callback function gets called every time this ISR executes
    ${moduleNameUpperCase}_CallBack();
    <#elseif (tickerFactor != "0")>
    // callback function - called every ${tickerFactor}th pass
    if (++CountCallBack >= ${moduleNameUpperCase}_INTERRUPT_TICKER_FACTOR)
    {
        // ticker function call
        ${moduleNameUpperCase}_CallBack();

        // reset ticker counter
        CountCallBack = 0;
    }
    <#else>
    if(${moduleNameUpperCase}_InterruptHandler)
    {
        ${moduleNameUpperCase}_InterruptHandler();
    }
    </#if>

    // add your ${moduleNameUpperCase} interrupt custom code
}

<#if (tickerFactor != "0")>
void ${moduleNameUpperCase}_CallBack(void)
{
    // Add your custom callback code here
    <#-- this code executes every ${tickerFactor} ${moduleNameUpperCase} periods -->

    if(${moduleNameUpperCase}_InterruptHandler)
    {
        ${moduleNameUpperCase}_InterruptHandler();
    }
}
</#if>

void ${moduleNameUpperCase}_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_InterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_DefaultInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}_SetInterruptHandler()
}

<#else>
bool ${moduleNameUpperCase}_HasOverflowOccured(void)
{
    <#-- Routine to check whether overflow has occured -->
    // check if  overflow has occurred by checking the TMRIF bit
    return(${interruptFlagName});
}
</#if>
/**
  End of File
*/