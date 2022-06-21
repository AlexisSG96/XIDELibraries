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
    // Disable module before configuring
    LCDCONbits.LCDEN = 0;

    // set the ${moduleNameUpperCase} to the options selected in the User Interface
    <#list initUIRegisters as data >
    // ${data.comment}
    ${data.name} = ${data.value};
    
	</#list>
    //SegCom Data Registers
    <#list initLCDDataRegisters as data >
	${data.name} = ${data.value};
	</#list>
    
	//Enable used segments
	<#list initSEGRegisters as data >
	${data.name} = ${data.value};
	</#list>
	
	<#list lcdPostReg as data >
    // ${data.comment}
    ${data.name} = ${data.value};
	</#list>
	
	<#if useInterrupt>
    // Clearing IF flag before enabling the interrupt.
    ${interruptFlagName} = 0;    
    
    // Enabling ${moduleNameUpperCase} interrupt.
    ${interruptEnableBit} = 1;
    </#if>     
}
</#list>

void ${moduleNameUpperCase}_Enable (void)
{
    LCDCONbits.LCDEN = 1;
}

void ${moduleNameUpperCase}_Disable (void)
{
    LCDCONbits.LCDEN = 0;    
}

void ${moduleNameUpperCase}_EnableSleepMode (void)
{
    LCDCONbits.SLPEN = 1;
}

void ${moduleNameUpperCase}_DisableSleepMode (void) 
{
    LCDCONbits.SLPEN = 0;    
}

void ${moduleNameUpperCase}_SetContrast (unsigned int value)
{
    ${contrastReg}bits.LCDCST = value;
}

void ${moduleNameUpperCase}_SetIntervalAPowerMode (unsigned int value)
{
    LCDRLbits.LRLAP = value;      
}

void ${moduleNameUpperCase}_SetIntervalBPowerMode (unsigned int value)
{
    LCDRLbits.LRLBP = value;      
}

void ${moduleNameUpperCase}_SetPowerDistribution (unsigned int value)
{
    LCDRLbits.LRLAT = value;       
}

bool ${moduleNameUpperCase}_IsActive (void)
{
    return LCDPSbits.LCDA;
}
<#if interruptAvailable >
bool ${moduleNameUpperCase}_HasWriteFailureOccurred (void)
{
    return LCDCONbits.WERR;
}

bool ${moduleNameUpperCase}_IsWritingAllowed (void)
{
    return LCDPSbits.WA;    
}
</#if>

<#if useInterrupt>
void ${interruptFunction}(void)
{
    // Clear interrupt flag
    ${interruptFlagName} = 0;
}
</#if>
<#list numSymbolMacros as data>
void LCD_DisplayOn_${data.name}Num()
{
	${data.pixelsA}ON;${data.pixelsB}ON;${data.pixelsC}ON;${data.pixelsD}ON;${data.pixelsE}ON;${data.pixelsF}ON;${data.pixelsG}ON;
}

void LCD_DisplayOff_${data.name}Num()
{
	${data.pixelsA}OFF;${data.pixelsB}OFF;${data.pixelsC}OFF;${data.pixelsD}OFF;${data.pixelsE}OFF;${data.pixelsF}OFF;${data.pixelsG}OFF;
}

void LCD_${data.name}Num (unsigned char num) 
{
    switch (num)
    {
        case 0: ${data.pixelsA}ON;   ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}ON;   ${data.pixelsE}ON;   ${data.pixelsF}ON;   ${data.pixelsG}OFF;  break;
        case 1: ${data.pixelsA}OFF;  ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}OFF;  ${data.pixelsE}OFF;  ${data.pixelsF}OFF;  ${data.pixelsG}OFF;  break;
        case 2: ${data.pixelsA}ON;   ${data.pixelsB}ON;   ${data.pixelsC}OFF;  ${data.pixelsD}ON;   ${data.pixelsE}ON;   ${data.pixelsF}OFF;  ${data.pixelsG}ON;   break;
        case 3: ${data.pixelsA}ON;   ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}ON;   ${data.pixelsE}OFF;  ${data.pixelsF}OFF;  ${data.pixelsG}ON;   break;
        case 4: ${data.pixelsA}OFF;  ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}OFF;  ${data.pixelsE}OFF;  ${data.pixelsF}ON;   ${data.pixelsG}ON;   break;
        case 5: ${data.pixelsA}ON;   ${data.pixelsB}OFF;  ${data.pixelsC}ON;   ${data.pixelsD}ON;   ${data.pixelsE}OFF;  ${data.pixelsF}ON;   ${data.pixelsG}ON;   break;
        case 6: ${data.pixelsA}ON;   ${data.pixelsB}OFF;  ${data.pixelsC}ON;   ${data.pixelsD}ON;   ${data.pixelsE}ON;   ${data.pixelsF}ON;   ${data.pixelsG}ON;   break;
        case 7: ${data.pixelsA}ON;   ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}OFF;  ${data.pixelsE}OFF;  ${data.pixelsF}OFF;  ${data.pixelsG}OFF;  break;
        case 8: ${data.pixelsA}ON;   ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}ON;   ${data.pixelsE}ON;   ${data.pixelsF}ON;   ${data.pixelsG}ON;   break;
        case 9: ${data.pixelsA}ON;   ${data.pixelsB}ON;   ${data.pixelsC}ON;   ${data.pixelsD}ON;   ${data.pixelsE}OFF;  ${data.pixelsF}ON;   ${data.pixelsG}ON;   break;

        default: ${data.pixelsA}OFF; ${data.pixelsB}OFF; ${data.pixelsC}OFF; ${data.pixelsD}OFF; ${data.pixelsE}OFF; ${data.pixelsF}OFF; ${data.pixelsG}OFF;
    }    
}

</#list>
// end of file