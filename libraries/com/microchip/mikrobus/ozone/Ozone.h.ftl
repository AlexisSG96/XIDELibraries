/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef OZONE_CLICK
#define	OZONE_CLICK

<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void Ozone_Initialize(void);
float Ozone_Read(void);

#endif	/* OZONE_CLICK */

