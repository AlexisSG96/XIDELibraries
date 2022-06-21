/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "mcc.h"
#include "EEPROM_app.h"
#include "EEPROM_example.h"

volatile  EEPROM_ADDRESS_t targetAddress = 0xAA;
volatile  EEPROM_ADDRESS_t initialAddress = 0x12;
volatile  uint8_t storeData = 0x55;
volatile  uint8_t blockWrite[] = {0,2,3,4,5,6,7,8};
volatile  uint8_t blockRead[12];
volatile  uint8_t blockStore[8];
volatile  uint8_t dataVal;

void EEPROM_example(void){
    
    EEPROM_WriteByte(targetAddress, storeData);   
    
    <#if (isAVR == "true")>
	_delay_ms(10);
	<#else>
	__delay_ms(10);
	</#if>
    
    dataVal = EEPROM_ReadByte(targetAddress);
    
    <#if (isAVR == "true")>
	_delay_ms(10);
	<#else>
	__delay_ms(10);
	</#if>
    
    EEPROM_WriteBlock(initialAddress,&blockWrite,8);
    
     <#if (isAVR == "true")>
	 _delay_ms(10);
	 <#else>
	 __delay_ms(10);
	 </#if>
    
    EEPROM_ReadBlock(initialAddress,&blockStore,8);
    
}

