/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.11
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} 
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
 Section: Data Type Definitions
*/

/**
  HLT Mode Setting Enumeration

  @Summary
    Defines the different modes of the HLT.

  @Description
    This defines the several modes of operation of the Timer with
	HLT extension. The modes can be set in a control register associated
	with the timer
*/

typedef enum
{

	/* Roll-over Pulse mode clears the TMRx upon TMRx = PRx, then continue running.
	ON bit must be set and is not affected by Resets
	*/

   /* Roll-over Pulse mode indicates that Timer starts
   immediately upon ON = 1 (Software Control)
   */
   ${moduleNameUpperCase}_ROP_STARTS_TMRON,

   /* Roll-over Pulse mode indicates that the Timer starts
       when ON = 1 and TMRx_ers = 1. Stops when TMRx_ers = 0
     */
   ${moduleNameUpperCase}_ROP_STARTS_TMRON_ERSHIGH,

   /* Roll-over Pulse mode indicates that the Timer starts
      when ON = 1 and TMRx_ers = 0. Stops when TMRx_ers = 1
     */
   ${moduleNameUpperCase}_ROP_STARTS_TMRON_ERSLOW,

   /* Roll-over Pulse mode indicates that the Timer resets
   upon rising or falling edge of TMRx_ers
     */
   ${moduleNameUpperCase}_ROP_RESETS_ERSBOTHEDGE,

   /* Roll-over Pulse mode indicates that the Timer resets
    upon rising edge of TMRx_ers
     */
   ${moduleNameUpperCase}_ROP_RESETS_ERSRISINGEDGE,

   /* Roll-over Pulse mode indicates that the Timer resets
   upon falling edge of TMRx_ers
     */
   ${moduleNameUpperCase}_ROP_RESETS_ERSFALLINGEDGE,

   /* Roll-over Pulse mode indicates that the Timer resets
   upon TMRx_ers = 0
     */
   ${moduleNameUpperCase}_ROP_RESETS_ERSLOW,

   /* Roll-over Pulse mode indicates that the Timer resets
   upon TMRx_ers = 1
     */
   ${moduleNameUpperCase}_ROP_RESETS_ERSHIGH,

    /*In all One-Shot mode the timer resets and the ON bit is
	cleared when the timer value matches the PRx period
	value. The ON bit must be set by software to start
	another timer cycle.
	*/

   /* One shot mode indicates that the Timer starts
    immediately upon ON = 1 (Software Control)
     */
   ${moduleNameUpperCase}_OS_STARTS_TMRON,

   /* One shot mode indicates that the Timer starts
    when a rising edge is detected on the TMRx_ers
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSRISINGEDGE ,

   /* One shot mode indicates that the Timer starts
    when a falling edge is detected on the TMRx_ers
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSFALLINGEDGE ,

   /* One shot mode indicates that the Timer starts
    when either a rising or falling edge is detected on TMRx_ers
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSBOTHEDGE,

   /* One shot mode indicates that the Timer starts
    upon first TMRx_ers rising edge and resets on all
	subsequent TMRx_ers rising edges
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSFIRSTRISINGEDGE,

   /* One shot mode indicates that the Timer starts
    upon first TMRx_ers falling edge and restarts on all
	subsequent TMRx_ers falling edges
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSFIRSTFALLINGEDGE,

   /* One shot mode indicates that the Timer starts
    when a rising edge is detected on the TMRx_ers,
	resets upon TMRx_ers = 0
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSRISINGEDGEDETECT,
    <#if selectedDevice?contains("PIC16F1613")|| selectedDevice?contains("PIC16LF1613")||        
    selectedDevice?contains("PIC12F1612")|| selectedDevice?contains("PIC12LF1612")>
    /* One shot mode indicates that the Timer starts
    when a falling edge is detected on the TMRx_ers,
	resets upon TMRx_ers = 1
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSFALLINGEDGEDETECT
    </#if>
    <#if selectedDevice?contains("PIC16F1614")|| selectedDevice?contains("PIC16LF1614")||
     selectedDevice?contains("PIC16F1615")|| selectedDevice?contains("PIC16LF1615") ||
     selectedDevice?contains("PIC16F1618")|| selectedDevice?contains("PIC16LF1618")||
     selectedDevice?contains("PIC16F1619")|| selectedDevice?contains("PIC16LF1619")||
     selectedDevice?contains("PIC16F1764")|| selectedDevice?contains("PIC16LF1764")||
     selectedDevice?contains("PIC16F1765")|| selectedDevice?contains("PIC16LF1765")||
     selectedDevice?contains("PIC16F1768")|| selectedDevice?contains("PIC16LF1768")||
     selectedDevice?contains("PIC16F1769")|| selectedDevice?contains("PIC16LF1769") ||
     selectedDevice?contains("PIC16F1777")|| selectedDevice?contains("PIC16LF1777") ||
     selectedDevice?contains("PIC16F1778")|| selectedDevice?contains("PIC16LF1778") ||
     selectedDevice?contains("PIC16F1779")|| selectedDevice?contains("PIC16LF1779") ||
    selectedDevice?contains("PIC16F18854")|| selectedDevice?contains("PIC16LF18854") ||
    selectedDevice?contains("PIC16F18855")|| selectedDevice?contains("PIC16LF18855") ||
    selectedDevice?contains("PIC16F18856")|| selectedDevice?contains("PIC16LF18856") ||
    selectedDevice?contains("PIC16F18857")|| selectedDevice?contains("PIC16LF18857") ||
    selectedDevice?contains("PIC16F18875")|| selectedDevice?contains("PIC16LF18875") ||
    selectedDevice?contains("PIC16F18876")|| selectedDevice?contains("PIC16LF18876") ||
    selectedDevice?contains("PIC16F18877")|| selectedDevice?contains("PIC16LF18877") ||
    selectedDevice?contains("PIC18F24K40")|| selectedDevice?contains("PIC18LF24K40") ||
    selectedDevice?contains("PIC18F25K40")|| selectedDevice?contains("PIC18LF25K40") ||
    selectedDevice?contains("PIC18F26K40")|| selectedDevice?contains("PIC18LF26K40") ||
    selectedDevice?contains("PIC18F27K40")|| selectedDevice?contains("PIC18LF27K40") ||
    selectedDevice?contains("PIC18F45K40")|| selectedDevice?contains("PIC18LF45K40") ||
    selectedDevice?contains("PIC18F46K40")|| selectedDevice?contains("PIC18LF46K40") ||
    selectedDevice?contains("PIC18F47K40")|| selectedDevice?contains("PIC18LF47K40") ||
    selectedDevice?contains("PIC18F65K40")|| selectedDevice?contains("PIC18LF65K40") ||
    selectedDevice?contains("PIC18F66K40")|| selectedDevice?contains("PIC18LF66K40") ||
    selectedDevice?contains("PIC18F67K40")|| selectedDevice?contains("PIC18LF67K40") ||
    selectedDevice?contains("PIC16F15313")|| selectedDevice?contains("PIC16LF15313") ||
    selectedDevice?contains("PIC16F15323")|| selectedDevice?contains("PIC16LF15323") ||
    selectedDevice?contains("PIC16F15324")|| selectedDevice?contains("PIC16LF15324") ||
    selectedDevice?contains("PIC16F15325")|| selectedDevice?contains("PIC16LF15325") ||
    selectedDevice?contains("PIC16F15344")|| selectedDevice?contains("PIC16LF15344") ||
    selectedDevice?contains("PIC16F15345")|| selectedDevice?contains("PIC16LF15345") ||
    selectedDevice?contains("PIC16F15354")|| selectedDevice?contains("PIC16LF15354") ||
    selectedDevice?contains("PIC16F15355")|| selectedDevice?contains("PIC16LF15355") ||
    selectedDevice?contains("PIC16F15356")|| selectedDevice?contains("PIC16LF15356") ||
    selectedDevice?contains("PIC16F15375")|| selectedDevice?contains("PIC16LF15375") ||
    selectedDevice?contains("PIC16F15376")|| selectedDevice?contains("PIC16LF15376") ||
    selectedDevice?contains("PIC16F15385")|| selectedDevice?contains("PIC16LF15385") ||
    selectedDevice?contains("PIC16F15386")|| selectedDevice?contains("PIC16LF15386") ||
    selectedDevice?contains("PIC18F24K42")|| selectedDevice?contains("PIC18LF24K42") ||
    selectedDevice?contains("PIC18F25K42")|| selectedDevice?contains("PIC18LF25K42") ||
    selectedDevice?contains("PIC18F26K42")|| selectedDevice?contains("PIC18LF26K42") ||
    selectedDevice?contains("PIC18F27K42")|| selectedDevice?contains("PIC18LF27K42") ||
    selectedDevice?contains("PIC18F45K42")|| selectedDevice?contains("PIC18LF45K42") ||
    selectedDevice?contains("PIC18F46K42")|| selectedDevice?contains("PIC18LF46K42") ||
    selectedDevice?contains("PIC18F47K42")|| selectedDevice?contains("PIC18LF47K42") ||
    selectedDevice?contains("PIC18F55K42")|| selectedDevice?contains("PIC18LF55K42") ||
    selectedDevice?contains("PIC18F56K42")|| selectedDevice?contains("PIC18LF56K42") ||
    selectedDevice?contains("PIC18F57K42")|| selectedDevice?contains("PIC18LF57K42") ||
    selectedDevice?contains("PIC18F25K83")|| selectedDevice?contains("PIC18LF25K83") ||
    selectedDevice?contains("PIC18F26K83")|| selectedDevice?contains("PIC18LF26K83") ||
    selectedDevice?contains("PIC16F19195")|| selectedDevice?contains("PIC16LF19195") ||
    selectedDevice?contains("PIC16F19196")|| selectedDevice?contains("PIC16LF19196") ||
    selectedDevice?contains("PIC16F19197")|| selectedDevice?contains("PIC16LF19197") ||
    selectedDevice?contains("PIC16F19185")|| selectedDevice?contains("PIC16LF19185") ||
    selectedDevice?contains("PIC16F19186")|| selectedDevice?contains("PIC16LF19186") ||
    selectedDevice?contains("PIC16F19155")|| selectedDevice?contains("PIC16LF19155") ||
    selectedDevice?contains("PIC16F19156")|| selectedDevice?contains("PIC16LF19156") ||
    selectedDevice?contains("PIC16F19175")|| selectedDevice?contains("PIC16LF19175") ||
    selectedDevice?contains("PIC16F19176")|| selectedDevice?contains("PIC16LF19176") ||
    selectedDevice?contains("PIC18F25Q43")|| selectedDevice?contains("PIC18F45Q43") ||
    selectedDevice?contains("PIC18F55Q43") || selectedDevice?contains("PIC18F26Q43")|| 
    selectedDevice?contains("PIC18F46Q43") || selectedDevice?contains("PIC18F56Q43") ||
    selectedDevice?contains("PIC18F27Q43")|| selectedDevice?contains("PIC18F47Q43") ||
    selectedDevice?contains("PIC18F57Q43") || selectedDevice?contains("PIC18F26Q83")|| 
    selectedDevice?contains("PIC18F46Q83") || selectedDevice?contains("PIC18F56Q83") ||
    selectedDevice?contains("PIC18F27Q83") || selectedDevice?contains("PIC18F47Q83")||
    selectedDevice?contains("PIC18F57Q83") || selectedDevice?contains("PIC18F26Q84")|| 
    selectedDevice?contains("PIC18F46Q84") || selectedDevice?contains("PIC18F56Q84") ||
    selectedDevice?contains("PIC18F27Q84") || selectedDevice?contains("PIC18F47Q84")||
    selectedDevice?contains("PIC18F57Q84")|| selectedDevice?contains("PIC16F15213")|| 
    selectedDevice?contains("PIC16F15214")|| selectedDevice?contains("PIC16F15223")|| 
    selectedDevice?contains("PIC16F15224")|| selectedDevice?contains("PIC16F15225")|| 
    selectedDevice?contains("PIC16F15243")|| selectedDevice?contains("PIC16F15244")|| 
    selectedDevice?contains("PIC16F15245")|| selectedDevice?contains("PIC16F15254")|| 
    selectedDevice?contains("PIC16F15255")|| selectedDevice?contains("PIC16F15256")|| 	
    selectedDevice?contains("PIC16F15274")|| selectedDevice?contains("PIC16F15275")|| 
    selectedDevice?contains("PIC16F15276")|| selectedDevice?contains("Q40")||
    selectedDevice?contains("Q41")>
     /* One shot mode indicates that the Timer starts
    when a falling edge is detected on the TMRx_ers,
	resets upon TMRx_ers = 1
     */
   ${moduleNameUpperCase}_OS_STARTS_ERSFALLINGEDGEDETECT,
   
   /* One shot mode indicates that the Timer starts
    when a TMRx_ers = 1,ON =1 and resets upon TMRx_ers =0
    */
   ${moduleNameUpperCase}_OS_STARTS_TMRON_ERSHIGH = 0x16,
           
   /* One shot mode indicates that the Timer starts
     when a TMRx_ers = 0,ON = 1 and resets upon TMRx_ers =1 
    */
   ${moduleNameUpperCase}_OS_STARTS_TMRON_ERSLOW = 0x17,
        
   /*In all Mono-Stable mode the ON bit must be initially set,but
     not cleared upon the TMRx = PRx, and the timer will start upon
     an TMRx_ers start event following TMRx = PRx.*/
               
   /* Mono Stable mode indicates that the Timer starts
      when a rising edge is detected on the TMRx_ers and ON = 1
    */
   ${moduleNameUpperCase}_MS_STARTS_TMRON_ERSRISINGEDGEDETECT = 0x11,
           
   /* Mono Stable mode indicates that the Timer starts
      when a falling edge is detected on the TMRx_ers and ON = 1
    */
   ${moduleNameUpperCase}_MS_STARTS_TMRON_ERSFALLINGEDGEDETECT = 0x12,
           
   /* Mono Stable mode indicates that the Timer starts
      when  either a rising or falling edge is detected on TMRx_ers 
      and ON = 1
    */
   ${moduleNameUpperCase}_MS_STARTS_TMRON_ERSBOTHEDGE = 0x13
     </#if>
           
} ${moduleNameUpperCase}_HLT_MODE;

