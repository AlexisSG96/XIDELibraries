/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef IrDA2_DRIVER_H
#define IrDA2_DRIVER_H 

#include <stdint.h>
#include <stdbool.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

typedef enum
{
    BAUDRATE_9600 = 0,
    BAUDRATE_19200,
    BAUDRATE_38400,
    BAUDRATE_57600,
    BAUDRATE_115200

} IrDA2_BaudRate_t;

void IrDA2_Initialize(void);
void IrDA2_SetEnableState(bool state);
void IrDA2_SetnResetState(bool state);
void IrDA2_SendData(const uint8_t data);
uint8_t IrDA2_ReceiveData(void);
void IrDA2_ConfigBaudRate(IrDA2_BaudRate_t baudRate);

#endif	/* IrDA2_DRIVER_H */