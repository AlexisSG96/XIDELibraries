/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BT_H
#define	BT_H

#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

const char softRebootStr[] = "Reboot!\r\n";
const char nullStr[] = "";
const char cmdStr[] = "CMD\r\n";
const char aokStr[] = "AOK\r\n";
bool BT_IsMessage;

void BT_Reboot(void);
void BT_Setup(const char* name);
char BT_ReadByte(void);
void BT_SendData(const char * data, size_t length);
void BT_SendByte(uint8_t byte);

void BT_Enable7BitData(bool enable);
void BT_SetAuthentication(uint8_t authentication);
void BT_SetBreak(uint8_t breakVal);
void BT_SetServiceClass(uint16_t class);
void BT_SetDeviceClass(uint16_t class);
void BT_SetUUID(const char * UUID);
void BT_UseDefaultUUID(void);
void BT_UseiPhoneUUID(void);
void BT_UseCustomUUID(void);
void BT_RestoreFactoryDefaults(void);
void BT_SetHidFlag(uint16_t flag);
void BT_SetInquiryScanWindow(uint16_t window);
void BT_SetPageScanWindow(uint16_t window);
void BT_SetParity(char parity);
void BT_SetMode(uint8_t mode);
void BT_SetName(const char * name, size_t length);
void BT_SetStatusString(const char * name, size_t length);
void BT_SetPinCode(const char * code, size_t length);
void BT_SetSpecialConfig(uint16_t config);
void BT_SetRemote(const char * remote);
void BT_EraseRemote(void);
void BT_UseLastObservedRemote(void);
void BT_SetRemoteConfigTimer(uint8_t timer);
void BT_SetLowPowerSniff(uint16_t time);
void BT_EnableBonding(bool enable);
void BT_SetPower(uint16_t power);
void BT_SetProfile(uint8_t profile);
void BT_SetSerializedName(const char * name, size_t length);
void BT_EnableRoleSwitch(bool enable);
void BT_SetLowerPowerTimer(uint8_t onTime, uint8_t offTime);
void BT_KillConnection(void);

void BT_GetSettings(void);
void BT_GetExtendedSettings(void);
void BT_GetAddr(void);
void BT_GetConnectedAddr(void);
void BT_GetConnectionStatus(void);
void BT_GetRemoteAddr(void);
void BT_InquiryScan(uint8_t time, const char * COD);
void BT_PairingDevicesScan(void);
void BT_GetLinkQuality(void);
void BT_GetRemoteModemStatus(void);

void BT_blockingWait(uint16_t limit);
void BT_ClearReceivedMessage(void);
void BT_Reset_Module(void);
uint8_t BT_CheckResponse(const char *response);

#endif
