<#assign settings = pcgConfiguration.configuration.settings>
<#assign data = pcgConfiguration.configuration.data>
<#assign moduleNameUpperCase = data.moduleName?upper_case>
<#assign moduleNameLowerCase = data.moduleName?lower_case>
<#assign instanceNumber = settings.instanceNumber>
<#assign moduleName = data.moduleName>
<#assign interruptadc = data.getInterrupt("ADI")>
<#if settings.usesInterrupt("ADI")>
	<#assign interrupt = settings.getInterrupt("ADI")>
</#if>
/**
  ${data.moduleName} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${data.moduleName} driver using ${pcgConfiguration.productName}

  @Description
    This header file provides APIs for driver for ${data.moduleName}.
    Generation Information :
        Product Revision  :  ${pcgConfiguration.productName} - ${pcgConfiguration.productVersion}
        Device            :  ${pcgConfiguration.selectedDevice}
    The generated drivers are tested against the following:
        Compiler          :  ${pcgConfiguration.compiler}
        MPLAB 	          :  ${pcgConfiguration.tool}
*/

${pcgConfiguration.disclaimer}

#ifndef _${data.moduleName}_H
#define _${data.moduleName}_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: Data Types
*/

/** ADC Channel Definition
 
 @Summary 
   Defines the channels available for conversion
 
 @Description
   This routine defines the channels that are available for the module to use.
 
 Remarks:
   None
 */
typedef enum 
{
    <#list settings.channels as channel>
    <#if !channel.customName?contains("CHANNEL")>
    ${channel.customName} =  ${channel.registerSelectValue},
    <#else>
    ${channel.sourceName} =  ${channel.registerSelectValue},
    </#if>
    </#list>	
    ${data.moduleName}_MAX_CHANNEL_COUNT = ${settings.getNumberOfChannels()}
} ${data.moduleName}_CHANNEL;

/**
  Section: Interface Routines
*/

<#list settings.initializers as initializer>

/**
  @Summary
    This function initializes ${data.moduleGroup} instance : ${instanceNumber}

  @Description
    This routine initializes the ${data.moduleGroup} driver instance for : ${instanceNumber}
    index, making it ready for clients to open and use it. It also initializes any
    internal data structures.
    This routine must be called before any other ${data.moduleGroup} routine is called. 

  @Preconditions
    None.

  @Param
    None.

  @Returns
    None.

  @Comment
    ${initializer.comment}
 
  @Example
    <code>
        int conversion;
        ${data.moduleName}_${initializer.customName}();
        ${data.moduleName}_ChannelSelect(AN1_Channel);
        ${data.moduleName}_Start();
        //Provide Delay
        for(int i=0;i <1000;i++)
        {
        }
        ${data.moduleName}_Stop();
        while(!${data.moduleName}_IsConversionComplete())
        {
            ${data.moduleName}_Tasks();   
        }
        conversion = ${data.moduleName}_ConversionResultGet();
    </code>

*/

void ${data.moduleName}_${initializer.customName} (void);
</#list>

/**
  @Summary
    Starts sampling manually.

  @Description
    This routine is used to start the sampling manually.
 
  @Preconditions
    ${data.moduleName}_Initializer function should have been called 
    before calling this function.

  @Param
    None.

  @Returns
    None.

  @Example
    Refer to ${data.moduleName}_Initializer() for an example

*/

void ${data.moduleName}_Start(void);
/**
  @Summary
    Stops sampling manually.

  @Description
    This routine is used to stop the sampling manually before conversion
    is triggered.
 
  @Preconditions
    ${data.moduleName}_Initializer() function should have been 
    called before calling this function.

  @Param
    None.

  @Returns
    None.

  @Example
    Refer to ${data.moduleName}_Initializer() for an example
*/

void ${data.moduleName}_Stop(void);
/**
  @Summary
    Gets the buffer loaded with conversion results.

  @Description
    This routine is used to get the analog to digital converted values in a
    buffer. This routine gets converted values from multiple channels.
 
  @Preconditions
    This routine returns the buffer containing the conversion values only after 
    the conversion is complete. Completion status conversion can be checked using 
    ${data.moduleName}_IsConversionComplete() routine.
 
  @Param
    None.

  @Returns
    Returns the count of the buffer containing the conversion values.

  @Example
    <code>
        int count;
        //Initialize for channel scanning
        ${data.moduleName}_Initializer();
        ${data.moduleName}_Start();
        //Provide Delay
        for(int i=0;i <1000;i++)
        {
        }
        ${data.moduleName}_Stop();
        while(!${data.moduleName}_IsConversionComplete())
        {
            count = ${data.moduleName}_ConversionResultBufferGet();
        }

*/

uint16_t ${data.moduleName}_ConversionResultBufferGet(uint16_t *buffer);
/**
  @Summary
    Returns the ${data.moduleName} conversion value.

  @Description
    This routine is used to get the analog to digital converted value. This
    routine gets converted values from the channel specified.
 
  @Preconditions
    The channel required must be selected before calling this routine using
    ${data.moduleName}_ChannelSelect(channel). This routine returns the 
    conversion value only after the conversion is complete. Completion status 
    conversion can be checked using ${data.moduleName}_IsConversionComplete()
    routine.
   
  @Returns
    Returns the buffer containing the conversion value.

  @Param
    Buffer address
  
  @Example
    Refer to ${data.moduleName}_Initializer}(); for an example
 */

uint16_t ${data.moduleName}_ConversionResultGet(void);
/**
  @Summary
    Returns true when the conversion is completed

  @Description
    This routine is used to determine if conversion is completed. This routine
    returns the value of the DONE bit. When conversion is complete the routine
    returns 1. It returns 0 otherwise.
 
  @Preconditions
    ${data.moduleName}_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    Returns true if conversion is completed

  @Param
    None
  
  @Example
    Refer to ${data.moduleName}_Initializer(); for an example
 */

bool ${data.moduleName}_IsConversionComplete( void );
/**
  @Summary
    Allows selection of a channel for conversion

  @Description
    This routine is used to select desired channel for conversion.
  
  @Preconditions
    ${data.moduleName}_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    None

  @Param
    Pass in required channel from the ${data.moduleName}_CHANNEL list
  
  @Example
    Refer to ${data.moduleName}_Initializer(); for an example
 
*/

void ${data.moduleName}_ChannelSelect( ${data.moduleName}_CHANNEL channel );
/**
  @Summary
    Allows single conversion of a channel

  @Description
    This routine is used to get a single blocking conversion of a desired 
    channel.
  
  @Preconditions
    ${data.moduleName}_Initializer() function should have been 
    called before calling this function.
 
  @Returns
    Returns the conversion value.

  @Param
    Pass in required channel from the ${data.moduleName}_CHANNEL list
   
*/

uint16_t ${data.moduleName}_GetConversion(${data.moduleName}_CHANNEL channel);
<#if !settings.useInterrupt>
/**
  @Summary
    Polled implementation

  @Description
    This routine is used to implement the tasks for polled implementations.
  
  @Preconditions
    ${data.moduleName}_Initializer() function should have been 
    called before calling this function.
 
  @Returns 
    None
 
  @Param
    None
 
  @Example
    Refer to ${data.moduleName}_Initializer(); for an example
    
*/
void ${data.moduleName}_Tasks(void);
</#if>


        
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif //_${data.moduleName}_H
    
/**
 End of File
*/
