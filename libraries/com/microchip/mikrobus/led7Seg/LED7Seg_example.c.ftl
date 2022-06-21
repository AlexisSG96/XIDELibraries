 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LED7Seg.h"
#include "${DELAYFunctions.delayHeader}"

static const uint8_t Digits[10]=
{
    0xFC, // '0'  
    0x60, // '1' 
    0xDA, // '2' 
    0xF2, // '3' 
    0x66, // '4' 
    0xB6, // '5' 
    0xBE, // '6'
    0xE0, // '7'
    0xFE, // '8'
    0xE6  // '9'  
};

void LED7Seg_Example(void) 
{
    int tens = 0;
    int ones = 0;

    for(tens = 0; tens < 10; tens++)
    {
        for(ones = 0; ones < 10; ones++)
        {
            LED7seg_Write(Digits[tens], Digits[ones]);
            ${DELAYFunctions.delayMs}(1000);
        }
    }

}