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
        Driver Version    :  2.02
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

/**
 *  result type of a synchronized A/D conversion
 */
typedef struct
{
    adc_result_t adc1Result;
    adc_result_t adc2Result;
} adc_sync_result_t;

/**
 *  result type of a Double ADC1 conversion
 */
typedef struct
{
    adc_result_t adc1Result1;
    adc_result_t adc1Result2;
} adc1_sync_double_result_t;

/**
 *  result type of a Double ADC2 conversion
 */
typedef struct
{
    adc_result_t adc2Result1;
    adc_result_t adc2Result2;
} adc2_sync_double_result_t;

/** ADC1 Channel Definition

 @Summary
   Defines the ADC1 channels available for conversion.

 @Description
   This routine defines the channels that are available for the ADC1 module to use.

 Remarks:
   None
 */

typedef enum
{
    <#list channels1 as channel>  
    ${channel.name}_adc1 =  ${channel.value}<#if channel_has_next>,</#if>
    </#list>
} adc1_channel_t;

/** ADC2 Channel Definition

 @Summary
   Defines the ADC2 channels available for conversion.
     
 @Description
   This routine defines the channels that are available for the ADC2 module to use.

 Remarks:
   None
 */
typedef enum
{
    <#list channels2 as channel>  
    ${channel.name}_adc2 =  ${channel.value}<#if channel_has_next>,</#if>
    </#list>
} adc2_channel_t;



/**
  Section: ADC Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine initializes the Initializes the ${moduleNameUpperCase}.
    This routine must be called before any other ${moduleNameUpperCase} routine is called.
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
    uint16_t convertedValue;

    ${initializer}();
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
*/
void ${initializer}(void);

</#list>
/**
  @Summary
    Allows selection of an ADC1 channel for conversion 

  @Description
    This routine is used to select desired channel for conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    Pass in required channel number
    "For available channel refer to enum under adc.h file"

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel);
    convertedValue = ${moduleNameUpperCase}1_GetConversionResult();
    </code>
*/
void ${moduleNameUpperCase}1_StartConversion(adc1_channel_t channel);

/**
  @Summary
    Allows selection of an ADC2 channel for conversion 

  @Description
    This routine is used to select desired channel for conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    Pass in required channel number
    "For available channel refer to enum under adc.h file"

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel);
    convertedValue = ${moduleNameUpperCase}2_GetConversionResult();
    </code>
*/
void ${moduleNameUpperCase}2_StartConversion(adc2_channel_t channel);

/**
  @Summary
    Allows selection of two channels for a synchronized conversion 

  @Description
    This routine is used to select the desired channels for a synchronized conversion.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    Pass in required channel numbers
    "For available channels refer to the ADC1 and ADC2 enums under adc.h file"

  @Example
    <code>
    adc_sync_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartSyncConversion(AN1_Channel, AN2_Channel);
    convertedValues = ${moduleNameUpperCase}_GetSyncConversionResult();
    </code>
*/
void ${moduleNameUpperCase}_StartSyncConversion(adc1_channel_t channelADC1, adc2_channel_t channelADC2);

/**
  @Summary
    Returns true when the ADC1 conversion is completed otherwise false.

  @Description
    This routine is used to determine if an ADC1 conversion is completed.
    When conversion is complete routine returns true. It returns false otherwise.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}1_StartConversion(adc1_channel_t channel)
    function should have been called before calling this function.

  @Returns
    true  - If conversion is complete
    false - If conversion is not completed

  @Param
    None

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel);

    while(!${moduleNameUpperCase}1_IsConversionDone());
    convertedValue = ${moduleNameUpperCase}1_GetConversionResult();
    </code>
 */
bool ${moduleNameUpperCase}1_IsConversionDone(void);

/**
  @Summary
    Returns true when the ADC2 conversion is completed otherwise false.

  @Description
    This routine is used to determine if an ADC2 conversion is completed.
    When conversion is complete routine returns true. It returns false otherwise.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}2_StartConversion(adc2_channel_t channel)
    function should have been called before calling this function.

  @Returns
    true  - If conversion is complete
    false - If conversion is not completed

  @Param
    None

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel);

    while(!${moduleNameUpperCase}2_IsConversionDone());
    convertedValue = ${moduleNameUpperCase}2_GetConversionResult();
    </code>
 */
