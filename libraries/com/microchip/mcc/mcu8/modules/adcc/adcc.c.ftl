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
        Driver Version    :  2.1.5
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
<#if useInterrupt>
<#if isVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>
<#if PIC16device>
#include "mcc.h"
</#if>

/**
  Section: ADCC Module Variables
*/
<#if usesInterruptADI>
void (*${moduleNameUpperCase}_ADI_InterruptHandler)(void);
</#if>
<#if usesInterruptADTI>
void (*${moduleNameUpperCase}_ADTI_InterruptHandler)(void);
</#if>

/**
  Section: ADCC Module APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    
<#if usesInterruptADI>
    // Clear the ADC interrupt flag
    ${interruptFlagName} = 0;
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;

    ${moduleNameUpperCase}_SetADIInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
</#if>

<#if usesInterruptADTI>
    // Clear the ADC Threshold interrupt flag
    ${thresholdInterruptFlagName} = 0;
    // Enabling ${moduleNameUpperCase} threshold interrupt.
    ${thresholdInterruptEnableBitName} = 1;

    ${moduleNameUpperCase}_SetADTIInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
</#if>
}
</#list>

void ${moduleNameUpperCase}_StartConversion(adcc_channel_t channel)
{
    // select the A/D channel
    ${positiveChannelSelect} = channel;      
  
    // Turn on the ADC module
    ${enableADC} = 1;

    // Start the conversion
    ${startConversion} = 1;
}

bool ${moduleNameUpperCase}_IsConversionDone(void)
{
    // Start the conversion
    return ((unsigned char)(!${startConversion}));
}

adc_result_t ${moduleNameUpperCase}_GetConversionResult(void)
{
    // Return the result
    return ((adc_result_t)((${resultHigh} << 8) + ${resultLow}));
}

adc_result_t ${moduleNameUpperCase}_GetSingleConversion(adcc_channel_t channel)
{
    // select the A/D channel
    ${positiveChannelSelect} = channel;  

    // Turn on the ADC module
    ${enableADC} = 1;
	
    //Disable the continuous mode.
    ${continuousModeEnable} = 0;    

    // Start the conversion
    ${startConversion} = 1;

    <#-- MCCV3XX-4358: MCC fix for PIC16F18855 silicon bug | Remove this when new silicon available -->
    <#if selectedDevice == "PIC16F18875" || selectedDevice == "PIC16LF18875" || selectedDevice == "PIC16F18855" || selectedDevice == "PIC16LF18855">
    // Extra NOP() instruction required; See rev. A2 errata:  http://ww1.microchip.com/downloads/en/DeviceDoc/80000669C.pdf 
    NOP();    
    </#if>

    // Wait for the conversion to finish
    while (${startConversion})
    {
    }
    
    
    // Conversion finished, return the result
    return ((adc_result_t)((${resultHigh} << 8) + ${resultLow}));
}

void ${moduleNameUpperCase}_StopConversion(void)
{
    //Reset the ADGO bit.
    ${startConversion} = 0;
}

void ${moduleNameUpperCase}_SetStopOnInterrupt(void)
{
    //Set the ADSOI bit.
    ${StopOnInterruptEnable} = 1;
}

void ${moduleNameUpperCase}_DischargeSampleCapacitor(void)
{
    //Set the ADC channel to AVss.
    ${positiveChannelSelect} = ${vssOptionADPCHReg};   
}

<#if !acquisitionHighAndLowRegistersExists>
void ${moduleNameUpperCase}_LoadAcquisitionRegister(uint8_t acquisitionValue)
{
    //Load the ${acquisitionTime} register.
    ${acquisitionTime} = acquisitionValue;   
}
<#else>
void ${moduleNameUpperCase}_LoadAcquisitionRegister(uint16_t acquisitionValue)
{
    //Load the ${acquisitionTimeHigh} and ${acquisitionTimeLow} registers.
    ${acquisitionTimeHigh} = (uint8_t) (acquisitionValue >> 8); 
    ${acquisitionTimeLow} = (uint8_t) acquisitionValue;  
}
</#if>

<#if !prechargeHighAndLowRegistersExists>
void ${moduleNameUpperCase}_SetPrechargeTime(uint8_t prechargeTime)
{
    //Load the ${prechargeTime} register.
    ${prechargeTime} = prechargeTime;  
}
<#else>
void ${moduleNameUpperCase}_SetPrechargeTime(uint16_t prechargeTime)
{
    //Load the ${prechargeTimeHigh} and ${prechargeTimeLow} registers.
    ${prechargeTimeHigh} = (uint8_t) (prechargeTime >> 8);  
    ${prechargeTimeLow} = (uint8_t) prechargeTime;
}
</#if>

void ${moduleNameUpperCase}_SetRepeatCount(uint8_t repeatCount)
{
    //Load the ${repeatCountValue} register.
    ${repeatCountValue} = repeatCount;   
}

uint8_t ${moduleNameUpperCase}_GetCurrentCountofConversions(void)
{
    //Return the contents of ${currentCoversionCount} register
    return ${currentCoversionCount};
}

void ${moduleNameUpperCase}_ClearAccumulator(void)
{
    //Reset the ${clearAccumulator} bit.
    ${clearAccumulator} = 1;
}

<#if !bit24AccumulatorExists>
uint16_t ${moduleNameUpperCase}_GetAccumulatorValue(void)
{
    //Return the contents of ${accumulaterHigh} and ${accumulaterLow} registers
    return ((uint16_t)((${accumulaterHigh} << 8) + ${accumulaterLow}));
}
<#else>
uint24_t ${moduleNameUpperCase}_GetAccumulatorValue(void)
{
    //Return the contents of ${accumulaterUpper}, ${accumulaterHigh} and ${accumulaterLow} registers
    return (((uint24_t)${accumulaterUpper} << 16)+((uint24_t)${accumulaterHigh} << 8) + ${accumulaterLow});
}
</#if>

bool ${moduleNameUpperCase}_HasAccumulatorOverflowed(void)
{
    //Return the status of ${accumulatorOverflow}
    return ${accumulatorOverflow};
}

uint16_t ${moduleNameUpperCase}_GetFilterValue(void)
{
    //Return the contents of ${filterValueHigh} and ${filterValueLow} registers
    return ((uint16_t)((${filterValueHigh} << 8) + ${filterValueLow}));
}

uint16_t ${moduleNameUpperCase}_GetPreviousResult(void)
{
    //Return the contents of ${previousResultHigh} and ${previousResultLow} registers
    return ((uint16_t)((${previousResultHigh} << 8) + ${previousResultLow}));
}

void ${moduleNameUpperCase}_DefineSetPoint(uint16_t setPoint)
{
    //Sets the ${setPointHigh} and ${setPointLow} registers
    ${setPointHigh} = (uint8_t) (setPoint >> 8);
    ${setPointLow} = (uint8_t) setPoint;
}

void ${moduleNameUpperCase}_SetUpperThreshold(uint16_t upperThreshold)
{
    //Sets the ${upperThresholdHigh} and ${upperThresholdLow} registers
    ${upperThresholdHigh} = (uint8_t) (upperThreshold >> 8);
    ${upperThresholdLow} = (uint8_t) (upperThreshold);
}

void ${moduleNameUpperCase}_SetLowerThreshold(uint16_t lowerThreshold)
{
    //Sets the ${lowerThresholdHigh} and ${lowerThresholdLow} registers
    ${lowerThresholdHigh} = (uint8_t) (lowerThreshold >> 8);
    ${lowerThresholdLow} = (uint8_t) lowerThreshold;
}

uint16_t ${moduleNameUpperCase}_GetErrorCalculation(void)
{
<#-- MCCV3XX-2231: This special code supports the errors v1.35 compiler header files. -->
<#-- Specifically, the registers "ADERRH" and "ADERRL" are named "ADSTPEH" and "ADSTPEL" for 4 devices in the 16(L)F188xx family -->
<#if selectedDevice == "PIC16F18875" || selectedDevice == "PIC16LF18875" || selectedDevice == "PIC16F18855" || selectedDevice == "PIC16LF18855">
#if (__XC8_VERSION < 1360)
	//Return the contents of ${aderrh_v1350} and ${aderrl_v1350} registers
	return ((${aderrh_v1350} << 8) + ${aderrl_v1350});
#else // __XC8_VERSION
	//Return the contents of ${errorHigh} and ${errorLow} registers
	return ((uint16_t)((${errorHigh} << 8) + ${errorLow}));
#endif // __XC8_VERSION
<#else>
	//Return the contents of ${errorHigh} and ${errorLow} registers
	return ((uint16_t)((${errorHigh} << 8) + ${errorLow}));
</#if>
}

void ${moduleNameUpperCase}_EnableDoubleSampling(void)
{
    //Sets the ${doubleSamplingEnable}
    ${doubleSamplingEnable} = 1;
}

void ${moduleNameUpperCase}_EnableContinuousConversion(void)
{
    //Sets the ${continuousModeEnable}
    ${continuousModeEnable} = 1;
}

void ${moduleNameUpperCase}_DisableContinuousConversion(void)
{
    //Resets the ${continuousModeEnable}
    ${continuousModeEnable} = 0;
}

bool ${moduleNameUpperCase}_HasErrorCrossedUpperThreshold(void)
{
    //Returns the value of ${upperThresholdStatus} bit.
    return ${upperThresholdStatus};
}

bool ${moduleNameUpperCase}_HasErrorCrossedLowerThreshold(void)
{
    //Returns the value of ${lowerThresholdStatus} bit.
    return ${lowerThresholdStatus};
}

uint8_t ${moduleNameUpperCase}_GetConversionStageStatus(void)
{
    //Returns the contents of ${conversionStageStatus} field.
    return ${conversionStageStatus};
}

<#if usesInterruptADI>
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
    // Clear the ADCC interrupt flag
    ${interruptFlagName} = 0;

    if (${moduleNameUpperCase}_ADI_InterruptHandler)
            ${moduleNameUpperCase}_ADI_InterruptHandler();
}

void ${moduleNameUpperCase}_SetADIInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_ADI_InterruptHandler = InterruptHandler;
}
</#if>

<#if usesInterruptADTI>
<#if isVectoredInterruptEnabled>
<#if isHighPriority>
void __interrupt(irq(${thresholdInterruptIRQName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${thresholdInterruptFunctionName}()
<#else>
void __interrupt(irq(${thresholdInterruptIRQName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${thresholdInterruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${thresholdInterruptFunctionName}(void)
</#if>
{
    // Clear the ADCC Threshold interrupt flag
    ${thresholdInterruptFlagName} = 0;

    if (${moduleNameUpperCase}_ADTI_InterruptHandler)
        ${moduleNameUpperCase}_ADTI_InterruptHandler();
}

void ${moduleNameUpperCase}_SetADTIInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_ADTI_InterruptHandler = InterruptHandler;
}
</#if>
<#if useInterrupt>
void ${moduleNameUpperCase}_DefaultInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}_SetADIInterruptHandler() or ${moduleNameUpperCase}_SetADTIInterruptHandler()
}
</#if>
/**
 End of File
*/
