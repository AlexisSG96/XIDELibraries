/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "CAPTOUCH_example.h"
#include "CAPTOUCH_driver.h"

/**
 * @brief  This is an example function for reading touch State
 * @param  None
 * @return [Out]: Touch state of CAP TOUCH click.
 */
void CAPTOUCH_Example(void)
{
    if(CAPTOUCH_GetTouchState())
    {    
        //Note: Add and configure EUART module for printf
        printf("CAP TOUCH STATE: Detected\r\n");
    }
    else
    {
        printf("CAP TOUCH STATE: Not detected\r\n");
    }
}    