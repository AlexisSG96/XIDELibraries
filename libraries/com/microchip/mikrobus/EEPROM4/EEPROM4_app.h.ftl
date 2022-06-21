/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EEPROM4_APP_H
#define	EEPROM4_APP_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void EEPROM4_WriteByte (uint8_t byteData, unsigned long byteAddr);
uint8_t EEPROM4_ReadByte (unsigned long address);
void EEPROM4_WriteBlock(uint8_t *writeBuffer, uint8_t buflen, unsigned long startAddr);
void EEPROM4_ReadBlock(uint8_t *readBuffer, uint8_t buflen, unsigned long startAddr);
uint8_t EEPROM4_WritePoll(void);


#endif	/* EEPROM4_APP_H */
