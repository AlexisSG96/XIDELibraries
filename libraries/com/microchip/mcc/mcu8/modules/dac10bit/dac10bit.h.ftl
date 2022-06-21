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
    Load 16bit input data to ${moduleNameUpperCase}.

  @Description
    This routine passes the 16bit input data into
    ${moduleNameUpperCase} voltage reference control register.This data will
    be left justified. 
 
  @Preconditions
    The ${moduleNameUpperCase}_Initialize() routine should be called
    before using this routine.DAC input reference range should be 16bit.
 
  @Param
    input16BitData - 16bit input data to ${moduleNameUpperCase}.

  @Returns
    None

  @Example
    <code>
    uint16_t count=0xFFFF;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_Load16bitInputData(count);
    while(1)
    {
    }
    </code>
*/
void ${moduleNameUpperCase}_Load16bitInputData(uint16_t input16BitData);

/**
  @Summary
    Load 10bit input data to ${moduleNameUpperCase}.

  @Description
    This routine passes the 10bit input data into ${moduleNameUpperCase} 
    voltage reference control register.This data will be right justified. 
 
  @Preconditions
   The ${moduleNameUpperCase}_Initialize() routine should be called
   before using this routine.DAC input reference range should be 10bit.
 
  @Param
    input10BitData - 10bit input data to ${moduleNameUpperCase}.

  @Returns
    None

  @Example
    <code>
    uint16_t count=0x3FF;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_Load10bitInputData(count);
    while(1)
    {
    }
    </code>
*/
void ${moduleNameUpperCase}_Load10bitInputData(uint16_t input10BitData);

/**
  @Summary
    Load 8 bit input data to ${moduleNameUpperCase}.

  @Description
    This routine passes the 8 bit input data into ${moduleNameUpperCase} 
    voltage reference control register.This data will be right justified. 
 
  @Preconditions
   The ${moduleNameUpperCase}_Initialize() routine should be called
   before using this routine.DAC input reference range should be 10bit.
 
  @Param
    input8BitData - 8 bit input data to ${moduleNameUpperCase}.

  @Returns
    None

  @Example
    <code>
    uint8_t count=0x3F;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_Load8bitInputData(count);
    while(1)
    {
    }
    </code>
*/
void ${moduleNameUpperCase}_Load8bitInputData(uint8_t input8BitData);

/**
  @Summary
    Read 10bit data from ${moduleNameUpperCase}.

  @Description
    This routine reads the 10bit data from ${moduleNameUpperCase} 
    voltage reference control register.This data will be right justified. 
 
  @Preconditions
   The ${moduleNameUpperCase}_Initialize() routine should be called
   before using this routine.DAC input reference range should be 10bit.

  @Returns
    uint16_t - 10bit data from ${moduleNameUpperCase}.

  @Example
    <code>
    uint16_t count=0x3FF;

    ${moduleNameUpperCase}_Initialize();
    ${moduleNameUpperCase}_Load10bitInputData(count);
    
    // Make sure data was written to DAC correctly
    __conditional_software_breakpoint(count == ${moduleNameUpperCase}_Read10BitInputData(count));
    </code>
*/
uint16_t ${moduleNameUpperCase}_Read10BitInputData(void);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/

