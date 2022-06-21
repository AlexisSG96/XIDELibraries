/**
  PWM${instanceNumber} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    pwm${instanceNumber}.h

  @Summary
    This is the generated driver implementation file for the PWM${instanceNumber} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for PWM${instanceNumber}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef PWM${instanceNumber}_H
#define PWM${instanceNumber}_H

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
    Initializes the PWM${instanceNumber}

  @Description
    This routine initializes the PWM${instanceNumber} module.
    This routine must be called before any other PWM${instanceNumber} routine is called.
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
    uint16_t dutycycle;

    ${initializer}();
	PWM${instanceNumber}_LoadDutyValue(dutycycle);
    </code>
 */
void PWM${instanceNumber}_Initialize(void);
</#list>

/**
  @Summary
    Loads 16-bit duty cycle.

  @Description
    This routine loads the 16 bit duty cycle value.

  @Preconditions
    PWM${instanceNumber}_Initialize() function should have been called
    before calling this function.

  @Param
    Pass 16bit duty cycle value.

  @Returns
    None

  @Example
    <code>
    uint16_t dutycycle;

    PWM${instanceNumber}_Initialize();
    PWM${instanceNumber}_LoadDutyValue(dutycycle);
    </code>
*/
void PWM${instanceNumber}_LoadDutyValue(uint16_t dutyValue);

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
void PWM${instanceNumber}_${interruptFunctionName}(void);
</#if>
        
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif	//PWM${instanceNumber}_H
/**
 End of File
*/
