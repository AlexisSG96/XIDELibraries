/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
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

<#if DMASCNTI_ENABLE.value == "enabled">
void (*${moduleNameUpperCase}_SCNTI_InterruptHandler)(void);
</#if>
<#if DMADCNTI_ENABLE.value == "enabled">
void (*${moduleNameUpperCase}_DCNTI_InterruptHandler)(void);
</#if>
<#if DMAAI_ENABLE.value == "enabled">
void (*${moduleNameUpperCase}_AI_InterruptHandler)(void);
</#if>
<#if DMAORI_ENABLE.value == "enabled">
void (*${moduleNameUpperCase}_ORI_InterruptHandler)(void);
</#if>

/**
  Section: ${moduleNameUpperCase} APIs
*/

void ${moduleNameUpperCase}_Initialize(void)
{
    <#if DMASELECT??>
    //DMA Instance Selection : ${DMASELECT.hexValue}
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
    <#if DMASSAL??>
    <#if SrcRegion == "Data EEPROM">
    //Source Address : ${SrcAddress}
    ${moduleName}SSA = ${SrcAddress};
    <#elseif SrcRegion == "SFR">
    //Source Address : &${SrcSFR}
    ${moduleName}SSA = &${SrcSFR};
    <#elseif SrcRegion == "GPR">
    //Source Address : ${SrcVarName}
    ${moduleName}SSA = &${SrcVarName};
    <#else>
    //Source Address : ${SrcAddress}
    ${moduleName}SSA = ${SrcAddress};
    </#if>
    </#if>
    <#if DMASSAL??>
    <#if DstRegion == "SFR">
    //Destination Address : &${DstSFR}
    ${moduleName}DSA = &${DstSFR};
    <#else>
    //Destination Address : &${DstVarName}
    ${moduleName}DSA= &${DstVarName};
    </#if>
    </#if>
    <#if DMACON1??>
    //${DMACON1.csvComment}
    ${DMACON1.name} = ${DMACON1.hexValue};
    </#if>
    <#if DMASSZL??>
    //Source Message Size : ${SrcMessageSize}
    ${moduleName}SSZ = ${SrcMessageSize};
    </#if>
    <#if DMADSZL??>
    //Destination Message Size : ${DstMessageSize}
    ${moduleName}DSZ = ${DstMessageSize};
    </#if>
    <#if DMASIRQ??>
    //Start Trigger : ${DMASIRQ.csvComment}
    ${DMASIRQ.name} = ${DMASIRQ.hexValue};
    </#if>
    <#if DMAAIRQ??>
    //Abort Trigger : ${DMAAIRQ.csvComment}
    ${DMAAIRQ.name} = ${DMAAIRQ.hexValue};
    </#if>
	
    // Clear Destination Count Interrupt Flag bit
    ${DMADCNTI_FLAG.name} = 0; 
    // Clear Source Count Interrupt Flag bit
    ${DMASCNTI_FLAG.name} = 0; 
    // Clear Abort Interrupt Flag bit
    ${DMAAI_FLAG.name} = 0; 
    // Clear Overrun Interrupt Flag bit
    ${DMAORI_FLAG.name} =0; 
    
    <#if DMADCNTI_ENABLE.value == "enabled">
    ${DMADCNTI_ENABLE.name} = 1;
	${moduleNameUpperCase}_SetDCNTIInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>
    ${DMADCNTI_ENABLE.name} = 0;
    </#if>
    <#if DMASCNTI_ENABLE.value == "enabled">
    ${DMASCNTI_ENABLE.name} = 1; 
	${moduleNameUpperCase}_SetSCNTIInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>
    ${DMASCNTI_ENABLE.name} = 0;
    </#if>
    <#if DMAAI_ENABLE.value == "enabled">
    ${DMAAI_ENABLE.name} = 1; 
	${moduleNameUpperCase}_SetAIInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>
    ${DMAAI_ENABLE.name} = 0;
    </#if>
    <#if DMAORI_ENABLE.value == "enabled">
    ${DMAORI_ENABLE.name} =1; 
	${moduleNameUpperCase}_SetORIInterruptHandler(${moduleNameUpperCase}_DefaultInterruptHandler);
    <#else>
    ${DMAORI_ENABLE.name} = 0;
    </#if>
	
    <#if DMACON0??>
    //${DMACON0.csvComment}
    ${DMACON0.name} = ${DMACON0.hexValue};
    </#if>
	
}

void ${moduleNameUpperCase}_SelectSourceRegion(uint8_t region)
{
    <#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${DMACON1.name}bits.${DMACON1_SMR.name}  = region;
}

void ${moduleNameUpperCase}_SetSourceAddress(uint24_t address)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${moduleName}SSA = address;
}

void ${moduleNameUpperCase}_SetDestinationAddress(uint16_t address)
{
    <#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${moduleName}DSA = address;
}

void ${moduleNameUpperCase}_SetSourceSize(uint16_t size)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${moduleName}SSZ= size;
}

void ${moduleNameUpperCase}_SetDestinationSize(uint16_t size)
{                     
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${moduleName}DSZ= size;
}

uint24_t ${moduleNameUpperCase}_GetSourcePointer(void)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	return ${moduleName}SPTR;
}

uint16_t ${moduleNameUpperCase}_GetDestinationPointer(void)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	return ${moduleName}DPTR;
}

void ${moduleNameUpperCase}_SetStartTrigger(uint8_t sirq)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${moduleName}SIRQ = sirq;
}

void ${moduleNameUpperCase}_SetAbortTrigger(uint8_t airq)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${moduleName}AIRQ = airq;
}

