/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"

<#if enableCrcInterrupt>
#define  CRC_BUFFER_SIZE       8
static volatile uint8_t crcBufferHead = 0;
static volatile uint8_t crcBufferTail = 0;
static volatile uint32_t crcBuffer[CRC_BUFFER_SIZE];
volatile uint8_t crcBufferRemaining;
</#if>

<#if enableCrcInterrupt>
void (*${moduleNameUpperCase}_CrcInterruptHandler)(void);
</#if>
<#if enableScannerInterrupt>
void (*${moduleNameUpperCase}_ScannerInterruptHandler)(void);
</#if>

void ${moduleNameUpperCase}_Initialize(void)
{
    //${moduleNameUpperCase} Configurations
    <#if CRCCON1??>
    //${CRCCON1.csvComment}
    ${CRCCON1.name} = ${CRCCON1.hexValue};
    </#if>
    <#if CRCCON2??>
    //${CRCCON2.csvComment}
    ${CRCCON2.name} = ${CRCCON2.hexValue};
    </#if>

    // Read/Write access to CRCXOR
    ${CRCCON0.name}bits.SETUP = 0b10;
    <#if CRCXORT??>
    //${CRCXORT.csvComment}
    ${CRCXORT.name} = ${CRCXORT.hexValue};
    </#if>
    <#if CRCXORU??>
    //${CRCXORU.csvComment}
    ${CRCXORU.name} = ${CRCXORU.hexValue};
    </#if>
    <#if CRCXORH??>
    //${CRCXORH.csvComment}
    ${CRCXORH.name} = ${CRCXORH.hexValue};
    </#if>
    <#if CRCXORL??>
    //${CRCXORL.csvComment}
    ${CRCXORL.name} = ${CRCXORL.hexValue};
    </#if>

    // Read/Write access to CRCOUT
    ${CRCCON0.name}bits.SETUP = 0b00;
    <#if CRCOUTT??>
    //${CRCOUTT.csvComment}
    ${CRCOUTT.name} = ${CRCOUTT.hexValue};
    </#if>
    <#if CRCOUTU??>
    //${CRCOUTU.csvComment}
    ${CRCOUTU.name} = ${CRCOUTU.hexValue};
    </#if>
    <#if CRCOUTH??>
    //${CRCOUTH.csvComment}
    ${CRCOUTH.name} = ${CRCOUTH.hexValue};
    </#if>
    <#if CRCOUTL??>
    //${CRCOUTL.csvComment}
    ${CRCOUTL.name} = ${CRCOUTL.hexValue};
    </#if>

    <#if seedMethod == "indirect">
    // Indirect method calculation
    ${CRCI_ENABLE.name} = 0;
    ${CRCI_FLAG.name} = 0;
    <#if CRCCON0??>
    //${CRCCON0.csvComment}
    ${CRCCON0.name} = ${CRCCON0.hexValue};
    </#if>
    ${CRCCON0.name}bits.CRCGO = 1;
    </#if>
    <#if CRCDATAT??>
    //${CRCDATAT.csvComment}
    ${CRCDATAT.name} = ${CRCDATAT.hexValue};
    </#if>
    <#if CRCDATAU??>
    //${CRCDATAU.csvComment}
    ${CRCDATAU.name} = ${CRCDATAU.hexValue};
    </#if>
    <#if CRCDATAH??>
    //${CRCDATAH.csvComment}
    ${CRCDATAH.name} = ${CRCDATAH.hexValue};
    </#if>
    <#if CRCDATAL??>
    //${CRCDATAL.csvComment}
    ${CRCDATAL.name} = ${CRCDATAL.hexValue};
    </#if>
    <#if seedMethod == "indirect">
    while(${CRCCON0.name}bits.CRCBUSY == 0);
    ${CRCCON0.name}bits.CRCGO = 0;
    ${CRCI_FLAG.name} = 0;
    </#if>

    //Scanner Configurations
    <#if SCANHADRU??>
    //${SCANHADRU.csvComment}
    ${SCANHADRU.name} = ${SCANHADRU.hexValue};
    </#if>
    <#if SCANHADRH??>
    //${SCANHADRH.csvComment}
    ${SCANHADRH.name} = ${SCANHADRH.hexValue};
    </#if>
    <#if SCANHADRL??>
    //${SCANHADRL.csvComment}
    ${SCANHADRL.name} = ${SCANHADRL.hexValue};
    </#if>
    <#if SCANLADRU??>
    //${SCANLADRU.csvComment}
    ${SCANLADRU.name} = ${SCANLADRU.hexValue};
    </#if>
    <#if SCANLADRH??>
    //${SCANLADRH.csvComment}
    ${SCANLADRH.name} = ${SCANLADRH.hexValue};
    </#if>
    <#if SCANLADRL??>
    //${SCANLADRL.csvComment}
    ${SCANLADRL.name} = ${SCANLADRL.hexValue};
    </#if>
    <#if SCANTRIG??>
    //${SCANTRIG.csvComment}
    ${SCANTRIG.name} = ${SCANTRIG.hexValue};
    </#if>

    <#if enableCrcInterrupt>
    // Clearing IF flag before enabling the interrupt.
    ${CRCI_FLAG.name} = 0;
    crcBufferHead = 0;
    crcBufferTail = 0;
    crcBufferRemaining = CRC_BUFFER_SIZE;
    // Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetCrcInterruptHandler(${moduleNameUpperCase}_DefaultCrcInterruptHandler);
    // Enabled CRCI ${moduleNameUpperCase} interrupt
    ${CRCI_ENABLE.name} = 1;
    <#else>
    // Clearing ${moduleNameUpperCase} IF flag
    ${CRCI_FLAG.name} = 0;
    // Disabled CRCI ${moduleNameUpperCase} interrupt
    ${CRCI_ENABLE.name} = 0;
    </#if>

    <#if enableScannerInterrupt>
    // Clearing Scanner IF flag before enabling the interrupt.
    ${SCANI_FLAG.name} = 0;
    // Set Default Interrupt Handler
    ${moduleNameUpperCase}_SetScannerInterruptHandler(${moduleNameUpperCase}_DefaultScannerInterruptHandler);
    // Enabled SCANI ${moduleNameUpperCase} interrupt
    ${SCANI_ENABLE.name} = 1;
    <#else>
    // Clearing Scanner IF flag.
    ${SCANI_FLAG.name} = 0;
    // Disabled SCANI ${moduleNameUpperCase} interrupt
    ${SCANI_ENABLE.name} = 0;
    </#if>

    <#if CRCCON0??>
    //${CRCCON0.csvComment}
    ${CRCCON0.name} = ${CRCCON0.hexValue};
    </#if>
    <#if SCANCON0??>
    //${SCANCON0.csvComment}
    ${SCANCON0.name} = ${SCANCON0.hexValue};
    </#if>
}

