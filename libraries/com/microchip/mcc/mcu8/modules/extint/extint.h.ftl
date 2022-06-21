/**
   ${moduleNameUpperCase} Generated Driver File
 
   @Company
     Microchip Technology Inc.
 
   @File Name
     ${moduleNameLowerCase}.c
 
   @Summary
     This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}
 
   @Description
     This source file provides implementations for driver APIs for ${moduleNameUpperCase}.
     Generation Information :
         Product Revision  :  ${productName} - ${productVersion}
         Device            :  ${selectedDevice}
         Driver Version    :  1.11
     The generated drivers are tested against the following:
         Compiler          :  ${compiler}
         MPLAB             :  ${tool}
 */ 

${disclaimer}

#ifndef _${moduleNameUpperCase}_H
#define _${moduleNameUpperCase}_H

/**
    Section: Includes
*/
#include <xc.h>

// Provide C++ Compatibility
#ifdef __cplusplus  

extern "C" {

#endif

/**
    Section: Macros
*/
<#list allocatedPins as intPin>
<#-- if intPin.interruptEnabled -->
/**
  @Summary
    Clears the interrupt flag for ${intPin.functionName}

  @Description
    This routine clears the interrupt flag for the external interrupt, ${intPin.functionName}.
 
  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    <code>
    void ${intPin.functionName}_ISR(void)
    {
        // User Area Begin->code

        // User Area End->code
        ${intPin.customName}_InterruptFlagClear();
    }
    </code>

*/
#define ${intPin.customName}_InterruptFlagClear()       (${intPin.flagName} = 0)

/**
  @Summary
    Clears the interrupt enable for ${intPin.functionName}

  @Description
    This routine clears the interrupt enable for the external interrupt, ${intPin.functionName}.
    After calling this routine, external interrupts on this pin will not be serviced by the 
    interrupt handler, ${intPin.functionName}.

  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    Changing the external interrupt edge detect from negative to positive
    <code>
    // clear the interrupt enable
    ${intPin.customName}_InterruptDisable();
    // change the edge
    ${intPin.customName}_${intPin.edge}EdgeSet();
    // clear the interrupt flag and re-enable the interrupt
    ${intPin.customName}_InterruptFlagClear();
    ${intPin.customName}_InterruptEnable();
    </code>

*/
#define ${intPin.customName}_InterruptDisable()     (${intPin.enableBitName} = 0)

/**
  @Summary
    Sets the interrupt enable for ${intPin.functionName}

  @Description
    This routine sets the interrupt enable for the external interrupt, ${intPin.functionName}.
    After calling this routine, external interrupts on this pin will be serviced by the 
    interrupt handler, ${intPin.functionName}.
 
  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    Setting the external interrupt to handle positive edge interrupts
    <code>
    // set the edge
    ${intPin.customName}_${intPin.edge}EdgeSet();
    // clear the interrupt flag and enable the interrupt
    ${intPin.customName}_InterruptFlagClear();
    ${intPin.customName}_InterruptEnable();
    </code>

*/
#define ${intPin.customName}_InterruptEnable()       (${intPin.enableBitName} = 1)

/**
  @Summary
    Sets the edge detect of the external interrupt to negative edge.

  @Description
    This routine set the edge detect of the extern interrupt to negative edge.  
    After this routine is called the interrupt flag will be set when the external 
    interrupt pins level transitions from a high to low level.
 
  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    Setting the external interrupt to handle negative edge interrupts
    <code>
    // set the edge
    ${intPin.customName}_${intPin.edge}EdgeSet();
    // clear the interrupt flag and enable the interrupt
    ${intPin.customName}_InterruptFlagClear();
    ${intPin.customName}_InterruptEnable();
    </code>

*/
#define ${intPin.customName}_risingEdgeSet()          (${intPin.SFREdgeDetectFromPin} = 1)

/**
  @Summary
    Sets the edge detect of the external interrupt to positive edge.

  @Description
    This routine set the edge detect of the extern interrupt to positive edge.  
    After this routine is called the interrupt flag will be set when the external 
    interrupt pins level transitions from a low to high level.
 
  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    Setting the external interrupt to handle positive edge interrupts
    <code>
    // set the edge
    ${intPin.customName}_${intPin.edge}EdgeSet();
    // clear the interrupt flag and enable the interrupt
    ${intPin.customName}_InterruptFlagClear();
    ${intPin.customName}_InterruptEnable();
    </code>

*/
#define ${intPin.customName}_fallingEdgeSet()          (${intPin.SFREdgeDetectFromPin} = 0)
<#-- /#if -->
</#list>
/**
    Section: External Interrupt Initializers
 */
<#list initializers as initializer>
/**
  @Summary
    Initializes the external interrupt pins

  @Description
    This routine initializes the ${moduleNameUpperCase} driver to detect the configured edge, clear
    the interrupt flag and enable the interrupt.

    The following external interrupts will be initialized:
<#list allocatedPins as pin>
    <#-- if pin.interruptEnabled -->
    ${pin.functionName} - ${pin.customName}
    <#-- /#if -->
</#list>    
 
  @Preconditions
    None.

  @Returns
    None.

  @Param
    None.

  @Example
    Initialize the external interrupt pins
    <code>
    ${initializer}();
    </code>

*/
void ${initializer}(void);

</#list>
/**
   Section: External Interrupt Handlers
 */
<#list allocatedPins as intPin>
<#if vectoredInterruptEnabled>
<#else>
<#-- if intPin.interruptEnabled -->
/**
  @Summary
    Interrupt Service Routine for ${intPin.customName} - ${intPin.functionName} pin

  @Description
    This ISR will execute whenever the signal on the ${intPin.functionName} pin will transition to the preconfigured state.
    
  @Preconditions
    ${moduleNameUpperCase} intializer called

  @Returns
    None.

  @Param
    None.

*/
void ${intPin.functionName}_ISR(void);
</#if>

/**
  @Summary
    Callback function for ${intPin.customName} - ${intPin.functionName}

  @Description
    Allows for a specific callback function to be called in the ${intPin.functionName} ISR.
    It also allows for a non-specific interrupt handler to be called at runtime.
    
  @Preconditions
    ${moduleNameUpperCase} intializer called

  @Returns
    None.

  @Param
    None.

  @Example
    ${moduleNameUpperCase}_Initializer();
    void ${intPin.functionName}_CallBack();

*/
void ${intPin.functionName}_CallBack(void);

/**
  @Summary
    Interrupt Handler Setter for ${intPin.customName} - ${intPin.functionName} pin

  @Description
    Allows selecting an interrupt handler for ${intPin.customName} - ${intPin.functionName} at application runtime
    
  @Preconditions
    ${moduleNameUpperCase} intializer called

  @Returns
    None.

  @Param
    InterruptHandler function pointer.

  @Example
    ${moduleNameUpperCase}_Initializer();
    ${intPin.functionName}_SetInterruptHandler(MyInterruptHandler);

*/
void ${intPin.functionName}_SetInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Dynamic Interrupt Handler for ${intPin.customName} - ${intPin.functionName} pin

  @Description
    This is the dynamic interrupt handler to be used together with the ${intPin.functionName}_SetInterruptHandler() method.
    This handler is called every time the ${intPin.functionName} ISR is executed and allows any function to be registered at runtime. 
    
  @Preconditions
    ${moduleNameUpperCase} intializer called

  @Returns
    None.

  @Param
    None.

  @Example
    ${moduleNameUpperCase}_Initializer();
    ${intPin.functionName}_SetInterruptHandler(${intPin.functionName}_InterruptHandler);

*/
extern void (*${intPin.functionName}_InterruptHandler)(void);

/**
  @Summary
    Default Interrupt Handler for ${intPin.customName} - ${intPin.functionName} pin

  @Description
    This is a predefined interrupt handler to be used together with the ${intPin.functionName}_SetInterruptHandler() method.
    This handler is called every time the ${intPin.functionName} ISR is executed. 
    
  @Preconditions
    ${moduleNameUpperCase} intializer called

  @Returns
    None.

  @Param
    None.

  @Example
    ${moduleNameUpperCase}_Initializer();
    ${intPin.functionName}_SetInterruptHandler(${intPin.functionName}_DefaultInterruptHandler);

*/
void ${intPin.functionName}_DefaultInterruptHandler(void);
<#-- /#if -->
</#list>

// Provide C++ Compatibility
#ifdef __cplusplus  

}

#endif
#endif
