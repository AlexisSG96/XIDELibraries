/**
\file
\addtogroup doc_driver_delay_code
\brief This file contains the functions to generate delays in the millisecond and microsecond ranges as well as using timer ticks to indicate delay length.
<br>
<#include "MicrochipDisclaimer.ftl">
*/

/* NOTICE: This module overwrites the CORE timer. */

#include <stdint.h>
#include <stdbool.h>

#include <xc.h>
#include "clock.h"

#define MILLISECONDS_TO_TICKS(milliseconds) (milliseconds*(_XTAL_FREQ/2)/1000)
#define MICROSECONDS_TO_TICKS(microseconds) (MILLISECONDS_TO_TICKS(microseconds)/1000)

/**
 *  \ingroup doc_driver_delay_code
 *  Call this function to delay execution of the program for a certain number of timer ticks
@param ticks - number of timer ticks to delay
*/
static void delay_ticks(uint32_t ticks)
{
    IEC0bits.CTIE = 0;      //Disable core timer interrupt;
    
    _CP0_SET_COUNT(0);
    
    /* we are using the compare to test for a roll over in case of a really long
     * delay + an interrupt occurring close to the end causing it to roll over.
     * By setting the compare to the end of the timer and clearing the flag, we
     * can tell if the timer rolled over in that event. */
    _CP0_SET_COMPARE(0xFFFFFFFF);
    IFS0CLR = 0x00000001;
        
    while( (_CP0_GET_COUNT() < ticks ) && ( IFS0bits.CTIF == 0 ) )
    {
    }
}

/**
*  \ingroup doc_driver_delay_code
*  Call this function to delay execution of the program for a certain number of milliseconds
@param milliseconds - number of milliseconds to delay
*/
void ${delayInterface["delayMs"]}(uint16_t milliseconds)
{
    #if _XTAL_FREQ > 130000000
    #error This delay implementation will only work up until 130MHz
    #endif 

    delay_ticks(MILLISECONDS_TO_TICKS(milliseconds));
}

/**
*  \ingroup doc_driver_delay_code
*  Call this function to delay execution of the program for a certain number of microseconds
@param microseconds - number of microseconds to delay
*/
void ${delayInterface["delayUs"]}(uint16_t microseconds)
{
    delay_ticks(MICROSECONDS_TO_TICKS(microseconds));
}

