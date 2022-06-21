 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef EINK_EXAMPLE_H
#define	EINK_EXAMPLE_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void eInk_example(void);

#endif