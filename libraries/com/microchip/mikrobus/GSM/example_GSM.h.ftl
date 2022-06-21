/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_GSM_H
#define	EXAMPLE_GSM_H

#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EXAMPLE_useGSM (void);
void EXAMPLE_CaptureReceivedMessage(void);

#endif	/* EXAMPLE_GSM_H */

