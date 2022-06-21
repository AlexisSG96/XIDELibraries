#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"
#include "digipot.h"

// Registers          3210xxxx
#define TCON_REG   0b01000000U
#define STATUS_REG  0b01010000U

// Commands           xxxx21xx
#define WRITE       0b00000000U
#define READ        0b00001100U
#define INCREMENT   0b00000100U
#define DECREMENT   0b00001000U
#define WL_EN       DECREMENT
#define WL_DIS      INCREMENT

uint16_t MCP4161_read(uint8_t addr);
void MCP4161_write(uint8_t addr, uint16_t val);
uint8_t MCP4161_isEEPROMWriteDone();
uint8_t MCP4161_send8BitCommand(uint8_t command);
uint16_t MCP4161_send16BitCommand(uint16_t command);

typedef struct {
    uint8_t V;
    uint8_t NV;
} MCP4161_wiper_t;


static MCP4161_wiper_t channels[1] = {
    //     8421xxxx    8421xxxx
    {0b00000000, 0b00100000} // Wiper 0
};

static MCP4161_wiper_t *activeChannel = channels;

void DIGIPOT_setChannel(uint8_t channel) {
    if (channel < 1) {
        activeChannel = channels + channel;
    }
}

void DIGIPOT_set(uint16_t val) {
    MCP4161_write(activeChannel->V, val); // Right justified input
    //    MCP4161_write(activeChannel->V, val << 7; // Left justified input
}

uint16_t DIGIPOT_get(void) {
    return MCP4161_read(activeChannel->V); // Right justified output
    //    return MCP4161_read(activeChannel->V) << 7; // Left justified output
}

void DIGIPOT_save(void) {
    while (!MCP4161_isEEPROMWriteDone());
    MCP4161_write(activeChannel->NV, MCP4161_read(activeChannel->V));
}

void DIGIPOT_load(void) {
    MCP4161_write(activeChannel->V, MCP4161_read(activeChannel->NV));
}

void DIGIPOT_lock(void) {
    // Apply high voltage (V_IHH = 8.5 to 12.5 V) on chip select pin first
    MCP4161_send8BitCommand(activeChannel->NV | WL_EN);
}

void DIGIPOT_unlock(void) {
    // Apply high voltage (V_IHH = 8.5 to 12.5 V) on chip select pin first
    MCP4161_send8BitCommand(activeChannel->NV | WL_DIS);
}

uint16_t MCP4161_read(uint8_t addr) {
    return MCP4161_send16BitCommand((addr | READ) << 8) & 0x01FF;
}

void MCP4161_write(uint8_t addr, uint16_t val) {
    MCP4161_send16BitCommand(((addr | WRITE) << 8) | val);
}

uint8_t MCP4161_isEEPROMWriteDone() {
    return !(MCP4161_read(STATUS_REG) & 0x10);
}

uint16_t MCP4161_send16BitCommand(uint16_t command) {
    uint16_t readVal;

    while (!${SPIFunctions["spiOpen"]}(MCP73213_CLICK));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    readVal = ${SPIFunctions["exchangeByte"]}(command >> 8);
    readVal <<= 8;
    readVal |= ${SPIFunctions["exchangeByte"]}(command);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();

    return readVal;
}

uint8_t MCP4161_send8BitCommand(uint8_t command) {

    while (!${SPIFunctions["spiOpen"]}(MCP73213_CLICK));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    command = ${SPIFunctions["exchangeByte"]}(command);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();

    return command;
}