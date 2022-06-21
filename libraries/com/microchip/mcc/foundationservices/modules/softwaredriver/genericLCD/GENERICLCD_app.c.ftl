/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "generic_lcd.h"
#include "LCD Drivers/${header}"

/**
  Section: Driver APIs
 */ 

void glcd_Init(void) {
    ${Init}();
}

void glcd_goto(const uint8_t x, const uint8_t y) {
    ${goto}(x, y);
}

void glcd_putchar(const int8_t c) {
    ${putchar}(c);
}

void glcd_putstr(char *s, uint8_t length) {
    ${putstr}(s, length);
}

void glcd_putcmd(uint8_t Command) {
    ${putcmd}(Command);
}

/**
 End of File
 */ 
