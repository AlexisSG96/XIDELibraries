/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   SOFTWARE_Uart.c
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "SOFTWARE_Uart.h"
#include "mcc.h"   // Required for XTAL_FREQ definition

//********************************************
// Software Emulation UART Uni-directional Tx 
//********************************************
void SOFTWARE_UartInitialize(void)
{
    ${exampleTxPin["setOutputLevelHigh"]};
    ${exampleTxPin["setOutput"]};
    ${exampleTxPin["setOutputLevelHigh"]};
}
void SOFTWARE_UartPutString (const char *string)
{
    uint8_t  cp = 0;

     while (string[cp] != (char) 0)
    {
        SOFTWARE_UartPutChar (string[cp]);
        ++cp;
    }
}
void SOFTWARE_UartPutChar (uint8_t  ch)
{
    uint8_t  i;
    uint8_t  SaveINTCON;
    
    SaveINTCON = INTCON;
    GIE = 0;
    ${exampleTxPin_LAT} = 0;
    <#if (isAVR == "true")>
	_delay_us(15);		// 1-bit length
	<#else>
	__delay_us(15);		// 1-bit length
	</#if>
    NOP();NOP();NOP();NOP();NOP();NOP();
  	
    for (i = 0; i < 8; i++)
    {
    	${exampleTxPin_LAT} = (ch & 0x01);
    	ch >>= 1;
        <#if (isAVR == "true")>
		_delay_us(15);		// 1-bit length
		<#else>
		__delay_us(15);		// 1-bit length
		</#if>
    }

    NOP();NOP();NOP();NOP();NOP();NOP();NOP();NOP();
    ${exampleTxPin_LAT} = 1;

    if (SaveINTCON & 0x80)
        GIE = 1;
    
    <#if (isAVR == "true")>
	_delay_us(15);		// 1-bit length
	<#else>
	__delay_us(15);		// 1-bit length
	</#if>             
}
void SOFTWARE_UartFormateUI8ToStr (uint8_t x, char string[])
{   //  Converts a 16 bit unsigned int to a null terminated character String. 
    uint8_t y;
    uint8_t digit = 0;
    uint8_t  cp = 0;

    digit = x / 100U;
    y = digit * 100U;
    x -= y;
    if (digit != 0)
        string [cp++] = (char)((uint8_t)'0' + digit);

    digit = x / 10U;
    y = digit * 10U;
    x -= y;

    string [cp++] = (unsigned int)'0' + digit;
    string [cp++] = (unsigned int)'0' + x;
    string [cp] = 0;
}    
void SOFTWARE_UartFormateHdgToSt(uint16_t x, char string[])
{   // Converts a 16 bit unsigned int to a null terminated character String.
    uint16_t y;
    uint16_t base = 100;
    uint8_t  digit = 0;
    uint8_t  LeadingZero = false; //  disable leading zero supression...  true;
    uint8_t  cp = 0;
    uint8_t  i;
    
    for (i = 0; i < 2; i++)
    {
        digit = x / base;
        y = digit * base;
        x -= y;

        if ((digit > 0) || (LeadingZero == false))
        {
            string [cp] = (unsigned int)'0' + digit;
            ++cp;
            LeadingZero = false;
        }
            
        base /= 10;
    }
    string [cp++] = (unsigned int)'0' + x;
    string [cp] = 0;    
}   
/**
 End of File
*/