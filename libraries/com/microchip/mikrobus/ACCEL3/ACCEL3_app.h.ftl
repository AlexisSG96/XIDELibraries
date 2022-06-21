/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ACCEL3_H
#define	ACCEL3_H

#include <stdint.h>

void ACCEL3_Initialize(void);

int16_t ACCEL3_ReadX(void);
int16_t ACCEL3_ReadY(void);
int16_t ACCEL3_ReadZ(void);

#endif
