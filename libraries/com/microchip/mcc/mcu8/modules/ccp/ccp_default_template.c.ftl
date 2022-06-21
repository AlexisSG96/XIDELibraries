/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
         MPLAB 	          :  ${tool}
*/

${disclaimer}

#include <xc.h>
#include "${moduleNameLowerCase}.h"
<#list initializers as initializer>
void ${initializer}(void)
{
    <#list initRegisters_Default as reg>
	
	// ${reg.comment}
	${reg.name} = ${reg.value};    
	</#list>
}
</#list>

<#if usesInterrupt>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;
}
</#if>