inline void ${moduleNameUpperCase}_StartCrc(void)
{
    // Start the serial shifter
    ${CRCCON0.name}bits.CRCGO = 1;
}

bool ${moduleNameUpperCase}_WriteData(uint32_t data)
{
    if(!${CRCCON0.name}bits.FULL)
    {
        <#if CRCDATAT??>
        ${CRCDATAT.name} = (uint8_t)((data >> 24) & 0xFF);
        </#if>
        <#if CRCDATAU??>
        ${CRCDATAU.name} = (uint8_t)((data >> 16) & 0xFF);
        </#if>
        <#if CRCDATAH??>
        ${CRCDATAH.name} = (uint8_t)((data >> 8) & 0xFF);
        </#if>
        <#if CRCDATAL??>
        ${CRCDATAL.name} = (uint8_t)(data & 0xFF);
        </#if>
        return true;
    } 
    else 
    {
        return false;
    }
}
<#if enableCrcInterrupt>

bool CRC_IsBufferEmpty()
{
    if(crcBufferRemaining == CRC_BUFFER_SIZE)
    {
        return true;
    }
    else 
    {
        return false;
    }
}

bool ${moduleNameUpperCase}_WriteBuffer(uint32_t data)
{
    if(!crcBufferRemaining)
    {
      return false;
    }
    else
    {
        if((crcBufferRemaining == CRC_BUFFER_SIZE) && (${CRCCON0.name}bits.FULL == 0))
        {
            <#if CRCDATAT??>
            ${CRCDATAT.name} = (uint8_t)((data >> 24) & 0xFF);
            </#if>
            <#if CRCDATAU??>
            ${CRCDATAU.name} = (uint8_t)((data >> 16) & 0xFF);
            </#if>
            <#if CRCDATAH??>
            ${CRCDATAH.name} = (uint8_t)((data >> 8) & 0xFF);
            </#if>
            <#if CRCDATAL??>
            ${CRCDATAL.name} = (uint8_t)(data & 0xFF);
            </#if>
        }
        else
        {
            // Write data into CRC software buffer
            crcBuffer[crcBufferHead] = data;
            crcBufferHead++;
            crcBufferRemaining--;

            if(CRC_BUFFER_SIZE <= crcBufferHead)
            {
                crcBufferHead = 0;
            }
        }
        return true;
    }
}
</#if>

