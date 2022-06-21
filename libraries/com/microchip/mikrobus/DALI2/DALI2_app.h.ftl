/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef DALI2_H
#define	DALI2_H

#include <stdint.h>

void DALI2_Initialize(void);
void DALI2_Transmit(uint8_t address, uint8_t data);       
uint16_t DALI2_Receive(void);      

#endif	/* DALI2_H */