/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <stdio.h>
#include "SQIFLASH_example.h"
#include "SQIFLASH.h"
#include "SST26VF064B/SST26VF064B.h"

#define SQIFLASH_ADDRESS        0x010000
#define BUFFER_SIZE             SQIFLASH_PAGE_SIZE/2

uint16_t SQIFLASH_example_writeRead(void);

uint8_t buffer[BUFFER_SIZE];

void SQIFLASH_example(void) {
    uint16_t errorCountSPI = 0, errorCountSQI = 0;

    SST26VF064B_reset();
    errorCountSPI = SQIFLASH_example_writeRead();
    SQIFLASH_enableSQI();
    errorCountSQI = SQIFLASH_example_writeRead();
    SQIFLASH_disableSQI();
    printf("SPI errors: %d\tSQI errors: %d\r\n", errorCountSPI, errorCountSQI);
}

uint16_t SQIFLASH_example_writeRead(void) {
    uint16_t errorCount = 0;
    uint8_t writeVal;
    
    // Initialize buffer with increasing values
    for (uint16_t i = 0; i < BUFFER_SIZE; i++) {
        buffer[i] = i;
    }
    
    SQIFLASH_eraseChip();
    SQIFLASH_write(SQIFLASH_ADDRESS, buffer, BUFFER_SIZE);
    
    // Rewrite buffer with dummy value
    for (uint16_t i = 0; i < BUFFER_SIZE; i++) {
        buffer[i] = 'x';
    }
    
    SQIFLASH_read(SQIFLASH_ADDRESS, buffer, BUFFER_SIZE);
    
    for (uint16_t i = 0; i < BUFFER_SIZE; i++) {
        writeVal = i;
        if (buffer[i] != writeVal) {
            errorCount++;
        }
    }
    
    return errorCount;
}
