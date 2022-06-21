/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include <stdio.h>
#include "adc3.h"
#include "adc3_example.h"

/**
  Section: Example Code
 */

void  ADC3_Example(void) {
    printf("CH1 Ouput: %u \n\r", ADC3_getConversionCH1());
    printf("CH2 Ouput: %u \n\r", ADC3_getConversionCH2());
    printf("CH3 Ouput: %u \n\r", ADC3_getConversionCH3());
    printf("CH4 Ouput: %u \n\r", ADC3_getConversionCH4());
}
