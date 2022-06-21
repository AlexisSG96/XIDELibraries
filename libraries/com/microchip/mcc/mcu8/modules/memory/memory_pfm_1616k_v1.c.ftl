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
        Driver Version    :  4.2.1
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
    //Set TBLPTR with the target byte address
    ${TablePointerUpperByte} = (uint8_t)((flashAddr & 0x00FF0000) >> 16);
    ${TablePointerHighByte} = (uint8_t)((flashAddr & 0x0000FF00)>> 8);
    ${TablePointerLowByte} = (uint8_t)(flashAddr & 0x000000FF);

    //Perform table read to move one byte from NVM to TABLAT
    asm("TBLRD");

    return (${TableLatchRegister});
}

uint16_t FLASH_ReadWord(uint32_t flashAddr)
{
    //Set TBLPTR with the target byte address
    ${NVMAddressUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (flashAddr & 0x000000FF);
    
    //NVMCON1.RD operations are not affected by NVMEN, ignore NVMEN
    ${ReadControlBit} = 1;
    while (${ReadControlBit});
    
    return ((((uint16_t)${NVMDataRegHighByte}) << 8) | ${NVMDataRegLowByte});
}

void FLASH_ReadSector(uint32_t flashAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};
        
    //Enable NVM access
    ${NVMAccessEnableBit} = 1;

    //Set NVMADR with the target word address
    ${NVMAddressUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (flashAddr & 0x000000FF);
    
    //Disable all interrupt
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMControl2Register} = 0xBB;
    ${NVMControl2Register} = 0x44;

    //Start sector read and wait for the operation to complete
    ${SectorReadControlReg} = 1;
    while (${SectorReadControlReg});

    //Restore the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Disable NVM access
    ${NVMAccessEnableBit} = 0;
}

void FLASH_WriteSector(uint32_t flashAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};
    
    //Enable NVM access
    ${NVMAccessEnableBit} = 1;

    //Set NVMADR with the target word address
    ${NVMAddressUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (flashAddr & 0x000000FF);

    //Disable all interrupt
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMControl2Register} = 0xDD;
    ${NVMControl2Register} = 0x22;

    //Start sector write and wait for the operation to complete
    ${SectorWriteControlBit} = 1;
    while (${SectorWriteControlBit});

    //Restore the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Disable NVM access
    ${NVMAccessEnableBit} = 0;
}

uint8_t sectorRAM __at(${SECRAMStartAddress});
void FLASH_WriteWord(uint32_t flashAddr, uint16_t word)
{
    uint16_t *secramWordPtr = (uint16_t*) & sectorRAM;
    uint32_t blockStartAddr = (uint32_t) (flashAddr & ((END_FLASH - 1) ^ ((ERASE_FLASH_BLOCKSIZE * 2) - 1)));
    uint8_t offset = (uint8_t) ((flashAddr & ((ERASE_FLASH_BLOCKSIZE * 2) - 1)) / 2);
        
    //Read existing block into Sector RAM
    FLASH_ReadSector(blockStartAddr);

    //Erase the given block
    FLASH_EraseBlock(blockStartAddr);

    //Modify Sector RAM for the given word to be written to Program Flash Memory
    secramWordPtr += offset;
    *secramWordPtr = word;

    //Write Sector RAM contents to given Program Flash Memory block
    FLASH_WriteSector(blockStartAddr);
}

int8_t FLASH_WriteBlock(uint32_t flashAddr, uint16_t *flashWrBufPtr)
{
    uint16_t *secramWordPtr = (uint16_t*) & sectorRAM;
    uint32_t blockStartAddr = (uint32_t) (flashAddr & ((END_FLASH - 1) ^ ((ERASE_FLASH_BLOCKSIZE * 2) - 1)));
    uint8_t i;

    //Block write must start at the beginning of a row
    if (flashAddr != blockStartAddr)
    {
        return -1;
    }

    //Copy application buffer contents to Buffer RAM
    for (i = 0; i < WRITE_FLASH_BLOCKSIZE; i++)
    {
        *secramWordPtr++ = flashWrBufPtr[i];
    }

    //Erase the given block
    FLASH_EraseBlock(flashAddr);

    //Write Sector RAM contents to given Program Flash Memory block
    FLASH_WriteSector(flashAddr);

    return 0;
}

