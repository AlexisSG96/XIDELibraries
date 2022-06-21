/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef __ALTITUDE_CLICK_H
#define __ALTITUDE_CLICK_H

#include <stdint.h>

int16_t altitude_readAltitude(void);
int8_t altitude_readTemperature(void);
void altitude_shutdown(void);

#endif // __ALTITUDE_CLICK_H
