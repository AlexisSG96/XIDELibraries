/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MIKROE_COMPASS2_CLICK
#define MIKROE_COMPASS2_CLICK

#include <stdint.h>

typedef struct {
    int16_t  X; 
    int16_t  Y; 
    int16_t  Z; 
} COMPASS2_result_data_t; 


uint8_t  COMPASS2_getStatus();
void     COMPASS2_setSingleMeasurementMode16bit();
void     COMPASS2_getBearing(COMPASS2_result_data_t*  bearing);
uint8_t  COMPASS2_getDeviceId(void);

#endif
