/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using PIC10 / PIC12 / PIC16 / PIC18 MCUs 

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  PIC10 / PIC12 / PIC16 / PIC18 MCUs - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.1.5
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: Data Types Definitions
*/

/**
 *  result size of an A/D conversion
 */

typedef uint16_t adc_result_t;
<#if bit24AccumulatorExists>
#ifndef uint24_t
typedef __uint24 uint24_t;
#endif
</#if>

/** ${moduleNameUpperCase} Channel Definition

 @Summary
   Defines the channels available for conversion.

 @Description
   This routine defines the channels that are available for the module to use.

 Remarks:
   None
 */

typedef enum
{
    <#list channels as channel>
    <#if (channel.name != "channel_no channel selected") && (channel.name != "channel_reserved") >
    ${channel.name} =  ${channel.value}<#if channel_has_next>,</#if>
    </#if>    
    </#list>
} adcc_channel_t;

/**
  Section: ${moduleNameUpperCase} Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}.

  @Description
    This routine initializes the ${moduleNameUpperCase} and must be called before any other ${moduleNameUpperCase} routine.
    This routine should only be called once during system initialization.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment
    

  @Example
    <code>
    adc_result_t convertedValue;    

    ${initializer}();
    convertedValue = ${moduleNameUpperCase}_GetSingleConversion(channel_ANA0);
    </code>
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Starts A/D conversion on selected analog channel.

  @Description
    This routine is used to trigger A/D conversion on selected analog channel.
    
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    channel: Analog channel number on which A/D conversion has to be applied.
             For available analog channels refer adcc_channel_t enum from adcc.h file

  @Example
    <code>
    adc_result_t convertedValue; 

    ${moduleNameUpperCase}_Initialize();   
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    while(!${moduleNameUpperCase}_IsConversionDone());
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
*/
void ${moduleNameUpperCase}_StartConversion(adcc_channel_t channel);

/**
  @Summary
    Determine if A/D conversion is completed.

  @Description
    This routine is used to determine if A/D conversion is completed.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion(adcc_channel_t channel)
    functions should have been called before calling this function.

  @Returns
    true  - If conversion is completed
    false - If conversion is not completed

  @Param
    None

  @Example
    <code>
    adc_result_t convertedValue;    

    ${moduleNameUpperCase}_Initialize();    
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    while(!${moduleNameUpperCase}_IsConversionDone());
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
 */
bool ${moduleNameUpperCase}_IsConversionDone(void);

/**
  @Summary
    Returns result of latest A/D conversion.

  @Description
    This routine is used to retrieve the result of latest A/D conversion.
    This routine returns the conversion value only after the conversion is complete.
    

  @Preconditions
    ${moduleNameUpperCase}_Initialize(), ${moduleNameUpperCase}_StartConversion() functions should have been called
    before calling this function.
    Completion status should be checked using ${moduleNameUpperCase}_IsConversionDone() routine.

  @Returns
    Returns the result of A/D conversion.

  @Param
    None

  @Example
    <code>
    adc_result_t convertedValue;

    ${moduleNameUpperCase}_Initialize();    
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    while(!${moduleNameUpperCase}_IsConversionDone());
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
 */
adc_result_t ${moduleNameUpperCase}_GetConversionResult(void);

/**
  @Summary
    Returns the result of A/D conversion for requested analog channel.

  @Description
    This routine is used to retrieve the result of A/D conversion for requested 
    analog channel.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_DisableContinuousConversion() functions should have 
    been called before calling this function.

  @Returns
    Returns the result of A/D conversion.

  @Param
    channel: Analog channel number for which A/D conversion has to be applied
             For available analog channels refer adcc_channel_t enum from adcc.h file

  @Example
    <code>
    adcc_channel_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DisableContinuousConversion();
    
    convertedValue = ${moduleNameUpperCase}_GetSingleConversion(channel_ANA0);
    </code>
*/
adc_result_t ${moduleNameUpperCase}_GetSingleConversion(adcc_channel_t channel);

