/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "MAX7219.h"

#define MAXVAL 7
#define MINVAL 0

// Sends byte 'value' to be displayed on row 'row' (zero indexed)

void LED8X8G_Row(uint8_t row, uint8_t value) 
{
    if (row < MAXVAL + 1) 
    {
        MAX7219_Write(row + 1, value); // First digit is at mem location 0x01 and so on
    }
}

// Run through all rows and set them to zero

void LED8X8G_Clear(void) 
{
    uint8_t i = 0;
    for (i = 0; i < MAXVAL + 1; i++) 
    {
        LED8X8G_Row(i, 0);
    }
}

void LED8X8G_Initialize(void)
{
    MAX7219_Write(MAX7219_SCAN_LIMIT, 0x7); // Use all rows
    MAX7219_Write(MAX7219_SHUTDOWN, 0x1); // Turn on
    LED8X8G_Clear(); // Make sure display is clear
}

