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

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif


/**
  Section: Macro Declarations
*/
<#if (useInterrupt) && (tickerFactor != "0") && (tickerFactor != "1")>
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
    This function starts the ${moduleNameUpperCase}.

  @Description
    This function starts the ${moduleNameUpperCase} operation.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Do something else...
    </code>
*/
void ${moduleNameUpperCase}_StartTimer(void);

/**
  @Summary
    This function stops the ${moduleNameUpperCase}.

  @Description
    This function stops the ${moduleNameUpperCase} operation.
    This function must be called after the start of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Do something else...

    // Stop ${moduleNameUpperCase};
    ${moduleNameUpperCase}_StopTimer();
    </code>
*/
void ${moduleNameUpperCase}_StopTimer(void);

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

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

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
    Load value to Period Register.

  @Description
    This function writes the value to PR${instanceNumber} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    periodVal - Value to load into TMR${instanceNumber} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD1 0x80
    #define PERIOD2 0x40
    #define ZERO    0x00

    while(1)
    {
        // Read the TMR${instanceNumber} register
        if(ZERO == ${moduleNameUpperCase}_ReadTimer())
        {
            // Do something else...

            if(flag)
            {
                flag = 0;

                // Load Period 1 value
                ${moduleNameUpperCase}_LoadPeriodRegister(PERIOD1);
            }
            else
            {
                 flag = 1;

                // Load Period 2 value
                ${moduleNameUpperCase}_LoadPeriodRegister(PERIOD2);
            }
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_LoadPeriodRegister(uint8_t periodVal);

<#if useInterrupt>
/**
  @Summary
    Timer Interrupt Service Routine

  @Description
    Timer Interrupt Service Routine is called by the Interrupt Manager.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_${interruptFunctionName}(void);

<#if (tickerFactor != "0")>
/**
  @Summary
    CallBack function

  @Description
    This function is called from the timer ISR. User can write your code in this function.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this function.

  @Param
    None

  @Returns
    None
*/
 void ${moduleNameUpperCase}_CallBack(void);
</#if>
 <#else>
/**
  @Summary
    Boolean routine to poll or to check for the match flag on the fly.

  @Description
    This function is called to check for the timer match flag.
    This function is used in timer polling method.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module before calling this routine.

  @Param
    None

  @Returns
    true - timer match has occurred.
    false - timer match has not occurred.

  @Example
    <code>
    while(1)
    {
        // check the match flag
        if(${moduleNameUpperCase}_HasOverflowOccured())
        {
            // Do something else...

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

