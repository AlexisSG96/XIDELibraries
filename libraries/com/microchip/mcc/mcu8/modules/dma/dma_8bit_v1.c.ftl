/**
  DMA Generated Driver File
  
  @Company
    Microchip Technology Inc.

  @File Name
    ${fileName}.c

  @Summary
    This is the generated driver implementation file for the DMA driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
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

#include <xc.h>
#include "${fileName}.h"
<#if useInterruptSCNTI || useInterruptDCNTI || useInterruptAI || useInterruptORI>
#include "interrupt_manager.h"
</#if>

/**
  Section: Global Variables Definitions
*/

/**
  Section: DMA APIs
*/
void DMA${channelNumber}_Initialize(void)
{
    DMA${channelNumber}SSA = ${sourceAddress}; //set source start address
    DMA${channelNumber}DSA = ${destinationAddress}; //set destination start address 
    DMA${channelNumber}CON1 = ${control1Register}; //set control register1 
    DMA${channelNumber}SSZ = ${sourceSize}; //set source size
    DMA${channelNumber}DSZ = ${destinationSize}; //set destination size
    DMA${channelNumber}SIRQ = ${triggerSource}; //set DMA Transfer Trigger Source
    DMA${channelNumber}AIRQ = ${abortSource}; //set DMA Transfer abort Source
    
    ${flagDCNTI} =0; // clear Destination Count Interrupt Flag bit
    ${flagSCNTI} =0; // clear Source Count Interrupt Flag bit
    ${flagAI} =0; // clear abort Interrupt Flag bit
	${flagORI} =0; // clear overrun Interrupt Flag bit
    
    <#if useInterruptDCNTI>
    ${enableDCNTI} =1; // enable Destination Count 0 Interrupt
    <#else>
    ${enableDCNTI} =0; // disable Destination Count 0 Interrupt
    </#if>
    <#if useInterruptSCNTI>
    ${enableSCNTI} =1; // enable Source Count Interrupt
    <#else>
    ${enableSCNTI} =0; // disable Source Count Interrupt
    </#if>
    <#if useInterruptAI>
    ${enableAI} =1; // enable abort Interrupt
    <#else>
    ${enableAI} =0; // disable abort Interrupt
    </#if>
    <#if useInterruptORI>    
    ${enableORI} =1; // enable overrun Interrupt 
    <#else>
    ${enableORI} =0; // disable overrun Interrupt 
    </#if>
	
	asm("BCF ${interruptControlRegister0},7");
	
	asm ("BANKSEL ${priorityLockRegister}");
    asm ("MOVLW 0x55");
    asm ("MOVWF ${priorityLockRegister}");
    asm ("MOVLW 0xAA");
    asm ("MOVWF ${priorityLockRegister}");
    asm ("BSF ${priorityLockRegister}, 0");
	
	asm("BSF ${interruptControlRegister0},7");
        
    DMA${channelNumber}CON0 = ${control0Register}; //set control register0
}

<#if useInterruptSCNTI>
<#if isVectoredInterrupt>
<#if isHighPrioritySCNTI>
void __interrupt(irq(${interruptIRQName}SCNT),base(${IVTBaseAddress})) DMA${channelNumber}_DMASCNT_ISR()
<#else>
void __interrupt(irq(${interruptIRQName}SCNT),base(${IVTBaseAddress}),low_priority) DMA${channelNumber}_DMASCNT_ISR()
</#if>
<#else>         
void DMA${channelNumber}_DMASCNT_ISR(void)
</#if>
{
    ${flagSCNTI}=0;// clear Source Count Interrupt Flag 
    // add your DMA channel ${channelNumber} source count 0 interrupt custom code
}
</#if>

<#if useInterruptDCNTI>
<#if isVectoredInterrupt>
<#if isHighPriorityDCNTI>
void __interrupt(irq(${interruptIRQName}DCNT),base(${IVTBaseAddress})) DMA${channelNumber}_DMADCNT_ISR()
<#else>
void __interrupt(irq(${interruptIRQName}DCNT),base(${IVTBaseAddress}),low_priority) DMA${channelNumber}_DMADCNT_ISR()
</#if>
<#else>  
void DMA${channelNumber}_DMADCNT_ISR(void)
</#if>
{
    ${flagDCNTI}=0; // clear Destination Count Interrupt Flag 
    // add your DMA channel ${channelNumber} destination count 0 interrupt custom code
}
</#if>

<#if useInterruptAI>
<#if isVectoredInterrupt>
<#if isHighPriorityAI>
#if (__XC8_VERSION <= 1400)
void __interrupt(irq(${interruptIRQName}ARBT),base(${IVTBaseAddress})) DMA${channelNumber}_DMAA_ISR()
#else   // __XC8_VERSION
void __interrupt(irq(${interruptIRQName}A),base(${IVTBaseAddress})) DMA${channelNumber}_DMAA_ISR()
#endif // __XC8_VERSION
<#else>
#if (__XC8_VERSION <= 1400)
void __interrupt(irq(${interruptIRQName}ARBT),base(${IVTBaseAddress}),low_priority) DMA${channelNumber}_DMAA_ISR()    
#else  // __XC8_VERSION   
void __interrupt(irq(${interruptIRQName}A),base(${IVTBaseAddress}),low_priority) DMA${channelNumber}_DMAA_ISR()
#endif // __XC8_VERSION
</#if>
<#else>
void DMA${channelNumber}_DMAA_ISR(void)
</#if>
{
    ${flagAI}=0;// clear abort Interrupt Flag 
    // add your DMA channel ${channelNumber} abort interrupt custom code
}
</#if>

<#if useInterruptORI>
<#if isVectoredInterrupt>
<#if isHighPriorityORI>
#if (__XC8_VERSION <= 1400)
void __interrupt(irq(IRQ_DMA${channelNumber}OVR),base(${IVTBaseAddress})) DMA${channelNumber}_DMAOR_ISR()
#else // __XC8_VERSION
void __interrupt(irq(${interruptIRQName}OR),base(${IVTBaseAddress})) DMA${channelNumber}_DMAOR_ISR()
#endif // __XC8_VERSION
<#else>
#if (__XC8_VERSION <= 1400)
void __interrupt(irq(IRQ_DMA${channelNumber}OVR),base(${IVTBaseAddress}),low_priority) DMA${channelNumber}_DMAOR_ISR()
#else // __XC8_VERSION
void __interrupt(irq(${interruptIRQName}OR),base(${IVTBaseAddress}),low_priority) DMA${channelNumber}_DMAOR_ISR()
#endif // __XC8_VERSION
</#if>
<#else>
void DMA${channelNumber}_DMAOR_ISR(void)
</#if>
{
    ${flagORI}=0;// clear overrun Interrupt Flag 
    // add your DMA channel ${channelNumber} overrun interrupt custom code
}
</#if>
/**
  End of File
*/