/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.11
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

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase} module

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
    Allows to enable data acquisition

  @Description
    This routine is used to enable data acquisition

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
    </code>
*/
void ${moduleNameUpperCase}_DataAcquisitionEnable(void);

/**
  @Summary
    Allows to disable data acquisition

  @Description
    This routine is used to disable data acquisition

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase}_DataAcquisitionEnable() 
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
        .
        .
        .
    ${moduleNameUpperCase}_DataAcquisitionDisable();
    </code>
*/
void ${moduleNameUpperCase}_DataAcquisitionDisable(void);

/**
  @Summary
    Allows counter to be at ${moduleNameUpperCase}PR and
    interrupt occurs when clocked.

  @Description
    This routine allows the counter to be at ${moduleNameUpperCase}PR and
    interrupt occurs when clocked.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase}_DataAcquisitionEnable() 
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
 
    // User Code
 
    ${moduleNameUpperCase}_HaltCounter();
    </code>
*/
void ${moduleNameUpperCase}_HaltCounter(void);

/**
  @Summary
    Allows to change period.

  @Description
    This routine is used to change the period

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    None

  @Param
    periodVal : Period value to be loaded

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_SetPeriod(0x00123456);
    </code>
*/
void ${moduleNameUpperCase}_SetPeriod(uint32_t periodVal);

/**
  @Summary
    To get ${moduleNameUpperCase} period value.

  @Description
    This routine is used to get ${moduleNameUpperCase} period value.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    uint32_t - Value of period register.

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_GetPeriod();
    </code>
*/
uint32_t ${moduleNameUpperCase}_GetPeriod(void);

/**
  @Summary
    Allows single data acquisition.

  @Description
    This routine allows single data acquisition.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
 
    // User Code
 
    ${moduleNameUpperCase}_SingleDataAcquisition();
    </code>
*/
void ${moduleNameUpperCase}_SingleDataAcquisition(void);

/**
  @Summary
    Allows repeat data acquisition.

  @Description
    This routine allows repeat data acquisition.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
 
    // User Code
 
    ${moduleNameUpperCase}_RepeatDataAcquisition();
    </code>
*/
void ${moduleNameUpperCase}_RepeatDataAcquisition(void);

/**
  @Summary
    Allows ${moduleNameUpperCase} to update ${moduleNameUpperCase}PR registers.

  @Description
    This routine allows ${moduleNameUpperCase} to update ${moduleNameUpperCase}PR registers.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
 
    // User Code
 
    ${moduleNameUpperCase}_ManualPeriodBufferUpdate();
    </code>
*/
void ${moduleNameUpperCase}_ManualPeriodBufferUpdate(void);

/**
  @Summary
    Allows ${moduleNameUpperCase} to update ${moduleNameUpperCase}CPW registers.

  @Description
    This routine allows ${moduleNameUpperCase} to update ${moduleNameUpperCase}CPW registers.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
 
    // User Code
 
    ${moduleNameUpperCase}_ManualPulseWidthBufferUpdate();
    </code>
*/
void ${moduleNameUpperCase}_ManualPulseWidthBufferUpdate(void);

/**
  @Summary
    Allows ${moduleNameUpperCase} to reset ${moduleNameUpperCase}TMR registers.

  @Description
    This routine allows ${moduleNameUpperCase} to reset ${moduleNameUpperCase}TMR registers.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_DataAcquisitionEnable();
 
    // User Code
 
    ${moduleNameUpperCase}_ManualTimerReset();
    </code>
*/
void ${moduleNameUpperCase}_ManualTimerReset(void);

/**
  @Summary
    Determines if ${moduleNameUpperCase} window is open or closed.

  @Description
    This routine is used to determine if ${moduleNameUpperCase} window is open or closed.
    This bit is only valid when TS bit equals to 1. 

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    1 - ${moduleNameUpperCase} window is open
    0 - ${moduleNameUpperCase} window is closed

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    if(${moduleNameUpperCase}_IsWindowOpen())
    {
        // User code..
    }
    else
    {
        // User code..
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsWindowOpen(void);

/**
  @Summary
    Determines if ${moduleNameUpperCase} signal acquisition is in progress or not.

  @Description
    This routine is used to determine if ${moduleNameUpperCase} signal acquisition is in progress or not.
    This bit is only valid when TS bit equals to 1. 
 
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    1 - ${moduleNameUpperCase} signal acquisition is in progress
    0 - ${moduleNameUpperCase} signal acquisition is not in progress

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    while(!${moduleNameUpperCase}_IsSignalAcquisitionInProgress())
    {
        // User code..
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsSignalAcquisitionInProgress(void);

/**
  @Summary
    Determines if ${moduleNameUpperCase} timer is incrementing or not.

  @Description
    This routine is used to determine if ${moduleNameUpperCase} timer is incrementing or not.
     
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function and ${moduleNameUpperCase} data acquisition bit
    should have been called before calling this function.

  @Returns
    1 - ${moduleNameUpperCase} timer is incrementing
    0 - ${moduleNameUpperCase} timer is not incrementing

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    while(!${moduleNameUpperCase}_IsTimerIncrementing())
    {
        // User code..
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsTimerIncrementing(void);

/**
  @Summary
    To get ${moduleNameUpperCase} pulse width latch register value.

  @Description
    This routine is used to get ${moduleNameUpperCase} pulse width latch register value.
     
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    uint32_t - Value of pulse width latch register.
    
  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_GetCapturedPulseWidth();
    </code>
*/
uint32_t ${moduleNameUpperCase}_GetCapturedPulseWidth(void);

/**
  @Summary
    To get ${moduleNameUpperCase} period latch register value.

  @Description
    This routine is used to get ${moduleNameUpperCase} period latch register value.
     
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    uint32_t - Value of period register.
    
  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_GetCapturedPeriod();
    </code>
*/
uint32_t ${moduleNameUpperCase}_GetCapturedPeriod(void);

/**
  @Summary
    To get ${moduleNameUpperCase} Timer latch register value.

  @Description
    This routine is used to get ${moduleNameUpperCase} Timer latch register value.
     
  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    uint32_t - Value of Timer register.
    
  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    ${moduleNameUpperCase}_GetTimerValue();
    </code>
*/
uint32_t ${moduleNameUpperCase}_GetTimerValue(void);
<#if usesPRAcquInterrupt>
<#if isVectoredPRAcquInterruptEnabled>
<#else>

/**
  @Summary
    Implements Period Acquisition Interrupt ISR.

  @Description
    This routine is used to implement the Period Acquisition Interrupt ISR for 
    the interrupt-driven implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${PRAcquInterruptFunctionName}(void);
</#if>
</#if>
<#if usesPWAcquInterrupt>
<#if isVectoredPWAcquInterruptEnabled>
<#else>

/**
  @Summary
    Implements Pulse Width Acquisition Interrupt ISR.

  @Description
    This routine is used to implement the Pulse Width Acquisition Interrupt ISR for 
    the interrupt-driven implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${PWAcquInterruptFunctionName}(void);
</#if>
</#if>
<#if usesOverflowInterrupt>
<#if isVectoredOverflowInterruptEnabled>
<#else>

/**
  @Summary
    Implements Counter Overflow Interrupt ISR.

  @Description
    This routine is used to implement the Counter Overflow Interrupt ISR for 
    the interrupt-driven implementations.

  @Returns
    None

  @Param
    None
*/
void ${moduleNameUpperCase}_${overflowInterruptFunctionName}(void);
</#if>
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/


