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
         Driver Version    :  2.11
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

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>



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
    ${moduleNameUpperCase}_Initialize();
    </code>
*/
void ${moduleNameUpperCase}_Initialize(void);
</#list>

<#if bridgeEnabled>
/**
  @Summary
    This function would write the rising dead band count into ${moduleNameUpperCase}DBR registers

  @Description
    This function can be used to modify rising dead band count of CWG on the fly

    When module is disabled, the ${moduleNameUpperCase}DBR register is loaded immediately when
    ${moduleNameUpperCase}DBR is written. When module is enabled, then software must set the
    ${moduleNameUpperCase}CON0<LD> bit, and the buffer will be loaded at the next falling edge of
    the CWG input signal.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    value - 6 bit digital rising dead band count to CWG.

  @Example
    <code>
    uint8_t myDutyValue;

    ${moduleNameUpperCase}_Initialize();

    // do something

    CWG1_LoadRiseDeadbandCount(myDutyValue);

    if(CWG1_IsModuleEnabled())
    { // yes
        CWG1_LoadBufferEnable();
    }
    </code>
*/
void ${moduleNameUpperCase}_LoadRiseDeadbandCount(uint8_t dutyValue);

/**
  @Summary
    This function would write the falling dead band count into ${moduleNameUpperCase}DBF registers

  @Description
    This function can be used to modify falling dead band count of CWG on the fly

    When module is disabled, the ${moduleNameUpperCase}DBF register is loaded immediately when
    ${moduleNameUpperCase}DBF is written. When module is enabled, then software must set the
    ${moduleNameUpperCase}CON0<LD> bit, and the buffer will be loaded at the rising edge of CWG
    input signal after the next falling edge (that is, after the falling-edge update.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    value - 6 bit digital falling dead band count to CWG.

  @Example
    <code>
    uint8_t myDutyValue;

    ${moduleNameUpperCase}_Initialize();

    // do something

    CWG1_LoadFallDeadbandCount(myDutyValue);

    if(CWG1_IsModuleEnabled())
    { // yes
        CWG1_LoadBufferEnable();
    }
    </code>
*/
void ${moduleNameUpperCase}_LoadFallDeadbandCount(uint8_t dutyValue);



/**
  @Summary
    This function sets the ${moduleNameUpperCase}CON0<LD> bit

  @Description
    This function enables the ${moduleNameUpperCase} module to load the buffers on the next
	rising/falling event of the input signal.
	
	The ${moduleNameUpperCase}CON0<LD> bit can only be set after EN = 1 and cannot be set in the same 
	instruction that EN is set.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called and the EN bit
	has to be set before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    Refer ${moduleNameUpperCase}_LoadFallDeadbandCount() example.
    </code>
*/
void ${moduleNameUpperCase}_LoadBufferEnable(void);

/**
  @Summary
    Returns ${moduleNameUpperCase} module enable status

  @Description
    Returns the status of whether the ${moduleNameUpperCase} module is enabled or not

  @Preconditions
    None

  @Returns
    Returns ${moduleNameUpperCase} module enable status

  @Param
    None

  @Example
    <code>
    Refer ${moduleNameUpperCase}_LoadFallDeadbandCount() example.
    </code>
*/
bool ${moduleNameUpperCase}_IsModuleEnabled(void);
</#if>

/**
  @Summary
    Software generated Shutdown event

  @Description
    This function forces the CWG into Shutdown state.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    
    // do something
    
    ${moduleNameUpperCase}_AutoShutdownEventSet();
    </code>
*/
void ${moduleNameUpperCase}_AutoShutdownEventSet();

/**
  @Summary
    This function makes the CWG to resume its operations from the software
    generated shutdown state.

  @Description
    When auto-restart is disabled, the shutdown state will persist as long as the
    ${moduleNameUpperCase}AS0<SHUTDOWN> bit is set and hence to resume operations, this function should be used.

    However when auto-restart is enabled, the ${moduleNameUpperCase}AS0<SHUTDOWN> bit will be cleared automatically
    and resume operation on the next rising edge event. In that case, there is no
    need to call this function.

  @Preconditions
    ${moduleNameUpperCase}_Initialize() and ${moduleNameUpperCase}_AutoShutdownEventSet() functions should have been called before calling this function

  @Returns
    None

  @Param
    None

  @Example
    <code>
    ${moduleNameUpperCase}_Initialize();
    
    // Do something
    
    ${moduleNameUpperCase}_AutoShutdownEventSet();

    // Do something
    
    ${moduleNameUpperCase}_AutoShutdownEventClear();
    </code>
*/
void ${moduleNameUpperCase}_AutoShutdownEventClear();

<#if interruptEnabled>
<#if isVectoredInterruptEnabled>
<#else>
/** Function:
  void ${moduleNameUpperCase}_ISR(void)

  Summary:
    Interrupt Service Routine for the CWG Peripheral

  Description:
    This is the interrupt service routine for the RTCC peripheral. Add in code if 
    required in the ISR. 
*/
void ${moduleNameUpperCase}_ISR(void);
</#if>
</#if>

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  // ${moduleNameUpperCase}_H
/**
 End of File
*/