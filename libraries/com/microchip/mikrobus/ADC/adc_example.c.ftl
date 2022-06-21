/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include <stdio.h>
#include "adc_click.h"

/**
  Section: Example Code
 */

void  ADC_example(void) {
    printf("The CH0 conversion result is: %u \n\r", ADC_CLICK_getConversionCH0());
}