/**
  @Summary
    Stops the ongoing continuous A/D conversion.

  @Description
    This routine is used to stop ongoing continuous A/D conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion() functions should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    ${moduleNameUpperCase}_StopConversion();
    </code>
*/
void ${moduleNameUpperCase}_StopConversion(void);

/**
  @Summary
    Stops the ${moduleNameUpperCase} from re-triggering A/D conversion cycle 
    upon completion of each conversion.

  @Description
    In continuous mode, stops the ${moduleNameUpperCase} from re-triggering A/D conversion cycle 
    upon completion of each conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_EnableContinuousConversion() function should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_EnableContinuousConversion();
    ${moduleNameUpperCase}_SetStopOnInterrupt();
    </code>
*/
void ${moduleNameUpperCase}_SetStopOnInterrupt(void);

/**
  @Summary
    Discharges the input sample capacitor by setting the channel to AVss.

  @Description
    This routine is used to discharge input sample capacitor by selecting analog
    ground (AVss) channel.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DischargeSampleCapacitor();
    </code>
*/
void ${moduleNameUpperCase}_DischargeSampleCapacitor(void); 

/**
  @Summary
    Loads the Acquisition Time Control register.

  @Description
    This routine is used to load 13-bit ${moduleNameUpperCase} Acquisition Time Control register by
    a value provided by user.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    13-bit value to be set in the acquisition register.

  @Example
    <code>
    uint16_t acquisitionValue = 98;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_LoadAcquisitionRegister(acquisitionValue);
    </code>
*/
<#if ! acquisitionHighAndLowRegistersExists>
void ${moduleNameUpperCase}_LoadAcquisitionRegister(uint8_t);
<#else>
void ${moduleNameUpperCase}_LoadAcquisitionRegister(uint16_t);
</#if>

/**
  @Summary
    Loads the Precharge Time Control register.

  @Description
    This routine is used to load 13-bit ${moduleNameUpperCase} Precharge Time Control register by
    a value provided by user.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    13-bit value to be set in the precharge register.

  @Example
    <code>
    uint16_t prechargeTime = 98;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_SetPrechargeTime(prechargeTime);
    </code>
*/
<#if !prechargeHighAndLowRegistersExists>
void ${moduleNameUpperCase}_SetPrechargeTime(uint8_t);
<#else>
void ${moduleNameUpperCase}_SetPrechargeTime(uint16_t);
</#if>

/**
  @Summary
    Loads the Repeat Setting register.

  @Description
    This routine loads ${moduleNameUpperCase} Repeat Setting register with 8-bit value provided by user.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    8-bit value to be set in the Repeat Setting register.

  @Example
    <code>
    uint8_t repeat = 98;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_SetRepeatCount(repeat);
    </code>
*/
void ${moduleNameUpperCase}_SetRepeatCount(uint8_t);

/**
  @Summary
    Returns the current value of Repeat Count register.

  @Description
    This routine retrieves the current value of ${moduleNameUpperCase} Repeat Count register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize(), ${moduleNameUpperCase}_StartConversion() should have been called before calling
    this function.

  @Returns
    Value of ${moduleNameUpperCase} Repeat Count register

  @Param
    None.

  @Example
    <code>
    adc_result_t convertedValue;
    uint8_t count;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    count = ${moduleNameUpperCase}_GetCurrentCountofConversions();
    </code>
*/
uint8_t ${moduleNameUpperCase}_GetCurrentCountofConversions(void);

/**
  @Summary
    Clears the A/D Accumulator.

  @Description
    This routine is used to clear A/D Accumulator

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    None.

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_ClearAccumulator();
    </code>
*/
void ${moduleNameUpperCase}_ClearAccumulator(void);

/**
  @Summary
   Returns the value of ${moduleNameUpperCase} Accumulator.

  @Description
    This routine is is to retrieve the 17-bit value of ${moduleNameUpperCase} accumulator.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    17-bit value obtained from ${moduleNameUpperCase} Accumulator register.

  @Param
    None.

  @Example
    <code>
    <#if !bit24AccumulatorExists>
    uint16_t accumulatorValue;
    <#else>
    uint24_t accumulatorValue;
    </#if>
    ${moduleNameUpperCase}_Initialize();
    accumulatorValue = ${moduleNameUpperCase}_GetAccumulatorValue();
    </code>
*/
<#if !bit24AccumulatorExists>
uint16_t ${moduleNameUpperCase}_GetAccumulatorValue(void);
<#else>
uint24_t ${moduleNameUpperCase}_GetAccumulatorValue(void);
</#if>

