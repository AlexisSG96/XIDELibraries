/**
  @Generated Pin Manager Header File

  @Company:
    Microchip Technology Inc.

  @File Name:
    pin_manager.h

  @Summary:
    This is the Pin Manager file generated using ${productName}

  @Description:
    This header file provides implementations for pin APIs for all pins selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Version           :  2.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}

    Copyright (c) 2013 - 2015 released Microchip Technology Inc.  All rights reserved.
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
#define ${pin.customName}_TRIS                 ${pin.trisName}
#define ${pin.customName}_LAT                  ${pin.latName}
#define ${pin.customName}_PORT                 ${pin.portName}
<#if pin.anselName?has_content>
#define ${pin.customName}_ANS                  ${pin.anselName}
</#if>
#define ${pin.customName}_SetHigh()            do { ${pin.latName} = 1; } while(0)
#define ${pin.customName}_SetLow()             do { ${pin.latName} = 0; } while(0)
#define ${pin.customName}_Toggle()             do { ${pin.latName} = ~${pin.latName}; } while(0)
#define ${pin.customName}_GetValue()           ${pin.portName}
#define ${pin.customName}_SetDigitalInput()    do { ${pin.trisName} = 1; } while(0)
#define ${pin.customName}_SetDigitalOutput()   do { ${pin.trisName} = 0; } while(0)
<#if pin.anselName?has_content>
#define ${pin.customName}_SetAnalogMode()      do { ${pin.anselName} = 1; } while(0)
#define ${pin.customName}_SetDigitalMode()     do { ${pin.anselName} = 0; } while(0)
</#if>
<#else>// get/set ${pin.pinName} procedures
#define ${pin.pinName}_SetHigh()               do { ${pin.latName} = 1; } while(0)
#define ${pin.pinName}_SetLow()                do { ${pin.latName} = 0; } while(0)
#define ${pin.pinName}_Toggle()                do { ${pin.latName} = ~${pin.latName}; } while(0)
#define ${pin.pinName}_GetValue()              ${pin.portName}
#define ${pin.pinName}_SetDigitalInput()       do { ${pin.trisName} = 1; } while(0)
#define ${pin.pinName}_SetDigitalOutput()      do { ${pin.trisName} = 0; } while(0)
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

<#-- If IOC interrupt is enabled/disabled, IOC routine should be available: MCCV3XX-4105 -->
<#-- Vectored interrupt is not supported for PIX16FxxJ60 devices -->
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



#endif // PIN_MANAGER_H
/**
 End of File
*/