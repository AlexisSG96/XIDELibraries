/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef TOUCHKEY3_DRIVER_H
#define	TOUCHKEY3_DRIVER_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
typedef enum { KEY1 = 0x01,
               KEY2 = 0x02,
               KEY3 = 0x04,
               KEY4 = 0x08,
               KEY5 = 0x10,
               KEY6 = 0x20,
               KEY7 = 0x40} key;
void TOUCHKEY3_Initialize(void);
key TOUCHKEY3_getButtonState(void);
inline void TOUCHKEY3_setTouchMode(void);


#endif	/* TOUCHKEY3_DRIVER_H */
