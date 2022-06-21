/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "gyro.h"

void Gyro_Example(void)
{
    printf("X = %d", Gyro_ReadX());
    printf("Y = %d", Gyro_ReadY());
    printf("Z = %d", Gyro_ReadZ());
}
