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
        Driver Version    :  2.10
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
    Set Input data into ${moduleNameUpperCase}.

  @Description
    This routine pass the digital input data into
    ${moduleNameUpperCase} voltage reference control register.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    inputData - 8bit digital data to ${moduleNameUpperCase}.

  @Returns
    None

  @Example
    <code>
    uint8_t count=0;

    ${moduleNameUpperCase}_Initialize();

    for(count=0; count<=30; count++)
    {
        ${moduleNameUpperCase}_SetOutput(count);
    }

    while(1)
    {
    }
    </code>
*/
void ${moduleNameUpperCase}_SetOutput(uint8_t inputData);

/**
  @Summary
    Read input data fed to ${moduleNameUpperCase}.

  @Description
    This routine reads the digital input data fed to
    ${moduleNameUpperCase} voltage reference control register.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    uint8_t inputData - digital data fed to ${moduleNameUpperCase}

  @Example
    <code>
    uint8_t count=0;
    uint8_t inputData;

    ${moduleNameUpperCase}_Initialize();

    inputData = ${moduleNameUpperCase}_GetOutput();

    while(1)
    {
    }
    </code>
*/
uint8_t ${moduleNameUpperCase}_GetOutput(void);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/
