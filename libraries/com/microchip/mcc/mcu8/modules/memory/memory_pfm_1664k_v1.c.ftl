/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This file provides implementations of driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.1.3
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/

#include <xc.h>
#include "${moduleNameLowerCase}.h"
<#if useInterrupt>
<#if isVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>


/**
  Section: Flash Module APIs
*/

uint8_t FLASH_ReadByte(uint32_t flashAddr)
{
	${NVMRegionSelectionBit} = 2;
    ${TablePointerUpperByte} = (uint8_t)((flashAddr & 0x00FF0000) >> 16);
    ${TablePointerHighByte} = (uint8_t)((flashAddr & 0x0000FF00)>> 8);
    ${TablePointerLowByte} = (uint8_t)(flashAddr & 0x000000FF);

    asm("TBLRD");

    return (${TableLatchRegister});
}

uint16_t FLASH_ReadWord(uint32_t flashAddr)
{
    return ((((uint16_t)FLASH_ReadByte(flashAddr+1))<<8)|(FLASH_ReadByte(flashAddr)));
}

void FLASH_WriteByte(uint32_t flashAddr, uint8_t *flashRdBufPtr, uint8_t byte)
{
    uint32_t blockStartAddr = (uint32_t)(flashAddr & ((END_FLASH-1) ^ (ERASE_FLASH_BLOCKSIZE-1)));
    uint8_t offset = (uint8_t)(flashAddr & (ERASE_FLASH_BLOCKSIZE-1));
    uint8_t i;

    // Entire row will be erased, read and save the existing data
    for (i=0; i<ERASE_FLASH_BLOCKSIZE; i++)
    {
        flashRdBufPtr[i] = FLASH_ReadByte((blockStartAddr+i));
    }

    // Load byte at offset
    flashRdBufPtr[offset] = byte;

    // Writes buffer contents to current block
    FLASH_WriteBlock(blockStartAddr, flashRdBufPtr);
}

int8_t FLASH_WriteBlock(uint32_t writeAddr, uint8_t *flashWrBufPtr)
{
    uint32_t blockStartAddr  = (uint32_t )(writeAddr & ((END_FLASH-1) ^ (ERASE_FLASH_BLOCKSIZE-1)));
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};     // Save interrupt enable
    uint8_t i;

    // Flash write must start at the beginning of a row
    if( writeAddr != blockStartAddr )
    {
        return -1;
    }

    // Block erase sequence
    FLASH_EraseBlock(writeAddr);

    // Block write sequence
    ${TablePointerUpperByte} = (uint8_t)((writeAddr & 0x00FF0000) >> 16);    // Load Table point register
    ${TablePointerHighByte} = (uint8_t)((writeAddr & 0x0000FF00)>> 8);
    ${TablePointerLowByte} = (uint8_t)(writeAddr & 0x000000FF);

    // Write block of data
    for (i=0; i<WRITE_FLASH_BLOCKSIZE; i++)
    {
        ${TableLatchRegister} = flashWrBufPtr[i];  // Load data byte

        if (i == (WRITE_FLASH_BLOCKSIZE-1))
        {
            asm("TBLWT");
        }
        else
        {
            asm("TBLWTPOSTINC");
        }
    }

    ${NVMRegionSelectionBit} = 2;
    ${Program_EraseEnableBit} = 1;	
    ${GlobalInterruptEnableBit} = 0; // Disable interrupts	
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;
    ${WriteControlBit} = 1; // Start program
	${GlobalInterruptEnableBit} = GIEBitValue; // Restore interrupt enable
    ${Program_EraseEnableBit} = 0; // Disable writes to memory

    return 0;
}

void FLASH_EraseBlock(uint32_t baseAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};   // Save interrupt enable

    ${TablePointerUpperByte} = (uint8_t)((baseAddr & 0x00FF0000) >> 16);
    ${TablePointerHighByte} = (uint8_t)((baseAddr & 0x0000FF00)>> 8);
    ${TablePointerLowByte} = (uint8_t)(baseAddr & 0x000000FF);

    ${NVMRegionSelectionBit} = 2;
    ${Program_EraseEnableBit} = 1;
    ${ProgramFlashEraseEnableBit} = 1;	
    ${GlobalInterruptEnableBit} = 0; // Disable interrupts	
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;
    ${WriteControlBit} = 1; // Start program
	${GlobalInterruptEnableBit} = GIEBitValue; // Restore interrupt enable
    ${Program_EraseEnableBit} = 0; // Disable writes to memory
}

<#if useDATAEE>
/**
  Section: Data EEPROM Module APIs
*/

<#if isAddress16bit>
void DATAEE_WriteByte(uint16_t bAdd, uint8_t bData)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};

    ${NVMAddressHighByte} = (uint8_t)((bAdd >> 8) & 0x03);
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0xFF);
    ${NVMDataRegByte} = bData;
    ${NVMRegionSelectionBit} = 0;
    ${Program_EraseEnableBit} = 1;
    ${GlobalInterruptEnableBit} = 0;     // Disable interrupts
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;
    ${WriteControlBit} = 1;
    // Wait for write to complete
    while (${WriteControlBit})
    {
    }

    ${Program_EraseEnableBit} = 0;
    ${GlobalInterruptEnableBit} = GIEBitValue;   // restore interrupt enable
}

uint8_t DATAEE_ReadByte(uint16_t bAdd)
{
    ${NVMAddressHighByte} = (uint8_t)((bAdd >> 8) & 0x03);
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0xFF);
    ${NVMRegionSelectionBit} = 0;
    ${ReadControlBit} = 1;
    NOP();  // NOPs may be required for latency at high frequencies
    NOP();

    return (${NVMDataRegByte});
}
<#else>
void DATAEE_WriteByte(uint8_t bAdd, uint8_t bData)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};

    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0xFF);
    ${NVMDataRegByte} = bData;
    ${NVMRegionSelectionBit} = 0;
    ${Program_EraseEnableBit} = 1;
    ${GlobalInterruptEnableBit} = 0;     // Disable interrupts
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;
    ${WriteControlBit} = 1;
    // Wait for write to complete
    while (${WriteControlBit})
    {
    }

    ${Program_EraseEnableBit} = 0;
    ${GlobalInterruptEnableBit} = GIEBitValue;   // Restore interrupt enable
}

uint8_t DATAEE_ReadByte(uint8_t bAdd)
{
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0xFF);
    ${NVMRegionSelectionBit} = 0;
    ${ReadControlBit} = 1;
    NOP();  // NOPs may be required for latency at high frequencies
    NOP();

    return (${NVMDataRegByte});
}
</#if>
</#if>

<#if useInterrupt>
<#if isVectoredInterruptEnabled>
<#if isHighPriority>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionName}()
<#else>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
</#if>
<#else>
void ${functionPrefix}${moduleNameUpperCase}_Tasks( void )
</#if>
{
    /* TODO : Add interrupt handling code */
    ${interruptFlag} = 0;
}
/**
 End of File
*/