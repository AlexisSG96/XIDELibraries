/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "LEDFlash2.h"
#include "LEDFlash2_example.h"

/**
  Section: Example 
 */

void LEDFlash2_example(void){
    LEDFlash2_setBrightness(p100);
    LEDFlash2_setFlashTimer(ms780);
    LEDFlash2_setMode(Torch);
}