/**
  HLT Reset Source Enumeration

  @Summary
    Defines the different reset source of the HLT.

  @Description
    This source can control starting and stopping of the
	timer, as well as resetting the timer, depending on
	which mode the timer is in. The mode of the timer is
	controlled by the HLT_MODE
*/

typedef enum
{
    <#if selectedDevice?contains("PIC16F1614")|| selectedDevice?contains("PIC16LF1614")||
     selectedDevice?contains("PIC16F1615")|| selectedDevice?contains("PIC16LF1615") ||
     selectedDevice?contains("PIC16F1618")|| selectedDevice?contains("PIC16LF1618")||
     selectedDevice?contains("PIC16F1619")|| selectedDevice?contains("PIC16LF1619")||
     selectedDevice?contains("PIC12F1612")|| selectedDevice?contains("PIC12LF1612")||
     selectedDevice?contains("PIC16F1613")|| selectedDevice?contains("PIC16LF1613")>
  
   /* T${instanceNumber}IN is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}IN,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,
            
     <#if selectedDevice?contains("PIC12F1612")|| selectedDevice?contains("PIC12LF1612")>
    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT = 0x03,
    <#else>
    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,
    </#if>
    
    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>
    
    /* ZCD1_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD1_OUTPUT,
    <#if selectedDevice?contains("PIC16F1613")|| selectedDevice?contains("PIC16LF1613")||        
    selectedDevice?contains("PIC12F1612")|| selectedDevice?contains("PIC12LF1612")>
          
    /* CWGA is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CWGA,

    /* CWGB is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CWGB,

    /* CWGC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CWGC,

    /* CWGD is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CWGD
    </#if>
    <#if selectedDevice?contains("PIC16F1614")|| selectedDevice?contains("PIC16LF1614")||
    selectedDevice?contains("PIC16F1618")|| selectedDevice?contains("PIC16LF1618")>
    
    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
         
   /* PWM3_out is the Timer external reset source 
    */
    ${moduleNameUpperCase}_PWM3_OUT = 0x0D,
            
    /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT = 0x0E
    </#if>
    <#if selectedDevice?contains("PIC16F1615")|| selectedDevice?contains("PIC16LF1615")||
    selectedDevice?contains("PIC16F1619")|| selectedDevice?contains("PIC16LF1619")>
    
    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,
         
    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT,
     
    /* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,
            
    /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT
    </#if>
     </#if>
    <#if selectedDevice?contains("PIC16F1764")|| selectedDevice?contains("PIC16LF1764")||
     selectedDevice?contains("PIC16F1765")|| selectedDevice?contains("PIC16LF1765")||
     selectedDevice?contains("PIC16F1768")|| selectedDevice?contains("PIC16LF1768")||
     selectedDevice?contains("PIC16F1769")|| selectedDevice?contains("PIC16LF1769")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>
	 /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,
	<#if selectedDevice?contains("PIC16F1764")|| selectedDevice?contains("PIC16LF1764")||
     selectedDevice?contains("PIC16F1765")|| selectedDevice?contains("PIC16LF1765")>
     /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_1,
	<#else>
	 /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
	</#if>
	/* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,
	<#if selectedDevice?contains("PIC16F1764")|| selectedDevice?contains("PIC16LF1764")||
     selectedDevice?contains("PIC16F1765")|| selectedDevice?contains("PIC16LF1765")>
	/* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_2,
	<#else>
	/* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT,
	</#if>
	/* PWM5_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM5_OUT,
	<#if selectedDevice?contains("PIC16F1764")|| selectedDevice?contains("PIC16LF1764")||
     selectedDevice?contains("PIC16F1765")|| selectedDevice?contains("PIC16LF1765")>
	/* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_3,
	<#else>
	/* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,
	</#if>
	 /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,
	
	 /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,
	<#if selectedDevice?contains("PIC16F1764")|| selectedDevice?contains("PIC16LF1764")||
     selectedDevice?contains("PIC16F1765")|| selectedDevice?contains("PIC16LF1765")>
	/* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_4,
	/* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_5,
	<#else>
	/* C3_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C3_OUT_SYNC,
	/* C4_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C4_OUT_SYNC,
	</#if>
	 /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,
	 /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT
    </#if>
    <#if selectedDevice?contains("PIC16F18854")|| selectedDevice?contains("PIC16LF18854") ||
         selectedDevice?contains("PIC16F18855")|| selectedDevice?contains("PIC16LF18855") ||
         selectedDevice?contains("PIC16F18856")|| selectedDevice?contains("PIC16LF18856") ||
         selectedDevice?contains("PIC16F18857")|| selectedDevice?contains("PIC16LF18857") ||
         selectedDevice?contains("PIC16F18875")|| selectedDevice?contains("PIC16LF18875") ||
         selectedDevice?contains("PIC16F18876")|| selectedDevice?contains("PIC16LF18876") ||
         selectedDevice?contains("PIC16F18877")|| selectedDevice?contains("PIC16LF18877")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>
     /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,

     /* CCP3_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP3_OUT,

    /* CCP4_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP4_OUT,

    /* CCP5_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP5_OUT,

    /* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,

     /* PWM7_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM7_OUT,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT
</#if>
<#if selectedDevice?contains("PIC16F1773")|| selectedDevice?contains("PIC16LF1773") ||
         selectedDevice?contains("PIC16F1776")|| selectedDevice?contains("PIC16LF1776") ||
         selectedDevice?contains("PIC16F1777")|| selectedDevice?contains("PIC16LF1777") ||
         selectedDevice?contains("PIC16F1778")|| selectedDevice?contains("PIC16LF1778") ||
         selectedDevice?contains("PIC16F1779")|| selectedDevice?contains("PIC16LF1779")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>

    <#if (instanceNumber) == "8" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer8 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T8POSTSCALED,
    </#if>
     /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,

     /* CCP7_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP7_OUT,

    <#if selectedDevice?contains("PIC16F1777")|| selectedDevice?contains("PIC16LF1777")||
     selectedDevice?contains("PIC16F1779")|| selectedDevice?contains("PIC16LF1779")>
    /* CCP8_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP8_OUT,
    <#else>
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_1,
    </#if>

    /* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,

     /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT,

    /* PWM9_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM9_OUT,

    <#if selectedDevice?contains("PIC16F1777")|| selectedDevice?contains("PIC16LF1777")||
     selectedDevice?contains("PIC16F1779")|| selectedDevice?contains("PIC16LF1779")>
     /* PWM10_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM10_OUT,
    <#else>
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_2,
    </#if>

    /* PWM5_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM5_OUT,

     /* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,

    /* PWM11_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM11_OUT,

    <#if selectedDevice?contains("PIC16F1777")|| selectedDevice?contains("PIC16LF1777")||
     selectedDevice?contains("PIC16F1779")|| selectedDevice?contains("PIC16LF1779")>
     /* PWM12_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM12_OUT,
    <#else>
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_3,
    </#if>

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* C3_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C3_OUT_SYNC,	

    /* C4_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C4_OUT_SYNC,

    /* C5_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C5_OUT_SYNC,	

    /* C6_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C6_OUT_SYNC,

    <#if selectedDevice?contains("PIC16F1777")|| selectedDevice?contains("PIC16LF1777")||
     selectedDevice?contains("PIC16F1779")|| selectedDevice?contains("PIC16LF1779")>
    /* C7_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C7_OUT_SYNC,	

    /* C8_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C8_OUT_SYNC,
    <#else>
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_4,

    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_5,
    </#if>

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT
</#if>
    <#if selectedDevice?contains("PIC18F24K40")|| selectedDevice?contains("PIC18LF24K40") ||
    selectedDevice?contains("PIC18F25K40")|| selectedDevice?contains("PIC18LF25K40") ||
    selectedDevice?contains("PIC18F26K40")|| selectedDevice?contains("PIC18LF26K40") ||
    selectedDevice?contains("PIC18F27K40")|| selectedDevice?contains("PIC18LF27K40") ||
    selectedDevice?contains("PIC18F45K40")|| selectedDevice?contains("PIC18LF45K40") ||
    selectedDevice?contains("PIC18F46K40")|| selectedDevice?contains("PIC18LF46K40") ||
    selectedDevice?contains("PIC18F47K40")|| selectedDevice?contains("PIC18LF47K40")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>
     /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,

    /* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,

     /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT
</#if>
    <#if selectedDevice?contains("PIC18F65K40")|| selectedDevice?contains("PIC18LF65K40") ||
    selectedDevice?contains("PIC18F66K40")|| selectedDevice?contains("PIC18LF66K40") ||
    selectedDevice?contains("PIC18F67K40")|| selectedDevice?contains("PIC18LF67K40")>
    /* T${instanceNumber}INPPS is the Timer external reset source
    */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>

    <#if (instanceNumber) == "8" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T8POSTSCALED,
    </#if>
     /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
    
    /* CCP3_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP3_OUT,

    /* CCP4_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP4_OUT,

    /* CCP5_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP5_OUT,

    /* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,

     /* PWM7_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM7_OUT,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* C3_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C3_OUT_SYNC,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT
</#if>
    <#if selectedDevice?contains("PIC16F15313")|| selectedDevice?contains("PIC16LF15313") ||
    selectedDevice?contains("PIC16F15323")|| selectedDevice?contains("PIC16LF15323") ||
    selectedDevice?contains("PIC16F15324")|| selectedDevice?contains("PIC16LF15324") ||
    selectedDevice?contains("PIC16F15325")|| selectedDevice?contains("PIC16LF15325") ||
    selectedDevice?contains("PIC16F15344")|| selectedDevice?contains("PIC16LF15344") ||
    selectedDevice?contains("PIC16F15345")|| selectedDevice?contains("PIC16LF15345") ||
    selectedDevice?contains("PIC16F15354")|| selectedDevice?contains("PIC16LF15354") ||
    selectedDevice?contains("PIC16F15355")|| selectedDevice?contains("PIC16LF15355") ||
    selectedDevice?contains("PIC16F15356")|| selectedDevice?contains("PIC16LF15356") ||
    selectedDevice?contains("PIC16F15375")|| selectedDevice?contains("PIC16LF15375") ||
    selectedDevice?contains("PIC16F15376")|| selectedDevice?contains("PIC16LF15376") ||
    selectedDevice?contains("PIC16F15385")|| selectedDevice?contains("PIC16LF15385") ||
    selectedDevice?contains("PIC16F15386")|| selectedDevice?contains("PIC16LF15386")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
    
    /* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,

     /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT,

    /* PWM5_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM5_OUT,

     /* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT
</#if>
<#if selectedDevice?contains("PIC16F19195")|| selectedDevice?contains("PIC16LF19195") ||
    selectedDevice?contains("PIC16F19196")|| selectedDevice?contains("PIC16LF19196") ||
    selectedDevice?contains("PIC16F19197")|| selectedDevice?contains("PIC16LF19197") ||
    selectedDevice?contains("PIC16F19185")|| selectedDevice?contains("PIC16LF19185") ||
    selectedDevice?contains("PIC16F19186")|| selectedDevice?contains("PIC16LF19186") ||
    selectedDevice?contains("PIC16F19155")|| selectedDevice?contains("PIC16LF19155") ||
    selectedDevice?contains("PIC16F19156")|| selectedDevice?contains("PIC16LF19156") ||
    selectedDevice?contains("PIC16F19175")|| selectedDevice?contains("PIC16LF19175") ||
    selectedDevice?contains("PIC16F19176")|| selectedDevice?contains("PIC16LF19176") >

     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
    
    /* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,

     /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT,

    /* RTCC_seconds is the Timer external reset source 
     */
    ${moduleNameUpperCase}_RTCC_seconds,

    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT
</#if>
    <#if selectedDevice?contains("PIC18F24K42")|| selectedDevice?contains("PIC18LF24K42") ||
    selectedDevice?contains("PIC18F25K42")|| selectedDevice?contains("PIC18LF25K42") ||
    selectedDevice?contains("PIC18F26K42")|| selectedDevice?contains("PIC18LF26K42") ||
    selectedDevice?contains("PIC18F27K42")|| selectedDevice?contains("PIC18LF27K42") ||
    selectedDevice?contains("PIC18F45K42")|| selectedDevice?contains("PIC18LF45K42") ||
    selectedDevice?contains("PIC18F46K42")|| selectedDevice?contains("PIC18LF46K42") ||
    selectedDevice?contains("PIC18F47K42")|| selectedDevice?contains("PIC18LF47K42") ||
    selectedDevice?contains("PIC18F55K42")|| selectedDevice?contains("PIC18LF55K42") ||
    selectedDevice?contains("PIC18F56K42")|| selectedDevice?contains("PIC18LF56K42") ||
    selectedDevice?contains("PIC18F57K42")|| selectedDevice?contains("PIC18LF57K42") ||
    selectedDevice?contains("PIC18F25K83")|| selectedDevice?contains("PIC18LF25K83") ||
    selectedDevice?contains("PIC18F26K83")|| selectedDevice?contains("PIC18LF26K83")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
    
    /* CCP3_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP3_OUT,

    /* CCP4_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP4_OUT,

    /* PWM5_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM5_OUT,

     /* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,
    
    /* PWM7_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM7_OUT,

     /* PWM8_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM8_OUT,
    
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_2,

    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_3,

    /* C1_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C1_OUT_SYNC,	

    /* C2_OUT_SYNC is the Timer external reset source 
     */
    ${moduleNameUpperCase}_C2_OUT_SYNC,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT,

    /* UART1_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART1_RX_EDGE,

    /* UART1_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART1_TX_EDGE,

    /* UART2_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART2_RX_EDGE,

    /* UART2_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART2_TX_EDGE
</#if>
<#if selectedDevice?contains("PIC18F24Q10") || selectedDevice?contains("PIC18F25Q10") ||
     selectedDevice?contains("PIC18F26Q10") || selectedDevice?contains("PIC18F27Q10") ||
     selectedDevice?contains("PIC18F45Q10") || selectedDevice?contains("PIC18F46Q10") || 
     selectedDevice?contains("PIC18F47Q10") >   
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
    
    /* PWM3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3_OUT,

    /* PWM4_out is the Timer external reset source 
    */
    ${moduleNameUpperCase}_PWM4_OUT,
    
    /* CMP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CMP1_OUT,

    /* CMP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CMP2_OUT,
    
    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,    

    /* Reserved enum cannot be used 
    */
    ${moduleNameUpperCase}_RESERVED_2,

    /* UART1_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART1_RX_EDGE,

    /* UART1_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART1_TX_EDGE,

    /* UART2_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART2_RX_EDGE,

    /* UART2_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART2_TX_EDGE,
    
    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT,  

    /* CLC5_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC5_OUT,
         
    /* CLC6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC6_OUT,
            
    /* CLC7_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC7_OUT,
    
    /* CLC8_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC8_OUT,    

    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_3,
</#if>
<#if selectedDevice?contains("PIC18F25Q43")|| selectedDevice?contains("PIC18F45Q43") ||
     selectedDevice?contains("PIC18F55Q43") || selectedDevice?contains("PIC18F26Q43")|| 
     selectedDevice?contains("PIC18F46Q43") || selectedDevice?contains("PIC18F56Q43") ||
     selectedDevice?contains("PIC18F27Q43")|| selectedDevice?contains("PIC18F47Q43") ||
     selectedDevice?contains("PIC18F57Q43") || selectedDevice?contains("PIC18F26Q83")|| 
    selectedDevice?contains("PIC18F46Q83") || selectedDevice?contains("PIC18F56Q83") ||
    selectedDevice?contains("PIC18F27Q83") || selectedDevice?contains("PIC18F47Q83")||
    selectedDevice?contains("PIC18F57Q83") || selectedDevice?contains("PIC18F26Q84")|| 
    selectedDevice?contains("PIC18F46Q84") || selectedDevice?contains("PIC18F56Q84") ||
    selectedDevice?contains("PIC18F27Q84") || selectedDevice?contains("PIC18F47Q84")||
    selectedDevice?contains("PIC18F57Q84") >
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,

    /* CCP3_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP3_OUT,

    /* PWM1S1P1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM1S1P1_OUT,

    /* PWM1S1P2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM1S1P2_OUT,

    /* PWM2S1P1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM2S1P1_OUT,

    /* PWM2S1P2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM2S1P2_OUT,

    /* PWM3S1P1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3S1P1_OUT,

    /* PWM3S1P2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM3S1P2_OUT,

    /* Reserved enum cannot be used 
    */
    ${moduleNameUpperCase}_RESERVED_2,

    /* Reserved enum cannot be used 
    */
    ${moduleNameUpperCase}_RESERVED_3,

    /* CMP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CMP1_OUT,

    /* CMP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CMP2_OUT,

    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT,  

    /* CLC5_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC5_OUT,
         
    /* CLC6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC6_OUT,
            
    /* CLC7_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC7_OUT,
    
    /* CLC8_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC8_OUT,

    /* UART1_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART1_RX_EDGE,

    /* UART1_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART1_TX_EDGE,

    /* UART2_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART2_RX_EDGE,

    /* UART2_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART2_TX_EDGE,

    /* UART3_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART3_RX_EDGE,

    /* UART3_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART3_TX_EDGE,

    /* UART4_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART4_RX_EDGE,

    /* UART4_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART4_TX_EDGE,

    /* UART5_rx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART5_RX_EDGE,

    /* UART5_tx_edge is the Timer external reset source 
     */
    ${moduleNameUpperCase}_UART5_TX_EDGE,

    /* Reserved enum cannot be used 
    */
    ${moduleNameUpperCase}_RESERVED_4
</#if>
<#if selectedDevice?contains("Q40")|| selectedDevice?contains("Q41")>
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>

    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>

    /* Reserved enum cannot be used
     */
    ${moduleNameUpperCase}_RESERVED_2,

    /* CCP1_OUT is the Timer external reset source
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* PWM1S1P1_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_PWM1S1P1_OUT,

    /* PWM1S1P2_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_PWM1S1P2_OUT,

    /* PWM2S1P1_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_PWM2S1P1_OUT,

    /* PWM2S1P2_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_PWM2S1P2_OUT,

    /* PWM3S1P1_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_PWM3S1P1_OUT,

    /* PWM3S1P2_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_PWM3S1P2_OUT,

    /* CMP1_OUT is the Timer external reset source
     */
    ${moduleNameUpperCase}_CMP1_OUT,

    /* CMP2_OUT is the Timer external reset source
     */
    ${moduleNameUpperCase}_CMP2_OUT,

    /* ZCD_Output is the Timer external reset source
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,

    /* CLC1_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_CLC1_OUT,

    /* CLC2_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_CLC2_OUT,

    /* CLC3_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source
     */
    ${moduleNameUpperCase}_CLC4_OUT,

    /* UART1_rx_edge is the Timer external reset source
     */
    ${moduleNameUpperCase}_UART1_RX_EDGE,

    /* UART1_tx_edge is the Timer external reset source
     */
    ${moduleNameUpperCase}_UART1_TX_EDGE,

    /* UART2_rx_edge is the Timer external reset source
     */
    ${moduleNameUpperCase}_UART2_RX_EDGE,

    /* UART2_tx_edge is the Timer external reset source
     */
    ${moduleNameUpperCase}_UART2_TX_EDGE,

    /* UART3_rx_edge is the Timer external reset source
     */
    ${moduleNameUpperCase}_UART3_RX_EDGE,

    /* UART3_tx_edge is the Timer external reset source
     */
    ${moduleNameUpperCase}_UART3_TX_EDGE,

    /* Reserved enum cannot be used
    */
    ${moduleNameUpperCase}_RESERVED_3
</#if>
<#if selectedDevice?contains("PIC16F18424") || selectedDevice?contains("PIC16LF18424") ||
     selectedDevice?contains("PIC16F18425") || selectedDevice?contains("PIC16LF18425") ||
     selectedDevice?contains("PIC16F18426") || selectedDevice?contains("PIC16LF18426") ||
     selectedDevice?contains("PIC16F18444") || selectedDevice?contains("PIC16LF18444") ||
     selectedDevice?contains("PIC16F18445") || selectedDevice?contains("PIC16LF18445") ||
     selectedDevice?contains("PIC16F18446") || selectedDevice?contains("PIC16LF18446") || 
     selectedDevice?contains("PIC16F18455") || selectedDevice?contains("PIC16LF18455") ||
     selectedDevice?contains("PIC16F18456") || selectedDevice?contains("PIC16LF18456") >
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

    <#if (instanceNumber) == "2" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer2 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T2POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "4" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer4 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T4POSTSCALED,
    </#if>
    
    <#if (instanceNumber) == "6" >
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED,
    <#else>
    /* Timer6 Postscale is the Timer external reset source 
     */
    ${moduleNameUpperCase}_T6POSTSCALED,
    </#if>

    /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,

    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,

    /* CCP3_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP3_OUT,

    /* CCP4_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP4_OUT,
    
    /* PWM6_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM6_OUT,

    /* PWM7_out is the Timer external reset source 
    */
    ${moduleNameUpperCase}_PWM7_OUT,
    
    /* CMP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CMP1_OUT,

    /* CMP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CMP2_OUT,
    
    /* ZCD_Output is the Timer external reset source 
     */
    ${moduleNameUpperCase}_ZCD_OUTPUT,    
    
    /* CLC1_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC1_OUT,
         
    /* CLC2_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC2_OUT,
            
    /* CLC3_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC3_OUT,

    /* CLC4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CLC4_OUT,  
    
<#if selectedDevice?contains("PIC16F18455") || selectedDevice?contains("PIC16LF18455") ||
     selectedDevice?contains("PIC16F18456") || selectedDevice?contains("PIC16LF18456") >
    /* CCP5_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP5_OUT,
</#if>   
    /* Reserved enum cannot be used 
     */
    ${moduleNameUpperCase}_RESERVED_2,
</#if>

<#if selectedDevice?contains("PIC16F15213")|| selectedDevice?contains("PIC16F15214")|| 
    selectedDevice?contains("PIC16F15223")|| selectedDevice?contains("PIC16F15224")||
    selectedDevice?contains("PIC16F15225")|| selectedDevice?contains("PIC16F15243")||
    selectedDevice?contains("PIC16F15244")|| selectedDevice?contains("PIC16F15245")||
	selectedDevice?contains("PIC16F15254")|| selectedDevice?contains("PIC16F15255")|| 
	selectedDevice?contains("PIC16F15256")|| selectedDevice?contains("PIC16F15274")|| 
	selectedDevice?contains("PIC16F15275")|| selectedDevice?contains("PIC16F15276")>
    
     /* T${instanceNumber}INPPS is the Timer external reset source
     */
    ${moduleNameUpperCase}_T${instanceNumber}INPPS,

     /* CCP1_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP1_OUT,
    
    /* CCP2_OUT is the Timer external reset source 
     */
    ${moduleNameUpperCase}_CCP2_OUT,
    
     /* PWM3_out is the Timer external reset source 
    */
    ${moduleNameUpperCase}_PWM3_OUT,
            
    /* PWM4_out is the Timer external reset source 
     */
    ${moduleNameUpperCase}_PWM4_OUT,
</#if>

} ${moduleNameUpperCase}_HLT_EXT_RESET_SOURCE;


