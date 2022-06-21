/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_RFID_H
#define	EXAMPLE_RFID_H

#include <stdint.h>
#include <stdbool.h>

void RFID_EXAMPLE_Preparation(void);
bool RFID_EXAMPLE_CheckNFCTag(void);
uint8_t* RFID_EXAMPLE_GetTag(void);

#endif	/* EXAMPLE_RFID_H */