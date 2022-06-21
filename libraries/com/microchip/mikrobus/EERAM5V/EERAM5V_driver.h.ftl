/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EERAM5V_DRIVER_H
#define EERAM5V_DRIVER_H 

#include <stdint.h>
#include "drivers/I2C_functions.h"

void EERAM5V_Initialize(void);
void EERAM5V_WriteSram(EERAM5V_ADDRESS_t regAddress, uint8_t* wrDataBlock,uint8_t length);
void EERAM5V_ReadSram(EERAM5V_ADDRESS_t regAddress, uint8_t* rdDataBlock,uint8_t length);
void EERAM5V_WriteCtlReg(EERAM5V_CMD_MODE_ADDRESS_t regAddress, uint8_t value);
uint8_t EERAM5V_ReadCtlReg(EERAM5V_CMD_MODE_ADDRESS_t regAddress);
void EERAM5V_HwStore(void);
void EERAM5V_CmdStore(void);
void EERAM5V_PowerDownStore(void);
void EERAM5V_CmdRecall(void);

#endif	/* EERAM5V_DRIVER_H */