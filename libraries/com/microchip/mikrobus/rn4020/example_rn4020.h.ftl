/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_RN4020_USE_H
#define	EXAMPLE_RN4020_USE_H

#include <stdint.h>
#include <stdbool.h>

void EXAMPLE_setupBLE2(const char* name) ;
void EXAMPLE_sendMessageOverBLE2(const char* message);
void EXAMPLE_sendBufferOverBLE2(uint8_t *buffer, uint8_t len);
void EXAMPLE_CaptureReceivedMessage(void);


#endif	/* EXAMPLE_RN4020_USE_H */
