/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "EXPAND2.h"
#include "EXPAND2_example.h"

void EXPAND2_example(void) {
    uint8_t sendVal = 0xAA;
    uint8_t GPIOA, GPIOB;
    
    EXPAND2_SetDirectionGPIOA(0x00);  //Set to outputs
    EXPAND2_SetDirectionGPIOB(0x00);  //Set to outputs
    
    EXPAND2_SetGPIOA(sendVal);
    EXPAND2_SetGPIOB(~sendVal);
    
    GPIOA = EXPAND2_ReadGPIOA();
    GPIOB = EXPAND2_ReadGPIOB();
    
    printf("PortA = 0x%2x\tPORTB = 0x%2x\r\n", EXPAND2_ReadGPIOA(), EXPAND2_ReadGPIOB());
}