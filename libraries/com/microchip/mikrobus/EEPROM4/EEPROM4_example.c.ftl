/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "mcc.h"
#include "EEPROM4_app.h"
#include "EEPROM4_example.h"
#include "device_config.h"

uint8_t     writeBuffer[] = {0x1B, 0x2B, 0x4B, 0x8B} ;
uint8_t     readBuffer[10];
uint8_t     readByte;
 
void EEPROM4_example(void){
   
    //Writes one byte to the address specified
    EEPROM4_WriteByte(0xE4,0x10AB01);

    //Wait for write cycle to complete
    EEPROM4_WritePoll();

    //Reads one byte of data from the address specified
    readByte = EEPROM4_ReadByte(0x10AB01);

    //Intermission
    <#if (isAVR == "true")>
    _delay_ms(10);
    <#else>
    __delay_ms(10);
    </#if>

    //Writes the data in writeBuffer beginning from the address specified
    EEPROM4_WriteBlock(writeBuffer,4,0x10AB02);

    //Wait for write cycle to complete
    EEPROM4_WritePoll();

    //Reads specified number of data bytes into the readBuffer array beginning from the address indicated
    EEPROM4_ReadBlock(readBuffer,4,0x10AB02);
}
