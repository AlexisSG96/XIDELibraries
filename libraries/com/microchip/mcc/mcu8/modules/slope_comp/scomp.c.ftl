/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

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

/**
  Section: Included Files
*/

#include <xc.h>
#include "${filePrefix}${moduleNameLowerCase}.h"

<#list initializers as initializer>
/**
  Prototype:        void ${functionPrefix}${moduleNameUpperCase}_${initializer}(void)
  Input:            none
  Output:           none
  Description:      ${functionPrefix}${moduleNameUpperCase}_${initializer} is an
                    initialization routine that takes inputs from the GUI.
  Comment:          
  Usage:            ${functionPrefix}${moduleNameUpperCase}_${initializer}();
*/


void ${functionPrefix}${moduleNameUpperCase}_${initializer}(void)
{
    <#list  initUIRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
}
</#list>