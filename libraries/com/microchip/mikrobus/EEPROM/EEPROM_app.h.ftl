/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ____eeprom__
#define ____eeprom__

#include <stdio.h>
#include <stdint.h>
#include "drivers/I2C_functions.h"

uint8_t EEPROM_ReadByte(EEPROM_ADDRESS_t address);
void EEPROM_WriteByte( EEPROM_ADDRESS_t address, uint8_t data);
void EEPROM_WriteBlock(EEPROM_ADDRESS_t address, void *dataBlock, uint8_t dataBlockByteCount);
void EEPROM_ReadBlock( EEPROM_ADDRESS_t address, void *dataBlock, uint8_t dataBlockByteCount);

#endif
