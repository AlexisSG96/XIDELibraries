 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "SRAM.h"
#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "${SPIFunctions["spiHeader"]}"

enum mode {
    UNDEFINED, BYTE, PAGE, SEQUENTIAL
};

static uint8_t writeMode = UNDEFINED;
static uint8_t readMode = UNDEFINED;

#define SRAM_READ 0x03
#define SRAM_WRITE 0x02
#define SRAM_RDMR 0x05
#define SRAM_WRMR 0x01

static void SRAM_GotoMode(uint8_t cmd, uint8_t mode) {
    uint8_t commandBlock[2];
    commandBlock[0] = cmd;
    switch (mode) {
        case BYTE:
            commandBlock[1] = 0x00;
            break;
        case PAGE:
            commandBlock[1] = 0x80;
            break;
        case SEQUENTIAL:
            commandBlock[1] = 0x40;
            break;
    }
    SRAM_nCS_LAT = 0;
    ${SPIFunctions["writeBlock"]}(commandBlock, 2);
    SRAM_nCS_LAT = 1;

}

static void SRAM_GotoWriteMode(uint8_t mode) {
    ${SPIFunctions["spiOpen"]}(SRAM);
    if (writeMode != mode) {
        SRAM_GotoMode(SRAM_WRMR, mode);
        writeMode = mode;
    }
}

static void SRAM_GotoReadMode(uint8_t mode) {
    ${SPIFunctions["spiOpen"]}(SRAM);
    if (readMode != mode) {
        SRAM_GotoMode(SRAM_RDMR, mode);
        readMode = mode;
    }
}

static void SRAM_SetAddr(uint8_t type, uint32_t location) {
    SRAM_HLD_LAT = 1;
    uint8_t commandBlock[4];
    commandBlock[0] = type;
    commandBlock[1] = (uint8_t) ((location >> 16) & 0xFF);
    commandBlock[2] = (uint8_t) ((location >> 8) & 0xFF);
    commandBlock[3] = (uint8_t) (location & 0xFF);
    SRAM_nCS_LAT = 0;
    ${SPIFunctions["writeBlock"]}(commandBlock, 4);
}

static void SRAM_SetWriteAddr(uint32_t location) {
    SRAM_SetAddr(SRAM_WRITE, location);
}

static void SRAM_SetReadAddr(uint32_t location) {
    SRAM_SetAddr(SRAM_READ, location);
}

void SRAM_StartSequentialWrite(uint32_t location) {
    SRAM_GotoWriteMode(SEQUENTIAL);
    SRAM_SetWriteAddr(location);
}

void SRAM_SequentialWrite(uint8_t byte) {
    ${SPIFunctions["exchangeByte"]}(byte);
}

void SRAM_EndSequentialWrite(void) {
    SRAM_nCS_LAT = 1;
    ${SPIFunctions["spiClose"]}();
}

void SRAM_ByteWrite(uint32_t location, uint8_t byte) {
    SRAM_GotoWriteMode(BYTE);
    SRAM_SetWriteAddr(location);
    ${SPIFunctions["exchangeByte"]}(byte);
    SRAM_nCS_LAT = 1;
    ${SPIFunctions["spiClose"]}();
}

void SRAM_PageWrite(uint32_t location, const uint8_t * data) {
    SRAM_GotoWriteMode(PAGE);
    SRAM_SetWriteAddr(location);
    uint8_t i;
    for (i = 0; i < 32; i++) {
        ${SPIFunctions["exchangeByte"]}(data[i]);
    }
    SRAM_nCS_LAT = 1;
    ${SPIFunctions["spiClose"]}();
}

void SRAM_StartSequentialRead(uint32_t location) {
    SRAM_GotoReadMode(SEQUENTIAL);
    SRAM_SetReadAddr(location);
}

uint8_t SRAM_SequentialRead(void) {
    return ${SPIFunctions["exchangeByte"]}(0);
}

void SRAM_EndSequentialRead(void) {
    SRAM_nCS_LAT = 1;
    ${SPIFunctions["spiClose"]}();
}

uint8_t SRAM_ByteRead(uint32_t location) {
    SRAM_GotoReadMode(BYTE);
    SRAM_SetReadAddr(location);
    uint8_t returnVal = ${SPIFunctions["exchangeByte"]}(0);
    SRAM_nCS_LAT = 1;
    ${SPIFunctions["spiClose"]}();
    return returnVal;
}

void SRAM_PageRead(uint32_t location, uint8_t * data) {
    SRAM_GotoReadMode(PAGE);
    SRAM_SetReadAddr(location);
    uint8_t i;
    for (i = 0; i < 32; i++) {
        data[i] = ${SPIFunctions["exchangeByte"]}(0);
    }
    SRAM_nCS_LAT = 1;
    ${SPIFunctions["spiClose"]}();
}
