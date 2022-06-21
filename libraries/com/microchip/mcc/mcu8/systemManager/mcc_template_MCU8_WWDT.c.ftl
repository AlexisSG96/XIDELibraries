/**
  @Generated ${productName} Source File

  @Company:
    Microchip Technology Inc.

  @File Name:
    mcc.c

  @Summary:
    This is the mcc.c file generated using ${productName}

  @Description:
    This header file provides implementations for driver APIs for all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.00
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#include "mcc.h"

<#if (selectedDevice == "PIC10F320") || (selectedDevice == "PIC10LF320")>
#if (__XC8_VERSION < 1430)
asm("psect functab,global,class=CODE,reloc=0x1,delta=2");
#endif // __XC8_VERSION
</#if>

void SYSTEM_Initialize(void)
{
<#if useInterruptManager>
    <#if ifPIC18>
    INTERRUPT_Initialize();
    </#if>
</#if>
<#list moduleInitializers as initializer>
    ${initializer}();
</#list>
<#if DMAavailable>
    SystemArbiter_Initialize();
</#if>
}

void OSCILLATOR_Initialize(void)
{
    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
    <#if isPLLEnabled>
    // Wait for PLL to stabilize
    while(${pllrBitName} == 0)
    {
    }
    </#if>
}

<#if PMDavailable>
void PMD_Initialize(void)
{
    <#list PMDregisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};
    </#list>
}
</#if>


<#if isWWDTEnabled>
void WWDT_Initialize(void)
{
    // Initializes the WWDT to the default states configured in the MCC GUI
    WDTCON0 = WDTCPS;
    WDTCON1 = WDTCWS|WDTCCS;
    
}

void WWDT_SoftEnable(void)
{
    // WWDT software enable. 
    WDTCON0bits.SEN=1;
}

void WWDT_SoftDisable(void)
{
    // WWDT software disable.
    WDTCON0bits.SEN=0;
}

bool WWDT_TimeOutStatusGet(void)
{
    // Return the status of WWDT time out reset.
    return (${PCONRegister}bits.nRWDT);
}

bool WWDT_WindowViolationStatusGet(void)
{
   // Return the status of WWDT window violation reset.
    return (${PCONRegister}bits.nWDTWV); 
}  

void WWDT_TimerClear(void)
{
    // Disable the interrupt,read back the WDTCON0 reg for arming, 
    // clearing the WWDT and enable the interrupt.
    uint8_t readBack=0;
    
    bool state = GIE;
    GIE = 0;
    readBack = WDTCON0;
    CLRWDT();
    GIE = state;
}
</#if>
<#if DMAavailable>
void SystemArbiter_Initialize(void)
{
    // This function is dependant on the PR1WAY CONFIG bit
    ${PriorityLockRegister} = 0x55;
    ${PriorityLockRegister} = 0xAA;
    ${PriorityLockRegister}bits.${PriorityLockedBit} = 1;
}
</#if>
/**
 End of File
*/
