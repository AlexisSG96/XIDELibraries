/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "TOUCHKEY4_example.h"
#include "TOUCHKEY4_driver.h"

#define BUTTON1_BIT_POSITION         0
#define BUTTON2_BIT_POSITION         1
#define BUTTON3_BIT_POSITION         2

/**
* @brief  This is an example function for TOUCHKEY4 click.
* @param  None
* @return None
*/

void TOUCHKEY4_Example(void)
{
	uint8_t touchState =0x00, buttonState =0x00;
    touchState = TOUCHKEY4_GetTouchState();
	touchState = touchState & 0x01;
	if (touchState) 
    {
        buttonState = TOUCHKEY4_GetButtonState();
        if((buttonState & (1 << BUTTON1_BIT_POSITION)))
        {
            printf("TOUCHKEY4: Button 1 is detected\r\n");
        }
        if((buttonState & (1 << BUTTON2_BIT_POSITION)))
        {
            printf("TOUCHKEY4: Button 2 is detected\r\n");
        }        
        if((buttonState & (1 << BUTTON3_BIT_POSITION)))
        {
            printf("TOUCHKEY4: Button 3 is detected\r\n");
        }		
	}
}
