/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef CAPTOUCH_DRIVER_H
#define CAPTOUCH_DRIVER_H 

#include <stdint.h>

void CAPTOUCH_Initialize(void); 
void CAPTOUCH_SetFastMode(void);
void CAPTOUCH_SetLowPowerMode(void);
uint8_t CAPTOUCH_GetTouchState(void);

#endif	/* CAPTOUCH_DRIVER_H */

