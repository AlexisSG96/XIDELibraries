/*
<#include "MicrochipDisclaimer.ftl">
*/
#ifndef _SST26VF064B_H
#define _SST26VF064B_H

#include <stdint.h>
#include <stdbool.h>

void SST26VF064B_CS_Low();
void SST26VF064B_CS_High();
void SST26VF064B_WP_Low();
void SST26VF064B_WP_High();
void SST26VF064B_Hold( bool state );
uint8_t SST26VF064B_Busy();
uint8_t SST26VF064B_SPI_ReadByte( uint8_t value );
void SST26VF064B_SPI_WriteByte( uint8_t value );
void SST26VF064B_SPI_ReadBuffer( uint8_t *buffer, uint16_t count );
void SST26VF064B_SPI_WriteBuffer( uint8_t *buffer, uint16_t count );
void SST26VF064B_Reset( void );
void SST26VF064B_WriteAddress( uint32_t address );
void SST26VF064B_SectorErase( uint32_t address );
void SST26VF064B_BlockErase( uint32_t address );
void SST26VF064B_ChipErase( void );
void SST26VF064B_Lock_BPR( void );
void SST26VF064B_GlobalBlockUnlock( void );
void SST26VF064B_WriteEnable( void );
void SST26VF064B_WriteDisable( void );
void SST26VF064B_WriteSuspend( void );
void SST26VF064B_WriteResume( void );
void SST26VF064B_PageProgram_Cmd( void );
void SST26VF064B_Read_Cmd( void );
void SST26VF064B_JEDECID_Cmd( void );

#endif // _SST26VF064B_H

