/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SST26VF064B_SQI_H
#define	SST26VF064B_SQI_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include "SST26VF064B_types.h"
    
void SST26VF064B_SQI_enable(void);
void SST26VF064B_SQI_disable(void);
bool SST26VF064B_SQI_readJedecID(SST26VF064B_jedecid_t *id);
void SST26VF064B_SQI_readBPR(uint8_t *dest);    // 18 bytes
void SST26VF064B_SQI_readHighSpeed(uint32_t address, uint8_t *dst, size_t len);

#endif	/* SST26VF064B_SQI_H */
