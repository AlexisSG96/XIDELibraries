/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _SQIFLASH_H
#define	_SQIFLASH_H

#include <stdint.h>
#include <stddef.h>

#define START_PAGE_ADDRESS                  0x010000
#define END_PAGE_ADDRESS                    0x7FFFFF
#define SQIFLASH_PAGE_SIZE                  256

void SQIFLASH_enableSQI(void);
void SQIFLASH_disableSQI(void);
void SQIFLASH_read(uint32_t addr, uint8_t *buff, size_t len);
void SQIFLASH_write(uint32_t addr, uint8_t *buff, size_t len);
void SQIFLASH_eraseChip(void);

#endif //_SQIFLASH_H
