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
        Driver Version    :  3.0.0
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

<#if enableUTmrInterrupt>
void (*${moduleNameUpperCase}_InterruptHandler)(void);
</#if>

void ${moduleNameUpperCase}_Initialize(void)
{
    //Stop Timer
    ${TU16CON0.name}bits.ON = 0;
    <#if TU16CON1??>
    //${TU16CON1.csvComment}
    ${TU16CON1.name} = ${TU16CON1.hexValue};
    </#if>
    <#if TU16HLT??>
    //${TU16HLT.csvComment}
    ${TU16HLT.name} = ${TU16HLT.hexValue};
    </#if>
    <#if TU16CLK??>
    //${TU16CLK.csvComment}
    ${TU16CLK.name} = ${TU16CLK.hexValue};
    </#if>
    <#if TU16ERS??>
    //${TU16ERS.csvComment}
    ${TU16ERS.name} = ${TU16ERS.hexValue};
    </#if>
    <#if TU16PS??>
    //${TU16PS.csvComment}
    ${TU16PS.name} = ${TU16PS.hexValue};
    </#if>
    // Period Count Register Values
    ${TU16BPRH_REG} = ${TU16BPRH_VALUE};
    ${TU16BPRL_REG} = ${TU16BPRL_VALUE};
    <#if TU16PRH??>
    ${TU16PRH.name} = ${TU16PRH.hexValue};
    </#if>
    <#if TU16PRL??>
    ${TU16PRL.name} = ${TU16PRL.hexValue};
    </#if>
    // Timer Register values
    ${TU16BTMRH_REG} = ${TU16BTMRH_VALUE};
    ${TU16BTMRL_REG} = ${TU16BTMRL_VALUE};
    <#if TU16TMRH??>
    ${TU16TMRH.name} = ${TU16TMRH.hexValue};
    </#if>
    <#if TU16TMRL??>
    ${TU16TMRL.name} = ${TU16TMRL.hexValue};
    </#if>

    <#if TUCHAIN??>
    //${TUCHAIN.csvComment}
    ${TUCHAIN.name} = ${TUCHAIN.hexValue};
    </#if>
    <#if enableUTmrInterrupt>
    // Clearing IF flag before enabling the interrupt.
    ${TU16CON1.name}bits.PRIF = 0;
    ${TU16CON1.name}bits.ZIF = 0;
    ${TU16CON1.name}bits.CIF = 0;
    // Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    // Enabled TUI ${moduleNameUpperCase} interrupt
    ${TUI_ENABLE.name} = 1;
    <#else>
    // Disabled TUI ${moduleNameUpperCase} interrupt
    ${TUI_ENABLE.name} = 0;
    </#if>
    <#if TU16CON0??>
    //${TU16CON0.csvComment}
    ${TU16CON0.name} = ${TU16CON0.hexValue};
    </#if>
}

inline void ${moduleNameUpperCase}_StartTimer(void)
{
    ${TU16CON0.name}bits.ON = 1;
}

inline void ${moduleNameUpperCase}_StopTimer(void)
{
    ${TU16CON0.name}bits.ON = 0;
}

uint32_t ${moduleNameUpperCase}_ReadCaptureValue(void)
{
    ${TU16CON0.name}bits.RDSEL = 0;
    return (uint32_t)(((uint32_t)${TU16BCRH_REG} << 24) | ((uint32_t)${TU16BCRL_REG} << 16) | ((uint32_t)${TU16CRH.name}<< 8) | ${TU16CRL.name});
}

uint32_t ${moduleNameUpperCase}_CaptureOnCommand(void)
{
    ${TU16CON1.name}bits.CAPT = 1;
    while(${TU16CON1.name}bits.CAPT == 1);
    /* 
       The above while loop is blocking code.
       If CSYNC=1 and ON=0 (or freeze=1), this bit will not clear unless there's
       clock provided. User must be careful here.
       Also when CSYNC=1 and timer clock is very slow, it will take forever
       to clear this bit because it takes 3 timer clocks to synchronize.
    */
    return ${moduleNameUpperCase}_ReadCaptureValue();
}

uint32_t ${moduleNameUpperCase}_ReadTimer(void)
{
    return (uint32_t)(((uint32_t)${TU16BTMRH_REG} << 24) | ((uint32_t)${TU16BTMRL_REG} << 16) | ((uint32_t)${TU16TMRH.name}<< 8) | ${TU16TMRL.name});
}

