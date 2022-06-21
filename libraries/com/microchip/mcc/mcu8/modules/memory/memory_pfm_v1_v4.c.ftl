/*******************************************************************************
  ${moduleNameUpperCase} Generated Driver File

  Company:
    Microchip Technology Inc.

  File Name:
    ${moduleNameLowerCase}.c

  Summary:
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  Description:
    This source file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Version           :  2.0.2
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*******************************************************************************/

${disclaimer}

#include <xc.h>
#include "${moduleNameLowerCase}.h"

/**
  Section: Flash Module APIs
*/

uint16_t FLASH_ReadWord(uint16_t flashAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};   // Save interrupt enable
    

    ${GlobalInterruptEnableBit} = 0;     // Disable interrupts

    ${ProgramMemoryAddressLowByte} = (flashAddr & 0x00FF);
    ${ProgramMemoryAddressHighByte} = ((flashAddr & 0xFF00) >> 8);   
  
    ${ReadControlBit} = 1;      // Initiate Read
    
    NOP();
    NOP();
    ${GlobalInterruptEnableBit} = GIEBitValue;   // Restore interrupt enable

    return ((uint16_t)((${ProgramMemoryDataHighByte} << 8) | ${ProgramMemoryDataLowByte}));
}

void FLASH_WriteWord(uint16_t flashAddr, uint16_t *ramBuf, uint16_t word)
{
    uint16_t blockStartAddr = (uint16_t)(flashAddr & ((END_FLASH-1) ^ (ERASE_FLASH_BLOCKSIZE-1)));
    uint8_t offset = (uint8_t)(flashAddr & (ERASE_FLASH_BLOCKSIZE-1));
    uint8_t i;

    // Entire row will be erased, read and save the existing data
    for (i=0; i<ERASE_FLASH_BLOCKSIZE; i++)
    {
        ramBuf[i] = FLASH_ReadWord((blockStartAddr+i));
    }

    // Write at offset
    ramBuf[offset] = word;

    // Writes ramBuf to current block
    FLASH_WriteBlock(blockStartAddr, ramBuf);
}

int8_t FLASH_WriteBlock(uint16_t writeAddr, uint16_t *flashWordArray)
{
    uint16_t    blockStartAddr  = (uint16_t )(writeAddr & ((END_FLASH-1) ^ (ERASE_FLASH_BLOCKSIZE-1)));
    uint8_t     GIEBitValue = ${GlobalInterruptEnableBit};   // Save interrupt enable
    uint8_t     i,j,numberOfWriteBlocks=0,dataCounter=0;


    // Flash write must start at the beginning of a row
    if( writeAddr != blockStartAddr )
    {
        return -1;
    }
    
    // Calculate number of write blocks available in an erase block
    numberOfWriteBlocks = (ERASE_FLASH_BLOCKSIZE/WRITE_FLASH_BLOCKSIZE);

    ${GlobalInterruptEnableBit} = 0;     // Disable interrupts

    // Block erase sequence
    FLASH_EraseBlock(writeAddr);

    for(j=0; j<numberOfWriteBlocks; j++)
    {
        ${Program_EraseEnableBit} = 1;    // Enable writes

        for(i=0; i<WRITE_FLASH_BLOCKSIZE; i++)
        {
            // Load lower 8 bits of write address
            ${ProgramMemoryAddressLowByte} = (writeAddr & 0xFF);
            // Load upper 6 bits of write address
            ${ProgramMemoryAddressHighByte} = ((writeAddr & 0xFF00) >> 8);

            // Load data in current address
            ${ProgramMemoryDataLowByte} = flashWordArray[dataCounter];
            ${ProgramMemoryDataHighByte} = ((flashWordArray[dataCounter] & 0xFF00) >> 8);
            dataCounter++;

            <#if isPMControl2RegAvailable>
            ${PMControl2Register} = 0x55;
            ${PMControl2Register} = 0xAA;
            </#if>
            ${WriteControlBit} = 1;
            NOP();
            NOP();

            writeAddr++;
        }
    }
    ${GlobalInterruptEnableBit} = 1;        // Enable interrupts
    ${Program_EraseEnableBit} = 0;       // Disable writes
    
    return 0;
}

void FLASH_EraseBlock(uint16_t startAddr)
{
    uint8_t GIEBitValue = ${GlobalInterruptEnableBit};   // Save interrupt enable


    ${GlobalInterruptEnableBit} = 0;     // Disable interrupts

    // Load lower 8 bits of erase address boundary
    ${ProgramMemoryAddressLowByte} = (startAddr & 0xFF);
    // Load upper 6 bits of erase address boundary
    ${ProgramMemoryAddressHighByte} = ((startAddr & 0xFF00) >> 8);

    // Block erase sequence
    ${Program_EraseEnableBit} = 1;    // Allows erase cycles

    // Start of required sequence to initiate erase
    <#if isPMControl2RegAvailable>
    ${PMControl2Register} = 0x55;
    ${PMControl2Register} = 0xAA;
    </#if>
    ${WriteControlBit} = 1;      // Set WR bit to begin erase
    NOP();
    NOP();

    ${Program_EraseEnableBit} = 0;       // Disable erase cycles
    ${GlobalInterruptEnableBit} = GIEBitValue;   // Restore interrupt enable
}

/**
 End of File
*/