/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_WIFI3_H
#define	EXAMPLE_WIFI3_H

#include <stdint.h>
<#if (isAVR == "true")>
#include "config/clock_config.h"
#include <util/delay.h>
</#if>

#define WIFI3_MAX_PACKET_SIZE 64

uint8_t wifi3LastSender;

// Call After System Init; Above while(1) Loop in Main.c
void EXAMPLE_startupWiFi3(void);

// Call within while(1) loop in Main.c  
char* EXAMPLE_runningWiFi3(void);

// Call in ISR EUSART RX after EUSART_Receive_ISR()
void EXAMPLE_CaptureReceivedMessage(void);

// Call within while(1) loop in Main.c 
void EXAMPLE_transmitWiFi3(uint8_t channel, uint8_t length, char* string);

// This will run standalone and call all necessary functions
// Provided interrupts are enabled
void EXAMPLE_fullWiFi3(void);

#endif	/* EXAMPLE_WIFI3_H */

