/**
   ${moduleNameUpperCase} Generated Driver File
 
   @Company
     Microchip Technology Inc.
 
   @File Name
     ${moduleNameLowerCase}.c
 
   @Summary
     This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}
 
   @Description
     This source file provides implementations for driver APIs for ${moduleNameUpperCase}.
     Generation Information :
         Product Revision  :  ${productName} - ${productVersion}
         Device            :  ${selectedDevice}
         Driver Version    :  2.01
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
    This routine configures the ${moduleNameUpperCase} specific control registers and input clock

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

/**
  @Summary
    Software generated Shutdown

  @Description
    This function forces the COG into Shutdown state.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_initialize();

    // Do something

    ${moduleNameUpperCase}_AutoShutdownEventSet();
    </code>
*/
void ${moduleNameUpperCase}_AutoShutdownEventSet();

/**
  @Summary
    This function makes the COG to resume its operations from the software
    generated shutdown state.

  @Description
    When auto-restart is disabled, the shutdown state will persist as long as the
    GxASE bit is set and hence to resume operations, this function should be used.

    However when auto-restart is enabled, the GxASE bit will clear automatically
    and resume operation on the next rising edge event. In that case, there is no
    need to call this function.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_AutoShutdownEventSet() functions should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_initialize();

    // Do something

    ${moduleNameUpperCase}_AutoShutdownEventSet();

    // Do something

    ${moduleNameUpperCase}_AutoShutdownEventClear();
    </code>
*/
void ${moduleNameUpperCase}_AutoShutdownEventClear();
<#if interruptEnabled>

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
void ${moduleNameUpperCase}_${interruptFunctionName}(void);
</#if>


#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  //${moduleNameUpperCase}_H
/**
 End of File
*/
