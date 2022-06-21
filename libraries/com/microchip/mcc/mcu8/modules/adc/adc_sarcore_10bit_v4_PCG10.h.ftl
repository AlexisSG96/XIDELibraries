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
 *  result type of a Double ADC conversion
 */
typedef struct
{
    adc_result_t adcResult1;
    adc_result_t adcResult2;
} adc_sync_double_result_t;

/** ADC Channel Definition

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
} adc_channel_t;

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
    Allows selection of a channel for conversion

  @Description
    This routine is used to select desired channel for conversion.
    available

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
    ${moduleNameUpperCase}_SelectChannel(AN1_Channel);
    ${moduleNameUpperCase}_StartConversion();
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
*/
void ${moduleNameUpperCase}_SelectChannel(adc_channel_t channel);

/**
  @Summary
    Starts conversion

  @Description
    This routine is used to start conversion of desired channel.
    
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
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
*/
void ${moduleNameUpperCase}_StartConversion(void);

/**
  @Summary
    Returns true when the conversion is completed otherwise false.

  @Description
    This routine is used to determine if conversion is completed.
    When conversion is complete routine returns true. It returns false otherwise.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_StartConversion(void)
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
    ${moduleNameUpperCase}_StartConversion();

    while(!${moduleNameUpperCase}_IsConversionDone());
    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
 */
bool ${moduleNameUpperCase}_IsConversionDone(void);

/**
  @Summary
    Returns the ${moduleNameUpperCase} conversion value.

  @Description
    This routine is used to get the analog to digital converted value. This
    routine gets converted values from the channel specified.

  @Preconditions
    This routine returns the conversion value only after the conversion is complete.
    Completion status can be checked using
    ${moduleNameUpperCase}_IsConversionDone() routine.

  @Returns
    Returns the converted value.

  @Param
    None

  @Example
    <code>
    uint16_t convertedValue;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion();

    while(${moduleNameUpperCase}_IsConversionDone());

    convertedValue = ${moduleNameUpperCase}_GetConversionResult();
    </code>
 */
adc_result_t ${moduleNameUpperCase}_GetConversionResult(void);

/**
  @Summary
    Returns the ${moduleNameUpperCase} conversion value
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

    conversion = ${moduleNameUpperCase}_GetConversion(AN1_Channel);
    </code>
*/
adc_result_t ${moduleNameUpperCase}_GetConversion(adc_channel_t channel);

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

    ${moduleNameUpperCase}_EnableDoubleSampling();
    </code>
*/
void ${moduleNameUpperCase}_EnableDoubleSampling(void);

/**
  @Summary
    Returns the ADC double conversion result
    
  @Description
    This routine is used to get the analog to digital converted values.

  @Preconditions
    ${moduleNameUpperCase}_EnableDoubleSampling() function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    adc1_sync_double_result_t convertedValues;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_EnableDoubleSampling();

    convertedValues = ${moduleNameUpperCase}_GetDoubleConversionResult();
    </code>
*/
adc_sync_double_result_t ${moduleNameUpperCase}_GetDoubleConversionResult(void);

/**
  @Summary
    Returns the ADC conversion Stage
    
  @Description
    This routine is used to get status of ADC process.
	(like Conversion or acquisition or precharge Stage)

  @Preconditions
    ${moduleNameUpperCase}_StartConversion(void) function should have been called before calling this function.

  @Returns
    Returns the converted values.

  @Param
    None

  @Example
    <code>
    uint8_t conversionStage;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion();

    conversionStage = ${moduleNameUpperCase}_GetStageStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}_GetStageStatus(void);

/**
  @Summary
    Returns the ADC conversion Status
    
  @Description
    This routine is used to get status of ADC conversion.
	
  @Preconditions
    ${moduleNameUpperCase}1_StartConversion(void) function should have been called before calling this function.

  @Returns
    Returns the status.

  @Param
    None

  @Example
    <code>
    uint8_t conversionStatus;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartConversion();

    conversionStatus = ${moduleNameUpperCase}_GetConversionStatus();
    </code>
*/
uint8_t ${moduleNameUpperCase}_GetConversionStatus(void);

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
	${moduleNameUpperCase}_SetPrechargeTime(prechargeTime);
    </code>
*/
void ${moduleNameUpperCase}_SetPrechargeTime(uint8_t);

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
	{moduleNameUpperCase}_SetAcquisitionTime(acquisitionValue);
    </code>
*/
void ${moduleNameUpperCase}_SetAcquisitionTime(uint8_t);

<#if useInterrupt>
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
 void ${moduleNameUpperCase}_SetInterruptHandler(void (* InterruptHandler)(void));

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
extern void (*${moduleNameUpperCase}_InterruptHandler)(void);

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

