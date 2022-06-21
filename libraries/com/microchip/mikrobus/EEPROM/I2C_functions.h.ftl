/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef I2C_FUNCTIONS_H
#define I2C_FUNCTIONS_H

#include <stdio.h>
#include <stdint.h>
#include "../${I2CFunctions["typeheader"]}"

typedef struct
{
    uint8_t *data;
    uint8_t *dataSize;
} pageWriteSize_t;

typedef enum {noError = 0, fail_busy, fail_timeout} eeprom_ErrNo_t;

typedef uint16_t EEPROM_ADDRESS_t;

#define PAGESIZE 16
#define EEPROM_ADDRESS 0x50
#define MIN(a,b) (a<b?a:b)

eeprom_ErrNo_t   eeprom_lastError; // 0 represents no error

${I2CFunctions["operations"]} wr1ByteCompleteHandler(void *p);
${I2CFunctions["operations"]} rd1ByteCompleteHandler(void *p);
${I2CFunctions["operations"]} writeData(void *payload);
__bit writePage(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
${I2CFunctions["operations"]} rdBlockCompleteHandler(void *payload);

#endif  /*end of I2C_FUNCTIONS_H*/
