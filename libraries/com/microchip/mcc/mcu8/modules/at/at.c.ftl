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

/**
  Section: Included Files
*/

#include <xc.h>
#include "mcc.h"
#include "${moduleNameLowerCase}.h"

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
void ${initializer}(void)
{
    // set the ${moduleNameUpperCase} to the options selected in the User Interface
<#list initRegisters as register>
    // ${register.comment}
    ${register.name} = ${register.value};
</#list>

<#if useInterrupt>
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${interruptFlagName} = 0;
        
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;
</#if>
}
</#list>


void ${moduleNameUpperCase}_ResolutionSet(uint16_t resolution)
{
    ${resolutionHighRegister} = (uint8_t)((resolution & 0x0300)>>8);	//writing 2 MSBs to AT1RESH register
    ${resolutionLowRegister} = (uint8_t)(resolution & 0x00FF);	//writing 8 LSBs to AT1RESL register	
}

void ${moduleNameUpperCase}_MissingPulseDelaySet(int16_t missingPulse)
{
    ${missingPulseHighRegister} = (uint8_t)(((uint16_t)missingPulse & 0xFF00)>>8);	//writing 8 MSBs to AT1MISSH register
    ${missingPulseLowRegister} = (uint8_t)((uint16_t)missingPulse & 0x00FF);		//writing 8 LSBs to AT1MISSL register
}

void ${moduleNameUpperCase}_SetPointLoad(uint16_t thresholdPeriod)
{
    ${pointLoadHighRegister} = (uint8_t)((thresholdPeriod & 0x7F00)>>8);	//writing 7 MSBs to AT1STPTH register
    ${pointLoadLowRegister} = (uint8_t)(thresholdPeriod & 0x00FF);       //writing 8 LSBs to AT1STPTL register
}

uint16_t ${moduleNameUpperCase}_PeriodGet(void)
{
    return ((uint16_t)((${periodHighRegister} << 8) | ${periodLowRegister}));		//return 15 bit (Period) AT1PER register
}

uint16_t ${moduleNameUpperCase}_PhaseGet(void)
{
    return ((uint16_t)((${phaseHighRegister} << 8) | ${phaseLowRegister}));		//return 10 bit (Phase)AT1PHS register
}

int16_t ${moduleNameUpperCase}_SetPointErrorGet(void)
{
    return ((uint16_t)((${errorHighRegister} << 8) | ${errorLowRegister}));		//return 16 bit AT1ERR register
}

bool ${moduleNameUpperCase}_CheckPeriodValue(void)
{
    return (${accelerationSignBit});
}

bool ${moduleNameUpperCase}_IsMeasurementValid(void)
{
    return (${validMeasurementBit});
}

bool ${moduleNameUpperCase}_IsPeriodCounterOverflowOccured(void)
{
    return (${periodOverflowBit});
}

bool ${moduleNameUpperCase}_IsPeriodCountAvailable(void)
{
    return (${periodInterruptFlag});
}

bool ${moduleNameUpperCase}_IsPhaseCountAvailable(void)
{
    return (${phaseInterruptFlag});
}

bool ${moduleNameUpperCase}_IsMissedPulseCountAvailable(void)
{
    return (${missingPulseInterruptFlag});
}

<#if isCapture1Mode>
uint16_t ${moduleNameUpperCase}_CC1_Capture_Read(void)
{
    return ((uint16_t)((${cc1HighRegister}<<8) | ${cc1LowRegister}));
}

bool ${moduleNameUpperCase}_CC1_IsCaptureDataReady(void)
{
    return (${cc1InterruptFlag});
}
</#if>

<#if isCompare1Mode>
void ${moduleNameUpperCase}_CC1_Compare_SetCount(uint16_t compareCount)
{
    ${cc1HighRegister} = ((compareCount & 0x0300)>>8);
    ${cc1LowRegister} = (compareCount & 0x00FF);	
}

