/**
  Generated Pin Manager File

  Company:
    Microchip Technology Inc.

  File Name:
    pin_manager.c

  Summary:
    This is the Pin Manager file generated using ${productName}

  Description:
    This header file provides implementations for pin APIs for all pins selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.1.2
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}

    Copyright (c) 2013 - 2015 released Microchip Technology Inc.  All rights reserved.
*/

${disclaimer}

#include "pin_manager.h"

<#if isInterruptEnabled>
void (*IOC_InterruptHandler)(void);
</#if>

void PIN_MANAGER_Initialize(void)
{
    /**
    LATx registers
    */
<#list LATReg as lat>
    ${lat.name} = ${lat.value};
</#list>

    /**
    TRISx registers
    */
<#list TRISReg as tris>
    ${tris.name} = ${tris.value};
</#list>

    /**
    ANSELx registers
    */
<#list ANSELReg as ansel>
    ${ansel.name} = ${ansel.value};
</#list>

    /**
    WPUx registers
    */
<#list WPUReg as wpu>
    ${wpu.name} = ${wpu.value};
</#list>
<#-- CT: we need to add this in order to set nWPUEN which is OPTION_REG -->    
<#if isWeakPullupEnRegAvailable>
    ${WeakPullupEnRegName} = ${WeakPullUpEnRegValue};
</#if>
<#if isPortDWeakPullupEnRegAvailable>
    ${PortDWeakPullupEnRegName} = ${PortDWeakPullUpEnRegValue};
</#if>
<#if isPortEWeakPullupEnRegAvailable>
    ${PortEWeakPullupEnRegName} = ${PortEWeakPullUpEnRegValue};
</#if>
<#-- CT: support for devices that have RBPU -->      
<#if isPortPullupEnRegAvailable>
    ${PortPullupEnRegName} = ${PortPullupEnRegValue};
</#if>

<#if ODReg?has_content>
    /**
    ODx registers
    */
<#list ODReg as od>
    ${od.name} = ${od.value};
</#list>
</#if>

<#if SLRCONReg?has_content>
    /**
    SLRCONx registers
    */
<#list SLRCONReg as slrcon>
    ${slrcon.name} = ${slrcon.value};
</#list>
</#if>

<#if INLVLReg?has_content>
    /**
    INLVLx registers
    */
<#list INLVLReg as inlvl>
    ${inlvl.name} = ${inlvl.value};
</#list>

</#if>
<#if PPSReg?has_content>
    /**
    RPINRx and RPORx registers
    */
<#list PPSReg as ppsData>
    ${ppsData.name} = ${ppsData.value};
</#list>
</#if>
   
<#if isInterruptEnabled>
	// register default IOC callback functions at runtime; use these methods to register a custom function
    IOC_SetInterruptHandler(IOC_DefaultInterruptHandler);
	
    // Enable ${InterruptName} interrupt 
    ${InterruptEnableBit} = 1; 
</#if>

}

void PIN_MANAGER_IOC(void)
{	
	<#if InterruptName != "IOCI">
	// Clear global Interrupt-On-Change flag
    ${GroupInterruptFlag} = 0;
	</#if>	
	<#if isInterruptEnabled>
	if(IOC_InterruptHandler)
    {
        IOC_InterruptHandler();
    }
	</#if>
}

<#if isInterruptEnabled>
/**
  Allows selecting an interrupt handler for IOC at application runtime
*/
void IOC_SetInterruptHandler(void (* InterruptHandler)(void)){
    IOC_InterruptHandler = InterruptHandler;
}

/**
  Default interrupt handler for IOC
*/
void IOC_DefaultInterruptHandler(void){
    // add your IOC interrupt custom code
    // or set custom function using IOC_SetInterruptHandler()
}
</#if>
/**
 End of File
*/