void ${moduleNameUpperCase}_StartTransfer(void)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${DMACON0.name}bits.${DMACON0_DGO.name} = 1;
}

void ${moduleNameUpperCase}_StartTransferWithTrigger(void)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${DMACON0.name}bits.${DMACON0_SIRQEN.name} = 1;
}

void ${moduleNameUpperCase}_StopTransfer(void)
{
	<#if DMASELECT??>
    ${DMASELECT.name} = ${DMASELECT.hexValue};
    </#if>
	${DMACON0.name}bits.${DMACON0_SIRQEN.name} = 0; 
	${DMACON0.name}bits.${DMACON0_DGO.name} = 0;
}

void ${moduleNameUpperCase}_SetDMAPriority(uint8_t priority)
{
    // This function is dependant on the PR1WAY CONFIG bit
	${PriorityLockRegister} = 0x55;
	${PriorityLockRegister} = 0xAA;
	${PriorityLockRegister}bits.${PriorityLockedBit} = 0;
	${DMAxPR} = priority;
	${PriorityLockRegister} = 0x55;
	${PriorityLockRegister} = 0xAA;
	${PriorityLockRegister}bits.${PriorityLockedBit} = 1;
}

<#if DMASCNTI_ENABLE.value == "enabled">
<#if isVectoredInterruptEnabled>
<#if isHighPriority_SCNTI>
void __interrupt(irq(IRQ_${DMASCNTI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_DMASCNTI_ISR()
<#else>
void __interrupt(irq(IRQ_${DMASCNTI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_DMASCNTI_ISR()
</#if>
<#else>
void ${moduleNameUpperCase}_DMASCNTI_ISR(void)
</#if>
{
    // Clear the source count interrupt flag
    ${DMASCNTI_FLAG.name} = 0;

    if (${moduleNameUpperCase}_SCNTI_InterruptHandler)
            ${moduleNameUpperCase}_SCNTI_InterruptHandler();
}

void ${moduleNameUpperCase}_SetSCNTIInterruptHandler(void (* InterruptHandler)(void))
{
	 ${moduleNameUpperCase}_SCNTI_InterruptHandler = InterruptHandler;
}

</#if>
<#if DMADCNTI_ENABLE.value == "enabled">
<#if isVectoredInterruptEnabled>
<#if isHighPriority_DCNTI>
void __interrupt(irq(IRQ_${DMADCNTI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_DMADCNTI_ISR()
<#else>
void __interrupt(irq(IRQ_${DMADCNTI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_DMADCNTI_ISR()
</#if>
<#else>
void ${moduleNameUpperCase}_DMADCNTI_ISR(void)
</#if>
{
    // Clear the source count interrupt flag
    ${DMADCNTI_FLAG.name} = 0;

    if (${moduleNameUpperCase}_DCNTI_InterruptHandler)
            ${moduleNameUpperCase}_DCNTI_InterruptHandler();
}

void ${moduleNameUpperCase}_SetDCNTIInterruptHandler(void (* InterruptHandler)(void))
{
	 ${moduleNameUpperCase}_DCNTI_InterruptHandler = InterruptHandler;
}

</#if>
<#if DMAAI_ENABLE.value == "enabled">
<#if isVectoredInterruptEnabled>
<#if isHighPriority_AI>
void __interrupt(irq(IRQ_${DMAAI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_DMAAI_ISR()
<#else>
void __interrupt(irq(IRQ_${DMAAI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_DMAAI_ISR()
</#if>
<#else>
void ${moduleNameUpperCase}_DMAAI_ISR(void)
</#if>
{
    // Clear the source count interrupt flag
    ${DMAAI_FLAG.name} = 0;

    if (${moduleNameUpperCase}_AI_InterruptHandler)
            ${moduleNameUpperCase}_AI_InterruptHandler();
}

void ${moduleNameUpperCase}_SetAIInterruptHandler(void (* InterruptHandler)(void))
{
	 ${moduleNameUpperCase}_AI_InterruptHandler = InterruptHandler;
}

</#if>
<#if DMAORI_ENABLE.value == "enabled">
<#if isVectoredInterruptEnabled>
<#if isHighPriority_ORI>
void __interrupt(irq(IRQ_${DMAORI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_DMAORI_ISR()
<#else>
void __interrupt(irq(IRQ_${DMAORI_HANDLER.name?replace("_", "")}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_DMAORI_ISR()
</#if>
<#else>
void ${moduleNameUpperCase}_DMAORI_ISR(void)
</#if>
{
    // Clear the source count interrupt flag
    ${DMAORI_FLAG.name} = 0;

    if (${moduleNameUpperCase}_ORI_InterruptHandler)
            ${moduleNameUpperCase}_ORI_InterruptHandler();
}

void ${moduleNameUpperCase}_SetORIInterruptHandler(void (* InterruptHandler)(void))
{
	 ${moduleNameUpperCase}_ORI_InterruptHandler = InterruptHandler;
}

</#if>
<#if DMASCNTI_ENABLE.value == "enabled" || DMADCNTI_ENABLE.value == "enabled" || DMAAI_ENABLE.value == "enabled" || DMAORI_ENABLE.value == "enabled">
void ${moduleNameUpperCase}_DefaultInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}_SetSCNTIInterruptHandler() /${moduleNameUpperCase}_SetDCNTIInterruptHandler() /${moduleNameUpperCase}_SetAIInterruptHandler() /${moduleNameUpperCase}_SetORIInterruptHandler()
}
</#if>
/**
 End of File
*/
