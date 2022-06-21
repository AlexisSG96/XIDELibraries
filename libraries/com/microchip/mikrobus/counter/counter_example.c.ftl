/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "counter.h"

void COUNTER_example(void){
    printf("Counter = %ld \r\n", COUNTER_read());
}
