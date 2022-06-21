/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   UTILITY_MyString.c
 */
#include <stdint.h>
#include <string.h>
#include "SOFTWARE_Uart.h"

//********************************************
// Local Defines 
//********************************************
#define ESC   0x1B

//********************************************
// Local (static) Prototype Function 
//********************************************
static char* VT100_uitoa (uint8_t);

//********************************************
// Actions Functions
//********************************************
void VT100_ClearScreen(void)
{
    SOFTWARE_UartPutChar (ESC);//escape
    SOFTWARE_UartPutString ("[2J");  // clear screen
}
void VT100_HomeCursor(void)
{
    SOFTWARE_UartPutChar (ESC);//escape
    SOFTWARE_UartPutString ("[H");
}
void VT100_ClearToEOL(void)
{
    SOFTWARE_UartPutChar (ESC);
    SOFTWARE_UartPutString ("[K");
}
void VT100_SetCursorRC(uint8_t  row, uint8_t col)
{   // Row 1 is the top row | Column 1 is the first position
    SOFTWARE_UartPutChar (ESC);
    SOFTWARE_UartPutChar ('[');
    SOFTWARE_UartPutString (VT100_uitoa (row));
    SOFTWARE_UartPutChar (';');
    SOFTWARE_UartPutString (VT100_uitoa (col));
    SOFTWARE_UartPutChar ('H');
}
//********************************************
// Local String Conversion Function
//********************************************
static char* VT100_uitoa (uint8_t  x)
{
    static  char string [4];
    uint8_t  digit;
    uint8_t  cp = 0;
    
    if (x > 99)
    {
        digit = x / 100;
        string [cp ++] = '0' + digit;
        x -= digit * 100;
    }
    digit = x / 10;
    if ((digit > 0) || (cp > 0))
    {
        string [cp ++] = '0' + digit;
        x %= 10;
    }
    string [cp ++] = '0' + x;
    string [cp] = NULL;
    return (string);
}
/**
 End of File
*/