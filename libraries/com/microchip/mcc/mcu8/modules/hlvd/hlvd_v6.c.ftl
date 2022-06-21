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
        Driver Version    :  2.11
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
<#if useInterrupt>
<#if isVectoredInterrupt>
#include "interrupt_manager.h"
</#if>
</#if>

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


bool ${functionPrefix}${moduleNameUpperCase}_IsBandGapVoltageStable(void)
{    
      
    //return band gap voltage status
    return(${hlvdCON0Register}bits.${BGVSTSetting});
}


void ${functionPrefix}${moduleNameUpperCase}_Enable(void)
{
    // enable HLVD module
    
    ${hlvdCON0Register}bits.${HLVDENSetting} = 1;
    ${interruptflagBitName} = 0;
    <#if useInterrupt>
    // Enable ${moduleNameUpperCase} interrupt.
    ${interruptenableBitName} = 1;
    </#if>
}

void ${functionPrefix}${moduleNameUpperCase}_Disable(void)
{
    
    // disable HLVD module
    ${hlvdCON0Register}bits.${HLVDENSetting} = 0; 
    <#if useInterrupt>
     //clear interrupt flag
    ${interruptflagBitName} = 0;
     // Disable ${moduleNameUpperCase} interrupt.
    ${interruptenableBitName} = 0;
    </#if>
}

void ${functionPrefix}${moduleNameUpperCase}_TripPointSetup(bool Negative_Trip,bool Positive_Trip,
        HLVD_TRIP_POINTS trip_points)
{
   //set Negative trip
   ${hlvdCON0Register}bits.${HLVDINTLSetting} = Negative_Trip;
 //set Positive trip
   ${hlvdCON0Register}bits.${HLVDINTHSetting} = Positive_Trip;
   // Set trip points
   ${hlvdCON1Register} = trip_points;
}

bool ${moduleNameUpperCase}_OutputStatusGet(void)
{    
    <#assign reg = hlvdCON0Register>    
    //return HLVD voltage status
    return(${hlvdCON0Register}bits.${HLVDOUTSettting});
}

<#if useInterrupt>
<#if isVectoredInterrupt>
<#if isHighPriority>
void __interrupt(irq(${interruptIQRName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunction}()
<#else>
void __interrupt(irq(${interruptIQRName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunction}()
</#if>
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
