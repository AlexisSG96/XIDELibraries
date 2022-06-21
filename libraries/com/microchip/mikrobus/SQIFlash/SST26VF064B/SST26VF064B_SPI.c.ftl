/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "../${pinHeader}"
#include "SST26VF064B_serial.h"
#include "SST26VF064B_util.h"
#include "SST26VF064B_SPI.h"

bool SST26VF064B_SPI_readJedecID(SST26VF064B_jedecid_t *id) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_JEDECID);
    SST26VF064B_serial.readBlock((uint8_t *)id, 3);  
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
    
    if(id->manu_id != 0xBF || id->device_type != 0x26 || id->device_id != 0x43){
        return false;
    }
    
    return true;
}

void SST26VF064B_SPI_read(uint32_t address, uint8_t *dst, size_t len) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_READ);
    SST26VF064B_writeAddress(address);
    SST26VF064B_serial.readBlock(dst, len);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

void SST26VF064B_SPI_readBPR(uint8_t *dest) { 
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RBPR);
    
    uint8_t len = 18;
    dest += len - 1;                // Most significant first
    while(len--) {
        *dest-- = SST26VF064B_serial.readByte();
    }
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}
