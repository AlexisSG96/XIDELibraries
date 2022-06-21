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
        Driver Version    :  2.11
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}

    Copyright (c) 2013 - 2015 released Microchip Technology Inc.  All rights reserved.
*/

${disclaimer}

#include "pin_manager.h"
<#if isInterruptEnabled>
<#if isVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>


<#assign isIocContentAvailable = false>
<#if iocFlagReg?has_content>
<#list PORTbitsSettings as list>
	<#if list.isIOC>
	<#assign isIocContentAvailable = true>
	<#break>
	</#if>
</#list>
</#if>

<#if isIocContentAvailable>
    <#if isDevicePIC12_L_F1612>
    <#-- This is to fix MCCV3XX-4963 and UDBC-xxxx for XC1.38 -->
	<#--
        PIC16F19155		PIC16LF19155
        PIC16F19156     PIC16LF19156
        PIC16F19175     IC16LF19175
        PIC16F19176     PIC16LF19176
        PIC16F19185     PIC16LF19185
        PIC16F19186     PIC16LF19186
	-->
#if (__XC8_VERSION <= 1410)

typedef union {
    struct {
        unsigned IOCAP0                 :1;
        unsigned IOCAP1                 :1;
        unsigned IOCAP2                 :1;
        unsigned IOCAP3                 :1;
        unsigned IOCAP4                 :1;
        unsigned IOCAP5                 :1;
    };
} IOCAPbits_t;
volatile IOCAPbits_t IOCAPbits @ (&IOCAF);

typedef union {
    struct {
        unsigned IOCAN0                 :1;
        unsigned IOCAN1                 :1;
        unsigned IOCAN2                 :1;
        unsigned IOCAN3                 :1;
        unsigned IOCAN4                 :1;
        unsigned IOCAN5                 :1;
    };
} IOCANbits_t;
volatile IOCANbits_t IOCANbits @ (&IOCAN);


typedef union {
    struct {
        unsigned IOCAF0                 :1;
        unsigned IOCAF1                 :1;
        unsigned IOCAF2                 :1;
        unsigned IOCAF3                 :1;
        unsigned IOCAF4                 :1;
        unsigned IOCAF5                 :1;
    };
} IOCAFbits_t;
volatile IOCAFbits_t IOCAFbits @ (&IOCAF);

#endif
    </#if>

<#list PORTbitsSettings as iocGroup>
<#if iocGroup.isIOC>
void (*${iocGroup.iocFlagName}_InterruptHandler)(void);
</#if>
</#list>
</#if>

<#if isDevicePIC16_L_F1915x_7x>
<#-- This is to fix MCCV3XX-5271 and UDBC-xxxx for XC8 v1.41B -->
#if (__XC8_VERSION <= 1410) 

typedef union {
    struct {
        unsigned T2INPPS                :6;
    };
    struct {
        unsigned T2INPPS0               :1;
        unsigned T2INPPS1               :1;
        unsigned T2INPPS2               :1;
        unsigned T2INPPS3               :1;
        unsigned T2INPPS4               :1;
        unsigned T2INPPS5               :1;
    };
} T2INPPSbits_t;
extern volatile T2INPPSbits_t T2INPPSbits @ (&T2AINPPS);

typedef union {
    struct {
        unsigned T4INPPS                :6;
    };
    struct {
        unsigned T4INPPS0               :1;
        unsigned T4INPPS1               :1;
        unsigned T4INPPS2               :1;
        unsigned T4INPPS3               :1;
        unsigned T4INPPS4               :1;
        unsigned T4INPPS5               :1;
    };
} T4INPPSbits_t;
extern volatile T4INPPSbits_t T4INPPSbits @ (&T4AINPPS);
#endif
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
<#if RxyI2CReg?has_content>

    /**
    RxyI2C registers
    */
<#list RxyI2CReg as i2creg>
    ${i2creg.name} = ${i2creg.value};
</#list>
</#if>
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
<#if APFConReg?has_content>
    /**
    APFCONx registers
    */
<#list APFConReg as apf>
    ${apf.name} = ${apf.value};
</#list>
</#if>

<#if isDevicePIC12_L_F1612>
<#if iocFlagReg?has_content && iocNegReg?has_content && iocPosReg?has_content>
    /**
    IOCx registers
    */
<#list iocFlagReg as pin>
    //${pin.comment}
    ${pin.iocGrp}.${pin.name} = ${pin.value};
