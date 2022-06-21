/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EEPROM3_H
#define	EEPROM3_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

#include <stdint.h>
    
uint16_t EEPROM_DEVICE_ADDRESS = (0xA8 >> 1);

void EEPROM3_WriteOneByte(uint32_t address, uint8_t data);
uint8_t EEPROM3_ReadOneByte(uint32_t address);
void EEPROM3_WriteBlock(uint32_t address, void* data, uint16_t count);
void EEPROM3_ReadBlock(uint32_t address, void* data, uint16_t count);

#endif  //EEPROM3_H
