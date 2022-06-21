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
        Driver Version    :  2.02
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
#include "device_config.h"


/**
  Section: ADC Module APIs
*/

void (*${moduleNameUpperCase}_InterruptHandler)(void);

<#list initializers as initializer>
void ${initializer}(void)
{
    // set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initRegisters as reg>
    
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    
<#if useInterrupt>
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;
	
	// Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
</#if>
}
</#list>

void ${moduleNameUpperCase}_SelectChannel(adc_channel_t channel)
{
    // select the A/D channel
    ${ChannelSelect} = channel;    
    // Turn on the ADC module
    ${enableADC} = 1;  
}

void ${moduleNameUpperCase}_StartConversion(void)
{
    // Start the conversion
    ${startConversion} = 1;
}


bool ${moduleNameUpperCase}_IsConversionDone(void)
{
    // Start the conversion
    return ((bool)(!${startConversion}));
}

adc_result_t ${moduleNameUpperCase}_GetConversionResult(void)
{
    // Conversion finished, return the result
     return ((adc_result_t)((${resultHigh} << 8) + ${resultLow}));
}

adc_result_t ${moduleNameUpperCase}_GetConversion(adc_channel_t channel)
{
    // select the A/D channel
    ${ChannelSelect} = channel;    

    // Turn on the ADC module
    ${enableADC} = 1;

    // Start the conversion
    ${startConversion} = 1;

    // Wait for the conversion to finish
    while (${startConversion})
    {
    }

    // Conversion finished, return the result
    return ((adc_result_t)((${resultHigh} << 8) + ${resultLow}));
}

void ${moduleNameUpperCase}_TemperatureAcquisitionDelay(void)
{
    __delay_us(200);
}
<#if useInterrupt>

void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    // Clear the ADC interrupt flag
    ${interruptFlagName} = 0;
	
	if(${moduleNameUpperCase}_InterruptHandler)
    {
        ${moduleNameUpperCase}_InterruptHandler();
    }
}

void ${moduleNameUpperCase}_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_InterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_DefaultInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}_SetInterruptHandler()
}
</#if>
/**
 End of File
*/