/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MCP25625_APP_H
#define	MCP25625_APP_H

#include <stdbool.h>
#include <stdint.h>

typedef union {
    struct {
        uint8_t idType;
        uint32_t id;
        uint8_t dlc;
        uint8_t data0;
        uint8_t data1;
        uint8_t data2;
        uint8_t data3;
        uint8_t data4;
        uint8_t data5;
        uint8_t data6;
        uint8_t data7;
    } frame;
    uint8_t array[14];
} uCAN_MSG;

#define dSTANDARD_CAN_MSG_ID_2_0B 1
#define dEXTENDED_CAN_MSG_ID_2_0B 2

void MCP25625_Initialize(void);
void MCP25625_Sleep(void);
uint8_t MCP25625_CANTransmit(uCAN_MSG *tempCanMsg);
uint8_t MCP25625_CANReceive(uCAN_MSG *tempCanMsg);
uint8_t MCP25625_messagesInBuffer(void);
uint8_t MCP25625_isBussOff(void);
uint8_t MCP25625_isRxErrorPassive(void);
uint8_t MCP25625_isTxErrorPassive(void);

#endif	/* MCP25625_APP_H */
