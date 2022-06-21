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
<#if selectedDevice?contains("PIC16")>
#include "device_config.h"
</#if>

void (*${moduleNameUpperCase}1_InterruptHandler)(void);
void (*${moduleNameUpperCase}2_InterruptHandler)(void);

/**
  Section: ADC Module APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
   <#list initRegisters as reg>
    
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
  
<#if usesInterruptAD1I>
    // Enabling ${moduleNameUpperCase}1 interrupt.
    ${interrupt1EnableBitName} = 1;
	
	// Set Default Interrupt Handler
    ${moduleNameUpperCase}1_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
</#if>

<#if usesInterruptAD2I>
    // Enabling ${moduleNameUpperCase}2 interrupt.
    ${interrupt2EnableBitName} = 1;
	
	// Set Default Interrupt Handler
    ${moduleNameUpperCase}2_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
</#if>
    


}
</#list>

void ${moduleNameUpperCase}1_StartConversion(adc1_channel_t channel)
{
    // select the A/D channel
   ${adc1ChannelSelect} = channel;

    // Turn on the ${moduleNameUpperCase}1 module
    ${enableADC1}= 1;

    // Start the conversion
    ${adc1startConversion} = 1;
}

void ${moduleNameUpperCase}2_StartConversion(adc2_channel_t channel)
{
    // select the A/D channel
   ${adc2ChannelSelect} = channel;

    // Turn on the ${moduleNameUpperCase}2 module
    ${enableADC2}= 1;

    // Start the conversion
    ${adc2startConversion} = 1;
}

void ${moduleNameUpperCase}_StartSyncConversion(adc1_channel_t channelADC1, adc2_channel_t channelADC2)
{
    // select the A/D channel on ADC1
    ${adc1ChannelSelect} = channelADC1;
    // select the A/D channel on ADC2
    ${adc2ChannelSelect} = channelADC2;

    // Turn on the ADC1 module
    ${enableADC1} = 1;
    // Turn on the ADC2 module
    ${enableADC2} = 1;

    // Start the synchronized conversion
    ${synchronizedConversion} = 1;
}

bool ${moduleNameUpperCase}1_IsConversionDone(void)
{
    // Check conversion status
    return ((unsigned char)(!${adc1startConversion}));
}

bool ${moduleNameUpperCase}2_IsConversionDone(void)
{
    // Check conversion status
    return ((unsigned char)(!${adc2startConversion}));
}


bool ${moduleNameUpperCase}_IsSyncConversionDone(void)
{
    // Check conversion status
    return ((unsigned char)(!${synchronizedConversion}));
}

adc_result_t ${moduleNameUpperCase}1_GetConversionResult(void)
{
    // Conversion finished, return the result
    return ((adc_result_t)((${adc1result0High} << 8) + ${adc1result0Low}));
}
adc_result_t ${moduleNameUpperCase}2_GetConversionResult(void)
{
    // Conversion finished, return the result
    return ((adc_result_t)((${adc2result0High} << 8) + ${adc2result0Low}));
}

adc_sync_result_t ${moduleNameUpperCase}_GetSyncConversionResult(void)
{
    adc_sync_result_t adcSyncResult;
  
    // Conversion finished, read the result
    adcSyncResult.adc1Result = (${adc1result0High} << 8) + ${adc1result0Low};
    adcSyncResult.adc2Result = (${adc2result0High} << 8) + ${adc2result0Low};

    // return the result
    return adcSyncResult;
}

adc_result_t ${moduleNameUpperCase}1_GetConversion(adc1_channel_t channel)
{
    // Select the A/D channel
     ${adc1ChannelSelect} = channel;

    // Turn on the ADC1 module
    ${enableADC1} = 1;

    // Start the conversion
    ${adc1startConversion} = 1;

    // Wait for the conversion to finish
    while (${adc1startConversion})
    {
    }
    
    // Conversion finished, return the result
    return ((adc_result_t)((${adc1result0High} << 8) + ${adc1result0Low}));
}

adc_result_t ${moduleNameUpperCase}2_GetConversion(adc2_channel_t channel)
{
    // Select the A/D channel
    ${adc2ChannelSelect} = channel;

    // Turn on the ADC2 module
    ${enableADC2} = 1;

    // Start the conversion
    ${adc2startConversion} = 1;

    // Wait for the conversion to finish
    while (${adc2startConversion})
    {
    }
    
    // Conversion finished, return the result
    return ((adc_result_t)((${adc2result0High} << 8) + ${adc2result0Low}));
}


adc_sync_result_t ${moduleNameUpperCase}_GetSyncConversion(adc1_channel_t adc1Channel, adc2_channel_t adc2Channel)
{
    adc_sync_result_t adcSyncResult;

    // Select the ADC1 channel
    ${adc1ChannelSelect} = adc1Channel;

    // Select the ADC2 channel
    ${adc2ChannelSelect} = adc2Channel;

    // Turn on the ADC1 module
    ${enableADC1}= 1;

    // Turn on the ADC2 module
    ${enableADC2} = 1;

    // Start the synchronized conversion
    ${synchronizedConversion} = 1;

    // Wait for the conversion to finish
    while (${synchronizedConversion})
    {
    }
    
    // Conversion finished, read the result
    adcSyncResult.adc1Result = (${adc1result0High} << 8) + ${adc1result0Low};
    adcSyncResult.adc2Result = (${adc2result0High} << 8) + ${adc2result0Low};

    // return the result
    return adcSyncResult;
}
void ${moduleNameUpperCase}_TemperatureAcquisitionDelay(void)
{
    __delay_us(200);
}

void ${moduleNameUpperCase}1_EnableDoubleSampling(void)
{
    //Sets the ${adc1DoubleSamplingEnable}
    ${adc1DoubleSamplingEnable} = 1;
}

void ${moduleNameUpperCase}2_EnableDoubleSampling(void)
{
    //Sets the ${adc2DoubleSamplingEnable}
    ${adc2DoubleSamplingEnable} = 1;
}

adc1_sync_double_result_t ${moduleNameUpperCase}1_GetDoubleConversionResult(void)
{
    adc1_sync_double_result_t adc1DoubleResult;

    // Conversion finished, read the result
    adc1DoubleResult.adc1Result1 = (${adc1result0High} << 8) + ${adc1result0Low};
    adc1DoubleResult.adc1Result2 = (${adc1result1High} << 8) + ${adc1result1Low};

    // return the result
    return adc1DoubleResult;
}

adc2_sync_double_result_t ${moduleNameUpperCase}2_GetDoubleConversionResult(void)
{
    adc2_sync_double_result_t adc2DoubleResult;

    // Conversion finished, read the result
    adc2DoubleResult.adc2Result1 = (${adc2result0High} << 8) + ${adc2result0Low};
    adc2DoubleResult.adc2Result2 = (${adc2result1High} << 8) + ${adc2result1Low};

    // return the result
    return adc2DoubleResult;
}

uint8_t ${moduleNameUpperCase}1_GetStageStatus(void)
{
	//Returns the contents of ${adc1StageStatus} field.
	return ${adc1StageStatus};
}

uint8_t ${moduleNameUpperCase}2_GetStageStatus(void)
{
	//Returns the contents of ${adc2StageStatus} field.
	return ${adc2StageStatus};
}

uint8_t ${moduleNameUpperCase}1_GetConversionStatus(void)
{
	//Returns the contents of ${adc1ConversionStatus} field.
	return ${adc1ConversionStatus};
}

uint8_t ${moduleNameUpperCase}2_GetConversionStatus(void)
{
	//Returns the contents of ${adc2ConversionStatus} field.
	return ${adc2ConversionStatus};
}

void ${moduleNameUpperCase}1_SetPrechargeTime(uint8_t prechargeTime)
{
	//Load the ${adc1PrechargeTime} register.
	${adc1PrechargeTime} = prechargeTime;  
}

void ${moduleNameUpperCase}2_SetPrechargeTime(uint8_t prechargeTime)
{
	//Load the ${adc2PrechargeTime} register.
	${adc2PrechargeTime} = prechargeTime;  
}

void ${moduleNameUpperCase}1_SetAcquisitionTime(uint8_t acquisitionValue)
{
	//Load the ${adc1AcquisitionTime} register.
	${adc1AcquisitionTime} = acquisitionValue;   
}

void ${moduleNameUpperCase}2_SetAcquisitionTime(uint8_t acquisitionValue)
{
	//Load the ${adc2AcquisitionTime} register.
	${adc2AcquisitionTime} = acquisitionValue;   
}

<#if usesInterruptAD1I>

void ${moduleNameUpperCase}_${interrupt1FunctionName}(void)
{
    // Clear the ADC interrupt flag
    ${adc1InterruptFlagName} = 0;
	
	if(${moduleNameUpperCase}1_InterruptHandler)
    {
        ${moduleNameUpperCase}1_InterruptHandler();
    }
}

void ${moduleNameUpperCase}1_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}1_InterruptHandler = InterruptHandler;
}
</#if>

<#if usesInterruptAD2I>

void ${moduleNameUpperCase}_${interrupt2FunctionName}(void)
{
    // Clear the ADC interrupt flag
    ${adc2InterruptFlagName} = 0;
	
	if(${moduleNameUpperCase}2_InterruptHandler)
    {
        ${moduleNameUpperCase}2_InterruptHandler();
    }
}

void ${moduleNameUpperCase}2_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}2_InterruptHandler = InterruptHandler;
}
</#if>

<#if usesInterruptAD2I || usesInterruptAD1I>
void ${moduleNameUpperCase}_DefaultInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}1_SetInterruptHandler() and ${moduleNameUpperCase}2_SetInterruptHandler()
}
</#if>
/**
 End of File
*/