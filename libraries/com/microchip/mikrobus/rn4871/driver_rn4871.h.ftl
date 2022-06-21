/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef DRIVER_RN4871_H
#define DRIVER_RN4871_H

#include <stdint.h>
#include <stdbool.h>

void rn4871_ClearResetPin(void);
void rn4871_SetResetPin(void);
void rn4871_SendString(const char *);
void rn4871_SendBuffer(const char *buffer, uint8_t length);
void rn4871_SendByte(uint8_t byte);

#endif /* DRIVER_RN4871_H */