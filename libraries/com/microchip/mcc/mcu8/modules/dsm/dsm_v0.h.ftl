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
    This routine configures the ${moduleNameUpperCase} specific control registers

  @Preconditions
    None

  @Returns
    None

  @Param
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
    Sets the MDxCON0<BIT> high

  @Description
    This API sets the MDxCON0<BIT> high, so modulator uses carrier high signal

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_ManualModulationSet();
    </code>

*/
void ${moduleNameUpperCase}_ManualModulationSet (void);

/**
  @Summary
    Sets the MDxCON0<BIT> low

  @Description
    This API sets the MDxCON0<BIT> low, so modulator uses carrier low signal

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_ManualModulationClear();
    </code>

*/
void ${moduleNameUpperCase}_ManualModulationClear (void);
/**
  @Summary
    Toggles the MDxCON0<BIT>

  @Description
    This API toggles the MDxCON0<BIT>

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called 
	before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_ManualModulationToggle();
    </code>
*/
void ${moduleNameUpperCase}_ManualModulationToggle (void);

/**
  @Summary
    Enables modulation

  @Description
    This API enables the modulator.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called 
	before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_ModulationStart();
    </code>
*/
void ${moduleNameUpperCase}_ModulationStart (void);

/**
  @Summary
    Disables modulation

  @Description
    This API disables the modulator.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_ModulationStart()
	functions should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_ModulationStart();
    ...
    ${moduleNameUpperCase}_ModulationStop();
    </code>
*/
void ${moduleNameUpperCase}_ModulationStop (void);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  // ${moduleNameUpperCase}_H
/**
 End of File
*/
