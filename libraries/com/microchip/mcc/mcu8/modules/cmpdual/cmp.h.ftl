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

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
 Section: Data Type Definitions
*/

/**
   Dual CMP state change setting Enumeration

  @Summary
    Defines the various state changes in CMPx out.

  @Description
    This defines whether any state changed in CMP1 and/or CMP2 output.
    
*/

typedef enum 
{
    /* No change in the state of the CMP1 & CMP2 output
	*/
    NOCHANGE_IN_C1_C2 = 0x00,
	
	 /* Only CMP1 output state changed
	*/
	CHANGE_IN_C1 = 0x40,
	
	 /* Only CMP2 output state changed
	*/
    CHANGE_IN_C2 = 0x80,
	
	 /* Both CMP1 & CMP2 output state changed
	*/
    CHANGE_IN_C1_C2 = 0xC0
}CMPstateChange_t;

/**
  Section: CMP APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the Dual CMP module.

  @Description
    This routine initializes the Dual CMP.
    This routine must be called before any other CMP routine is called.
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
    CMPstateChange_t CMPStateChange;
	
    CMP_Initialize();

    while(1)
    {
        CMPStateChange = CMP_GetOutputState();
        switch (CMPStateChange)
        {
            case NOCHANGE_IN_C1_C2:
                 //do something
                 break;

            case CHANGE_IN_C1:
                 //do something
                 break;

            case CHANGE_IN_C2:
                 //do something
                 break;

            case CHANGE_IN_C1_C2:
                 //do something
                 break;

            default:
                  break;
                }
    }
    </code>
*/
void CMP_Initialize(void);
</#list>

/**
  @Summary
   	Returns the change in CMP1 & CMP2 output state.

  @Description
   This routine Returns the change in CMP1 & CMP2 output state.

  @Preconditions
    The ${moduleNameUpperCase} initializer routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    Returns the below CMPx state changes.
    i.e. 
	0x00 -> No change happened in CMP1 & CMP2 output state
    0x40 -> Only CMP1 output sate changed
    0x80 -> Only CMP2 output sate changed
    0xC0 -> Both CMP1 & CMP2 output state changed

  @Example
    <code>
    Refer initializer example code
    </code>
*/
uint8_t CMP_OutputStateChangeGet(void);

/**
  @Summary
    Gets the dual CMP output status.

  @Description
    This routine gets the dual CMP output status.

  @Preconditions
    The CMP initializer routine should be called
    prior to use this routine.

  @Param
    None

  @Returns
    high  - if the dual CMP output is high.
    low   - if the dual CMP output is low.

  @Example
    <code>
    </code>
*/
bool ${moduleNameUpperCase}_OutputStatusGet(void);

<#if interruptEnabled>
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
void ${isrName}(void);
</#if>


#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/

