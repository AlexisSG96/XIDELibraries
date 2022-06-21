/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef RN4871_CLICK_H
#define RN4871_CLICK_H

#include <stdint.h>
#include <stdbool.h>

#define RN_BUFF_SIZE 128
extern volatile uint16_t rn_index;
extern volatile uint8_t  rn_buffer[RN_BUFF_SIZE];

void RN4871_Setup(const char *name);
void RN4871_Reset_Module(void);
void RN4871_ClearReceivedMessage(void);
void RN4871_blockingWait(uint16_t limit);
void RN4871_sendAndWait(const char *sendString, const char *response, uint16_t delay);
uint8_t RN4871_CheckResponse(const char *response);

#endif /* RN4871_CLICK_H */