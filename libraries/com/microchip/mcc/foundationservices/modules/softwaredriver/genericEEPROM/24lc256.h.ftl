/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _24LC256_H
#define _24LC256_H

/**
  Section: Included Files
 */

#include <stdio.h>
#include <stdint.h>

/**
  Section: Type Definitions
*/

typedef enum { noError = 0, fail_busy, fail_timeout }LC256_ErrNo_t;
typedef uint16_t LC256_ADDRESS_t;

/**
  Section: Variable Declarations
*/

extern LC256_ErrNo_t   LC256_lastError; // 0 represents no error

/**
  Section: 24LC256 EEPROM Driver APIs
 */  

uint8_t LC256_readByte(LC256_ADDRESS_t address);
void LC256_writeByte(LC256_ADDRESS_t address, uint8_t data);
void LC256_writeBlock(LC256_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
void LC256_readBlock(LC256_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);

#endif // _24LC256_H
/**
 End of File
*/
