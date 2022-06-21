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

#include <stdbool.h>
#include <stdint.h>

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
    This routine initializes the ${moduleNameUpperCase}.
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
    ${moduleNameUpperCase}_Initialize();
    </code>
*/
void ${moduleNameUpperCase}_Initialize(void);
</#list>

/**
  @Summary
    Gets the ${moduleNameUpperCase} output status.

  @Description
    This routine gets the ${moduleNameUpperCase} output status.

  @Preconditions
    The ${moduleNameUpperCase} initializer routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    high  - if the ${moduleNameUpperCase} output is high.
    low   - if the ${moduleNameUpperCase} output is low.

  @Example
    <code>
    #define LED_On  LATAbits.LATA0=1
    #define LED_Off LATAbits.LATA0=0

    ${moduleNameUpperCase}_Initialize();

    while(1)
    {
        if(${moduleNameUpperCase}_GetOutputStatus())
        {
            LED_On;
        }
        else
        {
             LED_Off;
        }
    }
    </code>
*/
bool ${moduleNameUpperCase}_GetOutputStatus(void);

<#if useInterrupt>
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


#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/

