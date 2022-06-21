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
        Driver Version    :  2.11
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: ZCD Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}_${initializer}.

  @Description
    This routine initializes the ${moduleNameUpperCase}_${initializer}.
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
    ${moduleNameUpperCase}_${initializer}();
    </code>
 */
void ${moduleNameUpperCase}_${initializer}(void);
</#list>

/**
  @Summary
    Determines if current is sinking or sourcing

  @Description
    This routine is used to determine if current is sinking or sourcing
    depending on output polarity.

    For non inverted polarity:
    high - Indicates current is sinking
    low - Indicates current is sourcing

    For inverted polarity:
    high - Indicates current is sourcing
    low - Indicates current is sinking

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Param
    None

  @Returns
   high or low

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    if(${moduleNameUpperCase}_IsLogicLevel())
    {
        // User code..
    }
    else
    {
        // User code..
    }
    </code>
 */
bool ${moduleNameUpperCase}_IsLogicLevel(void);
<#if useInterrupt>
<#if isVectoredInterrupt>
<#else>

/**
  @Summary
    Implements ISR.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${interruptFunction}(void);
</#if>
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  //${moduleNameUpperCase}_H
/**
 End of File
*/

