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

#include <xc.h>
#include <stdbool.h>
    
/**
    Section: Defines
*/ 
   
/**
    Defines: the segments pins
*/
<#list segRegisters as data >
#define ${data.name}      ${data.value}
</#list>

<#if pixelMacros?size != 0>
<#list pixelMacros as data >
#define ${data.name}      ${data.value}
</#list>

<#list oldPixelMap as data >
#define ${data.name}      ${data.value}
</#list>

/**
    Defines: To Turn on a pixel (a segment from a digit or a special character)
*/
<#list pixelMacros as data >
#define ${data.name}ON     ${data.name} = 1
</#list>

<#list oldPixelMap as data >
#define ${data.name}ON     ${data.value}ON
</#list>
/**
    Defines: To Turn off a pixel (a segment from a digit or a special character)
*/
<#list pixelMacros as data >
#define ${data.name}OFF    ${data.name} = 0
</#list>
<#list oldPixelMap as data >
#define ${data.name}OFF     ${data.value}OFF
</#list>
</#if>
<#if oldNumSymbolMacros?size != 0>
/**
    Defines: To support seven segment number 
*/
<#list oldNumSymbolMacros as data>
#define LCD_DisplayOn_${data.name}Num() LCD_DisplayOn_${data.value}Num()
#define LCD_DisplayOff_${data.name}Num() LCD_DisplayOff_${data.value}Num()   
#define LCD_${data.name}Num(num) LCD_${data.value}Num(num)
</#list> 
</#if>
/**
  Section: Interface Routines
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase} module

  @Description
    This routine should only be called once during system initialization.    

  @Preconditions
    None.

  @Param
    None.

  @Returns
    None.

  @Example
    <code>
    ${initializer}();
    </code>     
*/
void ${initializer}(void);
</#list>

/**
    @Summary
        Enable ${moduleNameUpperCase} module
        
    @Description
        This routine enables ${moduleNameUpperCase} module.   
        
    @Preconditions
        None.

    @Param
        None.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_Enable();
        </code>     
*/
void ${moduleNameUpperCase}_Enable (void);

/**
    @Summary
        Disable ${moduleNameUpperCase} module
        
    @Description
        This routine disables ${moduleNameUpperCase} module.   
        
    @Preconditions
        None.

    @Param
        None.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_Disable();
        </code>     
*/
void ${moduleNameUpperCase}_Disable (void);

/**
    @Summary
        Enable sleep mode for ${moduleNameUpperCase} module
        
    @Description
        This routine enables the sleep mode for ${moduleNameUpperCase} module.
        
    @Preconditions
        None.

    @Param
        None.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_EnableSleepMode();
        </code>     
*/
void ${moduleNameUpperCase}_EnableSleepMode (void);

/**
    @Summary
        Disable sleep mode for ${moduleNameUpperCase} module
        
    @Description
        This routine disables the sleep mode for ${moduleNameUpperCase} module.
        
    @Preconditions
        None.

    @Param
        None.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_DisableSleepMode();
        </code>     
*/
void ${moduleNameUpperCase}_DisableSleepMode (void);

/**
    @Summary
        Set contrast for ${moduleNameUpperCase} module
        
    @Description
        This routine set the contrast value for ${moduleNameUpperCase} module.
        
    @Preconditions
       If The internal reference source bit is 0, then the internal ${moduleNameUpperCase}contrast control is unconnected.

    @Param
        Pass the contrast bits value.
        This range for this value is specific for each device.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_SetContrast (value);
        </code>     
*/
void ${moduleNameUpperCase}_SetContrast (unsigned int value);

/**
    @Summary
        Set ${moduleNameUpperCase} module power mode for A interval.
        
    @Description
        This routine set the ${moduleNameUpperCase} module reference ladder A time
        power control.
        
    @Preconditions
        None.

    @Param
        Pass the power bits value.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_SetIntervalAPowerMode (value);
        </code>     
*/
void ${moduleNameUpperCase}_SetIntervalAPowerMode (unsigned int value);

/**
    @Summary
        Set ${moduleNameUpperCase} module power mode for B interval.
        
    @Description
        This routine set the ${moduleNameUpperCase} module reference ladder B time
        power control.
        
    @Preconditions
        None.

    @Param
        Pass the power bits value.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_SetIntervalBPowerMode (value);
        </code>     
*/
void ${moduleNameUpperCase}_SetIntervalBPowerMode (unsigned int value);

/**
    @Summary
        Set ${moduleNameUpperCase} module power distribution.
        
    @Description
        This routine set the ${moduleNameUpperCase} module power distribution during
        waveform intervals.
        
    @Preconditions
        None.

    @Param
        Pass the power bits value.

    @Returns
        None.
      
    @Example
        <code>
        ${moduleNameUpperCase}_SetPowerDistribution (value);
        </code>     
*/
void ${moduleNameUpperCase}_SetPowerDistribution (unsigned int value);

/**
    @Summary
        Returns true if the ${moduleNameUpperCase} module is active, otherwise false.
        
    @Description
        This routine is used to determine if the ${moduleNameUpperCase} module is active.
        
    @Preconditions
        None.

    @Param
        Node.

    @Returns
        true  - If module is active.
        false - If module is not active.
      
    @Example
        <code>
         ${moduleNameUpperCase}_Initialize();
         while(!${moduleNameUpperCase}_IsActive()); // wait until the module is available
        </code>     
*/
bool ${moduleNameUpperCase}_IsActive (void);

<#if interruptAvailable >
/**
    @Summary
        Return true if the write is disabled. 
        
    @Description
        This method returns the status of WERR bit. This is set when the user attepts to write
        when the write is disabled.
        
    @Preconditions
        None.

    @Param
        Node.

    @Returns
        true  - If the write is disabled and the user attempts to write. 
        false - If everithing works properly. 
      
    @Example
        <code>
   
        </code>     
*/
bool ${moduleNameUpperCase}_HasWriteFailureOccurred (void);

/**
    @Summary
        
    @Description
        
    @Preconditions
        None.

    @Param
        Node.

    @Returns
        true  - 
        false - 
      
    @Example
        <code>
   
        </code>     
*/
bool ${moduleNameUpperCase}_IsWritingAllowed (void);
</#if>

<#if useInterrupt>
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
 void ${interruptFunction}(void);
 </#if>

 <#list numSymbolMacros as data>
/**
  @Summary
    Displays on all the defined pixels for digit ${data.name}

  @Description
    This routine displays on all the defined pixels for digit ${data.name}

  @Returns
    None

  @Param
    None
  
  @Example
        <code>
        void LCD_DisplayOn_${data.name}Num();
        </code>
*/
void LCD_DisplayOn_${data.name}Num();

/**
  @Summary
    Displays off all the defined pixels for digit ${data.name}

  @Description
    This routine displays off all the defined pixels for digit ${data.name}

  @Returns
    None

  @Param
    None
  
  @Example
        <code>
        void LCD_DisplayOff_${data.name}Num();
        </code>
*/
void LCD_DisplayOff_${data.name}Num();    
/**
  @Summary
    Display a char for digit ${data.name}

  @Description
    This routine displays a specific char for lcd's digit ${data.name}

  @Returns
    None

  @Param
    The needed char
  
  @Example
        <code>
        void LCD_${data.name}Num ('5');
        </code>      
*/
void LCD_${data.name}Num (unsigned char num);
</#list> 
#endif /*_LCD_H*/