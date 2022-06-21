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
        Driver Version    :  2.05
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
  Section: Flash Module APIs
*/

uint8_t FLASH_ReadByte(uint32_t flashAddr)
{
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
    uint32_t blockStartAddr = (uint32_t)(flashAddr & ((END_FLASH+7) ^ (ERASE_FLASH_BLOCKSIZE-1)));
    uint16_t offset = (uint16_t)(flashAddr & (ERASE_FLASH_BLOCKSIZE-1));
    uint16_t i;

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
    uint32_t blockStartAddr  = (uint32_t )(writeAddr & ((END_FLASH+7) ^ (ERASE_FLASH_BLOCKSIZE-1)));
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};     // Save interrupt enable
    uint8_t i, j, numberOfWriteBlocks;
    uint16_t WriteBlkOffset = 0;
    
    // Flash write must start at the beginning of a row
    if(writeAddr != blockStartAddr)
    {
        return -1;
    }
    
    // Total number of write blocks present in one erase block
    numberOfWriteBlocks = ERASE_FLASH_BLOCKSIZE/WRITE_FLASH_BLOCKSIZE;   

    // Block erase sequence
    FLASH_EraseBlock(writeAddr); 

    for(j=0; j<numberOfWriteBlocks; j++)
    {
        // Calculate starting offset of Write Block
        WriteBlkOffset = (uint16_t)j * WRITE_FLASH_BLOCKSIZE;
        
        // Block Write sequence
        TBLPTRU = (uint8_t)(((writeAddr + WriteBlkOffset) & 0x00FF0000) >> 16);    // Load Table point register
        TBLPTRH = (uint8_t)(((writeAddr + WriteBlkOffset) & 0x0000FF00) >> 8);
        TBLPTRL = (uint8_t)((writeAddr + WriteBlkOffset) & 0x000000FF);
    
        for (i=0; i<WRITE_FLASH_BLOCKSIZE; i++)
        {
            TABLAT = flashWrBufPtr[WriteBlkOffset+i];  // Load data byte

            if (i == (WRITE_FLASH_BLOCKSIZE-1))
            {
                asm("TBLWT");
            }
            else
            {
                asm("TBLWTPOSTINC");
            }
        }
        
        ${Program_EraseEnableBit} = 1;
        ${GlobalInterruptEnableBit} = 0; // Disable interrupts
        ${NVMControl2Register} = 0x55;
        ${NVMControl2Register} = 0xAA;
        ${WriteControlBit} = 1;  // Start program

        ${Program_EraseEnableBit} = 0;    // Disable writes to memory
        ${GlobalInterruptEnableBit} = GIEBitValue;   // Restore interrupt enable
    }

    return 0;
}

void FLASH_EraseBlock(uint32_t baseAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};   // Save interrupt enable

    ${TablePointerUpperByte} = (uint8_t)((baseAddr & 0x00FF0000) >> 16);
    ${TablePointerHighByte} = (uint8_t)((baseAddr & 0x0000FF00)>> 8);
    ${TablePointerLowByte} = (uint8_t)(baseAddr & 0x000000FF);

    ${Program_EraseEnableBit} = 1;
    ${ProgramFlashEraseEnableBit} = 1;
    ${GlobalInterruptEnableBit} = 0; // Disable interrupts
    ${NVMControl2Register} = 0x55;
    ${NVMControl2Register} = 0xAA;
    ${WriteControlBit} = 1;
    ${GlobalInterruptEnableBit} = GIEBitValue;   // Restore interrupt enable
}
/**
 End of File
*/