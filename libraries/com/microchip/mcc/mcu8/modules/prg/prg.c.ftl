/**
  ${moduleNameUpperCase} Generated Driver  File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.01
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
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

bool ${moduleNameUpperCase}_IsReady(void)
{
    return (${prgRampGenReadyBit});
}

void ${moduleNameUpperCase}_StartRampGeneration(void)
{
    // Start the PRG module by set GO bit
    ${prgRampGenControlStartBit} = 1;
}

void ${moduleNameUpperCase}_StopRampGeneration(void)
{
    // Stop the PRG module by clearing GO bit
    ${prgRampGenControlStartBit} = 0;
}

void ${moduleNameUpperCase}_EnableOneShot(void)
{
    // Enable One-Shot mode by setting OS bit
    ${prgEnableOneShotBit} = 1;
}

void ${moduleNameUpperCase}_DisableOneShot(void)
{
    // Disable One-Shot mode by clearing OS bit
    ${prgEnableOneShotBit} = 0;
}

void ${moduleNameUpperCase}_UpdateSlope(uint8_t slopeValue )
{
    ${prgRampGenerationUpdateSlopeBit} = (slopeValue & 0x1F);
}

/**
 End of File
*/
