/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
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
#include "${moduleNameLowerCase}.h"

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
}
</#list>
/**
 End of File
*/
