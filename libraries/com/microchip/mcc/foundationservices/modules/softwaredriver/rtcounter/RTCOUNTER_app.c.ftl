/**
\file
\addtogroup doc_driver_rtc_code
\brief This file contains the methods needed to implement the RTCounter functionalities.

Notes:   
        1.  If you are interested in testing how this driver performs when 
            the counter overflows we recommend you change this to 65500, which will make the 
            counter start in range of the overflow, saving loads of time. Overflows are implemented
            as a rebase of absolute times so you may want to take time to understand this first.

        2.  The ISR assumes the callback completes before the next timer tick. We only increment the 
            overflow counter on every interrupt

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include <stdio.h>
#include <stdbool.h>
#include "rtcounter.h"
#include "${timerHeader}"


// Counter value is in 2 parts, high and low, this is the high, low is in the timer register
#ifdef RTCOUNTER_CONCATENATE_TIMER_TICKS
static uint16_t g_rtcounterH = 0;   
#else
static uint32_t g_rtcounterH = 0;
#endif
static rtcountStruct_t * volatile rtcoutListHead = NULL;
static volatile bool  isRunning = false;

/**
\ingroup doc_driver_rtc_code
This function is the handler that is called whenever the Timer peripheral overflows.
The handler increments the RTCounter overflow counter.
@param none
*/
void rtcount_isr(void) {
    g_rtcounterH++;
    ${ClearIntFlag};
}

/**
\ingroup doc_driver_rtc_code
This function sets the RTCounter ISR handler as the the interrupt handler for the timer. Must be called while GIE = 0
@param none
*/
void rtcount_initialize(void) {
    ${SetInterruptHandler}(rtcount_isr);
}

/**
\ingroup doc_driver_rtc_code
This function returns the 32-bit total tick count of the timer. This means concatenating the hardware timer value to the overflow counter
@param none
*/
uint32_t rtcount_getTickCount(void)
{
    uint32_t tmp;
    ${StopIRQ};
    tmp = g_rtcounterH;
    tmp <<= 16;
    tmp |= ${ReadTimer}();
    ${StartIRQ};
    
    return tmp;
}

/**
\ingroup doc_driver_rtc_code
This function returns a number of ticks and returns the total number of timer ticks since the last overflow occurred or the timer module was started.
@param period - timer period
\returns ac - number of timer ticks since the last timeout occurred
*/
static inline uint32_t rtcount_makeAbsolute(uint32_t period) {
    uint32_t ac = period + rtcount_getTickCount();
    return ac;
}

/**
\ingroup doc_driver_rtc_code
This function figures out where the specific timer will be placed on the queue. 
@param timer - instance of a timer being inserted to the queue
\returns true if the inserted at the head of the queue
\returns false in not at the head of the queue
*/
static bool rtcount_sortedInsert(rtcountStruct_t *timer) {
    uint32_t timerAbs = timer->absoluteTime;

    uint8_t atHead = 1;
    rtcountStruct_t *insertPoint = rtcoutListHead;
    rtcountStruct_t *prevPoint = NULL;
    timer->next = NULL;

    // We ignore wrapping here
    while (insertPoint != NULL) {
        if (insertPoint->absoluteTime > timerAbs) {
            break; // found the spot
        }
        prevPoint = insertPoint;
        insertPoint = insertPoint->next;
        atHead = 0;
    }

    if (atHead == 1) // At the front of the list. 
    {
        // Make sure there are no timeouts nearby and clear interrupt flags
        timer->next = rtcoutListHead;
        rtcoutListHead = timer;
        return true;
    } else // middle of the list
    {
        timer->next = prevPoint->next;
    }
    prevPoint->next = timer;
    return false;
}

