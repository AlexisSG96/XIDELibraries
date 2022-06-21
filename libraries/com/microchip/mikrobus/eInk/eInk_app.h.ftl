 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef EINK_H
#define	EINK_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void eInk_setup(void);

void eInk_startDisplayWrite(void);
void eInk_displayWrite(uint8_t pixel1, uint8_t pixel2, uint8_t pixel3, uint8_t pixel4);
void eInk_stopDisplayWrite(void);

#endif