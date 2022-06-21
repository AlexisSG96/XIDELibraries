/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef I2C_FUNCTIONS_H
#define I2C_FUNCTIONS_H

#include <stdio.h>
#include <stdint.h>
#include "i2c_types.h"

typedef struct
{
    uint8_t *data;
    uint8_t *dataSize;
} pageWriteSize_t;

typedef enum {noError = 0, fail_busy, fail_timeout} eeram3v3_ErrNo_t;

typedef uint16_t EERAM3V3_ADDRESS_t;
typedef uint8_t  EERAM3V3_CMD_MODE_ADDRESS_t;


#define EERAM3V3_7BITS_SRAM_ADDRESS                    0x50
#define EERAM3V3_7BITS_CNTL_REG_ADDRESS                0x18
#define EERAM3V3_CNTL_STATUS_REG_ADDRESS               0x00
#define EERAM3V3_CNTL_CMD_REG_ADDRESS                  0x55
#define EERAM3V3_CNTL_CMD_SOFT_STORE                   0x33
#define EERAM3V3_CNTL_CMD_SOFT_RECALL                  0xDD
#define MIN(a,b)                                       (a<b?a:b)
#define PAGESIZE                                       0x10  // 16 Byte write at a time

eeram3v3_ErrNo_t   eeram3v3_lastError; // 0 represents no error

i2c_operations_t wr1ByteCompleteHandler(void *p);
i2c_operations_t rd1ByteCompleteHandler(void *p);
i2c_operations_t writeData(void *payload);
__bit writePage(EERAM3V3_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount);
i2c_operations_t rdBlockCompleteHandler(void *payload);

#endif /* I2C_FUNCTIONS_H */
