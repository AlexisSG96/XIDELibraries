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

#include <xc.h>
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
    ${moduleNameUpperCase}_Initialize();
    </code>
*/
void ${moduleNameUpperCase}_Initialize(void);
</#list>

/**
  @Summary
    This function will write the rising dead band count into CWG registers

  @Description
    This function can be used to modify rising dead band count of CWG on the fly

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    value - 6 bit digital rising dead band count to CWG.

  @Example
    <code>
    uint8_t MyDutyValue;

    ${moduleNameUpperCase}_Initialize();
    
    // Do something
   
    ${moduleNameUpperCase}_LoadRiseDeadbandCount(MyDutyValue);
    </code>
*/
void ${moduleNameUpperCase}_LoadRiseDeadbandCount(uint8_t dutyValue);

/**
  @Summary
    This function will write the falling dead band count into CWG registers

  @Description
    This function can be used to modify falling dead band count of CWG on the fly

  @Preconditions
    ${moduleNameUpperCase}_Initialize() function should have been called before calling this function

  @Returns
    None

  @Param
    value - 6 bit digital falling dead band count to CWG.

  @Example
    <code>
    uint8_t MyDutyValue;

    ${moduleNameUpperCase}_initialize();
    
    // Do something
    
    ${moduleNameUpperCase}_LoadFallDeadbandCount(MyDutyValue);
    </code>
*/
void ${moduleNameUpperCase}_LoadFallDeadbandCount(uint8_t dutyValue);

/**
  @Summary
    Software generated Shutdown

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
    
    // Do something
    
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
    GxASE bit is set and hence to resume operations, this function should be used.

    However when auto-restart is enabled, the GxASE bit will clear automatically
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

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif  // ${moduleNameUpperCase}_H
/**
 End of File
*/