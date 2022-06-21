/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "RGB4x4.h"

static RGB4x4_t LEDS[16] = 
{
    {0, 50, 50}, {0, 50, 50}, {0, 50, 50}, {0, 50, 50},
    {0, 50, 50}, {0, 50, 50}, {0, 50, 50}, {0, 50, 50},
    {0, 50, 50}, {0, 50, 50}, {0, 50, 50}, {0, 50, 50},
    {0, 50, 50}, {0, 50, 50}, {0, 50, 50}, {0, 50, 50},
};

void RGB4x4_Example_Basic(void) 
{
    RGB4x4_SetBuffer(LEDS, 16);
    RGB4x4_Update();
}
