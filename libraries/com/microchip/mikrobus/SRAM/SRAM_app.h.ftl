 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef SRAM_H
#define	SRAM_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
// SPI can go up to 20 MHz
// Device has 1 Mbit (128k x 8 bit) of memory, 32 byte pages

void SRAM_StartSequentialWrite(uint32_t location); // Selects first address to sequentially write
void SRAM_SequentialWrite(uint8_t byte); // Writes sequential value
void SRAM_EndSequentialWrite(void); // Stop sequentially writing

void SRAM_ByteWrite(uint32_t location, uint8_t byte); // Write byte to location

void SRAM_PageWrite(uint32_t location, const uint8_t * data); // Writes 32 byte page from array data

void SRAM_StartSequentialRead(uint32_t location); // Selects first address to sequentially read
uint8_t SRAM_SequentialRead(void); // Reads sequential value
void SRAM_EndSequentialRead(void); // Stop sequentially reading

uint8_t SRAM_ByteRead(uint32_t location); // Reads byte at location

void SRAM_PageRead(uint32_t location, uint8_t * data); // Reads 32 byte page to array data

#endif
