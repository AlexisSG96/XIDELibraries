/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "${DELAYFunctions.delayHeader}"
#include "EEPROM2_app.h"

uint8_t		writeBuffer[] = {0x1A, 0x2A, 0x4A, 0x8A};
uint8_t     readBuffer[10];
uint8_t     addressBuffer[] = {0xAB,0x00,0x10}; // Store the address you want to access here
uint8_t     readByte;
 
void EEPROM2_example(void)
{
    //Writes one byte to the address specified
    EEPROM2_WriteByte(0xA5,0x10AB01);

    //Wait for write cycle to complete
    EEPROM2_WritePoll();

    //Reads one byte of data from the address specified
    readByte = EEPROM2_ReadByte(0x10AB01);

    //Intermission
    ${DELAYFunctions.delayMs}(10);

    //Writes the data in writeBuffer beginning from the address specified
    EEPROM2_WriteBlock(writeBuffer,4,0x10AB02);

    //Wait for write cycle to complete
    EEPROM2_WritePoll();

    //Reads specified number of data bytes into the readBuffer array beginning from the address indicated
    EEPROM2_ReadBlock(readBuffer,4,0x10AB02);
}
