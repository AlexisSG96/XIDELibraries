/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BRUSHLESS6_EXAMPLE_H
#define	BRUSHLESS6_EXAMPLE_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

void BRUSHLESS6_example(void);

#endif	/* BRUSHLESS6_EXAMPLE_H */