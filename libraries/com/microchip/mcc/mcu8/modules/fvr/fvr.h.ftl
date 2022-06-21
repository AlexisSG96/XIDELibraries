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
    Gets the ${moduleNameUpperCase} output ready status.

  @Description
    This routine gets the ${moduleNameUpperCase} output ready status.

  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
     true  - ${moduleNameUpperCase} module is ready for use.
     false - ${moduleNameUpperCase} module is not ready for use.

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();

    if(${moduleNameUpperCase}_IsOutputReady())
    {
          //user code
    }
    else
    {
          //user code
    }
    </code>
*/
bool ${moduleNameUpperCase}_IsOutputReady(void);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/

