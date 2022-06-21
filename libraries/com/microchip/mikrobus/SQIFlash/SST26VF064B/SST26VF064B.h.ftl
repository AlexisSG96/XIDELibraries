/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SST26VF064B_H
#define SST26VF064B_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

void SST26VF064B_reset(void);
uint8_t SST26VF064B_readStatusRegister(void);
uint8_t SST26VF064B_readConfigRegister(void);
void SST26VF064B_writeConfigRegister(uint8_t);
bool SST26VF064B_isBusy(void);

void SST26VF064B_disableWrite(void);
void SST26VF064B_eraseChip(void);
void SST26VF064B_pageProgram(uint32_t address, uint8_t *src, size_t len);

void SST26VF064B_globalUnlockBPR(void);

#endif // SST26VF064B_H
