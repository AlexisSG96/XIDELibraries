/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RTCC5_EXAMPLE_H
#define	RTCC5_EXAMPLE_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void rtcc5_example(void);

#endif	/* RTCC5_EXAMPLE_H */

