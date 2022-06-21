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
    Provides the readiness status of the ${moduleNameUpperCase} moduel

  @Description
    This Funtion provides the readiness status of the ${moduleNameUpperCase} moduel

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function.

  @Returns
    true  - PRG module is ready for use.
    false - PRG module is not ready for use


  @Param
    None

  @Example
    <code>
      ${moduleNameUpperCase}_Initialize();
      if(${moduleNameUpperCase}_IsReady())
      {
        ${moduleNameUpperCase}_GenarateRamp();
      }

    </code>
*/
bool ${moduleNameUpperCase}_IsReady(void);

/**
  @Summary
    Starts the Ramp generation.

  @Description
    This Funtion starts the Ramp generation.

  @Preconditions

    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function  and
    ${moduleNameUpperCase}_IsReady() function should return true.

  @Returns
    None

  @Param
    None

  @Example
    <code>
      ${moduleNameUpperCase}_Initialize();
      if(${moduleNameUpperCase}_IsReady())
      {
        ${moduleNameUpperCase}_StartRampGeneration();
      }
    </code>
*/
void ${moduleNameUpperCase}_StartRampGeneration(void);

/**
  @Summary
    Stops the Ramp generation.

  @Description
    This Funtion stops the Ramp generation.

  @Preconditions
    None

  @Returns
    None

  @Param
    None

  @Example
    <code>
        ${moduleNameUpperCase}_StopRampGeneration();
    </code>
*/
void ${moduleNameUpperCase}_StopRampGeneration(void);


/**
  @Summary
    Enables the One shot operation.

  @Description
    This Funtion enables the One shot operation.

  @Preconditions

    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function  and
    ${moduleNameUpperCase}_IsReady() function should return true.

  @Returns
    None

  @Param
    None

  @Example
    <code>
      ${moduleNameUpperCase}_Initialize();
      if(${moduleNameUpperCase}_IsReady())
      {
        ${moduleNameUpperCase}_EnableOneShot();
        ${moduleNameUpperCase}_StartRampGeneration();
      }
    </code>
*/
void ${moduleNameUpperCase}_EnableOneShot(void);

/**
  @Summary
    Disables the One shot operation.

  @Description
    This Funtion disables the One shot operation.

  @Preconditions
    None

  @Returns
    None

  @Param
    None

  @Example
    <code>
        ${moduleNameUpperCase}_DisableOneShot();
    </code>
*/
void ${moduleNameUpperCase}_DisableOneShot(void);
/**
  @Summary
    Used to update the slope rate of the Ramp.

  @Description
    This function is used to update the slope rate of the Ramp.

  @Preconditions
    None

  @Returns
    None

  @Param
    slopeValue: unsigned 8-bit value, valid value range is 0x00 <= slopeValue <= 0x1F

  @Example
    <code>
      ${moduleNameUpperCase}_UpdateSlope(0x10);
    </code>
*/
void ${moduleNameUpperCase}_UpdateSlope(uint8_t slopeValue);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/


