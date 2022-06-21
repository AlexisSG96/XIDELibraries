/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "altitude_example.h"
#include "altitude.h"

void altitude_example(void){
    printf("The current altitude is: %d \n", altitude_readAltitude());
    printf("The current temperature is: %d \n", altitude_readTemperature());
}