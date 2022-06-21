 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LCDMiniDrivers/lcd.h"
#include <stdint.h>

void lcd_example(void) {
    lcd_setContrast(0x20);
    while (1) {
        uint8_t row0_disp[16] = "<*   HELLO    *>";
        lcd_writeString(row0_disp, 0);
        uint8_t row1_disp[16] = "<*   WORLD    *>";
        lcd_writeString(row1_disp, 1);
    }
}
/**
 End of File
 */