bool ${moduleNameUpperCase}_CC1_Compare_IsMatchOccured(void)
{
    return (${cc1InterruptFlag});
}
</#if>

<#if isCapture2Mode>
uint16_t ${moduleNameUpperCase}_CC2_Capture_Read(void)
{
    return ((uint16_t)((${cc2HighRegister}<<8) | ${cc2LowRegister}));
}

bool ${moduleNameUpperCase}_CC2_IsCaptureDataReady(void)
{
    return (${cc2InterruptFlag});
}
</#if>

<#if isCompare2Mode>
void ${moduleNameUpperCase}_CC2_Compare_SetCount(uint16_t compareCount)
{
    ${cc2HighRegister} = ((compareCount & 0x0300)>>8);
    ${cc2LowRegister} = (compareCount & 0x00FF);	
}

bool ${moduleNameUpperCase}_CC2_Compare_IsMatchOccured(void)
{
    return (${cc2InterruptFlag});
}
</#if>

<#if isCapture3Mode>
uint16_t ${moduleNameUpperCase}_CC3_Capture_Read(void)
{
    return ((uint16_t)((${cc3HighRegister}<<8) | ${cc3LowRegister}));
}

bool ${moduleNameUpperCase}_CC3_IsCaptureDataReady(void)
{
    return (${cc3InterruptFlag});
}
</#if>

<#if isCompare3Mode>
void ${moduleNameUpperCase}_CC3_Compare_SetCount(uint16_t compareCount)
{
    ${cc3HighRegister} = ((compareCount & 0x0300)>>8);
    ${cc3LowRegister} = (compareCount & 0x00FF);	
}

bool ${moduleNameUpperCase}_CC3_Compare_IsMatchOccured(void)
{
    return (${cc3InterruptFlag});
}
</#if>

<#if useInterrupt>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
{
    ${interruptFlagName} = 0;
    <#if isPeriodInterruptEnabled>
    if(${periodInterruptFlag})
    {
        ${moduleNameUpperCase}_Period();
    }
    </#if>
    <#if isPhaseInterruptEnabled>    
    if(${phaseInterruptFlag})
    {
        ${moduleNameUpperCase}_Phase();
    }
    </#if>
    <#if isMissingPulseInterruptEnabled>
    if(${missingPulseInterruptFlag})
    {
        ${moduleNameUpperCase}_MissingPulseDelay();
    }
    </#if>
    <#if cc1Interrupt>
    if(${cc1InterruptFlag})
    {
        ${moduleNameUpperCase}_CC1();
    }
    </#if>
    <#if cc2Interrupt>
    if(${cc2InterruptFlag})
    {
        ${moduleNameUpperCase}_CC2();
    }
    </#if>
    <#if cc3Interrupt>
    if(${cc3InterruptFlag})
    {
        ${moduleNameUpperCase}_CC3();
    }
    </#if>    
}

<#if isPeriodInterruptEnabled>
void ${moduleNameUpperCase}_Period(void)
{
    ${periodInterruptFlag} = 0;
}
</#if>

<#if isPhaseInterruptEnabled>
void ${moduleNameUpperCase}_Phase(void)
{
    ${phaseInterruptFlag} = 0;
}
</#if>

<#if isMissingPulseInterruptEnabled>
void ${moduleNameUpperCase}_MissingPulseDelay(void)
{
    ${missingPulseInterruptFlag} = 0;
}
</#if>

<#if cc1Interrupt>
void ${moduleNameUpperCase}_CC1(void)
{
    ${cc1InterruptFlag} = 0;
}
</#if>

<#if cc2Interrupt>
void ${moduleNameUpperCase}_CC2(void)
{
    ${cc2InterruptFlag} = 0;
}
</#if>

<#if cc3Interrupt>
void ${moduleNameUpperCase}_CC3(void)
{
    ${cc3InterruptFlag} = 0;
}
</#if>
</#if>
        
/**
 End of File
*/