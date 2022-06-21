/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for ${moduleNameUpperCase}.
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

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

<#if (useInterrupt) && (tickerFactor != "0")>
/**
  Section: Macro Declarations
*/

#define ${moduleNameUpperCase}_INTERRUPT_TICKER_FACTOR    ${tickerFactor}

</#if>
/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase} module.

  @Description
    This function initializes the ${moduleNameUpperCase} Registers.
    This function must be called before any other ${moduleNameUpperCase} function is called.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment
    

  @Example
    <code>
    main()
    {
        // Initialize ${moduleNameUpperCase} module
        ${initializer}();

        // Do something else...
    }
    </code>
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Reads the TMR${instanceNumber} register.

  @Description
    This function reads the TMR${instanceNumber} register value and return it.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    This function returns the current value of TMR${instanceNumber} register.

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module
    // Read the current value of ${moduleNameUpperCase}
    if(0 == ${moduleNameUpperCase}_ReadTimer())
    {
        // Do something else...

        // Reload the TMR value
        ${moduleNameUpperCase}_Reload();
    }
    </code>
*/
uint8_t ${moduleNameUpperCase}_ReadTimer(void);

/**
  @Summary
    Writes the TMR${instanceNumber} register.

  @Description
    This function writes the TMR${instanceNumber} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    timerVal - Value to write into TMR${instanceNumber} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD 0x80
    #define ZERO   0x00

    while(1)
    {
        // Read the TMR${instanceNumber} register
        if(ZERO == ${moduleNameUpperCase}_ReadTimer())
        {
            // Do something else...

            // Write the TMR${instanceNumber} register
            ${moduleNameUpperCase}_WriteTimer(PERIOD);
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_WriteTimer(uint8_t timerVal);

/**
  @Summary
    Reload the ${moduleNameUpperCase} register.

  @Description
    This function reloads the ${moduleNameUpperCase} register.
    This function must be called to write initial value into ${moduleNameUpperCase} register.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    while(1)
    {
        if(TMR${instanceNumber}IF)
        {
            // Do something else...

            // clear the ${moduleNameUpperCase} interrupt flag
            TMR${instanceNumber}IF = 0;

            // Reload the initial value of ${moduleNameUpperCase}
            ${moduleNameUpperCase}_Reload();
        }
    }
    </code>
*/
void ${moduleNameUpperCase}_Reload(void);

<#if useInterrupt>
/**
  @Summary
    Timer Interrupt Service Routine

  @Description
    Timer Interrupt Service Routine is called by the Interrupt Manager.

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
    Boolean routine to poll or to check for the overflow flag on the fly.

  @Description
    This function is called to check for the timer overflow flag.
    This function is usd in timer polling method.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module before calling this routine.

  @Param
    None

  @Returns
    true - timer overflow has occured.
    false - timer overflow has not occured.

  @Example
    <code>
    while(1)
    {
        //check the overflow flag
        if(${moduleNameUpperCase}_HasOverflowOccured())
        {
            // Do something else...

            // clear the ${moduleNameUpperCase} interrupt flag
            TMR${instanceNumber}IF = 0;

            // Reload the ${moduleNameUpperCase} value
            ${moduleNameUpperCase}_Reload();
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
