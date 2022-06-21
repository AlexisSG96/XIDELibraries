/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs driver for ${moduleNameUpperCase}.
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

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

/**
 Section: Data Type Definitions
*/

/**
  ${moduleNameUpperCase} result structure

  @Summary
    Define result structure for math acc results

  @Description
    This structure is to collect results  for ${moduleNameUpperCase} mode operation and
    add & multiply operations of ${moduleNameUpperCase} module. The mentioned module
    have 36 bits result which is mapped into the structure.

 */
typedef struct
{
    uint8_t byteLL;
    uint8_t byteLH;
    uint8_t byteHL;
    uint8_t byteHH;
    uint8_t byteU;
} MATHACCResult;

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: Interface Routines
*/
        
<#list initializers as initializer>        
/**
  @Summary
    Initializes the ${moduleNameUpperCase} module

  @Description
    This routine initializes the ${moduleNameUpperCase} module

  @Preconditions
    None.

  @Param
    None.

  @Returns
    None.

  @Example
    <code>
    <#if useDiInterrupt>
    ${moduleNameUpperCase}Result result;

    ${initializer}();
    ${moduleNameUpperCase}_PIDController(0x0f, 0xf0);
    // have some other application code running here..

    // completion of ${moduleNameUpperCase} module operation triggers the module interrupt, now
    // read the result.
    result = ${moduleNameUpperCase}_ResultGet();
    <#else>
    ${moduleNameUpperCase}Result result;

    ${initializer}();
    result = ${moduleNameUpperCase}_PIDControllerResultGet(0x0f, 0xf0);
    if(true == ${moduleNameUpperCase}_HasOverflowOccured())
    {
        // overflow occured, returned value in 'result' is not correct.
    }
    </#if>
    </code>
*/
void ${initializer}(void);
</#list>

<#if useDiInterrupt>
/**
  @Summary
    Starts PID calculation

  @Description
    This function triggers the module to start PID caculation.

  @Preconditions
    K1, K2, and K3 values should be calculated and loaded to respective module
    registers, such as, PIDK1, PIDK2, and PIDK3.

    Load PIDZ1, and PIDZ2 registers if applicable.

  @Param
    setpoint - PID Setpoint data
    input    - PID input data

  @Returns
    None

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
void ${moduleNameUpperCase}_PIDController(int16_t setpoint, int16_t input);
<#else>
/**
  @Summary
    Does PID calculation and return the result

  @Description
    This function triggers the module to perform PID caculation and return
    the PID result.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    setpoint - PID Setpoint data
    input    - PID input data

  @Returns
    Return the PID result of type '${moduleNameUpperCase}Result'

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
MATHACCResult ${moduleNameUpperCase}_PIDControllerModeResultGet(int16_t setpoint, int16_t input);
</#if>

/**
  @Summary
    Get the value of Z1 register

  @Description
    Get the value of Z1 register

  @Preconditions
    None

  @Param
    None

  @Returns
    Returns 17bit value of Z1 register

  @Example
    <code>
    uint32_t value = ${moduleNameUpperCase}_Z1Get();
    </code>
*/
uint32_t ${moduleNameUpperCase}_Z1Get(void);

/**
  @Summary
    Get the value of Z2 register

  @Description
    Get the value of Z2 register

  @Preconditions
    None

  @Param
    None

  @Returns
    Returns 17bit value of Z1 register

   @Example
    <code>
    uint32_t value = ${moduleNameUpperCase}_Z2Get();
    </code>
*/
uint32_t ${moduleNameUpperCase}_Z2Get(void);

/**
  @Summary
    Load a value to Z1 register

  @Description
    Load a value to Z1 register

  @Preconditions
    None

  @Param
    value - 17bit value to be loaded to Z1 register

  @Returns
    None

  @Example
    <code>
    ${moduleNameUpperCase}_LoadZ1(0x10000);
    </code>
*/
void ${moduleNameUpperCase}_LoadZ1(uint32_t value);

/**
  @Summary
    Load a value to Z2 register

  @Description
    Load a value to Z2 register

  @Preconditions
    None

  @Param
    value - 17bit value to be loaded to Z2 register

  @Returns
    None

   @Example
    <code>
    ${moduleNameUpperCase}_LoadZ2(0x10000);
    </code>
*/
void ${moduleNameUpperCase}_LoadZ2(uint32_t value);

/**
  @Summary
    Read the result

  @Description
    Read the result available in PIDOUT registers.

  @Preconditions
    None

  @Param
    None

  @Returns
    Return the result of type 'MATHACCResult'

  @Example
    <code>
    MATHACCResult result = ${moduleNameUpperCase}_ResultGet();
    </code>
*/
MATHACCResult ${moduleNameUpperCase}_ResultGet(void);

/**
  @Summary
    Clear the result

  @Description
    Clear the result by clearing PIDOUT registers.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Example
    <code>
    ${moduleNameUpperCase}_ClearResult();
    </code>
*/
void ${moduleNameUpperCase}_ClearResult(void);

<#if useDiInterrupt>
/**
  @Summary
    Math Accelerator module error interrupt routine

  @Description
    This function will be invoked on error overflow during module operation
*/
void ${moduleNameUpperCase}_Error_ISR( void );

/**
  @Summary
    Math Accelerator module interrupt routine

  @Description
    This function will be invoked on completion of module operation
*/
void ${moduleNameUpperCase}_PID_ISR( void );
<#else>
/**
  @Summary
    Checks for overflow error

  @Description
    Checks for overflow error

  @Preconditions
    None

  @Param
    None

  @Returns
    true - in case of overflow error
    false - if no overflow error

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
bool ${moduleNameUpperCase}_HasOverflowOccured(void);
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

}
#endif
#endif /*_MATHACC_H*/

