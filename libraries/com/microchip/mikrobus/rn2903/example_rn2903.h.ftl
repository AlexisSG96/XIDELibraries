/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_RN2903_USE_H
#define	EXAMPLE_RN2903_USE_H

#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EXAMPLE_useRN2903 (void);
void EXAMPLE_CaptureReceivedMessage(void);

#endif	/* EXAMPLE_RN2903_USE_H */