/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
 * @brief This file contains API prototypes and other datatypes for ADC module.
 * @defgroup adc_context_scan  ADC3: Analog-to-Digital Converter with Context
 * @{
 */

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

/**
 @ingroup adc_context_scan
 @typedef adc_result_t
 @brief This typedef should be used for result of A/D conversion.
 */
typedef uint16_t adc_result_t;

/**
 @ingroup adc_context_scan
 @enum ${moduleNameUpperCase}_channel_t
 @brief This enumeration contains available ADC channels.
 */
typedef enum
{
<#list channels as channel>
<#if (channel.name != "channel_no channel selected") && (channel.name != "channel_reserved") >
    ${channel.name} =  ${channel.value}<#if channel_has_next>,</#if>
</#if>
</#list>
} ${moduleNameUpperCase}_channel_t;

/**
 @ingroup adc_context_scan
 @enum ${moduleNameUpperCase}_context_t
 @brief This enumeration contains available ADC contexts.
 */
typedef enum
{
    ${labelCtx1},
    <#if enableCtx2>
    ${labelCtx2},
    </#if>
    <#if enableCtx3>
    ${labelCtx3},
    </#if>
    <#if enableCtx4>
    ${labelCtx4},
    </#if>
} ${moduleNameUpperCase}_context_t;

/**
 * @ingroup adc_context_scan
 * @brief This API initializes the ADC module.
 *        This routine must be called before any other ADC routine.
 * @param void.
 * @return void.
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);   
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     convertedValue = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_Initialize(void);

/**
 * @ingroup adc_context_scan
 * @brief This API enables ADC channel sequencer.
 *        ADC module should be initialized using @ref ${moduleNameUpperCase}_Initialize before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue1, convertedValue2, convertedValue3, convertedValue4;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_EnableChannelSequencer();    //Enable auto-scanning if not already enabled	
 *     ${moduleNameUpperCase}_StartChannelSequencer();     // Software starts the sequencer	
 *
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);  
 *     convertedValue1 = ${moduleNameUpperCase}_GetConversionResult();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_2);  
 *     convertedValue2 = ${moduleNameUpperCase}_GetConversionResult();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_3);  
 *     convertedValue3 = ${moduleNameUpperCase}_GetConversionResult();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_4);  
 *     convertedValue4 = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_EnableChannelSequencer(void);

/**
 * @ingroup adc_context_scan
 * @brief This API disables ADC channel sequencer.
 *        ADC module should be initialized using @ref ${moduleNameUpperCase}_Initialize before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_DisableChannelSequencer();    //Disable scanner
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     convertedValue = ${moduleNameUpperCase}_GetSingleConversion(channel_ANA0);
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_DisableChannelSequencer(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API starts the channel sequencer by enabling GO bit.
 *        Channel sequencer should be enabled using @ref ${moduleNameUpperCase}_EnableChannelSequencer before calling
 *        this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue1, convertedValue2, convertedValue3, convertedValue4;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_EnableChannelSequencer();    //Enable auto-scanning if not already enabled	
 *     ${moduleNameUpperCase}_StartChannelSequencer();     // Software starts the sequencer	
 *
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);  
 *     convertedValue1 = ${moduleNameUpperCase}_GetConversionResult();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_2);  
 *     convertedValue2 = ${moduleNameUpperCase}_GetConversionResult();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_3);  
 *     convertedValue3 = ${moduleNameUpperCase}_GetConversionResult();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_4);  
 *     convertedValue4 = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_StartChannelSequencer(void);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to select an ADC context to perform read/write operations on 
 *        context specific registers.
 * @param[in] context - Context to be selected. Refer @ref ${moduleNameUpperCase}_context_t for available contexts
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);   
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     convertedValue = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_SelectContext(${moduleNameUpperCase}_context_t context);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to include a channel context in the scan sequence.
 *        Correct context should be selected using @ref ${moduleNameUpperCase}_SelectContext before calling this API.
 * @param[in] context - Context which needs to be included in scan. Refer @ref ${moduleNameUpperCase}_context_t for available contexts
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_EnableChannelScan(CONTEXT_1);
 *     ${moduleNameUpperCase}_EnableChannelScan(CONTEXT_2);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_EnableChannelScan(${moduleNameUpperCase}_context_t context);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to exclude a channel context from the scan sequence.
 *        Correct context should be selected using @ref ${moduleNameUpperCase}_SelectContext before calling this API.
 * @param[in] context - Context which needs to be excluded from scan. Refer @ref ${moduleNameUpperCase}_context_t for available contexts
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_EnableChannelScan(CONTEXT_1);
 *     ${moduleNameUpperCase}_DisableChannelScan(CONTEXT_2);
 *     ${moduleNameUpperCase}_DisableChannelScan(CONTEXT_3);
 *     ${moduleNameUpperCase}_EnableChannelScan(CONTEXT_4);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_DisableChannelScan(${moduleNameUpperCase}_context_t context);

/**
 * @ingroup adc_context_scan
 * @brief This API starts A/D conversion on selected channel.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] channel - Analog channel number on which A/D conversion has to be applied.
 *                      Refer @ref ${moduleNameUpperCase}_channel_t for available list of channels
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);   
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     convertedValue = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_StartConversion(${moduleNameUpperCase}_channel_t channel);

/**
 * @ingroup adc_context_scan
 * @brief This API checks if ongoing A/D conversion is complete.
 * @param void
 * @return bool - Status of A/D conversion.
 *         true - if conversion is complete.
 *         false - if conversion is ongoing.
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);   
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     convertedValue = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
bool ${moduleNameUpperCase}_IsConversionDone(void);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to retrieve the result of latest A/D conversion.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return The result of A/D conversion. Refer @ref adc_result_t
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);   
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     convertedValue = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
adc_result_t ${moduleNameUpperCase}_GetConversionResult(void);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to retrieve the result of single A/D conversion on given channel.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] channel - Analog channel number on which A/D conversion has to be applied.
 *                      Refer @ref ${moduleNameUpperCase}_channel_t  for available channels
 * @return The result of A/D conversion. Refer @ref adc_result_t
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_DisableChannelSequencer();    //Disable scanner
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     convertedValue = ${moduleNameUpperCase}_GetSingleConversion(channel_ANA0);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
adc_result_t ${moduleNameUpperCase}_GetSingleConversion(${moduleNameUpperCase}_channel_t channel);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to stop ongoing A/D conversion.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     ${moduleNameUpperCase}_StopConversion();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_StopConversion(void);

/**
 * @ingroup adc_context_scan
 * @brief This API is used enable Stop On Interrupt bit for selected A/D context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_EnableContinuousConversion();
 *     ${moduleNameUpperCase}_SetStopOnInterrupt();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_SetStopOnInterrupt(void);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to discharge input sample capacitor for selected context by
 *        setting the channel to AVss.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     adc_result_t convertedValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_DischargeSampleCapacitor();
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     while(!${moduleNameUpperCase}_IsConversionDone());
 *     convertedValue = ${moduleNameUpperCase}_GetConversionResult();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_DischargeSampleCapacitor(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to load ADC Acquisition Time Control register with specified value.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] acquisitionValue - Value to be loaded in the acquisition time control register.
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     uint16_t acquisitionValue = 98;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_LoadAcquisitionRegister(acquisitionValue);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_LoadAcquisitionRegister(uint16_t acquisitionValue);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to load ADC Precharge Time Control register with specified value.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] prechargeTime - Value to be loaded in the precharge time control register.
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     uint16_t prechargeTime = 98;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_SetPrechargeTime(prechargeTime);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetPrechargeTime(uint16_t prechargeTime);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to load repeat counter for given context with specified value.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] repeatCount - Value to be loaded to repeat counter.
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     uint8_t repeatCount = 32;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_SetRepeatCount(repeatCount);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_SetRepeatCount(uint8_t repeatCount);    

/**
 * @ingroup adc_context_scan
 * @brief This API retrieves the current value of ADC Repeat Count register for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return Current value of ADC Repeat Count register
 *
 * @code
 * void main(void)
 * {
 *     uint8_t conversionCount;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     conversionCount = ${moduleNameUpperCase}_GetCurrentCountofConversions();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
uint8_t ${moduleNameUpperCase}_GetCurrentCountofConversions(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API clears the accumulator of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_ClearAccumulator();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_ClearAccumulator(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API retrieves 18-bit value of ADC accumulator of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return Value of ADC accumulator.
 *
 * @code
 * void main(void)
 * {
 *     uint24_t accumulatorValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     accumulatorValue = ${moduleNameUpperCase}_GetAccumulatorValue();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
uint24_t ${moduleNameUpperCase}_GetAccumulatorValue(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to determine whether ADC accumulator has overflowed for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return Status of accumulator.
 *         true - ADC accumulator has overflowed.
 *         false - ADC accumulator has not overflowed.
 *
 * @code
 * void main(void)
 * {
 *     bool hasAccOvf;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     hasAccOvf = ${moduleNameUpperCase}_HasAccumulatorOverflowed();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
bool ${moduleNameUpperCase}_HasAccumulatorOverflowed(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API retrieves the value of ADC Filter register of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return 16-bit value obtained from ADFLTRH and ADFLTRL registers.
 *
 * @code
 * void main(void)
 * {
 *     uint16_t filterValue;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     filterValue = ${moduleNameUpperCase}_GetFilterValue();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
uint16_t ${moduleNameUpperCase}_GetFilterValue(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API retrieves the value of ADC Previous register of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return 16-bit value obtained from ADPREVH and ADPREVL registers.
 *
 * @code
 * void main(void)
 * {
 *     uint16_t previousResult;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     previousResult = ${moduleNameUpperCase}_GetPreviousResult();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
uint16_t ${moduleNameUpperCase}_GetPreviousResult(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API used to set value of ADC Threshold Set-point of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] setPoint - 16-bit value for set point.
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     uint16_t setPoint = 90;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_DefineSetPoint(setPoint);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_DefineSetPoint(uint16_t setPoint);    

/**
 * @ingroup adc_context_scan
 * @brief This API used to set value of ADC Upper Threshold register of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] upperThreshold - 16-bit value for upper threshold.
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     uint16_t upperThreshold = 5000;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_SetUpperThreshold(upperThreshold);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetUpperThreshold(uint16_t upperThreshold);    

/**
 * @ingroup adc_context_scan
 * @brief This API used to set value of ADC Lower Threshold register of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param[in] lowerThreshold - 16-bit value for lower threshold.
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     uint16_t lowerThreshold = 500;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_SetLowerThreshold(lowerThreshold);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetLowerThreshold(uint16_t lowerThreshold);    

/**
 * @ingroup adc_context_scan
 * @brief This API retrieves the value of ADC Set-point Error register of selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return 16-bit value obtained from ADERRH and ADERRL registers.
 *
 * @code
 * void main(void)
 * {
 *     uint16_t errorCalc;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     errorCalc = ${moduleNameUpperCase}_GetErrorCalculation();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
uint16_t ${moduleNameUpperCase}_GetErrorCalculation(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API enables double-sampling bit for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_EnableDoubleSampling();
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_EnableDoubleSampling(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API enables continuous conversion for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_EnableContinuousConversion();
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_EnableContinuousConversion(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API disables continuous conversion for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_DisableContinuousConversion();
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_DisableContinuousConversion(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to determine if ADC error has crossed the upper threshold for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return Status of operation.
 *         true - if ERR > UTH
 *         false - if ERR <= UTH
 *
 * @code
 * void main(void)
 * {
 *     bool uThr;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     uThr = ${moduleNameUpperCase}_HasErrorCrossedUpperThreshold();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
bool ${moduleNameUpperCase}_HasErrorCrossedUpperThreshold(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used to determine if ADC error is less than the lower threshold for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return Status of operation.
 *         true - if ERR < LTH.
 *         false - if ERR >= LTH.
 *
 * @code
 * void main(void)
 * {
 *     bool ulThr;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     ulThr = ${moduleNameUpperCase}_HasErrorCrossedLowerThreshold();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
bool ${moduleNameUpperCase}_HasErrorCrossedLowerThreshold(void);    

/**
 * @ingroup adc_context_scan
 * @brief This API is used retrieve the multi-stage status for selected context.
 *        Correct ADC context should be selected using @ref ${moduleNameUpperCase}_SelectContext
 *        before calling this API.
 * @param void
 * @return Contents of ADC STATUS register.
 *
 * @code
 * void main(void)
 * {
 *     uint8_t status;
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *     status = ${moduleNameUpperCase}_GetConversionStageStatus();
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
uint8_t ${moduleNameUpperCase}_GetConversionStageStatus(void); 

/**
 * @ingroup adc_context_scan
 * @brief This API is used to enable ADC charge pump.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_EnableChargePump();
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_EnableChargePump(void);

/**
 * @ingroup adc_context_scan
 * @brief This API is used to disable ADC charge pump.
 * @param void
 * @return void
 *
 * @code
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_DisableChargePump();
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Application code
 *
 *     while(1);
 * }
 * @endcode
 */
inline void ${moduleNameUpperCase}_DisableChargePump(void);   

<#if !isVectoredInterrupt>
/**
 * @ingroup adc_context_scan
 * @brief Interrupt Service Routine for A/D conversion interrupt.
 * @param void
 * @return void
 */
void ${moduleNameUpperCase}_ADI_ISR(void);
</#if>

/**
 * @ingroup adc_context_scan
 * @brief Setter for A/D conversion ISR.
 * @param[in] InterruptHandler - Pointer to custom ISR.
 * @return void
 *
 * @code
 * void customADIHandler(void)
 * {
 *    //Custom ISR code
 * }
 *
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SetADIInterruptHandler(customADIHandler);
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Replace with your application code
 *     while(1)
 *     {
 *     }
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetADIInterruptHandler(void (* InterruptHandler)(void));

<#if !isVectoredInterrupt>
/**
 * @ingroup adc_context_scan
 * @brief Interrupt Service Routine for A/D Active Clock Tuning interrupt.
 * @param void
 * @return void
 */
void ${moduleNameUpperCase}_ACTI_ISR(void);
</#if>

/**
 * @ingroup adc_context_scan
 * @brief Setter for A/D Active Clock Tuning ISR.
 * @param[in] InterruptHandler - Pointer to custom ISR.
 * @return void
 *
 * @code
 * void customACTIHandler(void)
 * {
 *    //Custom ISR code
 * }
 *
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SetActiveClockTuningInterruptHandler(customACTIHandler);
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Replace with your application code
 *     while(1)
 *     {
 *     }
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetActiveClockTuningInterruptHandler(void (* InterruptHandler)(void));

<#if !isVectoredInterrupt>
/**
 * @ingroup adc_context_scan
 * @brief Interrupt Service Routine for Context-1 threshold interrupt.
 * @param void
 * @return void
 */
void ${moduleNameUpperCase}_ADCH1_ISR(void);
</#if>

/**
 * @ingroup adc_context_scan
 * @brief Setter for Context-1 threshold interrupt.
 * @param[in] InterruptHandler - Pointer to custom ISR.
 * @return void
 *
 * @code
 * void customADCH1InterruptHandler(void)
 * {
 *    //Custom ISR code
 * }
 *
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SetContext1ThresholdInterruptHandler(customADCH1InterruptHandler);
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_1);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Replace with your application code
 *     while(1)
 *     {
 *     }
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetContext1ThresholdInterruptHandler(void (* InterruptHandler)(void));

<#if !isVectoredInterrupt>
/**
 * @ingroup adc_context_scan
 * @brief Interrupt Service Routine for Context-2 threshold interrupt.
 * @param void
 * @return void
 */
void ${moduleNameUpperCase}_ADCH2_ISR(void);
</#if>

/**
 * @ingroup adc_context_scan
 * @brief Setter for Context-2 threshold interrupt.
 * @param[in] InterruptHandler - Pointer to custom ISR.
 * @return void
 *
 * @code
 * void customADCH2InterruptHandler(void)
 * {
 *    //Custom ISR code
 * }
 *
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SetContext2ThresholdInterruptHandler(customADCH1InterruptHandler);
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_2);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Replace with your application code
 *     while(1)
 *     {
 *     }
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetContext2ThresholdInterruptHandler(void (* InterruptHandler)(void));

<#if !isVectoredInterrupt>
/**
 * @ingroup adc_context_scan
 * @brief Interrupt Service Routine for Context-3 threshold interrupt.
 * @param void
 * @return void
 */
void ${moduleNameUpperCase}_ADCH3_ISR(void);
</#if>

/**
 * @ingroup adc_context_scan
 * @brief Setter for Context-3 threshold interrupt.
 * @param[in] InterruptHandler - Pointer to custom ISR.
 * @return void
 *
 * @code
 * void customADCH3InterruptHandler(void)
 * {
 *    //Custom ISR code
 * }
 *
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SetContext3ThresholdInterruptHandler(customADCH1InterruptHandler);
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_3);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Replace with your application code
 *     while(1)
 *     {
 *     }
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetContext3ThresholdInterruptHandler(void (* InterruptHandler)(void));

<#if !isVectoredInterrupt>
/**
 * @ingroup adc_context_scan
 * @brief Interrupt Service Routine for Context-4 threshold interrupt.
 * @param void
 * @return void
 */
void ${moduleNameUpperCase}_ADCH4_ISR(void);
</#if>

/**
 * @ingroup adc_context_scan
 * @brief Setter for Context-4 threshold interrupt.
 * @param[in] InterruptHandler - Pointer to custom ISR.
 * @return void
 *
 * @code
 * void customADCH4InterruptHandler(void)
 * {
 *    //Custom ISR code
 * }
 *
 * void main(void)
 * {
 *     ${moduleNameUpperCase}_Initialize();
 *     ${moduleNameUpperCase}_SetContext4ThresholdInterruptHandler(customADCH1InterruptHandler);
 *     ${moduleNameUpperCase}_SelectContext(CONTEXT_4);
 *     ${moduleNameUpperCase}_StartConversion(channel_ANA0);
 *
 *     //Replace with your application code
 *     while(1)
 *     {
 *     }
 * }
 * @endcode
 */
void ${moduleNameUpperCase}_SetContext4ThresholdInterruptHandler(void (* InterruptHandler)(void));

/**
 * @}
 */
#endif //${moduleNameUpperCase}_H