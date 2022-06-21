/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <time.h>
#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void rtcc5_Initialize(void);
void rtcc5_SetTime(time_t);
time_t rtcc5_GetTime(void);

uint8_t rtcc5_ReadByteEEPROM(uint8_t addr);
void rtcc5_ReadBlockEEPROM(uint8_t addr, void *data, uint8_t len);

void rtcc5_WriteByteEEPROM(uint8_t addr, uint8_t data);
void rtcc5_WriteBlockEEPROM(uint8_t addr, void *data, uint8_t len);

