/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "counter.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

// Don't care bits            ...
// Register Select Bits   ...
// Command bits         ..
#define COUNTER_MDR0  0b00001000
#define COUNTER_MDR1  0b00010000
#define COUNTER_DTR   0b00011000
#define COUNTER_CNTR  0b00100000
#define COUNTER_OTR   0b00101000
#define COUNTER_STR   0b00110000

// Command definitions
#define COUNTER_CMD_CLR                 0x00
#define COUNTER_CMD_RD                  0x40
#define COUNTER_CMD_WR                  0x80
#define COUNTER_CMD_LD                  0xC0

// Mode Register0 Bits (bits 0-1)
#define COUNTER_MODE0_NONQCOUNT          0x00
#define COUNTER_MODE0_1QCOUNT            0x01
#define COUNTER_MODE0_2QCOUNT            0x02
#define COUNTER_MODE0_4QCOUNT            0x03

// Mode Register0 Bits (bits 2-3)
#define COUNTER_MODE0_FRCOUNT            0x00
#define COUNTER_MODE0_SSCOUNT            0x04
#define COUNTER_MODE0_RANGELIMITCOUNT    0x08
#define COUNTER_MODE0_MODNCOUNT          0x0C

// Mode Register0 Bits (bits 4-5)
#define COUNTER_MODE0_INDEX_NONE         0x00
#define COUNTER_MODE0_INDEX_LDCNTR       0x10
#define COUNTER_MODE0_INDEX_RSTCOUNT     0x20
#define COUNTER_MODE0_INDEX_LDOTR        0x30

// Mode Register0 Bits (bits 6)
#define COUNTER_MODE0_INDEX_ASYNC        0x00
#define COUNTER_MODE0_INDEX_SYNC         0x40

// Mode0 Register Bits (bits 7)
#define COUNTER_MODE0_INDEX_FILTERF1     0x00
#define COUNTER_MODE0_INDEX_FILTERF2     0x80

// Mode Register1 Bits (bits 0-1)
#define COUNTER_MODE1_4BYTE              0x00
#define COUNTER_MODE1_3BYTE              0x01
#define COUNTER_MODE1_2BYTE              0x02
#define COUNTER_MODE1_1BYTE              0x03

// Mode Register1 Bits (bits 2)
#define COUNTER_MODE1_ENABLED            0x00
#define COUNTER_MODE1_DISABLED           0x04

// Mode Register1 Bits (bits 3) - unused

void COUNTER_CS_SET_HIGH()
{
    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 1; } while(0);
}

void COUNTER_CS_SET_LOW()
{   
    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 0; } while(0);
}

void COUNTER_Reset(void)
{
    COUNTER_CS_SET_LOW();
    ${SPIFunctions["exchangeByte"]}(COUNTER_CNTR|COUNTER_CMD_CLR);
    COUNTER_CS_SET_HIGH();
}

uint8_t COUNTER_readReg(uint8_t  reg)
{
    uint8_t  retval;
    COUNTER_CS_SET_LOW();
    retval = ${SPIFunctions["exchangeByte"]}(reg|COUNTER_CMD_RD);
    COUNTER_CS_SET_HIGH();
    NOP();NOP();NOP();NOP();

    return retval;
}

void COUNTER_writeReg(uint8_t  reg, uint8_t  value)
{
    COUNTER_CS_SET_LOW();
    ${SPIFunctions["exchangeByte"]}(reg|COUNTER_CMD_WR);
    ${SPIFunctions["exchangeByte"]}(value);
    COUNTER_CS_SET_HIGH();
    NOP();NOP();NOP();NOP();
}

uint32_t COUNTER_read(void)
{   
    uint32_t  retVal = 0;
    COUNTER_CS_SET_LOW();
    ${SPIFunctions["exchangeByte"]}(COUNTER_CNTR|COUNTER_CMD_RD);
    
    retVal = ${SPIFunctions["exchangeByte"]}(0xFF);
    retVal <<=8;
    retVal |= ${SPIFunctions["exchangeByte"]}(0xFF);
    retVal <<=8;
    retVal |= ${SPIFunctions["exchangeByte"]}(0xFF);
    retVal <<=8;
    retVal |= ${SPIFunctions["exchangeByte"]}(0xFF);
    COUNTER_CS_SET_HIGH();

    return retVal;
}

void COUNTER_initialize(void){

    while (!${SPIFunctions["spiOpen"]}(${spi_configuration}));

    COUNTER_writeReg(COUNTER_MDR0,  COUNTER_MODE0_NONQCOUNT  | 
                                    COUNTER_MODE0_FRCOUNT    | 
                                    COUNTER_MODE0_INDEX_NONE | 
                                    COUNTER_MODE0_INDEX_SYNC | 
                                    COUNTER_MODE0_INDEX_FILTERF2
                    );
}