static uint32_t ${moduleNameUpperCase}_ReverseValue(uint32_t crc)
{
    uint32_t mask;
    uint32_t reverse;

    mask = 1;
    mask <<= ${CRCCON1.name}bits.PLEN;
    reverse = 0;

    while(crc)
    {
        if(crc & 0x01)
        {
            reverse |= mask;
        }
        mask >>= 1;
        crc >>= 1;
    }
    return reverse;
}

uint32_t ${moduleNameUpperCase}_GetCalculatedResult(bool reverse, uint32_t xorValue)
{
    uint32_t result = 0x00;
    // Read/Write access to CRCOUT
    ${CRCCON0.name}bits.SETUP = 0b00;
    <#if CRCOUTL??>
    result = (uint32_t)${CRCOUTL.name};
    </#if>
    <#if CRCOUTH??>
    result = result | ((uint32_t)${CRCOUTH.name} << 8);
    </#if>
    <#if CRCOUTU??>
    result = result | ((uint32_t)${CRCOUTU.name} << 16);
    </#if>
    <#if CRCOUTT??>
    result = result | ((uint32_t)${CRCOUTT.name} << 24);
    </#if>
    if(reverse)
    {
        result = CRC_ReverseValue(result);
    }
    result ^= xorValue;
    return (result & ${polyMask});
}

inline bool ${moduleNameUpperCase}_IsCrcBusy(void)
{
    return(${CRCCON0.name}bits.CRCBUSY);
}

inline void ${moduleNameUpperCase}_StartScanner(void)
{
    uint8_t gIntFlagStatus = 0;
    gIntFlagStatus = ${globalInterruptEnableBit};

    // Disable global Interrupts;
    ${globalInterruptEnableBit} = 0;
    // Grant memory access to ${moduleNameUpperCase} Scanner peripherals
    ${priorityLockRegister} = 0x55;
    ${priorityLockRegister} = 0xAA;
    ${priorityLockRegister}bits.PRLOCKED = 1;
    ${globalInterruptEnableBit} = gIntFlagStatus;

    // Start the serial shifter
    ${CRCCON0.name}bits.CRCGO = 1;
    // Start the scanner
    ${SCANCON0.name}bits.SGO = 1;
}

inline void ${moduleNameUpperCase}_StopScanner(void)
{
    uint8_t gIntFlagStatus = 0;
    gIntFlagStatus = ${globalInterruptEnableBit};

    // Disable global Interrupts;
    ${globalInterruptEnableBit} = 0;
    // Forbid memory access to ${moduleNameUpperCase} Scanner peripherals
    ${priorityLockRegister} = 0x55;
    ${priorityLockRegister} = 0xAA;
    ${priorityLockRegister}bits.PRLOCKED = 0;
    ${globalInterruptEnableBit} = gIntFlagStatus;

    // Stop the serial shifter
    ${CRCCON0.name}bits.CRCGO = 0;
    // Stop the scanner
    ${SCANCON0.name}bits.SGO = 0;
}

