/**
\file
\addtogroup doc_driver_timeout_example
\brief This file contains sample source codes to demonstrate the common use cases if the Timeout Driver

For the examples to run, the user must only need to select which timer the Timeout driver will be used and configure the selected timer.

There are three possible use cases in this example:
1. Oneshot Timer - After adding an event to the handler such as a pulse or an LED toggle, calling this example will run the the timer and execute the event exactly once.
2. Periodic Timer - After adding an event to the handler such as a pulse or an LED toggle, calling this example will run the the timer and execute the event repeatedly.
3. Stopwatch/Counter - Calling this example will run the the timer and return the number of timer ticks that has elapsed while a loop is executing.

Important Notes:
1. Include the timeout_example.h header file in whichever file the Timeout_example_create_<mode>() functions will be called.
2. If using MCC-generated GPIO operations and macros within the callbacks, make sure to include pin_manager.h (i.e. #include "../include/pin_manager.h")
3. If using interrupt-driven timers, make sure global interrupts are enabled.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#include "../drivers/timeout.h"
#include "timeout_example.h"    

<#if (genAll == "true")||(genOneshot == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * This timeout callback handler returns 0, does not reschedule the timer, so will execute only once. 
 * @param none
*/
static uint32_t oneshot_handler(void)
{
    //Put your application here
    
    return 0; // Do not reschedule timer
}
</#if>
<#if (genAll == "true")||(genPeriodic == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * This timeout callback handler continuously reschedules a periodic timer to timeout with the number of ticks it returns. 
 * @param none
*/
static uint32_t periodic_handler(void)
{
    //Put your application here
                
    return 1000; // Reschedule the timer after this many ticks
}

</#if>
<#if (genAll == "true")||(genPayload == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * This handler executes a repeating, periodic timer that uses a payload argument.
 * @param payload - any value that needs to be passed onto the handler.
*/
static uint32_t periodic_handler_payload(void *payload)
{
    uint8_t *p = (uint8_t *)payload;
	*p         = *p + 1;
	if (*p < 11) // Run timer 10 times
	{
            //Put your application here
                
            return 1000; // Reschedule the timer after this many ticks
	}
	return 0; // Stop the timer
   
}
</#if>
<#if (genAll == "true")||(genStopwatch == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * This handler executes a repeating timer that counts the ticks while an event is going on.
 * @param none
*/
static uint32_t counter_handler(void)
{
    //Put your application here
    
    return 1000; // Reschedule the timer after this many ticks
}
</#if>
<#if (genAll == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * Call this function to run a 1000-tick timer once. The timer will not be rescheduled in the associated callback function.
 * @param none
*/
void Timeout_example_create_sched_oneshot(void)
{
    timerStruct_t oneshot_timer = {oneshot_handler, NULL};
    timeout_create(&oneshot_timer,1000); //Create timer with the oneshot function as the callback handler, run timer for this number of ticks
    
    while(1)
    {
       timeout_callNextCallback(); 
    }
}

/**
 *  \ingroup doc_driver_timeout_example
 * Call this function to run a 1000-tick timer continuously. The callback function reschedules the timer continuously.
 * @param none
*/
void Timeout_example_create_sched_periodic(void)
{
    timerStruct_t periodic_timer = {periodic_handler,NULL};
    timeout_create(&periodic_timer,1000); //Create timer with the periodic function as the callback handler, run timer for this number of ticks.
                                          //The callback function determines for how many ticks the timer will be rescheduled. 
    while(1)
    {
       timeout_callNextCallback(); 
    }
}
</#if>
<#if (genOneshot == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * Call this function to run a 1000-tick timer once. The timer will not be rescheduled in the associated callback function.
 * @param none
*/
void Timeout_example_create_scheduler_mode(void)
{
    timerStruct_t oneshot_timer = {oneshot_handler, NULL};
    timeout_create(&oneshot_timer,1000); //Create timer with the oneshot function as the callback handler, run timer for this number of ticks
    
    while(1)
    {
       timeout_callNextCallback(); 
    }
}
</#if>
<#if (genPeriodic == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * Call this function to run a 1000-tick timer continuously. The callback function reschedules the timer continuously.
 * @param none
*/
void Timeout_example_create_scheduler_mode(void)
{
    timerStruct_t periodic_timer = {periodic_handler,NULL};
    timeout_create(&periodic_timer,1000); //Create timer with the periodic function as the callback handler, run timer for this number of ticks.
                                          //The callback function determines for how many ticks the timer will be rescheduled. 
    while(1)
    {
       timeout_callNextCallback(); 
    }
}
</#if>
<#if (genAll == "true")||(genPayload == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * Call this function to run a 1000-tick timer 10 times, with the counter sent as a payload.
 * @param none
*/
void Timeout_example_create_sched_periodic_with_payload(void)
{
    uint8_t timeout_count = 0;
    timerStruct_t periodic_timer_payload = {periodic_handler_payload, (void *)&timeout_count}; //Initialize the timer with the callback handler and a pointer to the payload 
    timeout_create(&periodic_timer_payload,1000); //Schedule the specified timer task, number ticks to initial timeout
                                                  //The callback function determines for how many ticks the timer will be rescheduled. 

    while(1)
    {
       timeout_callNextCallback(); 
    }
}
</#if>
<#if (genAll == "true")||(genStopwatch == "true")>
/**
 *  \ingroup doc_driver_timeout_example
 * Call this function to count how many timer ticks have elapsed since the start of a timer
 * @return cycle number of timer ticks that has elapsed since the start of the timer
*/
uint32_t Timeout_example_stopwatch_mode(void)
{
    uint32_t timerTicks = 0;
    int a = 0;
    timerStruct_t counter_timer = {counter_handler, NULL};
    timeout_startTimer(&counter_timer);
    
    for (a = 0; a < 200; a++) //time this loop
		;
    
    timerTicks = timeout_stopTimer(&counter_timer);
    return timerTicks;
}
</#if>

/**
 End of File
 */
