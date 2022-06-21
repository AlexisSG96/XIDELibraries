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
    <#if useEiInterrupt>
    ${moduleNameUpperCase}Result result;

    ${initializer}();

    ${moduleNameUpperCase}_AdditionAndMultiplication(0xff00,0xffff,0x00ff); // starts ${moduleNameUpperCase} module operation
    // have some other application code running here..

    // completion of ${moduleNameUpperCase} module operation triggers the module interrupt, now
    // read the result.
    result = ${moduleNameUpperCase}_ResultGet();

    ${moduleNameUpperCase} MAC_Addition(0xff00,0xffff);    // starts ${moduleNameUpperCase} module operation
    // have some other application code running here..

    // completion of ${moduleNameUpperCase} module operation triggers the module interrupt, now
    // read the result.
    result = ${moduleNameUpperCase}_ResultGet();

    ${moduleNameUpperCase}_Multiplication(0xffff,0x00ff);  // starts ${moduleNameUpperCase} module operation
    // have some other application code running here..

    // completion of ${moduleNameUpperCase} module operation triggers the module interrupt, now
    // read the result.
    result = ${moduleNameUpperCase}_ResultGet();
    <#else>
    ${moduleNameUpperCase}Result result1;
    uint32_t result2 = 0;

    ${initializer}();

    result1 = ${moduleNameUpperCase}_AdditionAndMultiplicationResultGet(0xff00,0xffff,0x00ff);
    if(true == ${moduleNameUpperCase}_HasOverflowOccured())
    {
        // overflow occured, returned value in 'result1' is not correct.
    }

    result2 = ${moduleNameUpperCase}_AdditionResultGet(0x00ff,0xffff);
    if(true == ${moduleNameUpperCase}_HasOverflowOccured())
    {
        // overflow occured, returned value in 'result2' is not correct.
    }

    result2 = ${moduleNameUpperCase}_MultiplicationResultGet(0xffff,0x00ff);
    if(true == ${moduleNameUpperCase}_HasOverflowOccured())
    {
        // overflow occured, returned value in 'result2' is not correct.
    }
    </#if>

    </code>
*/
void ${initializer}(void);
</#list>

<#if useEiInterrupt>
/**
  @Summary
    Initiates addition and multiplication operation on given input arguments

  @Description
    This function triggers the module to perform addition and multiplication
    operation on given input arguments, based on the formaula, (a+b).c

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    a - 16bit value for addition
    b - 16bit value for addition
    c - 16bit value for multiplication

  @Returns
    None

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
void ${moduleNameUpperCase}_AdditionAndMultiplication(uint16_t a, uint16_t b, uint16_t c);

/**
  @Summary
    Initiates addition operation on given input arguments

  @Description
    This function triggers the module to perform addition operation on
    given input arguments.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    a - 16bit value for addition
    b - 16bit value for addition

  @Returns
    None

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
void ${moduleNameUpperCase}_Addition(uint16_t a, uint16_t b);

/**
  @Summary
    Initiates multiplication operation on given input arguments

  @Description
    This function triggers the module to perform multiplication operation on
    given input arguments.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    b - 16bit value for multiplication
    c - 16bit value for multiplication

  @Returns
    None

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
void ${moduleNameUpperCase}_Multiplication(uint16_t b, uint16_t c);
<#else>
/**
  @Summary
    Does addition and multiplication operation on input arguments and return
    the result.

  @Description
    This function triggers the module to perform addition and multiplication
    operation on given input arguments, based on the formula, (a+b).C, and
    return the result.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    a - 16bit value for addition
    b - 16bit value for addition
    c - 16bit value for multiplication

  @Returns
    Returns the result of type 'MATHACCResult'

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
MATHACCResult ${moduleNameUpperCase}_AdditionAndMultiplicationResultGet(uint16_t a, uint16_t b, uint16_t c);

/**
  @Summary
    Does addition operation on input arguments and return the result

  @Description
    This function triggers the module to perform addition operation on given
    input arguments, and return the result.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    a - first value for addition
    b - second value for addition

  @Returns
    Returns 32-bit value as the result

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
MATHACCResult ${moduleNameUpperCase}_AdditionResultGet(uint16_t a, uint16_t b);

/**
  @Summary
    Does multiplication operation on input arguments and return the result

  @Description
    This function triggers the module to perform multiplication operation on
    given input arguments, and return the result.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() API should be called before calling this API.

  @Param
    b - first value for multiplication
    c - second value for multiplication

  @Returns
    Returns 32-bit value as the result

  @Example
    <code>
    Refer ${moduleNameUpperCase}_Initialize() example
    </code>
*/
MATHACCResult ${moduleNameUpperCase}_MultiplicationResultGet(uint16_t b, uint16_t c);
</#if>

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

<#if useEiInterrupt>
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

