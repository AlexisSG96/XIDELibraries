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
         Compiler          :  ${compiler} or later
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
void ${moduleNameUpperCase}_${initializer}(void)
{	
        <#list initRegisters as register>
        // ${register.comment}
        ${register.name} = ${register.value};
        </#list>	
}
</#list>

void ${moduleNameUpperCase}_StartSimultaneously(void)
{
	${PWMEnableBitMirrorRegister} = 0xFF;	
}

void ${moduleNameUpperCase}_StopSimultaneously(void)
{
	${PWMEnableBitMirrorRegister} = 0;	
}

void ${moduleNameUpperCase}_LoadBufferSimultaneouslySet(void)
{
	${LDABitMirrorRegister} = 0xFF;	
}

uint8_t ${moduleNameUpperCase}_CheckOutputStatusSimultaneously(void)
{
	return (${PWMOutBitMirrorRegister});	
}

/**
 End of File
*/
