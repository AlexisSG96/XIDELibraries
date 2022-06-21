/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EERAM3V3_DRIVER_H
#define EERAM3V3_DRIVER_H 

#include <stdint.h>
#include "drivers/I2C_functions.h"
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

void EERAM3V3_Initialize(void);
void EERAM3V3_WriteSram(EERAM3V3_ADDRESS_t regAddress, uint8_t* wrDataBlock,uint8_t length);
void EERAM3V3_ReadSram(EERAM3V3_ADDRESS_t regAddress, uint8_t* rdDataBlock,uint8_t length);
void EERAM3V3_WriteCtlReg(EERAM3V3_CMD_MODE_ADDRESS_t regAddress, uint8_t value);
uint8_t EERAM3V3_ReadCtlReg(EERAM3V3_CMD_MODE_ADDRESS_t regAddress);
void EERAM3V3_HwStore(void);
void EERAM3V3_CmdStore(void);
void EERAM3V3_PowerDownStore(void);
void EERAM3V3_CmdRecall(void);

#endif	/* EERAM3V3_DRIVER_H */