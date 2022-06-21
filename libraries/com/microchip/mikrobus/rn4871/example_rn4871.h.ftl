/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _EXAMPLE_RN4871_H
#define _EXAMPLE_RN4871_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void RN4871_Example(void);

#endif /* _EXAMPLE_RN4871_H */