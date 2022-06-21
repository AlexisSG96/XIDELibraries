/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _GENERIC_EEPROM_H
#define _GENERIC_EEPROM_H

/**
  Section: Included Files
 */

#include <stdio.h>
#include <stdint.h>

/**
  Section: Variable Declarations
*/

// TODO: MCC should determine what a reasonable data type is to represent EEPROM addresses.
typedef uint16_t EEPROM_ADDRESS_t;

/**
  Section: EEPROM Driver APIs
 */  

void eeprom_writeByte( EEPROM_ADDRESS_t address, uint8_t data);
uint8_t eeprom_readByte(EEPROM_ADDRESS_t address);
void eeprom_writeBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
void eeprom_readBlock( EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);

#endif // _GENERIC_EEPROM_H
/**
 End of File
*/