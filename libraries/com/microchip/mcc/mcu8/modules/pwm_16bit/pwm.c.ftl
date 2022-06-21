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
void ${initializer}(void)
{
    // set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initRegisters as reg>

     //${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>

    <#if useInterrupt>
    // Clear the ${moduleNameUpperCase} interrupt flag
    ${flagName} = 0;
        
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBitName} = 1;
</#if>
}    

</#list>

void ${moduleNameUpperCase}_Start(void)
{
    ${PWMCONRegister}bits.${enableBitName} = 1;		
}

void ${moduleNameUpperCase}_Stop(void)
{
    ${PWMCONRegister}bits.${enableBitName} = 0;		
}

bool ${moduleNameUpperCase}_CheckOutputStatus(void)
{
    return (${PWMCONRegister}bits.${pwmoutBitName});		
}

void ${moduleNameUpperCase}_LoadBufferSet(void)
{
    ${PWMLDCONRegister}bits.${loadBufferBitName} = 1;		
}

void ${moduleNameUpperCase}_PhaseSet(uint16_t phaseCount)
{
    ${PhaseHighRegister} = (phaseCount>>8);        //writing 8 MSBs to PWMPHH register
    ${PhaseLowRegister} = (phaseCount);           //writing 8 LSBs to PWMPHL register
}

void ${moduleNameUpperCase}_DutyCycleSet(uint16_t dutyCycleCount)
{
    ${DutyCycleHighRegister} = (dutyCycleCount>>8);	//writing 8 MSBs to PWMDCH register
    ${DutyCycleLowRegister} = (dutyCycleCount);	//writing 8 LSBs to PWMDCL register		
}

void ${moduleNameUpperCase}_PeriodSet(uint16_t periodCount)
{
    ${PeriodHighRegister} = (periodCount>>8);	//writing 8 MSBs to PWMPRH register
    ${PeriodLowRegister} = (periodCount);	//writing 8 LSBs to PWMPRL register		
}

void ${moduleNameUpperCase}_OffsetSet(uint16_t offsetCount)
{
    ${OffsetHighRegister} = (offsetCount>>8);	//writing 8 MSBs to PWMOFH register
    ${OffsetLowRegister} = (offsetCount);	//writing 8 LSBs to PWMOFL register		
}

uint16_t ${moduleNameUpperCase}_TimerCountGet(void)
{
    return ((uint16_t)((${TimerHighRegister}<<8) | ${TimerLowRegister}));       		
}

bool ${moduleNameUpperCase}_IsOffsetMatchOccured(void)
{
    return (${INTFRegister}bits.${OffsetInterruptFlag});		
}

bool ${moduleNameUpperCase}_IsPhaseMatchOccured(void)
{
    return (${INTFRegister}bits.${PhaseInterruptFlag});	
}

bool ${moduleNameUpperCase}_IsDutyCycleMatchOccured(void)
{
    return (${INTFRegister}bits.${DutyCycleInterruptFlag});		
}

bool ${moduleNameUpperCase}_IsPeriodMatchOccured(void)
{
    return (${INTFRegister}bits.${PeriodInterruptFlag});		
}

<#if useInterrupt>
void ${moduleNameUpperCase}_ISR(void)
{   
    ${flagName} = 0;
    <#if periodFlag>
    if(${INTFRegister}bits.${PeriodInterruptFlag})
    {
        ${moduleNameUpperCase}_Period();            
    }
    </#if>
    <#if phaseFlag>
    if(${INTFRegister}bits.${PhaseInterruptFlag})
    {
        ${moduleNameUpperCase}_Phase();
    }
    </#if>
    <#if dutycycleFlag>
    if(${INTFRegister}bits.${DutyCycleInterruptFlag})
    {
        ${moduleNameUpperCase}_DutyCycle();
    }
    </#if>
    <#if offsetFlag>
    if(${INTFRegister}bits.${OffsetInterruptFlag})
    {
        ${moduleNameUpperCase}_Offset();
    } 
    </#if>
}

<#if periodFlag>
void ${moduleNameUpperCase}_Period(void)
{
    ${INTFRegister}bits.${PeriodInterruptFlag} = 0;        
}
</#if>

<#if phaseFlag>
void ${moduleNameUpperCase}_Phase(void)
{
    ${INTFRegister}bits.${PhaseInterruptFlag} = 0;        
}
</#if>
    
<#if dutycycleFlag>
void ${moduleNameUpperCase}_DutyCycle(void)
{
    ${INTFRegister}bits.${DutyCycleInterruptFlag} = 0;        
}
</#if>
    
<#if offsetFlag>
void ${moduleNameUpperCase}_Offset(void)
{
    ${INTFRegister}bits.${OffsetInterruptFlag} = 0;        
}
</#if>
</#if>
/**
 End of File
*/


