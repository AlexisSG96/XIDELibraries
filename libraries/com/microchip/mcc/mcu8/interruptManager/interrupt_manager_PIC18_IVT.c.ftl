/**
  Generated Interrupt Manager Header File

  @Company:
    Microchip Technology Inc.

  @File Name:
    interrupt_manager.h

  @Summary:
    This is the Interrupt Manager file generated using ${productName}

  @Description:
    This header file provides implementations for global interrupt handling.
    For individual peripheral handlers please see the peripheral driver for
    all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.12
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#include "interrupt_manager.h"
#include "mcc.h"

void  INTERRUPT_Initialize (void)
{
    <#if IPENData??>
    ${IPENData.name} = 1;
    </#if>

    <#if IVTBaseAddress!="">
    bool state = (unsigned char)GIE;
    GIE = 0;
    IVTLOCK = 0x55;
    IVTLOCK = 0xAA;
    IVTLOCKbits.IVTLOCKED = 0x00; // unlock IVT

    IVTBASEU = ${IVTBASEUval};
    IVTBASEH = ${IVTBASEHval};
    IVTBASEL = ${IVTBASELval};

    IVTLOCK = 0x55;
    IVTLOCK = 0xAA;
    IVTLOCKbits.IVTLOCKED = 0x01; // lock IVT

    GIE = state;
    </#if>

    <#if IVTInterrupts?size != 0>
    // Assign peripheral interrupt priority vectors
    </#if>
    <#list IVTInterrupts as interrupt>
    <#if interrupt.priority == "low_priority">
    ${interrupt.priorityBitName} = 0;
    <#else>
    ${interrupt.priorityBitName} = 1;
    </#if>
    </#list>
}

void __interrupt(irq(default),base(${IVTBaseAddress})) Default_ISR()
{
}

/**
 End of File
*/
