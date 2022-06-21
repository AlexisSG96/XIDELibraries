/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"

// Write byte 'val' to address 'addr'

void MAX7219_Write(uint8_t addr, uint8_t value) 
{
    uint8_t packet[2];
    packet[0] = addr;
    packet[1] = value;
    uint8_t *pointer = packet;
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }   
    ${spiSSPinSettings["setOutputLevelLow"]} 
    ${SPIFunctions["functionName"]}[${spi_configuration}].writeBlock(pointer, 2);
    ${spiSSPinSettings["setOutputLevelHigh"]} 
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

