/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "compass2.h"

void compass_example(void)
{
    COMPASS2_result_data_t  bearing;
    
    COMPASS2_setSingleMeasurementMode16bit();
            
    // Get and print status
    printf("Status: %02x\r\n", COMPASS2_getStatus());

    // Get the bearing
    COMPASS2_getBearing(&bearing);
    printf("Bearing: X:%d Y:%d Z:%d\r\n", bearing.X,bearing.Y,bearing.Z);

}

