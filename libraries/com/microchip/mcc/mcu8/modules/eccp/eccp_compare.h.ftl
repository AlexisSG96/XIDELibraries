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
        MPLAB 	          :  ${tool}
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
  Section: Data type definitions
*/
        
/**
 @Summary
   Defines the values to convert from 16bit to two 8 bit and vice versa

 @Description
   This routine used to get two 8 bit values from 16bit also
   two 8 bit value are combine to get 16bit.

 Remarks:
   None
 */

<#-- This code should be removed once Jira issue UDBC-693 is fixed  -->
typedef union CCPR${instanceNumber}Reg_tag
{
   struct
   {
      uint8_t ccpr${instanceNumber}l;
      uint8_t ccpr${instanceNumber}h;
   };
   struct
   {
      uint16_t ccpr${instanceNumber}_16Bit;
   };
} CCP${instanceNumber}_PERIOD_REG_T ;

/**
  Section: COMPARE Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine initializes the ${initializer}.
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
    uint16_t compare;

    ${initializer}();
    ${moduleNameUpperCase}_SetCompareCount(compare);
    </code>
 */
void ${initializer}(void);
</#list>

/**
  @Summary
    Loads 16-bit compare value.

  @Description
    This routine loads the 16 bit compare value.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been
    called before calling this function.

  @Param
    compareCount: 16-bit unsigned value

  @Returns
    None

  @Example
    <code>
    uint16_t compare;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_SetCompareCount(compare);
    </code>
*/
void ${moduleNameUpperCase}_SetCompareCount(uint16_t compareCount);

<#if usesInterrupt>
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
<#else>
/**
  @Summary
    Determines the completion of the data compare.

  @Description
    This routine is used to determine if data comparison is completed.
    When data comparison is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    ${moduleNameUpperCase}_Initialize()function should have been called before calling this function.

  @Returns
   true - Indicates compare is complete
   false - Indicates compare is not complete

  @Param
    None

  @Example
    <code>
    uint16_t capture;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_SetCompareCount(compare);
    while(!${moduleNameUpperCase}_IsCompareComplete());
    </code>
*/
bool ${moduleNameUpperCase}_IsCompareComplete(void);
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  //${moduleNameUpperCase}_H
/**
 End of File
*/
