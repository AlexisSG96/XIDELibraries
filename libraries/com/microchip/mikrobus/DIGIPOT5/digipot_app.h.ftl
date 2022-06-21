/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _DIGIPOT_H
#define _DIGIPOT_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void DIGIPOT_setChannel(uint8_t channel);

void DIGIPOT_set(uint16_t);
uint16_t DIGIPOT_get(void);

void DIGIPOT_save(void);
void DIGIPOT_load(void);

void DIGIPOT_lock(void);
void DIGIPOT_unlock(void);

#endif // _DIGIPOT_H
