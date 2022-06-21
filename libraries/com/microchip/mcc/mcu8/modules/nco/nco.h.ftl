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
         Compiler          :  ${compiler} or later
         MPLAB             :  ${tool}
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
  Section: NCO1 Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${initializer}

  @Description
    This routine initializes the ${initializer}
    This routine must be called before any other ${moduleName} routine is called.
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
    ${initializer}();
    </code>
 */
void ${initializer}(void);
</#list>

<#if interruptEnabled>
<#if isVectoredInterruptEnabled>
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
void ${isrName}(void);
</#if>
<#else>
/**
  @Summary
    Determines if output status is high or low.

  @Description
    This routine returns the ${moduleName} output status.
    high - Indicates output is high
    low - Indicates output is low

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called
	before calling this function.

  @Param
    None

  @Returns
    high - Indicates output is high
    low - Indicates output is low

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    if(${moduleNameUpperCase}_GetOutputStatus())
    {
        // User code..
    }
    else
    {
         // User code..
    }
    </code>
 */
bool ${moduleNameUpperCase}_GetOutputStatus(void);
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  //${moduleNameUpperCase}_H
/**
 End of File
*/


