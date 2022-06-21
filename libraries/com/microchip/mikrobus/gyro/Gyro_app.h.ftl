/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef GYRO_H
#define GYRO_H

#include <stdint.h>

uint16_t Gyro_ReadX(void);
uint16_t Gyro_ReadY(void);
uint16_t Gyro_ReadZ(void);
void Gyro_Shutdown(void);

#endif // GYRO_H
