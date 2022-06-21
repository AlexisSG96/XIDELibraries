/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef DRIVER_BEECLICK_H
#define	DRIVER_BEECLICK_H

#include <stdint.h>
#include <stdbool.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void BEE_Init(void);
void BEE_Write(uint8_t *txPayload, uint8_t payloadLen);
bool BEE_Read(uint8_t *rxData, uint8_t payloadLen);

#endif	/* DRIVER_BEECLICK_H */
