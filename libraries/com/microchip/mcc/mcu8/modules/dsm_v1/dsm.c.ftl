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
    // set the ${moduleNameUpperCase} to the options selected in the User Interface
    
    // Modulator Pin Output is ${MDOE_Com}
    ${MDOE_Bit} = ${MDOE_Val}; 

    // Modulator Output Pin Slew Rate is ${MDSLR_Com}
    ${MDSLR_Bit} = ${MDSLR_Val}; 

    // Modulator Output Pin Polarity is ${MDPOL_Com}
    ${MDOPOL_Bit} = ${MDOPOL_Val}; 

    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>
    // ${MDEN_Com} the Modulator
    ${MDEN_Bit} = ${MDEN_Val};  

}
</#list>

void ${moduleNameUpperCase}_ManualModulationSet (void)
{
    // Set MDBIT to High, Modulator uses high carrier source
    ${MDBIT_Bit} = 1;
}

void ${moduleNameUpperCase}_ManualModulationClear (void)
{
    // Set MDBIT to Low, Modulator uses low carrier source
    ${MDBIT_Bit} = 0;
}

void ${moduleNameUpperCase}_ManualModulationToggle (void)
{
    // Toggle the MDBIT
    ${MDBIT_Bit} ^= 1;
}

void ${moduleNameUpperCase}_ModulationStart (void)
{
    // Enables module and begins modulation
    ${MDEN_Bit} = 1;
}

void ${moduleNameUpperCase}_ModulationStop (void)
{
    // Disables module and stops modulation
    ${MDEN_Bit} = 0;
}

void ${moduleNameUpperCase}_ModulatorOutputEnable (void)
{
    ${MDOE_Bit} = 1;
}

void ${moduleNameUpperCase}_ModulatorOutputDisable (void)
{
    ${MDOE_Bit} = 0;
}
/**
 End of File
*/