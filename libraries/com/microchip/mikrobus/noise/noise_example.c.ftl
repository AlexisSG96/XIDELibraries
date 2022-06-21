/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "noise.h"

void NOISE_example(void)
{
    if(NOISE_IsNoisy())
    {
        printf("There is a lot of noise!");
    }
}