void ${moduleNameUpperCase}_SetScannerAddressLimit(uint24_t startAddr, uint24_t endAddr)
{
    <#if SCANHADRU??>
    ${SCANHADRU.name} = (uint8_t)((endAddr >> 16) & 0xFF);
    </#if>
    <#if SCANHADRH??>
    ${SCANHADRH.name} = (uint8_t)((endAddr >> 8) & 0xFF);
    </#if>
    <#if SCANHADRL??>
    ${SCANHADRL.name} = (uint8_t)(endAddr & 0xFF);
    </#if>
    <#if SCANLADRU??>
    ${SCANLADRU.name} = (uint8_t)((startAddr >> 16) & 0xFF);
    </#if>
    <#if SCANLADRH??>
    ${SCANLADRH.name} = (uint8_t)((startAddr >> 8) & 0xFF);
    </#if>
    <#if SCANLADRL??>
    ${SCANLADRL.name} = (uint8_t)(startAddr & 0xFF);
    </#if>
}

inline bool ${moduleNameUpperCase}_IsScannerBusy(void)
{
    return(${SCANCON0.name}bits.BUSY);
}

<#if enableCrcInterrupt>
<#if isVectoredInterrupt>
<#if isHighPriorityCrc>
void __interrupt(irq(${crcInterrupt}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_CrcIsr()
<#else>
void __interrupt(irq(${crcInterrupt}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_CrcIsr()
</#if>
<#else>
void ${moduleNameUpperCase}_CrcIsr(void)
</#if>
{
    if(${CRCI_FLAG.name} == 1){
        if(${moduleNameUpperCase}_CrcInterruptHandler){
            ${moduleNameUpperCase}_CrcInterruptHandler();
        }
        ${CRCI_FLAG.name}= 0;
    }
}

void ${moduleNameUpperCase}_SetCrcInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_CrcInterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_DefaultCrcInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    if(CRC_BUFFER_SIZE > crcBufferRemaining)
    {
        <#if CRCDATAT??>
        ${CRCDATAT.name} = (uint8_t)((crcBuffer[crcBufferTail] >> 24) & 0xFF);
        </#if>
        <#if CRCDATAU??>
        ${CRCDATAU.name} = (uint8_t)((crcBuffer[crcBufferTail] >> 16) & 0xFF);
        </#if>
        <#if CRCDATAH??>
        ${CRCDATAH.name} = (uint8_t)((crcBuffer[crcBufferTail] >> 8) & 0xFF);
        </#if>
        <#if CRCDATAL??>
        ${CRCDATAL.name} = (uint8_t)(crcBuffer[crcBufferTail] & 0xFF);
        </#if>
        crcBufferTail ++;
        crcBufferRemaining++;
        if(CRC_BUFFER_SIZE <= crcBufferTail)
        {
            crcBufferTail = 0;
        }
    }
}
</#if>

<#if enableScannerInterrupt>
<#if isVectoredInterrupt>
<#if isHighPriorityScanner>
void __interrupt(irq(${scannerInterrupt}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ScannerIsr()
<#else>
void __interrupt(irq(${scannerInterrupt}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ScannerIsr()
</#if>
<#else>
void ${moduleNameUpperCase}_ScannerIsr(void)
</#if>
{
    if(${SCANI_FLAG.name} == 1){
        if(${moduleNameUpperCase}_ScannerInterruptHandler){
            ${moduleNameUpperCase}_ScannerInterruptHandler();
        }
        ${SCANI_FLAG.name}= 0;
    }
}

void ${moduleNameUpperCase}_SetScannerInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_ScannerInterruptHandler = InterruptHandler;
}

void ${moduleNameUpperCase}_DefaultScannerInterruptHandler(void){
    // add your ${moduleNameUpperCase} interrupt custom code
    // or set custom function using ${moduleNameUpperCase}_SetScannerInterruptHandler()
}
</#if>