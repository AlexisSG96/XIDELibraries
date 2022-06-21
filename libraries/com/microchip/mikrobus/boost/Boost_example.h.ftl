/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BOOST_EXAMPLE_H
#define	BOOST_EXAMPLE_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

void BOOST_Example(void);

#endif	/* BOOST_EXAMPLE_H */
