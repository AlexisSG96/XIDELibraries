/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _SLIDER_H
#define _SLIDER_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
uint16_t SLIDER_getPosition(void);
void SLIDER_setLEDS(uint16_t val);
void SLIDER_setBar(uint16_t val);

#endif // _SLIDER_H