/**
  Section: Macro Declarations
*/
<#if (useInterrupt) && (tickerFactor != "0") && (tickerFactor != "1")>
#define ${moduleNameUpperCase}_INTERRUPT_TICKER_FACTOR    ${tickerFactor}
</#if>

/**
  Section: ${moduleNameUpperCase} APIs
*/

<#list initializers as initializer>
/**
  @Summary
    Initializes the ${moduleNameUpperCase} module.

  @Description
    This function initializes the ${moduleNameUpperCase} Registers.
    This function must be called before any other ${moduleNameUpperCase} function is called.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment
    

  @Example
    <code>
    main()
    {
        // Initialize ${moduleNameUpperCase} module
        ${initializer}();

        // Do something else...
    }
    </code>
*/
void ${initializer}(void);
</#list>

/**
  @Summary
    Configures the Hardware Limit Timer mode.

  @Description
    Writes the T${instanceNumber}HLTbits.MODE bits.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    mode - Value to write into T${instanceNumber}HLTbits.MODE bits.

  @Returns
    None

  @Example
    <code>
	main()
    {

	    ${moduleNameUpperCase}_HLT_MODE hltmode;
		hltmode = ${moduleNameUpperCase}_ROP_STARTS_TMRON_EN;

		// Initialize ${moduleNameUpperCase} module
		 ${moduleNameUpperCase}.Initialize();

		// Set the HLT mode
		${moduleNameUpperCase}_ModeSet (hltmode);

		// Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_ModeSet(${moduleNameUpperCase}_HLT_MODE mode);

/**
  @Summary
    Configures the HLT external reset source.

  @Description
    Writes the T${instanceNumber}RSTbits.RSEL bits.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    reset - Value to write into T${instanceNumber}RSTbits.RSEL bits.

  @Returns
    None

  @Example
    <code>
	main()
    {

	    ${moduleNameUpperCase}_HLT_EXT_RESET_SOURCE hltresetsrc;
		hltresetsrc = T2IN;

        // Initialize ${moduleNameUpperCase} module

		// Set the HLT mode
		${moduleNameUpperCase}_ExtResetSourceSet(hltresetsrc);

		// Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_ExtResetSourceSet(${moduleNameUpperCase}_HLT_EXT_RESET_SOURCE reset);

/**
  @Summary
    This function starts the ${moduleNameUpperCase}.

  @Description
    This function starts the ${moduleNameUpperCase} operation.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_Start();

    // Do something else...
    </code>
*/
void ${moduleNameUpperCase}_Start(void);

