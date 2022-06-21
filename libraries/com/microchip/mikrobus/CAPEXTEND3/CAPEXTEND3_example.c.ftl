/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdio.h>
#include "CAPEXTEND3_example.h"
#include "CAPEXTEND3_driver.h"

/**
 * @brief  This is an example function for CAP ECTEND3 click
 * @param  None
 * @return None
 */
void CAPEXTEND3_Example(void)
{
    //Touch 2 is common touch indication for all keys
    if(CAPEXTEND3_GetTouch2())
    {
        if(CAPEXTEND3_GetTouch0())
        {
            printf("Touch 0 is detected\r\n");
        }
        if(CAPEXTEND3_GetTouch1())
        {
            printf("Touch 1 is detected\r\n");
        }
        if(CAPEXTEND3_GetTouch3())
        {
            printf("Touch 3 is detected\r\n");
        }
        if(CAPEXTEND3_GetTouch4())
        {
            printf("Touch 4 is detected\r\n");
        }
    }
}