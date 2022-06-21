/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "generic_eeprom.h"


/**
  Section: Driver APIs
 */ 

void eeprom_writeByte(EEPROM_ADDRESS_t address, uint8_t data) {
    ${WriteByte}(address, data);
}

uint8_t eeprom_readByte(EEPROM_ADDRESS_t address) {
     ${ReadByte}(address);
}

void eeprom_writeBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount) {   
     ${WriteBlock}(address, &dataBlock, dataBlockByteCount);
}

void eeprom_readBlock(EEPROM_ADDRESS_t address, uint8_t *dataBlock, uint8_t dataBlockByteCount) {
    ${ReadBlock}(address, &dataBlock, dataBlockByteCount);
}

/**
 End of File
 */ 
