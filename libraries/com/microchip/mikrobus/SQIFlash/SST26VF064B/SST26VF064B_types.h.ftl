/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SST26VF064B_TYPES_H
#define SST26VF064B_TYPES_H

#include <stdint.h>

typedef struct {
    uint8_t manu_id;
    uint8_t device_type;
    uint8_t device_id;
} SST26VF064B_jedecid_t;

#endif // SST26VF064B_TYPES_H
