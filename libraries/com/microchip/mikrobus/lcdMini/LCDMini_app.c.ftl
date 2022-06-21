 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include <stdbool.h>
#include "expander.h"
#include "digipot.h"
#include "../${DELAYFunctions.delayHeader}"
#include "../${pinHeader}"

void lcd_sendNibble(uint8_t nibble, bool RSbit){
    uint8_t packet = (nibble << 4) | (RSbit << 2);
    expander_setOutput(packet);
    expander_setOutput(packet | (1<<3));
    ${DELAYFunctions.delayMs}(1);
    expander_setOutput(packet);
    ${DELAYFunctions.delayMs}(40);
}

void lcd_sendByte(uint8_t byte, bool RSbit){
    uint8_t nibbleHigh = byte >> 4;
    uint8_t nibbleLow = byte & 0xF;
    uint8_t packetHigh = (nibbleHigh << 4) | (RSbit << 2);
    uint8_t packetLow = (nibbleLow << 4) | (RSbit << 2);
    
    expander_setOutput(packetHigh);
    ${DELAYFunctions.delayMs}(2);
    expander_setOutput(packetHigh | (1<<3));
    ${DELAYFunctions.delayMs}(2);
    expander_setOutput(packetLow);
    ${DELAYFunctions.delayMs}(2);
    expander_setOutput(packetLow | (1<<3));
    ${DELAYFunctions.delayMs}(40);
}

void lcd_returnHome(void){
    lcd_sendByte(0b10, false);
    ${DELAYFunctions.delayMs}(2);
}

void lcd_clearDisplay(void){
    lcd_sendByte(0b1, false);
    ${DELAYFunctions.delayMs}(2);
}

void lcd_setAddr(uint8_t row, uint8_t character){
    lcd_sendByte(0x80 | (character + (row*40)), false);
}

void lcd_writeChar(uint8_t character){
    lcd_sendByte(character, true);
}

void lcd_writeString(uint8_t* string, uint8_t row) {
    lcd_setAddr(row, 0);
    uint8_t i = 0;
    for (i = 0; i < 16; i++) {
        if (string[i]) {
            lcd_writeChar(string[i]);
        }
    }
    lcd_returnHome();
}

void lcd_setContrast(uint8_t contrast){
    digipot_setWiper(contrast);
}

void lcd_setup(){
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${led7SegnCS2PinSetting["setOutputLevelHigh"]}
    ${led7SegnRESETPinSetting["setOutputLevelHigh"]}
    expander_setup();
    expander_setOutput(0);
    ${DELAYFunctions.delayMs}(40);
    lcd_sendNibble(0b11, false);
    ${DELAYFunctions.delayMs}(10);

    lcd_sendNibble(0b11, false);
    ${DELAYFunctions.delayMs}(10);
    lcd_sendNibble(0b11, false);
    ${DELAYFunctions.delayMs}(10);
    lcd_sendNibble(0x2,false);
    lcd_sendByte(0x2C, false);
    lcd_sendByte(0b1100, false);
    lcd_sendByte(0x06, false);
    lcd_sendByte(0x0C, false);
    ${DELAYFunctions.delayMs}(2);
    lcd_returnHome();
    lcd_clearDisplay();
}
