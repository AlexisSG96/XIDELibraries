/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "EMG_example.h"
#include "EMG_driver.h"

#define   EMG_TOP_LIMIT                 0x300  //Dummy value, this has no meaning
#define   EMG_BOTTOM_LIMIT              0xFF   //Dummy value, this has no meaning
/**
 * @brief  This is an Example function for reading EMG data click
 * @param  None
 * @return None
 */
void  EMG_Example(void) 
{
    uint16_t rawEmgData = EMG_GetReading();
    
    if(rawEmgData > EMG_TOP_LIMIT)
    {    
        printf("The EMG result:0x%04X : Above Limit\r\n",rawEmgData);
    }
    else if(rawEmgData < EMG_BOTTOM_LIMIT)
    {    
        printf("The EMG result:0x%04X : Below Limit\r\n",rawEmgData);
    }
    else
    {
        printf("The EMG result:0x%04X : Normal\r\n",rawEmgData);
    }    
}