/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SST26VF064B_SERIAL_H
#define	SST26VF064B_SERIAL_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

typedef struct {
    void (*writeByte)(uint8_t tx);
    uint8_t (*readByte)(void);
    void (*writeBlock)(void *src, size_t s);
    void (*readBlock)(void *dst, size_t s);
    bool (*open)(void);
    void (*close)(void);
} serial_t;

extern serial_t SST26VF064B_serial;

void SST26VF064B_serial_setSerialFunctionsToSPI(void);
void SST26VF064B_serial_setSerialFunctionsToSQI(void);

#endif	/* SST26VF064B_SERIAL_H */

