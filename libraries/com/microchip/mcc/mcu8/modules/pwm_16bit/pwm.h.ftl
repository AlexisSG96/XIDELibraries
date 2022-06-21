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
  Section: PWM Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine initializes the Initializes the ${moduleNameUpperCase}.
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
    ${moduleNameUpperCase}_Start();

    // Do something else...
    </code>
*/
void ${moduleNameUpperCase}_Start(void);

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
    ${moduleNameUpperCase}_Stop();
    </code>
*/
void ${moduleNameUpperCase}_Stop(void);


/**
  @Summary
    This function used to check output status of ${moduleNameUpperCase}.

  @Description
    Check output status of ${moduleNameUpperCase} as High or Low.    

  @Preconditions
    Start the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    true - Output High.
	false - Output Low.

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_CheckOutputStatus(void);

/**
  @Summary
    This function is used to load buffer of ${moduleNameUpperCase} at the end of period.

  @Description
    load buffer of ${moduleNameUpperCase} at the end of period.

  @Preconditions
     Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_LoadBufferSet(void);

/**
  @Summary
    Load required 16 bit phase count

  @Description
    Set the expected phase count

  @Preconditions
    None

  @Param
    Pass 16 bit phase count

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_PhaseSet(uint16_t phaseCount);

/**
  @Summary
    Load required 16 bit Duty Cycle

  @Description
    Set the expected Duty Cycle

  @Preconditions
    None

  @Param
    Pass 16 bit Duty Cycle

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_DutyCycleSet(uint16_t dutyCycleCount);

/**
  @Summary
    Load required 16 bit Period

  @Description
    Set the expected Period

  @Preconditions
    None

  @Param
    Pass 16 bit Period

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_PeriodSet(uint16_t periodCount);

/**
  @Summary
    Load required 16 bit Offset

  @Description
    Set the expected Offset

  @Preconditions
    None

  @Param
    Pass 16 bit Offset

  @Returns
    None

  @Example
    <code>
    
    </code>
*/
void ${moduleNameUpperCase}_OffsetSet(uint16_t offsetCount);

/**
  @Summary
    Read measured Timer count

  @Description    
    Read the measured Timer count
 * 
  @Preconditions
    None

  @Param
    None

  @Returns
    Return 16 bit Timer count

  @Example
    <code>
    
    </code>
*/
uint16_t ${moduleNameUpperCase}_TimerCountGet(void);

/**
  @Summary
    Returns status of Offset interrupt flag bit (OFIF ).

  @Description    
    When PWMTMR = PWMOF value offset flag sets.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - PWMTMR >= PWMOF value
    false - PWMTMR < PWMOF value

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsOffsetMatchOccured(void);

/**
  @Summary
    Returns status of Phase interrupt flag bit (PHIF ).

  @Description    
    When PWMTMR = PWMPH value, Phase flag sets.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - PWMTMR count is >= PWMPH value
    false - PWMTMR count is < PWMPH value

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsPhaseMatchOccured(void);

/**
  @Summary
    Returns status of DutyCycle interrupt flag bit (DCIF ).

  @Description    
    When PWMTMR = PWMDC value DutyCycle flag sets.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - PWMTMR count is >= PWMDC value
    false - PWMTMR count is < PWMDC value

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsDutyCycleMatchOccured(void);

/**
  @Summary
    Returns status of Period interrupt flag bit (PRIF ).

  @Description    
    When PWMTMR = PWMPR value offset flag sets.

  @Preconditions
    None

  @Param
    None

  @Returns
    true - PWMTMR count is >= PWMPR value
    false - PWMTMR count is < PWMPR value

  @Example
    <code>
    
    </code>
*/
bool ${moduleNameUpperCase}_IsPeriodMatchOccured(void);

<#if useInterrupt>
/**
  @Summary
    Check which particular interrupt has occurred and call that function.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_ISR(void);

<#if periodFlag>
/**
  @Summary	
    Clears Period interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_Period(void);
</#if>
   
<#if phaseFlag>
/**
  @Summary	
    Clears Phase interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_Phase(void);
</#if>
    
<#if dutycycleFlag>
/**
  @Summary	
    Clears DutyCycle interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_DutyCycle(void);
</#if>
    
<#if offsetFlag>
/**
  @Summary	
    Clears Offset interrupt flag.

  @Description
    This routine is used to implement the ISR for the interrupt-driven
    implementations.

  @Preconditions
    None

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_Offset(void);
</#if>
</#if>        
#endif	/* ${moduleNameUpperCase}_H */
/**
 End of File
*/
