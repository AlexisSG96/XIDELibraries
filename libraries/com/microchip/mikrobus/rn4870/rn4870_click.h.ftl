/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RN4870_CLICK_H
#define RN4870_CLICK_H

#include <stdint.h>
#include <stdbool.h>

void RN4870_ClearResetPin(void);
void RN4870_SetResetPin(void);
void RN4870_InitLED_Set(bool level);
void RN4870_SendString(const char *);
void RN4870_SendBuffer(const char *buffer, uint8_t length);
void RN4870_SendByte(uint8_t byte);
void RN4870_Setup(const char *name);
void RN4870_Reset_Module(void);
void RN4870_ClearReceivedMessage(void);
void RN4870_ReadReceivedMessage(char *buff, uint16_t len);
void RN4870_blockingWait(uint16_t limit);
void RN4870_sendAndWait(const char *sendString, const char *response, uint16_t delay);
uint8_t RN4870_CheckResponse(const char *response);

#endif /* RN4870_CLICK_H */