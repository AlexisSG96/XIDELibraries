/*
<#include "MicrochipDisclaimer.ftl">
*/


#ifndef TOUCHKEY4_DRIVER_H
#define TOUCHKEY4_DRIVER_H

#include <stdint.h>

void TOUCHKEY4_Initialize(void);
uint8_t TOUCHKEY4_GetButtonState(void);
uint8_t TOUCHKEY4_GetTouchState(void);

#endif /* TOUCHKEY4_DRIVER_H */