/*
<#include "MicrochipDisclaimer.ftl">
*/
<#if (GPS_CLICK_NAME == "GPS_Nano")>
/*
 * File:   EXAMPLE_NANOGPS.h
 */
#ifndef EXAMPLE_NANOGPS_H
#define	EXAMPLE_NANOGPS_H
<#elseif (GPS_CLICK_NAME == "GPS_3")>
/*
 * File:   EXAMPLE_GPS3.h
 */
#ifndef EXAMPLE_GPS_H
#define	EXAMPLE_GPS3_H
</#if>

void EXAMPLE_StartUp(void);
void EXAMPLE_Running(void);

<#if (GPS_CLICK_NAME == "GPS_Nano")>
#endif	/* EXAMPLE_NANOGPS_H */
<#elseif (GPS_CLICK_NAME == "GPS_3")>
#endif	/* EXAMPLE_GPS3_H */
</#if>