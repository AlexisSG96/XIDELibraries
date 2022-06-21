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
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${filePrefix}${moduleNameLowerCase}.h"

/**
  Section: HLVD Module APIs
*/

<#list initializers as initializer>
void ${functionPrefix}${moduleNameUpperCase}_${initializer}(void)
{
    // set the ${moduleNameUpperCase}_${initializer} module to the options selected in the User Interface
    <#list initUIRegisters as reg>
     // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    ${interruptflagBitName} = 0;
    <#if useInterrupt>
    // Enable ${moduleNameUpperCase} interrupt.
    ${interruptenableBitName} = 1;
    </#if>
}
</#list>

bool ${functionPrefix}${moduleNameUpperCase}_IsReferenceVoltageStable(void)
{
    //return internal reference voltage status
    return(${hlvdOutRegister}bits.${IRVSTSetting});
}

<#if BGVSTSetting??>
bool ${functionPrefix}${moduleNameUpperCase}_IsBandGapVoltageStable(void)
{
    //return band gap voltage status
    return(${hlvdOutRegister}bits.${BGVSTSetting});
}

</#if>
void ${functionPrefix}${moduleNameUpperCase}_Enable(void)
{
    // enable HLVD module
    <#assign reg = hlvdOutRegister>
    ${reg}bits.${HLVDENSetting} = 1;
    ${interruptflagBitName} = 0;
    <#if useInterrupt>
    // Enable ${moduleNameUpperCase} interrupt.
    ${interruptenableBitName} = 1;
    </#if>
}

void ${functionPrefix}${moduleNameUpperCase}_Disable(void)
{
    // disable HLVD module
    ${hlvdOutRegister}bits.${HLVDENSetting} = 0; 
    <#if useInterrupt>
     //clear interrupt flag
    ${interruptflagBitName} = 0;
     // Disable ${moduleNameUpperCase} interrupt.
    ${interruptenableBitName} = 0;
    </#if>
}

void ${functionPrefix}${moduleNameUpperCase}_TripPointSetup(HLVD_TRIP_DIRECTION direction,
        HLVD_TRIP_POINTS trip_points)
{
   //set Voltage trip direction
   ${hlvdOutRegister}bits.${VDIRMAGSetting} = direction;
   // Set trip points
   ${hlvdOutRegister}bits.${HLVDLSetting} = trip_points;
}

<#if useInterrupt>
<#if selectedDevice?contains("PIC24")>
void __attribute__ (( interrupt, no_auto_psv )) _ISR ${interrupt.handlerName}( void )
<#else>
void ${moduleNameUpperCase}_${interruptFunction}(void)

</#if>
<#else>
void ${functionPrefix}${moduleNameUpperCase}_Tasks( void )
</#if>
{
    /* TODO : Add interrupt handling code */
    ${interruptflagBitName} = 0;
}

/**
 End of File
*/
