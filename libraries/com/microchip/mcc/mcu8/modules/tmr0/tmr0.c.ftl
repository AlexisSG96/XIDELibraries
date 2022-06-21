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
        Driver Version    :  2.01
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

/**
  Section: Global Variables Definitions
*/

volatile uint8_t timer${instanceNumber}ReloadVal;
<#if useInterrupt>
void (*${moduleNameUpperCase}_InterruptHandler)(void);
</#if>
/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // Set ${moduleNameUpperCase} to the options selected in the User Interface
	<#list initRegisters as reg>
    <#if reg.name == "OPTION_REG">
	
    // PSA ${OPTION_REG_PSA}; PS ${OPTION_REG_PS}; TMRSE ${OPTION_REG_TMRSE}; mask the nWPUEN and INTEDG bits
    ${reg.name} = (uint8_t)((${reg.name} & 0xC0) | (${reg.value} & 0x3F)); 
    <#else>
	
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#if>
</#list>
	
    // Load the TMR value to reload variable
    timer${instanceNumber}ReloadVal= ${TMR0Value};
    <#if useInterrupt>

    // Clear Interrupt flag before enabling the interrupt
    ${interruptFlagName} = 0;

    // Enabling ${moduleNameUpperCase} interrupt
    ${interruptEnableBitName} = 1;

    // Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>

    // Clearing IF flag
    ${interruptFlagName} = 0;
    </#if>
}
</#list>

uint8_t ${moduleNameUpperCase}_ReadTimer(void)
{
    uint8_t readVal;

    readVal = TMR${instanceNumber};

    return readVal;
}

void ${moduleNameUpperCase}_WriteTimer(uint8_t timerVal)
{
    // Write to the Timer${instanceNumber} register
    TMR${instanceNumber} = timerVal;
}

void ${moduleNameUpperCase}_Reload(void)
{
    // Write to the Timer${instanceNumber} register
    TMR${instanceNumber} = timer${instanceNumber}ReloadVal;
}

<#if useInterrupt>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    <#if (tickerFactor != "0") && (tickerFactor != "1")>
    static volatile uint16_t CountCallBack = 0;
    </#if>

    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;

    TMR${instanceNumber} = timer${instanceNumber}ReloadVal;

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
