/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef WIFLY_EXAMPLE_H
#define	WIFLY_EXAMPLE_H

// Run this first
void WiFly_Example_InitializeAsClient(const char* ssid, const char* password);

// Then this (port is 1337)
void WiFly_Example_Connect(const char* addr, const char* port);

// Then this
void WiFly_Example_SendMessages(void);

#endif


