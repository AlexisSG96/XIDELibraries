/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "DIGIPOT5.h"

// Registers          3210xxxx
#define TCON0_REG   0b01000000U
#define TCON1_REG   0b10100000U
#define STATUS_REG  0b01010000U

// Commands           xxxx10xx
#define WRITE       0b00000000U
#define READ        0b00001100U
#define INCREMENT   0b00000100U
#define DECREMENT   0b00001000U
#define WL_EN       DECREMENT
#define WL_DIS      INCREMENT

uint16_t MCP4361_read(uint8_t addr);
void MCP4361_write(uint8_t addr, uint16_t val);
uint8_t MCP4361_isEEPROMBusy(void);
uint8_t MCP4361_send8BitCommand(uint8_t command);
uint16_t MCP4361_send16BitCommand(uint16_t command);

typedef struct {
    uint8_t V;
    uint8_t NV;
} MCP4361_wiper_t;


static const MCP4361_wiper_t channels[4] = {
//     3210xxxx    3210xxxx
    {0b00000000, 0b00100000},   // Wiper 0
    {0b00010000, 0b00110000},   // Wiper 1
    {0b01100000, 0b10000000},   // Wiper 2
    {0b01110000, 0b10010000}    // Wiper 3
};

static const MCP4361_wiper_t *activeChannel = channels;


void DIGIPOT_setChannel(uint8_t channel) {
    if (channel < 4) {
        activeChannel = channels + channel;
    }
}

void DIGIPOT_set(uint16_t val) {
    <#if (comboSettings=="Left-justified")>
    MCP4361_write(activeChannel->V, val >> 7);
    <#elseif (comboSettings=="Right-justified")>
    MCP4361_write(activeChannel->V, val);
    </#if>
}

uint16_t DIGIPOT_get(void) {
    <#if (comboSettings=="Left-justified")>
    return MCP4361_read(activeChannel->V) << 7;
    <#elseif (comboSettings=="Right-justified")>
    return MCP4361_read(activeChannel->V);
    </#if>
}

void DIGIPOT_save(void) {
    MCP4361_write(activeChannel->NV, MCP4361_read(activeChannel->V));
    while(MCP4361_isEEPROMBusy());
}

void DIGIPOT_load(void) {
    MCP4361_write(activeChannel->V, MCP4361_read(activeChannel->NV));
}

void DIGIPOT_lock(void) {
    // Apply high voltage (V_IHH = 8.5 to 12.5 V) on chip select pin first
    MCP4361_send8BitCommand(activeChannel->NV | WL_EN);
}

void DIGIPOT_unlock(void) {
    // Apply high voltage (V_IHH = 8.5 to 12.5 V) on chip select pin first
    MCP4361_send8BitCommand(activeChannel->NV | WL_DIS);  
}

uint16_t MCP4361_read(uint8_t addr) {
    return MCP4361_send16BitCommand((addr | READ) << 8) & 0x01FF;
}

void MCP4361_write(uint8_t addr, uint16_t val) {
    MCP4361_send16BitCommand(((addr | WRITE) << 8) | val);
}

uint8_t MCP4361_isEEPROMBusy(void) {
    return MCP4361_read(STATUS_REG) & 0x10;
}

uint16_t MCP4361_send16BitCommand(uint16_t command) {
    uint16_t readVal;

    <#if resetPinSettings.LAT?has_content>
    ${resetPinSettings["LAT"]} = 1;
    </#if>
    
    while(!${SPIFunctions["spiOpen"]}(DIGIPOT5));
    ${spiSSPinSettings["LAT"]} = 0;
    readVal = ${SPIFunctions["exchangeByte"]}(command >> 8);
    readVal <<= 8;
    readVal |= ${SPIFunctions["exchangeByte"]}(command);
    ${spiSSPinSettings["LAT"]} = 1;
    ${SPIFunctions["spiClose"]}();
    
    return readVal;
}

uint8_t MCP4361_send8BitCommand(uint8_t command) {
    <#if resetPinSettings.LAT?has_content>
    ${resetPinSettings["LAT"]} = 1;
    </#if>

    while(!${SPIFunctions["spiOpen"]}(DIGIPOT5));
    ${spiSSPinSettings["LAT"]} = 0;
    command = ${SPIFunctions["exchangeByte"]}(command);
    ${spiSSPinSettings["LAT"]} = 1;
    ${SPIFunctions["spiClose"]}();
    
    return command;
}