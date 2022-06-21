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

#include <xc.h>
<#list initializers as initializer>
/**
 * Initialization routine that takes inputs from the GUI.
 * @prototype        void ${initializer}(void)
 * @param           none
 * @return           none
 * @comment          
 * @usage            ${initializer}();
 */
void ${initializer}(void);
</#list>

#endif  // ${moduleNameUpperCase}.h