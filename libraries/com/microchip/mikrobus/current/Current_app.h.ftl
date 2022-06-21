/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MIKROE_CLICK_CURRENT_H
#define	MIKROE_CLICK_CURRENT_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
uint32_t Current_Get_mAResult(void);

#endif
