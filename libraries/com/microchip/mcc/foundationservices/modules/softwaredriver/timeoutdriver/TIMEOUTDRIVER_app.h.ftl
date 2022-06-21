/**
\file
\defgroup doc_driver_timeout_code Timeout Driver Source Code Reference
\ingroup doc_driver_timeout
\brief This file contains the Timeout Driver APIs

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
**/

#ifndef __TIMEOUTDRIVER_H
#define __TIMEOUTDRIVER_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/*
*   Please note that the timer tick is different from the timer period. 
*   A tick occurs each time the peripheral timer increases its count
*   The timer period is when the number of ticks reaches its specified maximum and 
*      the timer overflow interrupt occurs. 
*   This library sets the timer period internally as needed
*/
<#if (isAVR == "true")>
#define INLINE
<#else>
#define INLINE inline
</#if>

// mSec to Ticks and Ticks to mSec conversion. These values are based on the minimum period of the TMRx peripheral
// Note that these values have been rounded to the nearest power of two to make the calculations faster at runtime
#define timeout_mSecToTicks(a)     ( ((uint32_t)(a)) * ${timerTickFactor}UL )
#define timeout_ticksToMsec(a)     ( ((uint32_t)(a)) / ${timerTickFactor}UL )

typedef  uint32_t (*timercallback_ptr_t)(void *payload);

/**
\ingroup doc_driver_timeout_code
\struct tmrStruct_t
\brief Defines a timer instance.
*/
typedef struct tmrStruct {
    timercallback_ptr_t  callbackPtr;   /**<This is a pointer to the callback handler*/
    void* payload;                      /**<This is a value that can be passed on to the callback*/
    struct tmrStruct*  next;            /**<This is a pointer to the next timer on the queue */
    uint32_t absoluteTime;              /**<This is the number of ticks the timer will count down*/
} timerStruct_t;

void timeout_initialize(void);
void timeout_create(timerStruct_t *timer, uint32_t timeout);
void timeout_delete(timerStruct_t *timer);
void timeout_flushAll(void);
bool timeout_hasPendingTimeouts(void);
bool timeout_hasPendingCallbacks(void);
INLINE void timeout_callNextCallback(void);
void timeout_isr(void);

void timeout_startTimer(timerStruct_t *timer);
uint32_t timeout_stopTimer(timerStruct_t *timer);

uint32_t timeout_getTimeRemaining(timerStruct_t *timer);

#endif // __TIMEOUTDRIVER_H
