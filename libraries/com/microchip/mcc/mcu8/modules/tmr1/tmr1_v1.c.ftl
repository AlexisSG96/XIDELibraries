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
  Section: Global Variable Definitions
*/
volatile uint16_t timer${instanceNumber}ReloadVal;
<#if useInterrupt>
void (*${moduleNameUpperCase}_InterruptHandler)(void);
</#if>

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    //Set the Timer to the options selected in the GUI
   <#list initRegisters as data >
	
	// ${data.comment}
		${data.name} = ${data.value};
    </#list>

    // Load the TMR value to reload variable
    timer${instanceNumber}ReloadVal=TMR${instanceNumber};

    <#if usesInterruptTMRI>
    // Clearing IF flag before enabling the interrupt.
    ${interruptFlagName} = 0;

    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;

    // Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>
    // Clearing IF flag.
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
    // Start the Timer by writing to TMRxON bit
    ${TCONbits_TMRON} = 1;
}

void ${moduleNameUpperCase}_StopTimer(void)
{
    // Stop the Timer by writing to TMRxON bit
    ${TCONbits_TMRON} = 0;
}

uint16_t ${moduleNameUpperCase}_ReadTimer(void)
{
    uint16_t readVal;
    uint8_t readValHigh;
    uint8_t readValLow;
	
    <#if tmr16BitModeExists>
    ${enable16bitmode} = 1;
    </#if>
	
    readValLow = ${TMRL};
    readValHigh = ${TMRH};
    
    readVal = ((uint16_t)readValHigh << 8) | readValLow;

    return readVal;
}

void ${moduleNameUpperCase}_WriteTimer(uint16_t timerVal)
{
    if (${TCONbits_nTSYNC} == 1)
    {
        <#-- write for TMR1 as asynchronous counter , stop Timer -->
        // Stop the Timer by writing to TMRxON bit
        ${TCONbits_TMRON} = 0;

        // Write to the Timer${instanceNumber} register
        ${TMRH} = (uint8_t)(timerVal >> 8);
        ${TMRL} = (uint8_t)timerVal;

        // Start the Timer after writing to the register
        ${TCONbits_TMRON} =1;
    }
    else
    {
        // Write to the Timer${instanceNumber} register
        ${TMRH} = (uint8_t)(timerVal >> 8);
        ${TMRL} = (uint8_t)timerVal;
    }
}

void ${moduleNameUpperCase}_Reload(void)
{
    ${moduleNameUpperCase}_WriteTimer(timer${instanceNumber}ReloadVal);
}

<#if usesInterruptTMRI>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    <#if tickerFactor != "0" && tickerFactor != "1">
    static volatile uint16_t CountCallBack = 0;
    </#if>

    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;    
    ${moduleNameUpperCase}_WriteTimer(timer${instanceNumber}ReloadVal);

    <#if tickerFactor == "1">
    // ticker function call;
    // ticker is 1 -> Callback function gets called every time this ISR executes
    ${moduleNameUpperCase}_CallBack();
    <#elseif tickerFactor != "0">
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
}

<#if tickerFactor != "0">
void ${moduleNameUpperCase}_CallBack(void)
{
    // Add your custom callback code here
    <#-- this code executes every $(tickerFactor) ${moduleNameUpperCase} periods -->

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
