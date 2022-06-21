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
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine configures the ${moduleNameUpperCase} specific control registers

  @Preconditions
    None

  @Returns
    None

  @Param
    None

  @Comment

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    </code>
*/
void ${moduleNameUpperCase}_Initialize(void);
</#list>

<#if interruptEnabled>
<#if isVectoredInterruptEnabled>
<#else>
/**
  @Summary
    ${moduleNameUpperCase} Interrupt Service Routine

  @Description
    This is the ${moduleNameUpperCase} interrupt service routine called by the Interrupt Manager. Place your ${moduleNameUpperCase} interrupt code here.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    None

*/
void ${isrName}(void);
</#if>
</#if>
/**
  @Summary
    Returns output pin status of the CLC module.

  @Description
    This routine returns output pin status of the CLC module.

  @Param
    None.

  @Returns
    Output pin status
 
  @Example 
    <code>
    bool outputStatus;
    outputStatus = ${moduleNameUpperCase}_OutputStatusGet();
    </code>
*/

bool ${moduleNameUpperCase}_OutputStatusGet(void);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  // ${moduleNameUpperCase}_H
/**
 End of File
*/

