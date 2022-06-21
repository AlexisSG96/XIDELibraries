 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#define DEEP_SLEEP_MODE 0x10
#define DATA_ENTRY_MODE 0x11
#define MASTER_ACTIVATION 0x20
#define DISPLAY_UPDATE_1 0x21
#define DISPLAY_UPDATE_2 0x22
#define WRITE_RAM 0x24
#define WRITE_VCOM_REGISTER 0x2C
#define WRITE_LUT_REGISTER 0x32
#define BORDER_WAVEFORM 0x3C
#define SET_RAM_X 0x44
#define SET_RAM_X_ADDRESS_COUNTER 0x4E
#define SET_RAM_Y_ADDRESS_COUNTER 0x4F
#define BOOSTER_FEEDBACK_SELECTION 0xF0
#define NO_OPERATION 0xFF

#include "../mcc.h"
#include "eInk.h"
#include "../${SPIFunctions["spiHeader"]}"


const unsigned char lut_data[] = {0x82, 0x00, 0x00, 0x00, 0xAA, 0x00, 0x00, 0x00, 0xAA,
    0xAA, 0x00, 0x00, 0xAA, 0xAA, 0xAA, 0x00, 0x55, 0xAA,
    0xAA, 0x00, 0x55, 0x55, 0x55, 0x55, 0xAA, 0xAA, 0xAA,
    0xAA, 0x55, 0x55, 0x55, 0x55, 0xAA, 0xAA, 0xAA, 0xAA,
    0x15, 0x15, 0x15, 0x15, 0x05, 0x05, 0x05, 0x05, 0x01,
    0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x41,
    0x45, 0xF1, 0xFF, 0x5F, 0x55, 0x01, 0x00, 0x00, 0x00};

void eInk_spiOut(unsigned char data) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    ${SPIFunctions["exchangeByte"]}(data);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
}

void eInk_writeCmd(char data) {
    eInk_DC_LAT = 0;
    eInk_spiOut(data);
}

void eInk_writeData(char data) {
    eInk_DC_LAT = 1;
    eInk_spiOut(data);
}

void eInk_writeByte(uint8_t reg, uint8_t data) {
    eInk_writeCmd(reg);
    eInk_writeData(data);
}

void eInk_startDisplayWrite(void) {
    eInk_writeCmd(WRITE_RAM);
}

void eInk_displayWrite(uint8_t pixel1, uint8_t pixel2, uint8_t pixel3, uint8_t pixel4) {
    uint8_t packet = (pixel1) + (pixel2 << 2) + (pixel3 << 4) + (pixel4 << 6);
    eInk_writeData(packet);
}

void eInk_stopDisplayWrite(void) {
    eInk_writeCmd(MASTER_ACTIVATION);
    eInk_writeByte(DISPLAY_UPDATE_1, 0x02);
    eInk_writeCmd(MASTER_ACTIVATION);
    eInk_writeCmd(NO_OPERATION);
}

void eInk_setup(void) {
    unsigned char i;
    ${SPIFunctions["spiOpen"]}(eInk);
    eInk_RST_LAT = 1;
    <#if (isAVR == "true")>
    _delay_ms(1);
	<#else>
    __delay_ms(1);
	</#if>
    eInk_RST_LAT = 0;
    <#if (isAVR == "true")>
    _delay_ms(2);
    <#else>
    __delay_ms(2);
    </#if>
    eInk_RST_LAT = 1;
    <#if (isAVR == "true")>
    _delay_ms(3);
    <#else>
    __delay_ms(3);
    </#if>
    eInk_writeByte(DEEP_SLEEP_MODE, 0x00); // Don't sleep
    eInk_writeByte(DATA_ENTRY_MODE, 0x01); // Y decrement, x increment
    eInk_writeCmd(SET_RAM_X);
    eInk_writeData(0x00);
    eInk_writeData(0x11);
    eInk_writeData(0xAB);
    eInk_writeData(0x00);
    eInk_writeByte(SET_RAM_X_ADDRESS_COUNTER, 0x00); // X starts at zero
    eInk_writeByte(SET_RAM_Y_ADDRESS_COUNTER, 0xAB); // Y starts at AB
    eInk_writeByte(BOOSTER_FEEDBACK_SELECTION, 0x1F); // Internal feedback
    eInk_writeByte(DISPLAY_UPDATE_1, 0x03);
    eInk_writeByte(WRITE_VCOM_REGISTER, 0xA0);
    eInk_writeByte(BORDER_WAVEFORM, 0x63);
    eInk_writeByte(DISPLAY_UPDATE_2, 0xC4);
    eInk_writeCmd(WRITE_LUT_REGISTER); //write LUT register
    for (i = 0; i < 90; i++)
        eInk_writeData(lut_data[i]);
}
