/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "ACCEL3.h"
    
void ACCEL3_example(void)
{
    printf("\rX = %5d \tY = %5d \tZ = %5d ", ACCEL3_ReadX(), ACCEL3_ReadY(), ACCEL3_ReadZ());
}
