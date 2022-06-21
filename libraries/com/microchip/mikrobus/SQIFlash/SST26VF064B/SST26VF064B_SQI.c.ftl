/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "../${pinHeader}"
#include "SST26VF064B_serial.h"
#include "SST26VF064B_util.h"
#include "SST26VF064B_SQI.h"

void SST26VF064B_SQI_enable(void) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_EQIO);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
    
    SST26VF064B_serial_setSerialFunctionsToSQI();
}

void SST26VF064B_SQI_disable(void) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RSTQIO);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
    
    ${SQ2PinSettings["TRIS"]} = 0;
    ${SQ2PinSettings["LAT"]} = 1;
    ${SQ3PinSettings["TRIS"]} = 0;
    ${SQ3PinSettings["LAT"]} = 1;
    
    SST26VF064B_serial_setSerialFunctionsToSPI();
}

bool SST26VF064B_SQI_readJedecID(SST26VF064B_jedecid_t *id) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_QUAD_JID);
    SST26VF064B_serial.writeByte(0xFF);             // Dummy
    SST26VF064B_serial.readBlock((uint8_t *)id, 3);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
    
    if(id->manu_id != 0xBF || id->device_type != 0x26 || id->device_id != 0x43){
        return false;
    }
    
    return true;
}

void SST26VF064B_SQI_readHighSpeed(uint32_t address, uint8_t *dst, size_t len) { 
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_HS_READ);
    SST26VF064B_writeAddress(address); 
    SST26VF064B_serial.writeByte(0xFF);            // Dummy
    SST26VF064B_serial.writeByte(0xFF);            // Dummy
    SST26VF064B_serial.writeByte(0xFF);            // Dummy
    SST26VF064B_serial.readBlock(dst, len);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

void SST26VF064B_SQI_readBPR(uint8_t *dest) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RBPR);
    SST26VF064B_serial.writeByte(0xFF);             // Dummy
    
    uint8_t len = 18;
    dest += len - 1;                                // Most significant first
    while(len--) {
        *dest-- = SST26VF064B_serial.readByte();
    }
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

