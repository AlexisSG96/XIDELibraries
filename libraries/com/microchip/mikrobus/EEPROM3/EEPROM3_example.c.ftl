/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "mcc.h"
#include "EEPROM3_example.h"
#include "EEPROM3_driver.h"

void EEPROM3_example(void){
    
    EEPROM3_WriteOneByte(0xAA, 0x55);
    
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    
    volatile uint8_t dataVal = EEPROM3_ReadOneByte(0xAA);
    
}