/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides implementations of driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.02
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

uint16_t FLASH_ReadWord(uint16_t flashAddr)
{
    uint8_t GIEBitValue = INTCONbits.GIE;   // Save interrupt enable
	
    INTCONbits.GIE = 0;     // Disable interrupts
    ${NVMAddressLowByte} = (flashAddr & 0x00FF);
    ${NVMAddressHighByte} = ((flashAddr & 0xFF00) >> 8);

    ${CofigSpaceSelectBit} = 0;    // Deselect Configuration space
    ${ProgramMemorySelectBit} = 1;   // Select Program Memory
    ${ReadControlBit} = 1;      // Initiate Read
    NOP();
    NOP();
    INTCONbits.GIE = GIEBitValue;   // Restore interrupt enable

    return ((uint16_t)((${NVMDataRegHighByte} << 8) | ${NVMDataRegLowByte}));
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
    uint8_t     GIEBitValue = INTCONbits.GIE;   // Save interrupt enable
    uint8_t     i,j,numberOfWriteBlocks=0,dataCounter=0;

    numberOfWriteBlocks = (ERASE_FLASH_BLOCKSIZE/WRITE_FLASH_BLOCKSIZE);

    // Flash write must start at the beginning of a row
    if( writeAddr != blockStartAddr )
    {
        return -1;
    }

    INTCONbits.GIE = 0;     // Disable interrupts

    // Block erase sequence
    FLASH_EraseBlock(writeAddr);

    for(j=0; j<numberOfWriteBlocks; j++)
    {
		// Block write sequence
		${ProgramMemorySelectBit} = 1;   // Select Program Memory
		${CofigSpaceSelectBit} = 0;    // Deselect Configuration space
		${Program_EraseEnableBit} = 1;    // Enable writes
		${LoadWriteLatchesOnlyBit} = 1;    // Only load write latches
		
		for (i=0; i<WRITE_FLASH_BLOCKSIZE; i++)
		{
			// Load lower 8 bits of write address
			${NVMAddressLowByte} = (writeAddr & 0xFF);
			// Load upper 6 bits of write address
			${NVMAddressHighByte} = ((writeAddr & 0xFF00) >> 8);
		
			// Load data in current address
			${NVMDataRegLowByte} = flashWordArray[dataCounter];
			${NVMDataRegHighByte} = ((flashWordArray[dataCounter] & 0xFF00) >> 8);
			dataCounter++;
		
			if(i == (WRITE_FLASH_BLOCKSIZE-1))
			{
				// Start Flash program memory write
				${LoadWriteLatchesOnlyBit} = 0;
			}
		
			${EEPROMControl2Register} = 0x55;
			${EEPROMControl2Register} = 0xAA;
			${WriteControlBit} = 1;
			NOP();
			NOP();
		
			writeAddr++;
		}
	}

    ${Program_EraseEnableBit} = 0; // Disable writes
    INTCONbits.GIE = GIEBitValue;   // Restore interrupt enable

    return 0;
}

void FLASH_EraseBlock(uint16_t startAddr)
{
    uint8_t GIEBitValue = INTCONbits.GIE;   // Save interrupt enable

    INTCONbits.GIE = 0;     // Disable interrupts
    // Load lower 8 bits of erase address boundary
    ${NVMAddressLowByte} = (startAddr & 0xFF);
    // Load upper 6 bits of erase address boundary
    ${NVMAddressHighByte} = ((startAddr & 0xFF00) >> 8);

    // Block erase sequence
    ${CofigSpaceSelectBit} = 0;    // Deselect Configuration space
    ${ProgramMemorySelectBit} = 1;   // Select Program Memory
    ${ProgramFlashEraseEnableBit} = 1;    // Specify an erase operation
    ${Program_EraseEnableBit} = 1;    // Allows erase cycles

    // Start of required sequence to initiate erase
    ${EEPROMControl2Register} = 0x55;
    ${EEPROMControl2Register} = 0xAA;
    ${WriteControlBit} = 1;      // Set WR bit to begin erase
    NOP();
    NOP();

    ${Program_EraseEnableBit} = 0;       // Disable writes
    INTCONbits.GIE = GIEBitValue;   // Restore interrupt enable
}

<#if useDATAEE>
/**
  Section: Data EEPROM Module APIs
*/

void DATAEE_WriteByte(uint8_t bAdd, uint8_t bData)
{
    uint8_t GIEBitValue = 0;

    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0x0ff);    // Data Memory Address to write
    ${NVMDataRegLowByte} = bData;             // Data Memory Value to write
    ${ProgramMemorySelectBit} = 0;   // Point to DATA memory
    ${CofigSpaceSelectBit} = 0;        // Deselect Configuration space
    ${Program_EraseEnableBit} = 1;        // Enable writes

    GIEBitValue = INTCONbits.GIE;
    INTCONbits.GIE = 0;     // Disable INTs
    ${EEPROMControl2Register} = 0x55;
    ${EEPROMControl2Register} = 0xAA;
    ${WriteControlBit} = 1;      // Set WR bit to begin write
    // Wait for write to complete
    while (${WriteControlBit})
    {
    }

    ${Program_EraseEnableBit} = 0;    // Disable writes
    INTCONbits.GIE = GIEBitValue;
}

uint8_t DATAEE_ReadByte(uint8_t bAdd)
{
    ${NVMAddressLowByte} = (uint8_t)(bAdd & 0x0ff);    // Data Memory Address to read
    ${CofigSpaceSelectBit} = 0;    // Deselect Configuration space
    ${ProgramMemorySelectBit} = 0;   // Point to DATA memory
    ${ReadControlBit} = 1;      // EE Read
    NOP();  // NOPs may be required for latency at high frequencies
    NOP();

    return (${NVMDataRegLowByte});
}
</#if>
/**
 End of File
*/