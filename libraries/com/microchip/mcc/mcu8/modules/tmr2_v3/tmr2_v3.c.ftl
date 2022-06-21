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

    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    <#if useInterrupt>
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
    ${startTimer} = 1;
}

void ${moduleNameUpperCase}_StopTimer(void)
{
    // Stop the Timer by writing to TMRxON bit
    ${startTimer} = 0;
}

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

void ${moduleNameUpperCase}_LoadPeriodRegister(uint8_t periodVal)
{
   PR${instanceNumber} = periodVal;
}

<#if useInterrupt>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    <#if (tickerFactor != "0") && (tickerFactor != "1")>
    static volatile unsigned int CountCallBack = 0;
    </#if>

    // clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;

    <#if (tickerFactor == "1")>
    // ticker function call;
    // ticker is 1 -> Callback function gets called everytime this ISR executes
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
}

<#if (tickerFactor != "0")>
void ${moduleNameUpperCase}_CallBack(void)
{
    // Add your custom callback code here
    // this code executes every ${moduleNameUpperCase}_INTERRUPT_TICKER_FACTOR periods of ${moduleNameUpperCase}
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
    bool status = ${interruptFlagName};
    if(status)
    {
        // Clearing IF flag.
        ${interruptFlagName} = 0;
    }
    return status;
}
</#if>
/**
  End of File
*/