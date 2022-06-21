/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef GAINAMP2_H
#define	GAINAMP2_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
typedef enum {
    GAIN01, GAIN02, GAIN04, GAIN05, GAIN08, GAIN10, GAIN16, GAIN32
} GAINAMP_gain_t;

void GAINAMP2_setGain(GAINAMP_gain_t gain);
void GAINAMP2_selectChannel(uint8_t channel);   // Available channels: 0 to 5
void GAINAMP2_shutdown(void);

#endif	/* GAINAMP2_H */