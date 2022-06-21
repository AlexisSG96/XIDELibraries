 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef ACCURRENT_H
#define	ACCURRENT_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>

uint16_t ACcurrent_getCurrent(void);  

#endif
