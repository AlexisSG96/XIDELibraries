/**
\file
\addtogroup doc_driver_delay_code
\brief This file contains the functions to generate delays in the millisecond and microsecond ranges.
\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
**/


<#list includes as include>
${include}
</#list>
#include <stdint.h>

/**
*  \ingroup doc_driver_delay_code
*  Call this function to delay execution of the program for a certain number of milliseconds
@param milliseconds - number of milliseconds to delay
*/
void ${delayInterface["delayMs"]}(uint16_t milliseconds) {
    while(milliseconds--){ 
        ${delay_ms}(1); 
    }
}

/**
*  \ingroup doc_driver_delay_code
*  Call this function to delay execution of the program for a certain number of microseconds
@param microseconds - number of microseconds to delay
*/
void ${delayInterface["delayUs"]}(uint16_t microseconds) {
    while( microseconds >= 32)
    {
        ${delay_us}(32);
        microseconds -= 32;
    }
    
    while(microseconds--)
    {
        ${delay_us}(1);
    }
}
