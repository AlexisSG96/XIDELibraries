/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef __nRFC_Example_H
#define	__nRFC_Example_H

<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

<#if nRFC_ModeKey == "Receive">
void receiver();
</#if>
<#if nRFC_ModeKey == "Transmit">
void transmitter();
</#if>

#endif