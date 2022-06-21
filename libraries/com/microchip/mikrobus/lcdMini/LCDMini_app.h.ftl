 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef LCD_H
#define	LCD_H

#include <stdint.h>

void lcd_setup(void);
void lcd_returnHome(void);
void lcd_clearDisplay(void);
void lcd_writeChar(uint8_t character);
void lcd_writeString(uint8_t* string, uint8_t row);
void lcd_setContrast(uint8_t contrast);
void lcd_setAddr(uint8_t row, uint8_t character);

#endif