bool ${moduleNameUpperCase}2_IsConversionDone(void);

/**
  @Summary
    Returns true when a synchronized conversion is completed otherwise false.

  @Description
    This routine is used to determine if a synchronized conversion is completed.
    When conversion is complete routine returns true. It returns false otherwise.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartSyncConversion(adc1_channel_t channel1, adc2_channel_t channel2)
    function should have been called before calling this function.

  @Returns
    true  - If conversion is complete
    false - If conversion is not completed

  @Param
    None

  @Example
    <code>
    adc_sync_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartSyncConversion(AN1_Channel, AN2_channel);

    while(!${moduleNameUpperCase}_IsSyncConversionDone());
    convertedValues = ${moduleNameUpperCase}_GetSyncConversionResult();
    </code>
 */
bool ${moduleNameUpperCase}_IsSyncConversionDone(void);

/**
  @Summary
    Returns the ${moduleNameUpperCase}1 conversion value.

  @Description
    This routine is used to get the analog to digital converted value. This
    routine gets converted values from the ADC1 channel specified.

  @Preconditions
    This routine returns the conversion value only after the conversion is complete.
    Completion status can be checked using the
    ${moduleNameUpperCase}1_IsConversionDone() routine.

  @Returns
    Returns the converted value.

  @Param
    None

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel);

    while(${moduleNameUpperCase}1_IsConversionDone());

    convertedValue = ${moduleNameUpperCase}1_GetConversionResult();
    </code>
 */
adc_result_t ${moduleNameUpperCase}1_GetConversionResult(void);

/**
  @Summary
    Returns the ${moduleNameUpperCase}2 conversion value.

  @Description
    This routine is used to get the analog to digital converted value. This
    routine gets converted values from the ADC2 channel specified.

  @Preconditions
    This routine returns the conversion value only after the conversion is complete.
    Completion status can be checked using the
    ${moduleNameUpperCase}2_IsConversionDone() routine.

  @Returns
    Returns the converted value.

  @Param
    None

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel);

    while(${moduleNameUpperCase}2_IsConversionDone());

    convertedValue = ${moduleNameUpperCase}2_GetConversionResult();
    </code>
 */
adc_result_t ${moduleNameUpperCase}2_GetConversionResult(void);

/**
  @Summary
    Returns the ${moduleNameUpperCase} synchronized conversion value.

  @Description
    This routine is used to get the analog to digital converted value. This
    routine gets converted values from the specified ADC1 and ADC2 channels.

  @Preconditions
    This routine returns the conversion value only after the conversion is complete.
    Completion status can be checked using the
    ${moduleNameUpperCase}_IsSyncConversionDone() routine.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    adc_sync_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartSyncConversion(AN1_Channel, AN2_Channel);

    while(${moduleNameUpperCase}_IsSyncConversionDone());

    convertedValues = ${moduleNameUpperCase}_GetSyncConversionResult();
    </code>
 */
adc_sync_result_t ${moduleNameUpperCase}_GetSyncConversionResult(void);

/**
  @Summary
    Returns the ${moduleNameUpperCase}1 conversion value
    also allows selection of a channel for conversion.

  @Description
    This routine is used to select desired channel for conversion
    and to get the analog to digital converted value.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    Returns the converted value.

  @Param
    Pass in required channel number.
    "For available channel refer to enum under adc.h file"

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();

    conversion = ${moduleNameUpperCase}1_GetConversion(AN1_Channel);
    </code>
*/
adc_result_t ${moduleNameUpperCase}1_GetConversion(adc1_channel_t channel);

