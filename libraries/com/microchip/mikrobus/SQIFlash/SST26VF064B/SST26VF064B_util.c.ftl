/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "SST26VF064B_serial.h"
#include "SST26VF064B_util.h"

void SST26VF064B_writeAddress(uint32_t address) {
    SST26VF064B_serial.writeByte(address);
    SST26VF064B_serial.writeByte(address >> 8);
    SST26VF064B_serial.writeByte(address >> 16);
}
