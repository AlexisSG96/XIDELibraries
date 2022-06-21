/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef USBSPI_H
#define	USBSPI_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void     USBSPI_Initialize(void);
uint8_t  USBSPI_ExchangeByte(uint8_t data);
void     USBSPI_ExchangeBlock(uint8_t *dataBlock, int blockSize);
void     USBSPI_ReleaseBus(void);

#endif	/* USBSPI_H */