void FLASH_EraseBlock(uint32_t flashAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};
    
    ${NVMAccessEnableBit} = 1;    // Enable NVM access

    //Set NVMADR with the target word address
    ${NVMAddressUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (flashAddr & 0x000000FF);

    //Disable all interrupts
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMControl2Register} = 0xCC;
    ${NVMControl2Register} = 0x33;

    //Start block erase and wait for the operation to complete
    ${SectorEraseControlBit} = 1;
    while (${SectorEraseControlBit});

    //Restore the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Disable NVM access
    ${NVMAccessEnableBit} = 0;
}

<#if useDATAEE>
/**
  Section: Data EEPROM Module APIs
*/
<#if isAddress16bit>
void DATAEE_WriteByte(uint16_t bAdd, uint8_t bData)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};
    
    //Set NVMADR with the target word address: 0x310000 - 0x3103FF
    ${NVMAddressUpperByte} = 0x31;
    ${NVMAddressHighByte} = (uint8_t)((bAdd & 0xFF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0x00FF);

    //Load NVMDATL with desired byte
    ${NVMDataRegLowByte} = (uint8_t)(bData & 0xFF);
    
    //Enable NVM access
    ${NVMAccessEnableBit} = 1;
    
    //Disable interrupts
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;

    //Start DATAEE write and wait for the operation to complete
    ${WriteControlBit} = 1;
    while (${WriteControlBit});

    //Restore all the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Disable NVM access
    ${NVMAccessEnableBit} = 0;
}

uint8_t DATAEE_ReadByte(uint16_t bAdd)
{
    //Set NVMADR with the target word address: 0x310000 - 0x3103FF
    ${NVMAddressUpperByte} = 0x31;
    ${NVMAddressHighByte} = (uint8_t)((bAdd & 0xFF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0x00FF);
    

    //Start DATAEE read
    ${ReadControlBit} = 1;
    NOP();  // NOPs may be required for latency at high frequencies
    NOP();

    return (${NVMDataRegLowByte});
}
<#else>
void DATAEE_WriteByte(uint8_t bAdd, uint8_t bData)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};
    
    //Set NVMADR with the target word address: 0x310000 - 0x3100FF
    ${NVMAddressUpperByte} = 0x31;
    ${NVMAddressHighByte} = 0x00;
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0xFF);

    //Load NVMDATL with desired byte
    ${NVMDataRegLowByte} = (uint8_t)(bData & 0xFF);
    
    //Enable NVM access
    ${NVMAccessEnableBit} = 1;
    
    //Disable interrupts
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;

    //Start DATAEE write and wait for the operation to complete
    ${WriteControlBit} = 1;
    while (${WriteControlBit});

    //Restore all the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Disable NVM access
    ${NVMAccessEnableBit} = 0;
}

uint8_t DATAEE_ReadByte(uint8_t bAdd)
{
    //Set NVMADR with the target word address: 0x310000 - 0x3100FF
    ${NVMAddressUpperByte} = 0x31;
    ${NVMAddressHighByte} = 0x00;
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0xFF);
    

    //Start DATAEE read
    ${ReadControlBit} = 1;
    NOP();  // NOPs may be required for latency at high frequencies
    NOP();

    return (${NVMDataRegLowByte});
}
</#if>
</#if>

<#if isVectoredInterruptEnabled>
<#if isHighPriority>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_${interruptFunctionName}()
<#else>
void __interrupt(irq(${IRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_${interruptFunctionName}()
</#if>
<#else>
void ${moduleNameUpperCase}_${interruptFunctionName}(void)
</#if>
{
    /* TODO : Add interrupt handling code */
    ${interruptFlag} = 0;
}
/**
 End of File
*/