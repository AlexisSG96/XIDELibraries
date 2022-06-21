/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef PROXIMITY2_H
#define	PROXIMITY2_H

#include <stdint.h>

enum Proximity2_Interrupts {ALS_INT, PROX_INT, NO_INT};

int Proximity2_Read_Interrupt(void);
<#if Proximity2_Mode_Key == "PROX Only" || Proximity2_Mode_Key == "ALS and PROX">
uint8_t Proximity2_Read_Proximity(void);
void Proximity2_Set_Threshold(uint8_t thresh);
</#if>
void Proximity2_Initialize(void);
<#if Proximity2_Mode_Key == "Standard ALS" || Proximity2_Mode_Key == "Green Only" || Proximity2_Mode_Key == "IR Only" || Proximity2_Mode_Key == "ALS and PROX">
uint16_t Proximity2_Read_Als(void);
void Proximity2_Set_Als_Lower_Threshold(uint16_t thresh);
void Proximity2_Set_Als_Upper_Threshold(uint16_t thresh);
</#if>

#endif
