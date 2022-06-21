/**
\file
\defgroup doc_driver_timeout_example Timeout Driver Example Source Code Reference
\ingroup doc_driver_timeout
\brief This file contains the APIs to demonstrate the common use cases of the Timeout Driver

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef TIMEOUT_EXAMPLE_H
#define	TIMEOUT_EXAMPLE_H

<#if (genAll == "true")>
void Timeout_example_create_sched_oneshot(void);
void Timeout_example_create_sched_periodic(void);
</#if>
<#if (genPeriodic == "true")||(genOneshot == "true")>
void Timeout_example_create_scheduler_mode(void);
</#if>
<#if (genAll == "true")||(genPayload == "true")>
void Timeout_example_create_sched_periodic_with_payload(void);
</#if>
<#if (genAll == "true")||(genStopwatch == "true")>
uint32_t Timeout_example_stopwatch_mode(void);
</#if>


#endif	/* TIMEOUT_EXAMPLE_H */

