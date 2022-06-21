/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef __nRFC_H
#define	__nRFC_H

#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
#define RX_DR_MASK 0b01000000
#define TX_DS_MASK 0b00100000
#define MAX_RT_MASK 0b00010000
#define RX_P_NO_MASK 0b00001110
#define TX_FULL_MASK 0b00000001

<#if nRFC_ModeKey == "Receive">
uint8_t Rx_Buffer[32];
uint8_t Rx_Buffer_Source;
uint8_t Rx_Buffer_Size;
</#if>

void Setup_Transmitter();
void Setup_Receiver();
void Retry_Transmit();
uint8_t Download_Rx_Payload();
void Upload_Tx_Payload(uint8_t *payload, uint8_t size);
void Clear_Interrupt(uint8_t mask);
uint8_t Read_Status();

#endif