 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef LR_EXAMPLE_H
#define	LR_EXAMPLE_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void Example_ReadRange(void);

#endif