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
void ${moduleNameUpperCase}_Initialize(void)
{
    // Set the CWG to the options selected in ${productName}
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>
}
</#list>

void ${moduleNameUpperCase}_LoadRiseDeadbandCount(uint8_t dutyValue)
{
    ${CWGDBRRegName} = dutyValue;
}

void ${moduleNameUpperCase}_LoadFallDeadbandCount(uint8_t dutyValue)
{
    ${CWGDBFRegName} = dutyValue;
}

void ${moduleNameUpperCase}_AutoShutdownEventSet()
{
    ${GASESettingName} = 1;
}

void ${moduleNameUpperCase}_AutoShutdownEventClear()
{
    ${GASESettingName} = 0;
}
/**
 End of File
*/
