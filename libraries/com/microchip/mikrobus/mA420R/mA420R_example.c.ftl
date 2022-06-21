/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "mA420R_driver.h"

void mA420R_example(void)
{
    printf("Detected current is %f mA", mA420R_Single());
}

