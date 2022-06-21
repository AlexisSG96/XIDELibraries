 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef LED7X10R_example_H
#define	LED7X10R_example_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void LED7X10R_Example(void);

#endif