/**
\ingroup doc_driver_rtc_code
This function adjusts the time base so that the timer can be in the lower half of the range
@param none
*/
static inline void rebase(void)
{
    rtcountStruct_t *thisone = rtcoutListHead;
    ${StopIRQ};

#ifdef RTCOUNTER_CONCATENATE_TIMER_TICKS 
    // If we had an overflow we need a rebase
    if((int16_t) g_rtcounterH < 0 )
    {
        g_rtcounterH &= 0x7FFF;
#else
         // If we had an overflow we need a rebase
    if((int32_t) g_rtcounterH < 0 )
    {
        
        g_rtcounterH &= 0x7FFFFFFF;
#endif
        while(thisone)
        {
            thisone->absoluteTime &= 0x7FFFFFFF; // clear the MSB
            thisone = thisone->next;
        }
    }
    ${StartIRQ};
}

/**
\ingroup doc_driver_rtc_code
This function adds a new timer to the list of serviced timers. The user supplies the memory for the timer and initializes it.
This method simply updates absoluteTime and adds the timer to the list of serviced timers. 
@param *timer - timer instance to be created and added to the list
@param timeout - number of timer ticks before this timer expires.
*/

void rtcount_create(rtcountStruct_t *timer, int32_t timeout) {
    
    if(timeout < 0) timeout = 0;
    
    // rebase if needed
    rebase();

    timer->absoluteTime = rtcount_makeAbsolute((uint32_t)timeout);

    // We only have to start the timer at head if the insert was at the head
    rtcount_sortedInsert(timer);
}

/**
\ingroup doc_driver_rtc_code
This function adds time to previous ticks. We add it to the previous target and not 
to current time to ensure the cadence of the timer will be exact and no skidding is possible.
@param *timer - timer instance to be added to
@param timeout - number of timer ticks to be added.
*/
void rtcount_reschedule(rtcountStruct_t *timer, int32_t timeout) {
    
    // rebase if needed
    rebase();
    
    // Limit the reschedule range to positive numbers, negative numbers are treated as now    
    if(timeout < 0) timeout = 0;

    timer->absoluteTime += (uint32_t)timeout;
    
    // We only have to start the timer at head if the insert was at the head
    rtcount_sortedInsert(timer);
}

/**
\ingroup doc_driver_rtc_code
This function cancels and removes a running timer
@param *timer - timer instance to be removed
*/
void rtcount_delete(rtcountStruct_t * volatile timer) {
    if (rtcoutListHead == NULL)
        return;

    // Special case, the head is the one we are deleting
    if (timer == rtcoutListHead) {
        rtcoutListHead = rtcoutListHead->next; // Delete the head
    } else { // More than one timer in the list, search the list.  
        rtcountStruct_t *findTimer = rtcoutListHead;
        rtcountStruct_t *prevTimer = NULL;
        while (findTimer != NULL) {
            if (findTimer == timer) {
                prevTimer->next = findTimer->next; // Delete not at the head
                break;
            }
            prevTimer = findTimer;
            findTimer = findTimer->next;
        }
    }
}

/**
\ingroup doc_driver_rtc_code
This function checks the list of expired timers and calls the first one in the 
list if the list is not empty. It also reschedules the timer if the callback
returned a value greater than 0.It is recommended that this is called from the main superloop 
(while(1)) in your code but by design this can also be called from the timer ISR. If you 
wish callbacks to happen from the ISR context you can call this as the last action in 
timeout_isr instead. 
@param none
*/
void rtcount_callNextCallback(void) {
    int32_t   reschedule = 0;
    uint32_t  timerTmp;
    uint32_t  timeAtTheTip;

    // No timers in the list, return
    if (rtcoutListHead == NULL)
        return;
 
    // Serialize in case timer overflows right here
    timerTmp = rtcount_getTickCount();
    
    timeAtTheTip = rtcoutListHead->absoluteTime;
    
    if ((int32_t)(timerTmp - timeAtTheTip) > 0)
    {  
        // Remember the call details
        rtcountStruct_t* timer = rtcoutListHead;
        
        // Advance the list
        rtcoutListHead = rtcoutListHead->next;

        // Call the callback (no check is done for a NULL callback ptr, users need to check this 
        //     upon inserting the timer. We will be adding an assert here for checking the null  
        reschedule = timer->callbackPtr(timer->payload);

        if (reschedule) {
            rtcount_reschedule(timer, reschedule);
        }
    }
}

/**
\ingroup doc_driver_rtc_code
This function stops all timers
@param none
*/ 
static void stopTimeouts(void)
{
    isRunning = false;
}

/**
\ingroup doc_driver_rtc_code
This function is specifically used in Stopwatch mode for calculating the elapsed time in stopwatch mode. It will start
a timer with maximum timeout length. 
@param *timer - timer instance. 
*/
void rtcount_startTimer(rtcountStruct_t *timer)
{
    rtcount_create(timer, ((uint32_t)1<<31)-1);
}

/**
\ingroup doc_driver_rtc_code
This function will stop the running timer and return the number of ticks it counted. 
@param *timer - timer instance. 
\returns number of ticks counted by the timer.
*/
uint32_t rtcount_stopTimer(rtcountStruct_t *timer)
{
    rtcount_delete(timer);
    
    // This calculates the max range - remaining time which = elapsed time
    return (((uint32_t)1<<31)-1) - (timer->absoluteTime - rtcount_makeAbsolute(0));
}


/**
\ingroup doc_driver_rtc_code
This function cancels and removes all timers in the queue
@param none
*/
void rtcount_flushAll(void)
{
    stopTimeouts();
    rtcoutListHead = NULL;
}


/**
\ingroup doc_driver_rtc_code
This function prints the times for each of the timer for each timer on the queue.
@param none
*/
int rtcount_printList(void)
{
    rtcountStruct_t *basePoint = rtcoutListHead;
    while(basePoint != NULL)
    {
        printf("%4p:%lu -> ",basePoint,basePoint->absoluteTime);
        basePoint = basePoint->next;
    }
    printf("NULL\n");
    return 0;
}

