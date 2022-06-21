/**
  @Generated Pin Manager Header File

  @Company:
    Microchip Technology Inc.

  @File Name:
    pin_manager.h

  @Summary:
    This is the Pin Manager file generated using ${productName}

  @Description
    This header file provides APIs for driver for .
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.11
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}	
*/

${disclaimer}

#ifndef PIN_MANAGER_H
#define PIN_MANAGER_H

/**
  Section: Included Files
*/

#include <xc.h>

#define INPUT   1
#define OUTPUT  0

#define HIGH    1
#define LOW     0

#define ANALOG      1
#define DIGITAL     0

#define PULL_UP_ENABLED      1
#define PULL_UP_DISABLED     0

<#list PORTbitsSettings as pin>
<#if !pin.isSystemPin && pin.isSelected>
<#if pin.customName?has_content>
// get/set ${pin.customName} aliases
<#if pin.trisName?has_content>
#define ${pin.customName}_TRIS                 ${pin.trisName}
</#if>
<#if pin.latName?has_content>
#define ${pin.customName}_LAT                  ${pin.latName}
</#if>
<#if pin.portName?has_content>
#define ${pin.customName}_PORT                 ${pin.portName}
</#if>
<#if pin.wpuName?has_content>
#define ${pin.customName}_WPU                  ${pin.wpuName}
</#if>
<#if pin.odName?has_content>
#define ${pin.customName}_OD                   ${pin.odName}
</#if>
<#if pin.anselName?has_content>
#define ${pin.customName}_ANS                  ${pin.anselName}
</#if>
<#if pin.latName?has_content>
#define ${pin.customName}_SetHigh()            do { ${pin.latName} = 1; } while(0)
#define ${pin.customName}_SetLow()             do { ${pin.latName} = 0; } while(0)
#define ${pin.customName}_Toggle()             do { ${pin.latName} = ~${pin.latName}; } while(0)
</#if>
<#if pin.portName?has_content>
#define ${pin.customName}_GetValue()           ${pin.portName}
</#if>
<#if pin.trisName?has_content>
#define ${pin.customName}_SetDigitalInput()    do { ${pin.trisName} = 1; } while(0)
#define ${pin.customName}_SetDigitalOutput()   do { ${pin.trisName} = 0; } while(0)
</#if>
<#if pin.wpuName?has_content>
#define ${pin.customName}_SetPullup()          do { ${pin.wpuName} = 1; } while(0)
#define ${pin.customName}_ResetPullup()        do { ${pin.wpuName} = 0; } while(0)
</#if>
<#if pin.odName?has_content>
#define ${pin.customName}_SetPushPull()        do { ${pin.odName} = 0; } while(0)
#define ${pin.customName}_SetOpenDrain()       do { ${pin.odName} = 1; } while(0)
</#if>
<#if pin.anselName?has_content>
#define ${pin.customName}_SetAnalogMode()      do { ${pin.anselName} = 1; } while(0)
#define ${pin.customName}_SetDigitalMode()     do { ${pin.anselName} = 0; } while(0)
</#if>
<#else>// get/set ${pin.pinName} procedures
<#if pin.latName?has_content>
#define ${pin.pinName}_SetHigh()            do { ${pin.latName} = 1; } while(0)
#define ${pin.pinName}_SetLow()             do { ${pin.latName} = 0; } while(0)
#define ${pin.pinName}_Toggle()             do { ${pin.latName} = ~${pin.latName}; } while(0)
</#if>
<#if pin.portName?has_content>
#define ${pin.pinName}_GetValue()              ${pin.portName}
</#if>
<#if pin.trisName?has_content>
#define ${pin.pinName}_SetDigitalInput()    do { ${pin.trisName} = 1; } while(0)
#define ${pin.pinName}_SetDigitalOutput()   do { ${pin.trisName} = 0; } while(0)
</#if>
<#if pin.wpuName?has_content>
#define ${pin.pinName}_SetPullup()             do { ${pin.wpuName} = 1; } while(0)
#define ${pin.pinName}_ResetPullup()           do { ${pin.wpuName} = 0; } while(0)
</#if>
<#if pin.anselName?has_content>
#define ${pin.pinName}_SetAnalogMode()         do { ${pin.anselName} = 1; } while(0)
#define ${pin.pinName}_SetDigitalMode()        do { ${pin.anselName} = 0; } while(0)
</#if>
</#if>
</#if>

</#list>
/**
   @Param
    none
   @Returns
    none
   @Description
    GPIO and peripheral I/O initialization
   @Example
    PIN_MANAGER_Initialize();
 */
void PIN_MANAGER_Initialize (void);

<#if isVectoredInterruptEnabled>
<#-- If IOC vectored interrupt is enabled, IOC routine should not be available -->
<#else>
<#-- If IOC interrupt is enabled/disabled, IOC routine should be available: MCCV3XX-4105 -->
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Interrupt on Change Handling routine
 * @Example
    PIN_MANAGER_IOC();
 */
void PIN_MANAGER_IOC(void);
</#if>


<#list PORTbitsSettings as pin>
<#if !pin.isSystemPin && pin.isSelected && pin.isIOC>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Interrupt on Change Handler for the ${pin.iocFlagName} pin functionality
 * @Example
    ${pin.iocFlagName}_ISR();
 */
void ${pin.iocFlagName}_ISR(void);

/**
  @Summary
    Interrupt Handler Setter for ${pin.iocFlagName} pin interrupt-on-change functionality

  @Description
    Allows selecting an interrupt handler for ${pin.iocFlagName} at application runtime
    
  @Preconditions
    Pin Manager intializer called

  @Returns
    None.

  @Param
    InterruptHandler function pointer.

  @Example
    PIN_MANAGER_Initialize();
    ${pin.iocFlagName}_SetInterruptHandler(MyInterruptHandler);

*/
void ${pin.iocFlagName}_SetInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Dynamic Interrupt Handler for ${pin.iocFlagName} pin

  @Description
    This is a dynamic interrupt handler to be used together with the ${pin.iocFlagName}_SetInterruptHandler() method.
    This handler is called every time the ${pin.iocFlagName} ISR is executed and allows any function to be registered at runtime.
    
  @Preconditions
    Pin Manager intializer called

  @Returns
    None.

  @Param
    None.

  @Example
    PIN_MANAGER_Initialize();
    ${pin.iocFlagName}_SetInterruptHandler(${pin.iocFlagName}_InterruptHandler);

*/
extern void (*${pin.iocFlagName}_InterruptHandler)(void);

/**
  @Summary
    Default Interrupt Handler for ${pin.iocFlagName} pin

  @Description
    This is a predefined interrupt handler to be used together with the ${pin.iocFlagName}_SetInterruptHandler() method.
    This handler is called every time the ${pin.iocFlagName} ISR is executed. 
    
  @Preconditions
    Pin Manager intializer called

  @Returns
    None.

  @Param
    None.

  @Example
    PIN_MANAGER_Initialize();
    ${pin.iocFlagName}_SetInterruptHandler(${pin.iocFlagName}_DefaultInterruptHandler);

*/
void ${pin.iocFlagName}_DefaultInterruptHandler(void);


</#if>
</#list>

#endif // PIN_MANAGER_H
/**
 End of File
*/