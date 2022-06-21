/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef LED8X8G_H
#define LED8X8G_H

#include <stdint.h>

void LED8X8G_Row(uint8_t row, uint8_t value);
void LED8X8G_Clear(void);
void LED8X8G_Initialize(void);

#endif