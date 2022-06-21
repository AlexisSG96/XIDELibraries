/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EEPROM2_APP_H
#define	EEPROM2_APP_H

#include <stdint.h>

void EEPROM2_WriteByte (uint8_t byteData, uint32_t byteAddr);
uint8_t EEPROM2_ReadByte (uint32_t address);
void EEPROM2_WriteBlock(uint8_t *writeBuffer, uint8_t buflen, uint32_t startAddr);
void EEPROM2_ReadBlock(uint8_t *readBuffer, uint8_t buflen, uint32_t startAddr);
uint8_t EEPROM2_WritePoll(void);

#endif	/* EEPROM2_APP_H */

