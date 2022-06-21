/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef LEDDRIVER2_EXAMPLE_H
#define LEDDRIVER2_EXAMPLE_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void  LEDDRIVER2_Example(void);

#endif	/* LEDDRIVER2_EXAMPLE_H */