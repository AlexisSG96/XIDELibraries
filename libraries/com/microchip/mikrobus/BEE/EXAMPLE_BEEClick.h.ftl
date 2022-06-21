/*
<#include "MicrochipDisclaimer.ftl">
*/
 
#ifndef EXAMPLE_BEECLICK_H
#define	EXAMPLE_BEECLICK_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

void BEE_Example_Transmitter(void);
void BEE_Example_Receiver(void);

#endif	/* EXAMPLE_BEECLICK_H */
