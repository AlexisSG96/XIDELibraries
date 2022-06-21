/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  Summary:
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef _${filePrefix}${moduleNameUpperCase}_H
#define _${filePrefix}${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
        
<#list initializers as initializer>
/**
 * Initialization routine that takes inputs from the GUI.
 * @prototype        void ${functionPrefix}${moduleNameUpperCase}_${initializer}(void)
 * @param            none
 * @return           none
 * @comment          
 * @usage            ${functionPrefix}${moduleNameUpperCase}_${initializer}();
 */
void ${functionPrefix}${moduleNameUpperCase}_${initializer}(void);
</#list>

#ifdef __cplusplus  // Provide C++ Compatibility
}
#endif

#endif	//_${filePrefix}${moduleNameUpperCase}_H
/**
 End of File
*/