/**
  @Summary
   Determines if ${moduleNameUpperCase} accumulator has overflowed.

  @Description
    This routine is used to determine whether ${moduleNameUpperCase} accumulator has overflowed.

  @Preconditions  
    ${moduleNameUpperCase}_Initialize(), ${moduleNameUpperCase}_StartConversion() should have been called before calling
    this function.

  @Returns
    1: ${moduleNameUpperCase} accumulator or ERR calculation have overflowed
    0: ${moduleNameUpperCase} accumulator and ERR calculation have not overflowed

  @Param
    None.

  @Example
    <code>
    bool accumulatorOverflow;    
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion();
    accumulatorOverflow = ${moduleNameUpperCase}_HasAccumulatorOverflowed();
    </code>
*/
bool ${moduleNameUpperCase}_HasAccumulatorOverflowed(void);

/**
  @Summary
   Returns the value of ${moduleNameUpperCase} Filter register.

  @Description
    This routine is used to retrieve value of ${moduleNameUpperCase} Filter register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    16-bit value obtained from ADFLTRH and ADFLTRL registers.

  @Param
    None.

  @Example
    <code>
    uint16_t filterValue;
    ${moduleNameUpperCase}_Initialize();
    filterValue = ${moduleNameUpperCase}_GetFilterValue();
    </code>
*/
uint16_t ${moduleNameUpperCase}_GetFilterValue(void);

/**
  @Summary
   Returns the value of ${moduleNameUpperCase} Previous Result register.

  @Description
    This routine is used to retrieve value of ${moduleNameUpperCase} Previous register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion() should have been called before
    calling this function.

  @Returns
    16-bit value obtained from ADPREVH and ADPREVL registers.

  @Param
    None.

  @Example
    <code>
    uint16_t prevResult, convertedValue;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    prevResult = ${moduleNameUpperCase}_GetPreviousResult();
    </code>
*/
uint16_t ${moduleNameUpperCase}_GetPreviousResult(void);

/**
  @Summary
   Sets the ${moduleNameUpperCase} Threshold Set-point.

  @Description
    This routine is used to set value of ${moduleNameUpperCase} Threshold Set-point.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    16-bit value for set point.

  @Example
    <code>
    uint16_t setPoint = 90;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DefineSetPoint(setPoint);
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    </code>
*/
void ${moduleNameUpperCase}_DefineSetPoint(uint16_t);

/**
  @Summary
   Sets the value of ${moduleNameUpperCase} Upper Threshold.

  @Description
    This routine is used to set value of ${moduleNameUpperCase} Upper Threshold register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    16-bit value for upper threshold.

  @Example
    <code>
        uint16_t upperThreshold = 90;
        ${moduleNameUpperCase}_Initialize();
        ${moduleNameUpperCase}_SetUpperThreshold(upperThreshold);
        ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    </code>
*/
void ${moduleNameUpperCase}_SetUpperThreshold(uint16_t);

/**
  @Summary
   Sets the value of ${moduleNameUpperCase} Lower Threshold.

  @Description
    This routine is used to set value of ${moduleNameUpperCase} Lower Threshold register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    16- bit value for lower threshold.

  @Example
    <code>
    uint16_t lowerThreshold = 90;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_SetLowerThreshold(lowerThreshold);
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);    
    </code>
*/
void ${moduleNameUpperCase}_SetLowerThreshold(uint16_t);

/**
  @Summary
   Returns the value of ${moduleNameUpperCase} Set-point Error.

  @Description
    This routine retrieves the value of ${moduleNameUpperCase} Set-point Error register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize(), ${moduleNameUpperCase}_StartConversion() should have been called before calling
    this function.

  @Returns
    16-bit value obtained from ADERRH and ADERRL registers.

  @Param
    None.

  @Example
    <code>
    uint16_t error;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    error = ${moduleNameUpperCase}_GetErrorCalculation(void);
    </code>
*/
uint16_t ${moduleNameUpperCase}_GetErrorCalculation(void);

