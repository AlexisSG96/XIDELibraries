/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "touchpad.h"

void TOUCHPAD_example(void)
{
    uint8_t x_axis = 0;
    uint8_t y_axis = 0;

    uint8_t touch_state = 0;

    touch_state = TOUCHPAD_getTouchState();
    touch_state = touch_state & 0x01;
    if(touch_state)
    {
        x_axis = TOUCHPAD_getX();
        y_axis = TOUCHPAD_getY();
        printf("X- Axis = %d  ", x_axis);
        printf("Y-Axis = %d\r\n  ", y_axis);  
    }  
}
