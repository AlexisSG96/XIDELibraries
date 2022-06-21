/**
  DMA${channelNumber} Generated Driver File
  
  @Company
    Microchip Technology Inc.

  @File Name
    ${fileName}.c

  @Summary
    This is the generated driver implementation file for the DMA${channelNumber} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for DMA${channelNumber}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
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
  Section: DMA${channelNumber} APIs
*/
void DMA${channelNumber}_Initialize(void)
{
    //Select DMA${channelNumber} for configuration
    DMASELECT = ${dmaSelectRegUser};
    
    //Configure DMA${channelNumber} Source Start Address
    DMAnSSAU = ${sourceAddressUpperByte};
    DMAnSSAH = ${sourceAddressHighByte};
    DMAnSSAL = ${sourceAddressLowByte};
    
    //Configure DMA${channelNumber} Destination Start Address
    DMAnDSAH = ${destinationAddressHighByte};
    DMAnDSAL = ${destinationAddressLowByte};
    
    //Configure DMA${channelNumber} Control Register 1
    DMAnCON1 = ${control1Register};
    
    //Configure DMA${channelNumber} Source Size Register
    DMAnSSZH = ${sourceSizeHighByte};
    DMAnSSZL = ${sourceSizeLowByte};
    
    //Configure DMA${channelNumber} Destination Size Register
    DMAnDSZH = ${destinationSizeHighByte};
    DMAnDSZL = ${destinationSizeLowByte};
    
    //Configure DMA${channelNumber} Start Interrupt Request Source Selection Register
    DMAnSIRQ = ${triggerSource};
    
    //Configure DMA${channelNumber} Abort Interrupt Request Source Selection Register
    DMAnAIRQ = ${abortSource};
    
    //Clear Destination Count Interrupt Flag bit
    ${flagDCNTI} =0; 
    
    //Clear Source Count Interrupt Flag bit
    ${flagSCNTI} = 0;
    
    //Clear abort Interrupt Flag bit
    ${flagAI} = 0;
    
    //Clear overrun Interrupt Flag bit
    ${flagORI} = 0;
    
    <#if useInterruptDCNTI>
    //Enable Destination Count 0 Interrupt
    ${enableDCNTI} = 1;
    <#else>
    //Disable Destination Count 0 Interrupt
    ${enableDCNTI} = 0;
    </#if>
    
    <#if useInterruptSCNTI>
    //Enable Source Count Interrupt
    ${enableSCNTI} = 1;
    <#else>
    //Disable Source Count Interrupt
    ${enableSCNTI} = 0;
    </#if>
    
    <#if useInterruptAI>
    //Enable abort Interrupt
    ${enableAI} = 1;
    <#else>
    //Disable abort Interrupt
    ${enableAI} = 0;
    </#if>
    
    <#if useInterruptORI>    
    //Enable overrun Interrupt 
    ${enableORI} = 1;
    <#else>
    //Disable overrun Interrupt 
    ${enableORI} = 0;
    </#if>
    
    //Priority Lock Sequence
    ${globalInterruptEnableBit} = 0;     // Disable Interrupts;
    ${priorityLockRegister} = 0x55;
    ${priorityLockRegister} = 0xAA;
    ${priorityLockRegister}bits.PRLOCKED = 1; // Grant memory access to peripherals;
    ${globalInterruptEnableBit} = 1;     // Enable Interrupts;
    
    //Configure DMA${channelNumber} Control Register 0
    DMAnCON0 = ${control0Register};
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