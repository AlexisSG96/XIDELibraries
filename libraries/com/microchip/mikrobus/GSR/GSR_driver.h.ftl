/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef GSR_DRIVER_H
#define GSR_DRIVER_H 

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
uint16_t GSR_GetReading(void);

#endif	/* GSR_DRIVER_H */