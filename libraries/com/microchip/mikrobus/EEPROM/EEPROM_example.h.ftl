/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EEPROM_EXAMPLE_H
#define	EEPROM_EXAMPLE_H
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include "util/delay.h"
</#if>

void EEPROM_example(void);

#endif	/* EEPROM_EXAMPLE_H */
