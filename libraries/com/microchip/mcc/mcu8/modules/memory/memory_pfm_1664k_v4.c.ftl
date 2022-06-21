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
        Driver Version    :  1.1.0
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

/**
  Section: Program Flash Memory APIs
 */

//128-words of Buffer RAM for ${selectedDevice} is available at ${BufferRAMStartAddress}
uint16_t bufferRAM __at(${BufferRAMStartAddress}); 

uint8_t FLASH_ReadByte(uint32_t flashAddr)
{
    //Set TBLPTR with the target byte address
    ${TablePointerUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${TablePointerHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${TablePointerLowByte} = (uint8_t) (flashAddr & 0x000000FF);

    //Perform table read to move one byte from NVM to TABLAT
    asm("TBLRD");

    return (${TableLatchRegister});
}

uint16_t FLASH_ReadWord(uint32_t flashAddr)
{
    uint8_t readWordL, readWordH;

    //Set TBLPTR with the target byte address
    ${TablePointerUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${TablePointerHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${TablePointerLowByte} = (uint8_t) (flashAddr & 0x000000FF);

    //Perform table read to move low byte from NVM to TABLAT
    asm("TBLRD*+");
    readWordL = ${TableLatchRegister};

    //Perform table read to move high byte from NVM to TABLAT
    asm("TBLRD");
    readWordH = ${TableLatchRegister};

    return (((uint16_t) readWordH << 8) | (readWordL));
}

void FLASH_ReadPage(uint32_t flashAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit}; // Save interrupt enable

    //Set NVMADR with the target word address
    ${NVMAddressUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (flashAddr & 0x000000FF);

    //Set the NVMCMD control bits for Page Read operation
    ${NVMCommand} = 0b010;

    //Disable all interrupt
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMLOCKRegister} = 0x55;
    ${NVMLOCKRegister} = 0xAA;

    //Start page read and wait for the operation to complete
    ${NVMOperationControlBit} = 1;
    while (${NVMOperationControlBit});

    //Restore the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Set the NVMCMD control bits for Word Read operation to avoid accidental writes
    ${NVMCommand} = 0b000;
}

void FLASH_WritePage(uint32_t flashAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit}; // Save interrupt enable

    //Set NVMADR with the target word address
    ${NVMAddressUpperByte} = (uint8_t) ((flashAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((flashAddr & 0x0000FF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (flashAddr & 0x000000FF);

    //Set the NVMCMD control bits for Write Page operation
    ${NVMCommand} = 0b101;

    //Disable all interrupt
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMLOCKRegister} = 0x55;
    ${NVMLOCKRegister} = 0xAA;

    //Start page programming and wait for the operation to complete
    ${NVMOperationControlBit} = 1;
    while (${NVMOperationControlBit});

    //Restore the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Set the NVMCMD control bits for Word Read operation to avoid accidental writes
    ${NVMCommand} = 0b000;
}

void FLASH_WriteWord(uint32_t flashAddr, uint16_t word)
{
    uint16_t *bufferRamPtr = (uint16_t*) & bufferRAM;
    uint32_t blockStartAddr = (uint32_t) (flashAddr & ((END_FLASH - 1) ^ ((ERASE_FLASH_BLOCKSIZE * 2) - 1)));
    uint8_t offset = (uint8_t) ((flashAddr & ((ERASE_FLASH_BLOCKSIZE * 2) - 1)) / 2);

    //Read existing block into Buffer RAM
    FLASH_ReadPage(blockStartAddr);

    //Erase the given block
    FLASH_EraseBlock(blockStartAddr);

    //Modify Buffer RAM for the given word to be written to Program Flash Memory
    bufferRamPtr += offset;
    *bufferRamPtr = word;

    //Write Buffer RAM contents to given Program Flash Memory block
    FLASH_WritePage(blockStartAddr);
}

int8_t FLASH_WriteBlock(uint32_t flashAddr, uint16_t *flashWrBufPtr)
{
    uint16_t *bufferRamPtr = (uint16_t*) & bufferRAM;
    uint32_t blockStartAddr = (uint32_t) (flashAddr & ((END_FLASH - 1) ^ ((ERASE_FLASH_BLOCKSIZE * 2) - 1)));
    uint8_t i;

    //Block write must start at the beginning of a row
    if (flashAddr != blockStartAddr)
    {
        return -1;
    }

    //Copy application buffer contents to Buffer RAM
    for (i = 0; i < ERASE_FLASH_BLOCKSIZE; i++)
    {
        *bufferRamPtr++ = flashWrBufPtr[i];
    }

    //Erase the given block
    FLASH_EraseBlock(flashAddr);

    //Write Buffer RAM contents to given Program Flash Memory block
    FLASH_WritePage(flashAddr);

    return 0;
}

void FLASH_EraseBlock(uint32_t flashAddr)
{
    uint32_t blockStartAddr = (uint32_t) (flashAddr & ((END_FLASH - 1) ^ ((ERASE_FLASH_BLOCKSIZE * 2) - 1)));
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};

    //The NVMADR[21:8] bits point to the page being erased.
    //The NVMADR[7:0] bits are ignored
    ${NVMAddressUpperByte} = (uint8_t) ((blockStartAddr & 0x00FF0000) >> 16);
    ${NVMAddressHighByte} = (uint8_t) ((blockStartAddr & 0x0000FF00) >> 8);

    //Set the NVMCMD control bits for Erase Page operation
    ${NVMCommand} = 0b110;

    //Disable all interrupts
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence
    ${NVMLOCKRegister} = 0x55;
    ${NVMLOCKRegister} = 0xAA;

    //Start page erase and wait for the operation to complete
    ${NVMOperationControlBit} = 1;
    while (${NVMOperationControlBit});

    //Restore the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Set the NVMCMD control bits for Word Read operation to avoid accidental writes
    ${NVMCommand} = 0b000;
}

<#if useDATAEE>
void DATAEE_WriteByte(uint16_t bAdd, uint8_t bData)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};

    //Set NVMADR with the target word address (0x380000 - 0x3803FF)
    ${NVMAddressUpperByte} = 0x38;
    ${NVMAddressHighByte} = (uint8_t) ((bAdd & 0xFF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (bAdd & 0x00FF);

    //Load ${NVMDataRegLowByte} with desired byte
    ${NVMDataRegLowByte} = bData;

    //Set the NVMCMD control bits for DFM Byte Write operation
    ${NVMCommand} = 0b011;

    //Disable all interrupts
    ${GlobalInterruptEnableBit} = 0;

    //Perform the unlock sequence and start Page Erase
    ${NVMLOCKRegister} = 0x55;
    ${NVMLOCKRegister} = 0xAA;

    //Start DFM write and wait for the operation to complete
    ${NVMOperationControlBit} = 1;
    while (${NVMOperationControlBit});

    //Restore all the interrupts
    ${GlobalInterruptEnableBit} = GIEBitValue;

    //Set the NVMCMD control bits for Word Read operation to avoid accidental writes
    ${NVMCommand} = 0b000;
}

uint8_t DATAEE_ReadByte(uint16_t bAdd)
{
    //Set NVMADR with the target word address (0x380000 - 0x3803FF)
    ${NVMAddressUpperByte} = 0x38;
    ${NVMAddressHighByte} = (uint8_t) ((bAdd & 0xFF00) >> 8);
    ${NVMAddressLowByte} = (uint8_t) (bAdd & 0x00FF);

    //Set the NVMCMD control bits for DFM Byte Read operation
    ${NVMCommand} = 0b000;
    ${NVMOperationControlBit} = 1;

    return ${NVMDataRegLowByte};
}
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
