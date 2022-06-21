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
        Driver Version    :  3.0.0
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

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

/**
  Section: ${moduleNameUpperCase} APIs
*/

/**
  @Summary
    Initializes the ${moduleNameUpperCase}.

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
        ${moduleNameUpperCase}_Initialize();

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_Initialize(void);

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
inline void ${moduleNameUpperCase}_StartTimer(void);

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
inline void ${moduleNameUpperCase}_StopTimer(void);

/**
  @Summary
    Reads the 16-bit value of Capture register.

  @Description
    This function reads the 16-bit value of Capture register and return it.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    This function returns the 16-bit value of Capture Register.

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Read the current value of ${moduleNameUpperCase}
    uint16_t capvalue= ${moduleNameUpperCase}_ReadCaptureValue())
    // Do something else...
    // Stop ${moduleNameUpperCase};
     ${moduleNameUpperCase}_StopTimer();
    </code>
*/
uint16_t ${moduleNameUpperCase}_ReadCaptureValue(void);

/**
  @Summary
    Reads the 16-bit value of Capture register.

  @Description
    This function captures the current timer value, stores it in the capture register,
    and returns the captured value.
    This function is blocking code.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    This function returns the 16-bit value of Capture Register.

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Read the current value of ${moduleNameUpperCase}
    uint16_t capvalue= ${moduleNameUpperCase}_CaptureOnCommand())
    // Do something else...
    // Stop ${moduleNameUpperCase};
     ${moduleNameUpperCase}_StopTimer();
    </code>
*/
uint16_t ${moduleNameUpperCase}_CaptureOnCommand(void);

/**
  @Summary
    Reads the ${moduleNameUpperCase} register.

  @Description
    This function reads the ${moduleNameUpperCase} TMR register value and return it.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    This function returns the current value of TMR register.

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
        ${moduleNameUpperCase}_SetPeriodValue(0xFFFF);
    }
    </code>
*/
uint16_t ${moduleNameUpperCase}_ReadTimer(void);

/**
  @Summary
    Writes the ${moduleNameUpperCase} register.

  @Description
    This function writes the ${moduleNameUpperCase} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    timerVal - Value to write into ${moduleNameUpperCase} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD 0x80
    #define ZERO   0x00

    while(1)
    {
        // Read the ${moduleNameUpperCase} register
        if(ZERO == ${moduleNameUpperCase}_ReadTimer())
        {
            // Do something else...

            // Write the ${moduleNameUpperCase} register
            ${moduleNameUpperCase}_WriteTimer(PERIOD);
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_WriteTimer(uint16_t timerVal);

/**
  @Summary
    Clear the Counter to zero.

  @Description
    Clear the Counter to zero. it helps to reload new PR value.
    This function is blocking code.

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

    // Read the current value of ${moduleNameUpperCase}
    ${moduleNameUpperCase}_SetPeriodValue(0xFFFF);
    ${moduleNameUpperCase}_ClearCounter();
    // Do something else...
    // Stop ${moduleNameUpperCase};
     ${moduleNameUpperCase}_StopTimer();
    </code>
*/
inline void ${moduleNameUpperCase}_ClearCounter(void);

/**
  @Summary
    Load value to Period Register.

  @Description
    This function writes the value to Period registers.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Note
    It is important to note that the Period register is double-buffered.
    SetPeriodValue() loads and arms the buffer. For the new period to kick in,
    a second qualifying event is required (like an ERS reset or CLR command)

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    prVal - Value to load into ${moduleNameUpperCase} register.

  @Returns
    None


  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Writes the new PR value to Period registers
    ${moduleNameUpperCase}_SetPeriodValue(0xFFFF);
    // Do something else...
    // Stop ${moduleNameUpperCase};
     ${moduleNameUpperCase}_StopTimer();
    </code>
*/
void ${moduleNameUpperCase}_SetPeriodValue(uint16_t prVal);

/**
  @Summary
    Enables Period register match interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_EnablePRMatchInterrupt(void);

/**
  @Summary
    Disables Period register match interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_DisablePRMatchInterrupt(void);

/**
  @Summary
    Enables Zero condition match interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_EnableZeroInterrupt(void);

/**
  @Summary
    Disables Zero condition match interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_DisableZeroInterrupt(void);

/**
  @Summary
    Enables Capture interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_EnableCaptureInterrupt(void);

/**
  @Summary
    Disables Capture interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_DisableCaptureInterrupt(void);

/**
  @Summary
    This function get the PR Match interrupt flag status.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    bool
*/
inline bool ${moduleNameUpperCase}_HasPRMatchOccured(void);

/**
  @Summary
    This function get the Zero condition Match interrupt flag status.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    bool
*/
inline bool ${moduleNameUpperCase}_HasResetOccured(void);

/**
  @Summary
    This function get the Capture interrupt flag status.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    bool
*/
inline bool ${moduleNameUpperCase}_HasCaptureOccured(void);

/**
  @Summary
    This function get the timer running flag status.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    bool
*/
inline bool ${moduleNameUpperCase}_IsTimerRunning(void);

/**
  @Summary
    Enables TU main interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_EnableInterrupt(void);

/**
  @Summary
    Disables TU main interrupt.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    None
*/
inline void ${moduleNameUpperCase}_DisableInterrupt(void);

/**
  @Summary
    This function get the status of main TU interrupt flag.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    bool
*/
inline bool ${moduleNameUpperCase}_IsInterruptEnabled(void);

/**
  @Summary
    This function clear the status bits of TU module interrupt flag.

  @Preconditions
    None
    
  @Param
    None

  @Returns
    bool
*/
inline void ${moduleNameUpperCase}_ClearInterruptFlags(void);
<#if enableUTmrInterrupt>
<#if isVectoredInterrupt>
<#else>

/**
  @Summary
    Universal Timer Interrupt Service Routine

  @Description
    Universal Timer Interrupt Service Routine is called by the Interrupt Manager.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
 */
void ${moduleNameUpperCase}_ISR(void);
</#if>
</#if>
<#if enableUTmrInterrupt>

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
</#if>

#endif //${moduleNameUpperCase}_H