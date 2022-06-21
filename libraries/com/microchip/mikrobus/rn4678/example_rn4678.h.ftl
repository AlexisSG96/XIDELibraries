/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_RN4678_USE_H
#define	EXAMPLE_RN4678_USE_H

#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EXAMPLE_useRN4678 (void);
void EXAMPLE_CaptureReceivedMessage(void);

#endif	/* EXAMPLE_RN4678_USE_H */

