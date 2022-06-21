/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "ADC2_example.h"
#include "ADC2.h"

void ADC2_example(void){
    printf("The ADC result is: %lu \n", ADC2_GetConversion_Result());
}
