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
   Section: Macro Declarations
 */

 #define PWM${instanceNumber}_INITIALIZE_DUTY_VALUE    ${dutyCycleValue}

 /**
   Section: PWM Module APIs
 */

<#list initializers as initializer>
 /**
   @Summary
     Initializes the PWM${instanceNumber}

   @Description
     This routine initializes the EPWM${instanceNumber}_Initialize
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
     uint16_t dutycycle;

     ${initializer}();
     PWM${instanceNumber}_LoadDutyValue(dutycycle);
     </code>
  */
 void ${initializer}(void);
</#list>

 /**
   @Summary
     Loads 16-bit duty cycle.

   @Description
     This routine loads the 16 bit duty cycle value.

   @Preconditions
     PWM${instanceNumber}_Initialize() function should have been called 
         before calling this function.

   @Param
     Pass 16bit duty cycle value.

   @Returns
     None

   @Example
     <code>
     uint16_t dutycycle;

     PWM${instanceNumber}_Initialize();
     PWM${instanceNumber}_LoadDutyValue(dutycycle);
     </code>
 */
 void PWM${instanceNumber}_LoadDutyValue(uint16_t dutyValue);

 
 #ifdef __cplusplus  // Provide C++ Compatibility

     }

 #endif

 #endif	//PWM${instanceNumber}_H
 /**
  End of File
 */