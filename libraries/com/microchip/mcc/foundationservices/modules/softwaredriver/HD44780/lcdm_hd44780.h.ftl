/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _LCDM_HD44780_H
#define _LCDM_HD44780_H

/**
  Section: Included Files
 */

#include <xc.h>
#include <stdint.h>

/**
  Section: HD44780 LCD Driver APIs
 */

/** Initialize the LCD for use */
void HD44780_Init(void);

/** This function moves the LCD cursor to the specified location
 * param x - cursor position
 * param y - line selection (0,1) */
void HD44780_goto(const uint8_t x, const uint8_t y);

/** Places a character at the current cursor on the LCD
 * param c -   character to write */
void HD44780_putchar(const int8_t c);

/** This function sends character data to the LCD and waits for the LCD to process the data.
 * param *s - pointer to the unsigned char variable
 * param length - total string length being passed*/
void HD44780_putstr(char *s, uint8_t length);

/** This function sends a command to the LCD
 * param  Command - Command to go to the LCD */
void HD44780_putcmd(uint8_t Command);

#endif // _LCDM_HD44780_H
/**
 End of File
*/

