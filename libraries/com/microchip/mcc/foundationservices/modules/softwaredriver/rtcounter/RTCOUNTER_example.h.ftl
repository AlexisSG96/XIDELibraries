/**
\file
\defgroup doc_driver_rtc_example Real Time Counter Driver Example Source Code Reference
\ingroup doc_driver_rtc
\brief This file contains the APIs to demonstrate the common use cases of the RTCounter

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RTCOUNTER_EXAMPLE_H
#define	RTCOUNTER_EXAMPLE_H

<#if (genAll == "true")>
void rtc_example_create_sched_oneshot(void);
void rtc_example_create_sched_periodic(void);
</#if>
<#if (genPeriodic == "true")||(genOneshot == "true")>
void rtc_example_create_scheduler_mode(void);
</#if>
<#if (genAll == "true")||(genPayload == "true")>
void rtc_example_create_sched_periodic_with_payload(void);
</#if>
<#if (genAll == "true")||(genStopwatch == "true")>
uint32_t rtc_example_stopwatch_mode(void);
</#if>


#endif	/* RTCOUNTER_EXAMPLE_H */

