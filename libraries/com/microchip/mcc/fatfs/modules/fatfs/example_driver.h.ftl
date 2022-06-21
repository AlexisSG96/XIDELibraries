/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ${instance_name}_H
#define ${instance_name}_H

#include <stdbool.h>
#include <stdint.h>

bool ${instance_name}_IsMediaPresent(void);
bool ${instance_name}_MediaInitialize(void);
bool ${instance_name}_IsMediaInitialized(void);

bool ${instance_name}_IsWriteProtected(void);
uint16_t ${instance_name}_GetSectorSize(void);
uint32_t ${instance_name}_GetSectorCount(void);

bool ${instance_name}_SectorRead(uint32_t sector_address, uint8_t* buffer, uint16_t sector_count);
bool ${instance_name}_SectorWrite(uint32_t sector_address, const uint8_t* buffer, uint16_t sector_count);

#endif