</#list>
<#list iocNegReg as pin>
    //${pin.comment}
    ${pin.iocGrp}.${pin.name} = ${pin.value};
</#list>
<#list iocPosReg as pin>
    //${pin.comment}
    ${pin.iocGrp}.${pin.name} = ${pin.value};
</#list>
</#if>
<#else>
<#if iocReg?has_content>
    /**
    IOCx registers 
    */
<#list iocReg as pin>
    //${pin.comment}
    ${pin.iocGrp}.${pin.name} = ${pin.value};
</#list>
</#if>
</#if>



<#if iocFlagReg?has_content>
    // register default IOC callback functions at runtime; use these methods to register a custom function
    <#list iocFlagReg as iocKey>
    ${iocKey.name}_SetInterruptHandler(${iocKey.name}_DefaultInterruptHandler);
    </#list>
</#if>
   
<#if isInterruptEnabled>
    // Enable ${InterruptName} interrupt 
    ${InterruptEnableBit} = 1; 
</#if>
    
<#if PPSReg?has_content>
    <#if isDevicePIC16_L_F1535x> 
	<#-- This is to fix MCCV3XX-4619 and UDBC-1462 for XC1.38 -->
    #if (__XC8_VERSION <= 1380)
    #define ADACTPPSbits ADCACTPPSbits
    #endif
    </#if>
	
	<#list PPSReg as ppsData>		
	<#if isDevicePIC16_L_F176x>
		<#-- http://jira:8080/browse/MCCV3XX-3267 - XC8 backward compatibility -->
		<#if ppsData.name?starts_with("T2INPPS")>
				<#assign t2ppsName = "T2CKIPPSbits.T2CKIPPS">
		<#elseif ppsData.name?starts_with("T4INPPS")>
				<#assign t2ppsName = "T4CKIPPSbits.T4CKIPPS">
		<#elseif ppsData.name?starts_with("T6INPPS")>
				<#assign t2ppsName = "T6CKIPPSbits.T6CKIPPS">
		</#if>
		
		<#if t2ppsName?? && t2ppsName?starts_with("T")>
    #if (__XC8_VERSION < 1370)
    <#-- ppsData.value contains value and comments.  -->
    ${t2ppsName} = ${ppsData.value};    
    <#assign t2ppsName = "">
    #else
    ${ppsData.name} = ${ppsData.value};    
    #endif
        <#else>
    ${ppsData.name} = ${ppsData.value};    
        </#if>
    <#else>
    ${ppsData.name} = ${ppsData.value};    
	</#if>
</#list>
</#if>
}
  
<#if isInterruptEnabled && isVectoredInterruptEnabled && isHighPriority>
void __interrupt(irq(${IRQName}),base(${IVTBaseAddress})) PIN_MANAGER_IOC()
<#elseif isInterruptEnabled && isVectoredInterruptEnabled && !isHighPriority>
void __interrupt(irq(${IRQName}),base(${IVTBaseAddress}),low_priority) PIN_MANAGER_IOC()
<#else>
void PIN_MANAGER_IOC(void)
</#if>
{   
    <#list iocFlagReg as pin>
	// interrupt on change for pin ${pin.name}
    if(${pin.iocGrp}.${pin.name} == 1)
    {
        ${pin.name}_ISR();  
    }	
	</#list>	
	<#if InterruptName != "IOCI" || !isIOCPinFlagAvailable>
	// Clear global Interrupt-On-Change flag
    ${GroupInterruptFlag} = 0;
	</#if>	
}

<#list iocFlagReg as pin>
/**
   ${pin.name} Interrupt Service Routine
*/
void ${pin.name}_ISR(void) {

    // Add custom ${pin.name} code

    // Call the interrupt handler for the callback registered at runtime
    if(${pin.name}_InterruptHandler)
    {
        ${pin.name}_InterruptHandler();
    }
	<#if InterruptName == "IOCI" && isIOCPinFlagAvailable>
    ${pin.iocGrp}.${pin.name} = 0;
	</#if>
}

/**
  Allows selecting an interrupt handler for ${pin.name} at application runtime
*/
void ${pin.name}_SetInterruptHandler(void (* InterruptHandler)(void)){
    ${pin.name}_InterruptHandler = InterruptHandler;
}

/**
  Default interrupt handler for ${pin.name}
*/
void ${pin.name}_DefaultInterruptHandler(void){
    // add your ${pin.name} interrupt custom code
    // or set custom function using ${pin.name}_SetInterruptHandler()
}

</#list> 
/**
 End of File
*/