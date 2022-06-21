/**
  DMA Generated Driver API Header File
  
  @Company
    Microchip Technology Inc.

  @File Name
    ${fileName}.h
	
  @Summary
    This is the generated header file for the DMA driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.10
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/
#ifndef DMA${channelNumber}_H
#define DMA${channelNumber}_H

#include <xc.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
        
/**
  Section: Interface Routines
*/

/**
  @Summary
    This function initializes DMA channel ${channelNumber} instance : 

  @Description
    This routine initializes the DMA channel driver instance for : 
    index, making it ready for clients to open and use it. It also initializes any
    internal data structures.
    This routine must be called before any other DMA routine is called. 

  @Preconditions
    None.

  @Param
    None.

  @Returns
    None.

  @Comment
    
 
  @Example
    <code>
        unsigned short int srcArray[100];
        unsigned short int dstArray[100];
        int i;
        int count;
        for (i=0; i<100; i++)
        {
            srcArray[i] = i+1;
            dstArray[i] = 0;
        }
        DMA1_Initialize();
        // lock priority for accessing program flash
        asm ("BANKSEL PRLOCK");
        asm ("MOVLW 0x55");
        asm ("MOVWF PRLOCK");
        asm ("MOVLW 0xAA");
        asm ("MOVWF PRLOCK");
        asm ("BSF PRLOCK, 0");
    //  hardware trigger source set as Timer 1
        TMR1_StartTimer();// start the trigger source 
    </code>

*/
void DMA${channelNumber}_Initialize(void);

<#if useInterruptSCNTI>  
<#if isVectoredInterrupt>
<#else>        
/**
  @Summary
    DMA channel  ${channelNumber} source count 0 Interrupt Service Routine

  @Description
    The DMA channel ${channelNumber} will trigger an interrupt when the DMAxSCNT<11:0> reaches zero and 
 * is reloaded to its starting value.
 * DMA source count 0 Interrupt Service Routine is called by the Interrupt Manager.
    User can write the code in this function.

  @Preconditions
    Initialize  the DMA channel ${channelNumber} module with source count reaching 0 interrupt before calling this isr.

  @Param
    None

  @Returns
    None

  @Example
    None
*/
void DMA${channelNumber}_DMASCNT_ISR(void);
</#if>
</#if>

<#if useInterruptDCNTI>
<#if isVectoredInterrupt>
<#else> 
/**
  @Summary
    DMA channel ${channelNumber} destination count 0 Interrupt Service Routine

  @Description
    The DMA channel ${channelNumber} will trigger an interrupt when the DMAxDCNT<11:0> reaches zero and 
 * is reloaded to its starting value.
 * DMA destination count 0 Interrupt Service Routine is called by the Interrupt Manager.
    User can write the code in this function.

  @Preconditions
    Initialize  the DMA channel ${channelNumber} module with destination count reaching 0 interrupt before calling this isr.

  @Param
    None

  @Returns
    None

  @Example
    None
*/
void DMA${channelNumber}_DMADCNT_ISR(void);
</#if>
</#if>

<#if useInterruptAI>
<#if isVectoredInterrupt>
<#else> 
/**
  @Summary
    DMA abort Interrupt Service Routine

  @Description
   The DMA channel ${channelNumber} will trigger an interrupt when the DMA channel ${channelNumber} has halted activity due to an abort signal from one of the abort sources. 
 * This is used to indicate that the DMA transaction has been halted for some reason.
 * DMA abort Interrupt Service Routine is called by the Interrupt Manager.
    User can write the code in this function.

  @Preconditions
    Initialize  the DMA channel ${channelNumber} module with source count reaching 0 interrupt before calling this isr.

  @Param
    None

  @Returns
    None

  @Example
    None
*/
void DMA${channelNumber}_DMAA_ISR(void);
</#if>
</#if>

<#if useInterruptORI>
<#if isVectoredInterrupt>
<#else> 
/**
  @Summary
    DMA channel ${channelNumber} overrun Interrupt Service Routine

  @Description
    The DMA channel ${channelNumber} will trigger an interrupt when the DMA channel ${channelNumber} controller receives a trigger to start a new message
 *  before the current message is completed. 
 * This condition indicates that the channel is being requested before its current transaction is finished.
 * DMA overrun Interrupt Service Routine is called by the Interrupt Manager.
    User can write the code in this function.

  @Preconditions
    Initialize  the DMA channel ${channelNumber} module with overrun interrupt before calling this isr.

  @Param
    None

  @Returns
    None

  @Example
    None
*/
void DMA${channelNumber}_DMAOR_ISR(void);
</#if>
</#if>
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
    
#endif  // ${fileName}.h