/**
  @Summary
    This function starts the ${moduleNameUpperCase}.

  @Description
    This function starts the ${moduleNameUpperCase} operation.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Do something else...
    </code>
*/
void ${moduleNameUpperCase}_StartTimer(void);

/**
  @Summary
    This function stops the ${moduleNameUpperCase}.

  @Description
    This function stops the ${moduleNameUpperCase} operation.
    This function must be called after the start of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_Start();

    // Do something else...

    // Stop ${moduleNameUpperCase};
    ${moduleNameUpperCase}_Stop();
    </code>
*/
void ${moduleNameUpperCase}_Stop(void);

/**
  @Summary
    This function stops the ${moduleNameUpperCase}.

  @Description
    This function stops the ${moduleNameUpperCase} operation.
    This function must be called after the start of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    None

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Do something else...

    // Stop ${moduleNameUpperCase};
    ${moduleNameUpperCase}_StopTimer();
    </code>
*/
void ${moduleNameUpperCase}_StopTimer(void);

/**
  @Summary
    Reads the TMR${instanceNumber} register.

  @Description
    This function reads the TMR${instanceNumber} register value and return it.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    This function returns the current value of TMR${instanceNumber} register.

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_Start();

    // Read the current value of ${moduleNameUpperCase}
    if(0 == ${moduleNameUpperCase}_Counter8BitGet())
    {
        // Do something else...

        // Reload the TMR value
        ${moduleNameUpperCase}_Period8BitSet();
    }
    </code>
*/
uint8_t ${moduleNameUpperCase}_Counter8BitGet(void);

