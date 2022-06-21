/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _GENERIC_LCD_H
#define _GENERIC_LCD_H

/**
  Section: Included Files
 */

#include <xc.h>
#include <stdint.h>

/**
  Section: LCD Driver APIs
 */  

void glcd_Init(void);
void glcd_goto(const uint8_t x, const uint8_t y);
void glcd_putchar(const int8_t c);
void glcd_putstr(char *s, uint8_t length);
void glcd_putcmd(uint8_t Command);

#endif // _GENERIC_LCD_H
/**
 End of File
*/

