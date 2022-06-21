/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "expand.h"

void EXPAND_example(void)
{
    static uint8_t sendVal = 0x55;
    
    EXPAND_SetRegister(IO_DIRA, 0x00);  //Set to outputs
    EXPAND_SetRegister(IO_DIRB, 0x00);  //Set to outputs
    
    EXPAND_SetGPIOA(sendVal);
    EXPAND_SetGPIOB(~sendVal);
    sendVal = ~sendVal;
    
    printf("PortA = 0x%2x\tPORTB = 0x%2x\r\n", EXPAND_ReadGPIOA(), EXPAND_ReadGPIOB());
}
