/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _MCP3201_H
#define	_MCP3201_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
uint16_t MCP3201_getConversionResult(void);

#endif // _MCP3201_H