/**
  @Summary
   Enables Double-Sampling.

  @Description
    This routine is used to enable double-sampling bit.
    Two conversions are performed on each trigger. Data from the first conversion 
    appears in PREV.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    None.

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_EnableDoubleSampling();    
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    </code>
*/
void ${moduleNameUpperCase}_EnableDoubleSampling(void);

/**
  @Summary
   Enables continuous A/D conversion.

  @Description
    This routine is used to enable continuous A/D conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    None.

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_EnableContinuousConversion();
    </code>
*/
void ${moduleNameUpperCase}_EnableContinuousConversion(void);

/**
  @Summary
   Disables continuous A/D conversion.

  @Description
    This routine is used to disable continuous A/D conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() should have been called before calling this function.

  @Returns
    None

  @Param
    None.

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DisableContinuousConversion();
    </code>
*/
void ${moduleNameUpperCase}_DisableContinuousConversion(void);

/**
  @Summary
   Determines if ${moduleNameUpperCase} ERR crosses upper threshold.

  @Description
    This routine is used to determine if ${moduleNameUpperCase} ERR has crossed the upper threshold.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion() should have been called 
    before calling this function.

  @Returns
    1: if ERR > UTH
    0: if ERR <= UTH

  @Param
    None.

  @Example
    <code>
    bool uThr;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    uThr = ${moduleNameUpperCase}_HasErrorCrossedUpperThreshold();
    </code>
*/
bool ${moduleNameUpperCase}_HasErrorCrossedUpperThreshold(void);

/**
  @Summary
   Determines if ${moduleNameUpperCase} ERR is less than lower threshold.

  @Description
    This routine is used to determine if ${moduleNameUpperCase} ERR is less than the lower threshold.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion() should have been called 
    before calling this function.

  @Returns
    1: if ERR < LTH
    0: if ERR >= LTH

  @Param
    None.

  @Example
    <code>
    bool lThr;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    lThr = ${moduleNameUpperCase}_HasErrorCrossedLowerThreshold();
    </code>
*/
bool ${moduleNameUpperCase}_HasErrorCrossedLowerThreshold(void);

/**
  @Summary
   Returns Status of ${moduleNameUpperCase}

  @Description
    This routine is used to retrieve contents of ${moduleNameUpperCase} status register.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion() should have been called 
    before calling this function.

  @Returns
    Returns the contents of ${moduleNameUpperCase} STATUS register

  @Param
    None.

  @Example
    <code>
    uint8_t adccStatus;
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion(channel_ANA0);
    adccStatus = ${moduleNameUpperCase}_GetConversionStageStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}_GetConversionStageStatus(void);


<#if usesInterruptADI>

/**
  @Summary
    Implements ISR

  @Description
    This routine is used to set the callback for the ADI Interrupt.

  @Returns
    None

  @Param
    Callback Function to be called
*/
void ${moduleNameUpperCase}_SetADIInterruptHandler(void (* InterruptHandler)(void));

<#if isVectoredInterruptEnabled>
<#else>
/**
  @Summary
    Implements ISR

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${interruptFunctionName}(void);
</#if>
</#if>

<#if usesInterruptADTI>
/**
  @Summary
    Implements ISR

  @Description
    This routine is used to set the callback for the ADTI Interrupt.

  @Returns
    None

  @Param
    Callback Function to be called
*/
void ${moduleNameUpperCase}_SetADTIInterruptHandler(void (* InterruptHandler)(void));

<#if isVectoredInterruptEnabled>
<#else>
/**
  @Summary
    Implements ISR

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${thresholdInterruptFunctionName}(void);
</#if>
</#if>

<#if useInterrupt>
/**
  @Summary
    Default ${moduleNameUpperCase} Interrupt Handler

  @Description
    This is the default Interrupt Handler function

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_DefaultInterruptHandler(void);
</#if>
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif    //${moduleNameUpperCase}_H
/**
 End of File
*/

