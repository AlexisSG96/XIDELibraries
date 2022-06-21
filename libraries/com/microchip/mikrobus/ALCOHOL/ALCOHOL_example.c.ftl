/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "alcohol.h"

void ALCOHOL_example(void){
    printf("BAC Level = %f (PPM = %f)\r\n", ALCOHOL_GetBACLevel(), ALCOHOL_GetPPM());
}
