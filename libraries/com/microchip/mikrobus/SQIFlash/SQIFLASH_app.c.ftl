/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "SST26VF064B/SST26VF064B.h"
#include "SST26VF064B/SST26VF064B_SPI.h"
#include "SST26VF064B/SST26VF064B_SQI.h"
#include "SQIFLASH.h"

typedef struct {
    void (*read)(uint32_t, uint8_t *, size_t);
} SQIFLASH_func_t;

static const SQIFLASH_func_t SQIFLASH[] = {
    {SST26VF064B_SPI_read}, 
    {SST26VF064B_SQI_readHighSpeed}
};

static uint8_t mode;

void SQIFLASH_enableSQI(void) {
    SST26VF064B_SQI_enable();
    mode = 1;
}

void SQIFLASH_disableSQI(void) {
    SST26VF064B_SQI_disable();
    mode = 0;
}

void SQIFLASH_write(uint32_t addr, uint8_t *buff, size_t len) {
    uint8_t pagesToWrite = len / SQIFLASH_PAGE_SIZE;
    uint8_t excessBytes = len % SQIFLASH_PAGE_SIZE;
    
    SST26VF064B_globalUnlockBPR();

    while (pagesToWrite--) {
        SST26VF064B_pageProgram(addr, buff, SQIFLASH_PAGE_SIZE);
        addr += SQIFLASH_PAGE_SIZE;
        buff += SQIFLASH_PAGE_SIZE;
        while(SST26VF064B_isBusy());
    }

    SST26VF064B_pageProgram(addr, buff, excessBytes);
    while(SST26VF064B_isBusy());
}

void SQIFLASH_read(uint32_t addr, uint8_t *buff, size_t len) {
    SQIFLASH[mode].read(addr, buff, len);
}

void SQIFLASH_eraseChip(void) {
    SST26VF064B_eraseChip();
    while(SST26VF064B_isBusy());
}
