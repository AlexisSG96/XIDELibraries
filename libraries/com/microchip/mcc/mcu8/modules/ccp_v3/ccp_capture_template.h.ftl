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
        Driver Version    :  2.0.3
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

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/** 
   Section: Data Type Definition
*/

/**
 @Summary
   Defines the values to convert from 16bit to two 8 bit and vice versa

 @Description
   This routine used to get two 8 bit values from 16bit also
   two 8 bit value are combine to get 16bit.

 Remarks:
   None
 */

<#-- This union should be removed once Jira issue UDBC-693 is fixed  -->
typedef union CCPR${instanceNumber}Reg_tag
{
   struct
   {
      uint8_t ccpr${instanceNumber}l;
      uint8_t ccpr${instanceNumber}h;
   };
   struct
   {
      uint16_t ccpr${instanceNumber}_16Bit;
   };
} CCP${instanceNumber}_PERIOD_REG_T ;

/**
  Section: Capture Module APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase}

  @Description
    This routine initializes the ${initializer}.
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
void ${moduleNameUpperCase}_${interruptFunctionName}(void);

/**
  @Summary
    Setter for ${moduleNameUpperCase} CallBack function

  @Description
    Calling this function will set a new custom call back function that will be 
    called from the Capture ISR.

  @Preconditions
    Initialize the ${moduleNameUpperCase} module with interrupt before calling this function.

  @Param
    A pointer to the new function

  @Returns
    None

  @Example
    <code>
    void Capture_CallBack(uint16_t capturedValue)
    {
        // Custom callback routine
    }
    
    void main(void)
    {
        // initialize the device
        SYSTEM_Initialize();
        
        // set the custom callback
        ${moduleNameUpperCase}_SetCallBack(Capture_CallBack);
        
        while(1)
        {
            //Add your application code
        }
    }
    </code>
*/
 void ${moduleNameUpperCase}_SetCallBack(void (*customCallBack)(uint16_t));
 
<#else>
/**
  @Summary
    Determines the completion of the data captured.

  @Description
    This routine is used to determine if data capture is completed.
    When data capture is complete routine returns 1. It returns 0 otherwise.

  @Preconditions
    ${moduleNameUpperCase}_Initialize()function should have been called before calling this function.

  @Returns
    Returns 1 if data capture is completed
    true - Indicates data capture complete
    false - Indicates data capture is not complete

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    while(!${moduleNameUpperCase}_IsCapturedDataReady());
    </code>
*/
bool ${moduleNameUpperCase}_IsCapturedDataReady(void);

/**
  @Summary
    Reads the 16 bit capture value.

  @Description
    This routine reads the 16 bit capture value.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and
    ${moduleNameUpperCase}_IsCapturedDataReady() function should have been
    called before calling this function.

  @Param
    None.

  @Returns
    Returns 16 bit captured value

  @Example
    <code>
    uint16_t capture;

    ${moduleNameUpperCase}_Initialize();

    while(!${moduleNameUpperCase}_IsCapturedDataReady());   //Used only for polling method
    capture = ${moduleNameUpperCase}_CaptureRead();
    </code>
*/
uint16_t ${moduleNameUpperCase}_CaptureRead(void);
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  //${moduleNameUpperCase}_H
/**
 End of File
*/

