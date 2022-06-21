/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef IRDA3_EXAMPLE_H
#define	IRDA3_EXAMPLE_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void IRDA3_example(void);

#endif	/* IRDA3_EXAMPLE_H */

