/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SQI_DRIVER_H
#define	SQI_DRIVER_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
bool sqi_open(void);
void sqi_close(void);
void sqi_writeByte(uint8_t);
uint8_t sqi_readByte(void);
void sqi_writeBlock(void *block, size_t blockSize);
void sqi_readBlock(void *block, size_t blockSize);

#endif	/* SQI_DRIVER_H */
