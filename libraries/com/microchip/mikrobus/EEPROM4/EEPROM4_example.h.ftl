/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EEPROM4_EXAMPLE_H
#define	EEPROM4_EXAMPLE_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EEPROM4_example(void);

#endif	/* EEPROM4_EXAMPLE_H */