/**
  @Summary
    Reads the TMR${instanceNumber} register.

  @Description
    This function reads the TMR${instanceNumber} register value and return it.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    None

  @Returns
    This function returns the current value of TMR${instanceNumber} register.

  @Example
    <code>
    // Initialize ${moduleNameUpperCase} module

    // Start ${moduleNameUpperCase}
    ${moduleNameUpperCase}_StartTimer();

    // Read the current value of ${moduleNameUpperCase}
    if(0 == ${moduleNameUpperCase}_ReadTimer())
    {
        // Do something else...

        // Reload the TMR value
        ${moduleNameUpperCase}_LoadPeriodRegister();
    }
    </code>
*/
uint8_t ${moduleNameUpperCase}_ReadTimer(void);

/**
  @Summary
    Writes the TMR${instanceNumber} register.

  @Description
    This function writes the TMR${instanceNumber} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    timerVal - Value to write into TMR${instanceNumber} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD 0x80
    #define ZERO   0x00

    while(1)
    {
        // Read the TMR${instanceNumber} register
        if(ZERO == ${moduleNameUpperCase}_Counter8BitGet())
        {
            // Do something else...

            // Write the TMR${instanceNumber} register
            ${moduleNameUpperCase}_Counter8BitSet(PERIOD);
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_Counter8BitSet(uint8_t timerVal);

/**
  @Summary
    Writes the TMR${instanceNumber} register.

  @Description
    This function writes the TMR${instanceNumber} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    timerVal - Value to write into TMR${instanceNumber} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD 0x80
    #define ZERO   0x00

    while(1)
    {
        // Read the TMR${instanceNumber} register
        if(ZERO == ${moduleNameUpperCase}_ReadTimer())
        {
            // Do something else...

            // Write the TMR${instanceNumber} register
            ${moduleNameUpperCase}_WriteTimer(PERIOD);
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_WriteTimer(uint8_t timerVal);

/**
  @Summary
    Load value to Period Register.

  @Description
    This function writes the value to PR${instanceNumber} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    periodVal - Value to load into TMR${instanceNumber} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD1 0x80
    #define PERIOD2 0x40
    #define ZERO    0x00

    while(1)
    {
        // Read the TMR${instanceNumber} register
        if(ZERO == ${moduleNameUpperCase}_Counter8BitGet())
        {
            // Do something else...

            if(flag)
            {
                flag = 0;

                // Load Period 1 value
                ${moduleNameUpperCase}_Period8BitSet(PERIOD1);
            }
            else
            {
                 flag = 1;

                // Load Period 2 value
                ${moduleNameUpperCase}_Period8BitSet(PERIOD2);
            }
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_Period8BitSet(uint8_t periodVal);

/**
  @Summary
    Load value to Period Register.

  @Description
    This function writes the value to PR${instanceNumber} register.
    This function must be called after the initialization of ${moduleNameUpperCase}.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} before calling this function.

  @Param
    periodVal - Value to load into TMR${instanceNumber} register.

  @Returns
    None

  @Example
    <code>
    #define PERIOD1 0x80
    #define PERIOD2 0x40
    #define ZERO    0x00

    while(1)
    {
        // Read the TMR${instanceNumber} register
        if(ZERO == ${moduleNameUpperCase}_ReadTimer())
        {
            // Do something else...

            if(flag)
            {
                flag = 0;

                // Load Period 1 value
                ${moduleNameUpperCase}_LoadPeriodRegister(PERIOD1);
            }
            else
            {
                 flag = 1;

                // Load Period 2 value
                ${moduleNameUpperCase}_LoadPeriodRegister(PERIOD2);
            }
        }

        // Do something else...
    }
    </code>
*/
void ${moduleNameUpperCase}_LoadPeriodRegister(uint8_t periodVal);

