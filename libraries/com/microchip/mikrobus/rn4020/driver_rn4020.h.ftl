/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BLE2_DRIVER_H
#define	BLE2_DRIVER_H

#include <stdint.h>
#include <stdbool.h>
#include "${DELAYFunctions.delayHeader}"

<#if (rn4020_CmdMldpPinKey != "")>
void BLE2_EnterCommand_Mode(void);
void BLE2_ExitCommand_Mode(void);
void BLE2_EnterMicrochipLowEnergyDataProfile_Mode(void);
</#if>
<#if (rn4020_WakePinKey != "")>
void BLE2_WakeModule(void);
void BLE2_DeepSleepModule(void);
</#if>
<#if (rn4020_ConnPinKey != "")>
bool BLE2_isConnected(void);
</#if>
void BLE2_SendString(const char*);
void BLE2_SendBuffer(uint8_t *buffer, uint8_t length);
void BLE2_SendByte(uint8_t byte);

#endif	/* BLE2_DRIVER_H */