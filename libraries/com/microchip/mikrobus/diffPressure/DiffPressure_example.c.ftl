/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "DiffPressure_example.h"
#include "DiffPressure.h"
#include <stdio.h>
    
void DiffPressure_example(void)
{
    float diffPres;
    diffPressureError_t diffPresError = NO_ERROR;
    diffPresError = DiffPressure_Read(&diffPres);
    if (diffPresError == NO_ERROR)
        printf("Difference in Pressure = %f \n", diffPres);
    else if (diffPresError == OVL)
        printf("Underflow Error\n");
    else if (diffPresError == OVH)
        printf("Overflow Error \n");
}