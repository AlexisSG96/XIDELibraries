/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "Ozone_example.h"
#include "Ozone.h"
#include <stdio.h>
    
void Ozone_example(void)
{
    float ozone;
    ozone = Ozone_Read();
    printf("Ozone = %f \n", ozone);
}