/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "current_example.h"
#include "current.h"

void Current_example(void){
    printf("The current is: %ld mA \n", Current_Get_mAResult());
}
