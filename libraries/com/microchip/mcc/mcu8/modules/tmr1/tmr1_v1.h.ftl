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
        Driver Version    :  2.01
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

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

<#if useInterrupt && (tickerFactor != "0")>
#define ${moduleNameUpperCase}_INTERRUPT_TICKER_FACTOR    ${tickerFactor}
</#if>

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
    ${initializer}();
    </code>
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Start ${moduleNameUpperCase}

  @Description
    This routine is used to  Start ${moduleNameUpperCase}.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    while(1)
    {
    }
    </code>
 */
void ${moduleNameUpperCase}_StartTimer(void);

/**
  @Summary
    Stop ${moduleNameUpperCase}

  @Description
    This routine is used to  Stop ${moduleNameUpperCase}.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    None

  @Example
    </code>
    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_StartTimer();
    if(${moduleNameUpperCase}_HasOverflowOccured())
    {
        ${moduleNameUpperCase}_StopTimer();
    }
    <code>
 */
void ${moduleNameUpperCase}_StopTimer(void);

/**
  @Summary
    Read ${moduleNameUpperCase} register.

  @Description
    This routine is used to  Read ${moduleNameUpperCase} register.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    ${moduleNameUpperCase} value at the time of the function call read as a 16-bit value

  @Example
    <code>
    uint16_t timerVal = 0;

    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_StartTimer();

    // some delay or code
    ${moduleNameUpperCase}_StopTimer();

    timerVal = ${moduleNameUpperCase}_ReadTimer();
    </code>
 */
uint16_t ${moduleNameUpperCase}_ReadTimer(void);

/**
  @Summary
    Write ${moduleNameUpperCase} register.

  @Description
    This routine is used to Write ${moduleNameUpperCase} register.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    timerVal : Timer value to be loaded

  @Returns
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_WriteTimer(0x055);
    ${moduleNameUpperCase}_StartTimer();
    </code>
 */
void ${moduleNameUpperCase}_WriteTimer(uint16_t timerVal);

/**
  @Summary
    Reload ${moduleNameUpperCase} register.

  @Description
    This routine is used to reload ${moduleNameUpperCase} register.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_StartTimer();

    if(${moduleNameUpperCase}_HasOverflowOccured())
     {
        ${moduleNameUpperCase}_StopTimer();
     }

     ${moduleNameUpperCase}_Reload();}
     </code>
*/
void ${moduleNameUpperCase}_Reload(void);

<#if usesInterruptTMRI>
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

<#if (tickerFactor != "0")>
/**
  @Summary
    CallBack function.

  @Description
    This routine is called by the Interrupt Manager.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_CallBack(void);
</#if>

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

<#else>
/**
  @Summary
    Get the ${moduleNameUpperCase} overflow status.

  @Description
    This routine get the ${moduleNameUpperCase} overflow status.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    true  - Overflow has occured.
    false - Overflow has not occured.

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_StartTimer();

    while(1)
    {
         if(${moduleNameUpperCase}_HasOverflowOccured())
         {
            ${moduleNameUpperCase}_StopTimer();
         }
    }
     </code>
*/
bool ${moduleNameUpperCase}_HasOverflowOccured(void);

</#if>
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/