/**
  @Summary
    Returns the ${moduleNameUpperCase}2 conversion value
    also allows selection of a channel for conversion.

  @Description
    This routine is used to select desired channel for conversion
    and to get the analog to digital converted value.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    Returns the converted value.

  @Param
    Pass in required channel number.
    "For available channel refer to enum under adc.h file"

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();

    conversion = ${moduleNameUpperCase}2_GetConversion(AN1_Channel);
    </code>
*/
adc_result_t ${moduleNameUpperCase}2_GetConversion(adc2_channel_t channel);

/**
  @Summary
    Returns the ${moduleNameUpperCase} synchronized conversion value
    also allows selection of two channels for conversion.

  @Description
    This routine is used to select the desired channels for a synchronized conversion
    and to get the analog to digital converted values.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    Pass in required channel numbers.
    "For available channels refer to the ADC1 and ADC2 enums under adc.h file"

  @Example
    <code>
    adc_sync_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();

    conversion = ${moduleNameUpperCase}_GetSyncConversion(AN1_Channel, AN_Channel2);
    </code>
*/
adc_sync_result_t ${moduleNameUpperCase}_GetSyncConversion(adc1_channel_t adc1Channel, adc2_channel_t adc2Channel);

/**
  @Summary
    Acquisition Delay for temperature sensor

  @Description
    This routine should be called when temperature sensor is used.
    
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();    
    ${moduleNameUpperCase}_StartConversion();
    ${moduleNameUpperCase}_temperatureAcquisitionDelay();
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
*/
void ${moduleNameUpperCase}_TemperatureAcquisitionDelay(void);

/**
  @Summary
    Allows to enable double conversion

  @Description
    This routine is used to enable double conversion on the same channel.
	Converted result will be stored in two different 10bit result register.    

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    adc_sync_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}1_EnableDoubleSampling();
    </code>
*/
void ${moduleNameUpperCase}1_EnableDoubleSampling(void);

/**
  @Summary
    Allows to enable double conversion

  @Description
    This routine is used to enable double conversion on the same channel.
	Converted result will be stored in two different 10bit result register.    

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    adc_sync_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}2_EnableDoubleSampling();
    </code>
*/
void ${moduleNameUpperCase}2_EnableDoubleSampling(void);

/**
  @Summary
    Returns the ADC double conversion result
    
  @Description
    This routine is used to get the analog to digital converted values.

  @Preconditions
    ${moduleNameUpperCase}1_EnableDoubleSampling() function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    adc1_sync_double_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}1_EnableDoubleSampling();

    convertedValues = ${moduleNameUpperCase}1_GetDoubleConversionResult();
    </code>
*/
adc1_sync_double_result_t ${moduleNameUpperCase}1_GetDoubleConversionResult(void);

/**
  @Summary
    Returns the ADC double conversion result
    
  @Description
    This routine is used to get the analog to digital converted values.

  @Preconditions
    ${moduleNameUpperCase}2_EnableDoubleSampling() function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    adc2_sync_double_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}2_EnableDoubleSampling();

    convertedValues = ${moduleNameUpperCase}2_GetDoubleConversionResult();
    </code>
*/
adc2_sync_double_result_t ${moduleNameUpperCase}2_GetDoubleConversionResult(void);

