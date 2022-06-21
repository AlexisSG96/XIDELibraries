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
        Driver Version    :  1.0.0
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

//Pointers to ${moduleNameUpperCase} interrupt handlers
//User can use them in application code to initialize with custom ISRs
static void (*${moduleNameUpperCase}_Slice1Output1_InterruptHandler)(void);   //SaP1IF and hence PWMxIF is set
static void (*${moduleNameUpperCase}_Slice1Output2_InterruptHandler)(void);   //SaP2IF and hence PWMxIF is set
static void (*${moduleNameUpperCase}_Period_InterruptHandler)(void);          //PWMxPIF is set
static void ${moduleNameUpperCase}_Slice1Output1_DefaultInterruptHandler(void);
static void ${moduleNameUpperCase}_Slice1Output2_DefaultInterruptHandler(void);
static void ${moduleNameUpperCase}_Period_DefaultInterruptHandler(void);

void ${moduleNameUpperCase}_Initialize(void)
{
    //${PWMERS.csvComment}
    ${PWMERS.name} = ${PWMERS.hexValue};

    //${PWMCLK.csvComment}
    ${PWMCLK.name} = ${PWMCLK.hexValue};

    //${PWMLDS.csvComment}
    ${PWMLDS.name} = ${PWMLDS.hexValue};

    //${PWMPRL.csvComment}
    ${PWMPRL.name} = ${PWMPRL.hexValue};

    //${PWMPRH.csvComment}
    ${PWMPRH.name} = ${PWMPRH.hexValue};

    //${PWMCPRE.csvComment}
    ${PWMCPRE.name} = ${PWMCPRE.hexValue};

    //${PWMPIPOS.csvComment}
    ${PWMPIPOS.name} = ${PWMPIPOS.hexValue};

    //${PWMGIR.csvComment}
    ${PWMGIR.name} = ${PWMGIR.hexValue};

    //${PWMGIE.csvComment}
    ${PWMGIE.name} = ${PWMGIE.hexValue};

    //${PWMS1CFG.csvComment}
    ${PWMS1CFG.name} = ${PWMS1CFG.hexValue};

    //${PWMS1P1L.csvComment}
    ${PWMS1P1L.name} = ${PWMS1P1L.hexValue};

    //${PWMS1P1H.csvComment}
    ${PWMS1P1H.name} = ${PWMS1P1H.hexValue};

    //${PWMS1P2L.csvComment}
    ${PWMS1P2L.name} = ${PWMS1P2L.hexValue};

    //${PWMS1P2H.csvComment}
    ${PWMS1P2H.name} = ${PWMS1P2H.hexValue};
    
    //Clear ${moduleNameUpperCase} period interrupt flag
    ${PWMPI_FLAG.name} = 0;
    
    //Clear ${moduleNameUpperCase} interrupt flag
    ${PWMI_FLAG.name} = 0;
    
    //Clear ${moduleNameUpperCase} slice 1, output 1 interrupt flag
    ${PWMGIR.name}bits.S1P1IF = 0;
    
    //Clear ${moduleNameUpperCase} slice 1, output 2 interrupt flag
    ${PWMGIR.name}bits.S1P2IF = 0;
    
    //${moduleNameUpperCase} interrupt enable bit
<#if isPWMInterruptEnabled>
    ${PWMI_ENABLE.name} = 1;
<#else>
    ${PWMI_ENABLE.name} = 0;
</#if>
    
    //${moduleNameUpperCase} period interrupt enable bit
<#if isPWMPeriodInterruptEnabled>  
    ${PWMPI_ENABLE.name} = 1;
<#else>
    ${PWMPI_ENABLE.name} = 0;
</#if>
    
    //Set default interrupt handlers
    ${moduleNameUpperCase}_Slice1Output1_SetInterruptHandler(${moduleNameUpperCase}_Slice1Output1_DefaultInterruptHandler);
    ${moduleNameUpperCase}_Slice1Output2_SetInterruptHandler(${moduleNameUpperCase}_Slice1Output2_DefaultInterruptHandler);
    ${moduleNameUpperCase}_Period_SetInterruptHandler(${moduleNameUpperCase}_Period_DefaultInterruptHandler);

    //${PWMCON.csvComment}
    ${PWMCON.name} = ${PWMCON.hexValue};
}

