 /**
   ${moduleNameUpperCase} Generated Driver File
 
   @Company
     Microchip Technology Inc.
 
   @File Name
     ${moduleNameLowerCase}.c
 
   @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
     Generation Information :
         Product Revision  :  ${productName} - ${productVersion}
         Device            :  ${selectedDevice}
         Driver Version    :  2.01
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
  Section: ${moduleNameUpperCase} Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes all PWM

  @Description
    This routine initializes all PWM.
    This routine must be called before any other PWM routine is called.
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
	
    </code>
*/
void ${moduleNameUpperCase}_${initializer}(void);

</#list>
/**
  @Summary
    This function starts all PWM.

  @Description
    This function starts all PWM at a time operation.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize all PWM before calling this function.

   @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize all PWM module

    // Start all PWM
    PWM_StartSimultaneously();

    // Do something else...
    </code>
*/
void ${moduleNameUpperCase}_StartSimultaneously(void);

/**
  @Summary
    This function stops all PWM.

  @Description
    This function stops all PWM operation at a time.
    This function must be called after the start of all PWM.

  @Preconditions
    Start all PWM before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start Simultaneously all PWM
    PWM_StartSimultaneously();

    // Do something else...

    // StopSimultaneously all PWM;
    PWM_StopSimultaneously();
    </code>
*/
void ${moduleNameUpperCase}_StopSimultaneously(void);

/**
  @Summary
    This function is used to load buffer to all PWM at the end of period.

  @Description
    load buffer to all PWM at the end of period.

  @Preconditions
     Initialize all PWM before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_LoadBufferSimultaneouslySet(void);

/**
  @Summary
    This function used to check output status of all PWM.

  @Description
    Check output status of all PWM as High or Low.    

  @Preconditions
    Start Simultaneously all PWM before calling this function.

  @Param
    None

  @Returns
    true - Output High.
	false - Output Low.

  @Example
    <code>
    
    </code>
*/
uint8_t ${moduleNameUpperCase}_CheckOutputStatusSimultaneously(void);

#endif	/* ${moduleNameUpperCase}_H */
/**
 End of File
*/
