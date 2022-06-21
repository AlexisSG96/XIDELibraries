/**
  DMA${channelNumber} Generated Driver API Header File
  
  @Company
    Microchip Technology Inc.

  @File Name
    ${fileName}.h
    
  @Summary
    This is the generated header file for the DMA${channelNumber} driver using ${productName}

  @Description
    This header file provides APIs for driver for DMA${channelNumber}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB               :  ${tool}
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
    This function initializes DMA${channelNumber} module

  @Description
    This routine initializes the DMA${channelNumber}
    This routine must be called before any other DMA${channelNumber} routine is called. 

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment    
 
  @Example
    <code>
    void SYSTEM_Initialize(void)
    {
        INTERRUPT_Initialize();
        PMD_Initialize();
        PIN_MANAGER_Initialize();
        OSCILLATOR_Initialize();
        DMA${channelNumber}_Initialize();
    }
    </code>

*/
void DMA${channelNumber}_Initialize(void);

<#if useInterruptSCNTI>  
<#if isVectoredInterrupt>
<#else>        
/**
  @Summary
    DMA${channelNumber} Source Count Interrupt Service Routine

  @Description
    DMA${channelNumber} will trigger an interrupt when the DMAxSCNT<11:0> reaches zero and 
    is reloaded to its starting value.

  @Preconditions
    Initialize the DMA${channelNumber} module with Source Count Interrupt Enable bit DMA${channelNumber}SCNTIE set

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
    DMA${channelNumber} Destination Count Interrupt Service Routine
    
  @Description
    DMA${channelNumber} will trigger an interrupt when the DMAxDCNT<11:0> reaches zero and 
    is reloaded to its starting value.

  @Preconditions
    Initialize the DMA${channelNumber} module with Destination Count Interrupt Enable bit DMA${channelNumber}DCNTIE set

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
    DMA${channelNumber} Abort Interrupt Service Routine

  @Description
    DMA${channelNumber} will trigger an interrupt when the DMA${channelNumber} has halted activity due to an abort signal from one of the abort sources. 
    This is used to indicate that the DMA transaction has been halted for some reason.

  @Preconditions
    Initialize  the DMA${channelNumber} module with Abort Interrupt Enable bit DMA${channelNumber}AIE set

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
    DMA${channelNumber} Overrun Interrupt Service Routine

  @Description
    DMA${channelNumber} will trigger an interrupt when the DMA${channelNumber} controller receives a trigger to start a new message
    before the current message is completed. 
    This condition indicates that the channel is being requested before its current transaction is finished.

  @Preconditions
    Initialize  the DMA${channelNumber} module with Overrun Interrupt Enable bit DMA${channelNumber}ORIE set

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