<#if useInterrupt>
<#if isVectoredInterruptEnabled>
<#else>
/**
  @Summary
    Timer Interrupt Service Routine

  @Description
    Timer Interrupt Service Routine is called by the Interrupt Manager.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_${interruptFunctionName}(void);
</#if>

<#if (tickerFactor != "0")>
/**
  @Summary
    CallBack function

  @Description
    This function is called from the timer ISR. User can write your code in this function.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this function.

  @Param
    None

  @Returns
    None
*/
 void ${moduleNameUpperCase}_CallBack(void);
</#if>
/**
  @Summary
    Set Timer Interrupt Handler

  @Description
    This sets the function to be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this.

  @Param
    Address of function to be set

  @Returns
    None
*/
 void ${moduleNameUpperCase}_SetInterruptHandler(void (* InterruptHandler)(void));

/**
  @Summary
    Timer Interrupt Handler

  @Description
    This is a function pointer to the function that will be called during the ISR

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
extern void (*${moduleNameUpperCase}_InterruptHandler)(void);

/**
  @Summary
    Default Timer Interrupt Handler

  @Description
    This is the default Interrupt Handler function

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module with interrupt before calling this isr.

  @Param
    None

  @Returns
    None
*/
void ${moduleNameUpperCase}_DefaultInterruptHandler(void);

 <#else>
/**
  @Summary
    Boolean routine to poll or to check for the match flag on the fly.

  @Description
    This function is called to check for the timer match flag.
    This function is usd in timer polling method.

  @Preconditions
    Initialize  the ${moduleNameUpperCase} module before calling this routine.

  @Param
    None

  @Returns
    true - timer match has occured.
    false - timer match has not occured.

  @Example
    <code>
    while(1)
    {
        // check the match flag
        if(${moduleNameUpperCase}_HasOverflowOccured())
        {
            // Do something else...

            // clear the ${moduleNameUpperCase} match interrupt flag
            TMR${instanceNumber}IF = 0;

            // Reload the ${moduleNameUpperCase} value
            ${moduleNameUpperCase}_Reload();
        }
    }
    </code>
*/
bool ${moduleNameUpperCase}_HasOverflowOccured(void);
</#if>

 #ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // ${moduleNameUpperCase}_H
/**
 End of File
*/