void ${moduleNameUpperCase}_Enable()
{
    ${PWMCON.name} |= _${pwmUpperCase}CON_EN_MASK;
}

void ${moduleNameUpperCase}_Disable()
{
    ${PWMCON.name} &= (~_${pwmUpperCase}CON_EN_MASK);
}

void ${moduleNameUpperCase}_WritePeriodRegister(uint16_t periodCount)
{
    ${PWMPRL.name} = (uint8_t)periodCount;
    ${PWMPRH.name} = (uint8_t)(periodCount >> 8);
}

void ${moduleNameUpperCase}_SetSlice1Output1DutyCycleRegister(uint16_t registerValue)
{    
    ${PWMS1P1L.name} = (uint8_t)(registerValue);
    ${PWMS1P1H.name} = (uint8_t)(registerValue >> 8);
}

void ${moduleNameUpperCase}_SetSlice1Output2DutyCycleRegister(uint16_t registerValue)
{        
    ${PWMS1P2L.name} = (uint8_t)(registerValue);
    ${PWMS1P2H.name} = (uint8_t)(registerValue >> 8);
}

void ${moduleNameUpperCase}_LoadBufferRegisters(void)
{
    //Load the period and duty cycle registers on the next period event
    ${PWMCON.name}bits.LD = 1;
}

<#if isVectoredInterrupt>
<#if isHighPriorityPWMI>
void __interrupt(irq(${PWMI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_PWMI_ISR()
<#else>
void __interrupt(irq(${PWMI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_PWMI_ISR()
</#if>
<#else>
void ${moduleNameUpperCase}_PWMI_ISR(void)
</#if>
{
    ${PWMI_FLAG.name} = 0;
    if((${PWMGIE.name}bits.S1P1IE == 1) && (${PWMGIR.name}bits.S1P1IF == 1))
    {
        ${PWMGIR.name}bits.S1P1IF = 0;
        if(${moduleNameUpperCase}_Slice1Output1_InterruptHandler != NULL)
            ${moduleNameUpperCase}_Slice1Output1_InterruptHandler();
    }
    else if((${PWMGIE.name}bits.S1P2IE == 1) && (${PWMGIR.name}bits.S1P2IF == 1))
    {
        ${PWMGIR.name}bits.S1P2IF = 0;
        if(${moduleNameUpperCase}_Slice1Output2_InterruptHandler != NULL)
            ${moduleNameUpperCase}_Slice1Output2_InterruptHandler();
    }
}

<#if isVectoredInterrupt>
<#if isHighPriorityPWMPI>
void __interrupt(irq(${PWMPI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_PWMPI_ISR()
<#else>
void __interrupt(irq(${PWMPI_HANDLER.name?replace("_", "")}),low_priority) ${moduleNameUpperCase}_PWMPI_ISR()
</#if>
<#else>
void ${moduleNameUpperCase}_PWMPI_ISR(void)
</#if>
{
    ${PWMPI_FLAG.name} = 0;
    if(${moduleNameUpperCase}_Period_InterruptHandler != NULL)
        ${moduleNameUpperCase}_Period_InterruptHandler();
}

void ${moduleNameUpperCase}_Slice1Output1_SetInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Slice1Output1_InterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_Slice1Output2_SetInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Slice1Output2_InterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_Period_SetInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_Period_InterruptHandler = InterruptHandler;
}

static void ${moduleNameUpperCase}_Slice1Output1_DefaultInterruptHandler(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_Slice1Output1_SetInterruptHandler() function to use Custom ISR
}

static void ${moduleNameUpperCase}_Slice1Output2_DefaultInterruptHandler(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_Slice1Output2_SetInterruptHandler() function to use Custom ISR
}

static void ${moduleNameUpperCase}_Period_DefaultInterruptHandler(void)
{
    //Add your interrupt code here or
    //Use ${moduleNameUpperCase}_Period_SetInterruptHandler() function to use Custom ISR
}
