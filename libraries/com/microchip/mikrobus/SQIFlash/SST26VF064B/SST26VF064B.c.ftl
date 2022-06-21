/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "../${pinHeader}"
#include "SST26VF064B_serial.h"
#include "SST26VF064B_util.h"
#include "SST26VF064B.h"

void SST26VF064B_enableWrite(void);

void SST26VF064B_reset(void) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RSTEN);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;

    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RST);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();

    ${SQ2PinSettings["TRIS"]} = 0;
    ${SQ2PinSettings["LAT"]} = 1;
    ${SQ3PinSettings["TRIS"]} = 0;
    ${SQ3PinSettings["LAT"]} = 1;
    
    SST26VF064B_serial_setSerialFunctionsToSPI();
}

uint8_t SST26VF064B_readStatusRegister(void) {
    uint8_t statusReg;
    
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RDSR);
    SST26VF064B_serial.writeByte(CMD_RDSR);         // Dummy
    statusReg = SST26VF064B_serial.readByte();
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
    
    return statusReg;
}

uint8_t SST26VF064B_readConfigRegister(void) {
    uint8_t config;
    
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_RDCR);
    SST26VF064B_serial.writeByte(CMD_RDCR);         // Dummy
    config = SST26VF064B_serial.readByte();
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
    
    return config;
}

void SST26VF064B_writeConfigRegister(uint8_t config) {
    SST26VF064B_enableWrite();
    
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_WRSR);
    SST26VF064B_serial.writeByte(0xFF);            // Dummy
    SST26VF064B_serial.writeByte(config); 
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

bool SST26VF064B_isBusy(void) {
    return SST26VF064B_readStatusRegister() & STATUS_BUSY;
}

void SST26VF064B_enableWrite(void) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_WREN);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

void SST26VF064B_disableWrite(void) {
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_WRDI);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

void SST26VF064B_eraseChip(void) {
    SST26VF064B_enableWrite();
    
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_CE);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

void SST26VF064B_pageProgram(uint32_t address, uint8_t *src, size_t len) {
    SST26VF064B_enableWrite();
    
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_PP);
    SST26VF064B_writeAddress(address);
    SST26VF064B_serial.writeBlock(src, len);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}

void SST26VF064B_globalUnlockBPR(void) {
    SST26VF064B_enableWrite();
    
    while(!SST26VF064B_serial.open());
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    SST26VF064B_serial.writeByte(CMD_ULBPR);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    SST26VF064B_serial.close();
}
