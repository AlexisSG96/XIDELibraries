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
        Driver Version    :  2.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

#include "pin_manager.h"


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
    PCFG setting
    */   
    ${ConfigurationControlBitsName} = ${ConfigurationControlBitsValue};


    
    
  
   
	<#if isInterruptOnChangeEnabled>
	// Enable RBI interrupt
    ${GlobalInterruptOnChangeEnableBit} = 1;
    </#if>
}

<#-- If IOC interrupt is enabled/disabled, IOC routine should be available: MCCV3XX-4105 
if IOCI is disabled through interrupt enable bit, IOCI-related methods should still be available-->
<#-- Vectored interrupt is not supported for PIX16FxxJ60 devices -->
void PIN_MANAGER_IOC(void)
{
    <#if isInterruptOnChangeEnabled>
	
	// Clear global Interrupt-On-Change flag
    ${GlobalInterruptOnChangeFlag} = 0;
    </#if>

}

/**
 End of File
*/