void ${moduleNameUpperCase}_WriteTimer(uint32_t timerVal)
{
    ${TU16BTMRH_REG} = (uint8_t) ((timerVal >> 24) & 0xFF);
    ${TU16BTMRL_REG} = (uint8_t) ((timerVal >> 16) & 0xFF);
    ${TU16TMRH.name} = (uint8_t) (timerVal >> 8);
    ${TU16TMRL.name} = (uint8_t) (timerVal & 0xFF);
}

inline void ${moduleNameUpperCase}_ClearCounter(void)
{
    ${TU16CON1.name}bits.CLR = 1;
    while(${TU16CON1.name}bits.CLR == 1);
    /* 
       The above while loop is blocking code.
       If CSYNC=1 and ON=0 (or freeze=1), this bit will not clear unless there's
       clock provided. User must be careful here.
       Also when CSYNC=1 and timer clock is very slow, it will take forever
       to clear this bit because it takes 3 timer clocks to synchronize.
    */
}

void ${moduleNameUpperCase}_SetPeriodValue(uint32_t prVal)
{
    ${TU16BPRH_REG} = (uint8_t)((prVal >> 24) & 0xFF);
    ${TU16BPRL_REG} = (uint8_t)((prVal >> 16) & 0xFF);
    ${TU16PRH.name} = (uint8_t)((prVal >> 8) & 0xFF);
    ${TU16PRL.name} = (uint8_t)(prVal & 0xFF);
}

inline void ${moduleNameUpperCase}_EnablePRMatchInterrupt(void)
{
    ${TU16CON0.name}bits.PRIE = 1;
}

inline void ${moduleNameUpperCase}_DisablePRMatchInterrupt(void)
{
    ${TU16CON0.name}bits.PRIE = 0;
}

inline void ${moduleNameUpperCase}_EnableZeroInterrupt(void)
{
    ${TU16CON0.name}bits.ZIE = 1;
}

inline void ${moduleNameUpperCase}_DisableZeroInterrupt(void)
{
    ${TU16CON0.name}bits.ZIE = 0;
}

inline void ${moduleNameUpperCase}_EnableCaptureInterrupt(void)
{
    ${TU16CON0.name}bits.CIE = 1;
}

inline void ${moduleNameUpperCase}_DisableCaptureInterrupt(void)
{
    ${TU16CON0.name}bits.CIE = 0;
}

inline bool ${moduleNameUpperCase}_HasPRMatchOccured(void)
{
    return ${TU16CON1.name}bits.PRIF;
}

inline bool ${moduleNameUpperCase}_HasResetOccured(void)
{
    return ${TU16CON1.name}bits.ZIF;
}

inline bool ${moduleNameUpperCase}_HasCaptureOccured(void)
{
    return ${TU16CON1.name}bits.CIF;
}

inline bool ${moduleNameUpperCase}_IsTimerRunning(void)
{
    return ${TU16CON1.name}bits.RUN;
}

inline void ${moduleNameUpperCase}_EnableInterrupt(void)
{
    ${TUI_ENABLE.name} = 1;
}

inline void ${moduleNameUpperCase}_DisableInterrupt(void)
{
    ${TUI_ENABLE.name} = 0;
}

inline bool ${moduleNameUpperCase}_IsInterruptEnabled(void)
{
    return ${TUI_ENABLE.name};
}

inline void ${moduleNameUpperCase}_ClearInterruptFlags(void)
{
    ${TU16CON1.name}bits.PRIF = 0;
    ${TU16CON1.name}bits.ZIF = 0;
    ${TU16CON1.name}bits.CIF = 0;
}
<#if enableUTmrInterrupt>
<#if isVectoredInterrupt>
<#if isHighPriority>

void __interrupt(irq(${tuInterrupt}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ISR()
<#else>

void __interrupt(irq(${tuInterrupt}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ISR()
</#if>
<#else>

void ${moduleNameUpperCase}_ISR()
</#if>
{
    <#if enablePrMatchInterrupt>
    if(${TU16CON1.name}bits.PRIF == 1)
    {
        ${TU16CON1.name}bits.PRIF = 0;
    }

    </#if>
    <#if enableZeroInterrupt>
    if(${TU16CON1.name}bits.ZIF == 1)
    {
        ${TU16CON1.name}bits.ZIF = 0;
    }

    </#if>
    <#if enableCaptureInterrupt>
    if(${TU16CON1.name}bits.CIF == 1)
    {
        ${TU16CON1.name}bits.CIF = 0;
    }

    </#if>
    if(${moduleNameUpperCase}_InterruptHandler)
    {
        ${moduleNameUpperCase}_InterruptHandler();
    }

    // add your ${moduleNameUpperCase} interrupt custom code
}

void ${moduleNameUpperCase}_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_InterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_DefaultInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}_SetInterruptHandler()
}

</#if>