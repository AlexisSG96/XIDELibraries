/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ____eeprom__
#define ____eeprom__

#include <stdio.h>
#include <stdint.h>

typedef enum { noError = 0, fail_busy, fail_timeout }eeprom_ErrNo_t;

// TODO: MCC should determine what a reasonable data type is to represent EEPROM addresses.
typedef uint16_t EEPROM_ADDRESS_t;

extern eeprom_ErrNo_t   eeprom_lastError; // 0 represents no error

uint8_t SPIEEPROM_ReadByte(EEPROM_ADDRESS_t address);
void SPIEEPROM_WriteByte(EEPROM_ADDRESS_t address, uint8_t data);
void SPIEEPROM_WriteBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
void SPIEEPROM_ReadBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);


#endif /* defined(____eeprom__) */