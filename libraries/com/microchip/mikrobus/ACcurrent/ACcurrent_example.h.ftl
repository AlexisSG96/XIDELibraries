 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef ACCURRENT_EXAMPLE_H
#define	ACCURRENT_EXAMPLE_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

void ACcurrent_example(void);  

#endif
