/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SST26VF064B_SPI_H
#define	SST26VF064B_SPI_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include "SST26VF064B_types.h"

bool SST26VF064B_SPI_readJedecID(SST26VF064B_jedecid_t *id);
void SST26VF064B_SPI_readBPR(uint8_t *dest);    // 18 bytes
void SST26VF064B_SPI_read(uint32_t address, uint8_t *dst, size_t len);

#endif	/* SST26VF064B_SPI_H */
