/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_WIFIPLUS_H
#define	EXAMPLE_WIFIPLUS_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EXAMPLE_startupWiFiPlus (void);
void EXAMPLE_CaptureReceivedMessage(void);

#endif	/* EXAMPLE_WIFIPLUS_H */