/**
  @Summary
    Returns the ADC conversion Stage
    
  @Description
    This routine is used to get status of ADC process.
	(like Conversion or acquisition or precharge Stage)

  @Preconditions
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel) function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    uint8_t conversionStage;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel);

    conversionStage = ${moduleNameUpperCase}1_GetStageStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}1_GetStageStatus(void);

/**
  @Summary
    Returns the ADC conversion Stage
    
  @Description
    This routine is used to get status of ADC process.
	(like Conversion or acquisition or precharge Stage)

  @Preconditions
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel) function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    uint8_t conversionStage;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel);

    conversionStage = ${moduleNameUpperCase}2_GetStageStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}2_GetStageStatus(void);

/**
  @Summary
    Returns the ADC conversion Status
    
  @Description
    This routine is used to get status of ADC conversion.
	
  @Preconditions
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel) function should have been called before calling this function.

  @Returns
    Returns the status.

  @Param
    None

  @Example
    <code>
    uint8_t conversionStatus;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}1_StartConversion(AN1_Channel);

    conversionStatus = ${moduleNameUpperCase}1_GetConversionStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}1_GetConversionStatus(void);

/**
  @Summary
    Returns the ADC conversion Status
    
  @Description
    This routine is used to get status of ADC conversion.
	
  @Preconditions
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel) function should have been called before calling this function.

  @Returns
    Returns the status.

  @Param
    None

  @Example
    <code>
    uint8_t conversionStatus;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}2_StartConversion(AN1_Channel);

    conversionStatus = ${moduleNameUpperCase}2_GetConversionStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}2_GetConversionStatus(void);

/**
  @Summary
    Loads the Precharge register by the 8 bit value sent as argument.

  @Description
    Set the desired precharge time to charge.

  @Preconditions
    None.

  @Returns
    None

  @Param
    8 bit value to be set in the precharge register.

  @Example
    <code>
	uint8_t prechargeTime = 98;
	${moduleNameUpperCase}1_SetPrechargeTime(prechargeTime);
    </code>
*/
void ${moduleNameUpperCase}1_SetPrechargeTime(uint8_t);

/**
  @Summary
    Loads the Precharge register by the 8 bit value sent as argument.

  @Description
    Set the desired precharge time to charge.

  @Preconditions
    None.

  @Returns
    None

  @Param
    8 bit value to be set in the precharge register.

  @Example
    <code>
	uint8_t prechargeTime = 98;
	${moduleNameUpperCase}2_SetPrechargeTime(prechargeTime);
    </code>
*/
void ${moduleNameUpperCase}2_SetPrechargeTime(uint8_t);

/**
  @Summary
    Loads the Acquisition time by the 8 bit value sent as argument.

  @Description
    Set the desired Acquisition time.

  @Preconditions
    None.

  @Returns
    None

  @Param
    8 bit value to be set in the acquisition register.

  @Example
    <code>
	uint8_t acquisitionValue = 98;
	{moduleNameUpperCase}1_SetAcquisitionTime(acquisitionValue);
    </code>
*/
void ${moduleNameUpperCase}1_SetAcquisitionTime(uint8_t);

/**
  @Summary
    Loads the Acquisition time by the 8 bit value sent as argument.

  @Description
    Set the desired Acquisition time.

  @Preconditions
    None.

  @Returns
    None

  @Param
    8 bit value to be set in the acquisition register.

  @Example
    <code>
	uint8_t acquisitionValue = 98;
	{moduleNameUpperCase}2_SetAcquisitionTime(acquisitionValue);
    </code>
*/
void ${moduleNameUpperCase}2_SetAcquisitionTime(uint8_t);

<#if usesInterruptAD1I>
/**
  @Summary
    Implements the ADC1 ISR

  @Description
    This routine is used to implement the ADC1 ISR for the interrupt-driven
    implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${interrupt1FunctionName}(void);

/**
  @Summary
    Set Timer Interrupt Handler

  @Description
    This sets the function to be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this.

  @Param
    Address of function to be set

  @Returns
    None
*/
 void ${moduleNameUpperCase}1_SetInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Timer Interrupt Handler

  @Description
    This is a function pointer to the function that will be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
extern void (*${moduleNameUpperCase}1_InterruptHandler)(void);

</#if>
<#if usesInterruptAD2I>
/**
  @Summary
    Implements the ADC2 ISR

  @Description
    This routine is used to implement the ADC2 ISR for the interrupt-driven
    implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${interrupt2FunctionName}(void);

/**
  @Summary
    Set Timer Interrupt Handler

  @Description
    This sets the function to be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this.

  @Param
    Address of function to be set

  @Returns
    None
*/
 void ${moduleNameUpperCase}2_SetInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Timer Interrupt Handler

  @Description
    This is a function pointer to the function that will be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
extern void (*${moduleNameUpperCase}2_InterruptHandler)(void);

</#if>
<#if usesInterruptAD2I || usesInterruptAD1I>
/**
  @Summary
    Default Timer Interrupt Handler

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

#endif	//${moduleNameUpperCase}_H
/**
 End of File
*/

