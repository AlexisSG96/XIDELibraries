/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXPAND_H
#define	EXPAND_H

#include <stdint.h>
#include <stdbool.h>

typedef enum {
    IO_DIRA = 0x00,IO_POLA = 0x02,INT_ENA = 0x04,nINT_EDGEA = 0x06,INT_CONA = 0x08,IO_CONA = 0x0A,PULL_UPA = 0x0C,INT_FLAGA = 0x0E,INT_CAPA = 0x10,GPIOA = 0x12,OLATA = 0x14, // GPIOA
    IO_DIRB = 0x01,IO_POLB = 0x03,INT_ENB = 0x05,nINT_EDGEB = 0x07,INT_CONB = 0x09,IO_CONB = 0x0B,PULL_UPB = 0x0D,INT_FLAGB = 0x0F,INT_CAPB = 0x11,GPIOB = 0x13,OLATB = 0x15 // GPIOB   
}EXPAND_GPIO_t;

void EXPAND_Initialize(void);

void EXPAND_SetGPIOA(uint8_t value);
void EXPAND_SetGPIOB(uint8_t value);

uint8_t EXPAND_ReadGPIOA(void);
uint8_t EXPAND_ReadGPIOB(void);

void EXPAND_SetRegister(EXPAND_GPIO_t reg, uint8_t value);
void EXPAND_SetRegisterBits(EXPAND_GPIO_t reg, uint8_t bitNumber);
void EXPAND_ClearRegisterBits(EXPAND_GPIO_t reg, uint8_t bitNumber);

uint8_t EXPAND_ReadRegister(EXPAND_GPIO_t reg);
bool EXPAND_ReadRegisterBits(EXPAND_GPIO_t reg, uint8_t bitNumber);

#endif	/* EXPAND_H */

