/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "sqi_driver.h"

#define SQ3_SetDigitalOutput()     do { ${SQ3PinSettings["TRIS"]} = 0; } while(0)
#define SQ3_SetDigitalInput()      do { ${SQ3PinSettings["TRIS"]} = 1; } while(0)
#define SQ3_SetHigh()              do { ${SQ3PinSettings["LAT"]} = 1; } while(0)
#define SQ3_SetLow()               do { ${SQ3PinSettings["LAT"]} = 0; } while(0)
#define SQ3_GetValue()             ${SQ3PinSettings["PORT"]}

#define SQ2_SetDigitalOutput()     do { ${SQ2PinSettings["TRIS"]} = 0; } while(0)
#define SQ2_SetDigitalInput()      do { ${SQ2PinSettings["TRIS"]} = 1; } while(0)
#define SQ2_SetHigh()              do { ${SQ2PinSettings["LAT"]} = 1; } while(0)
#define SQ2_SetLow()               do { ${SQ2PinSettings["LAT"]} = 0; } while(0)
#define SQ2_GetValue()             ${SQ2PinSettings["PORT"]}

#define SQ1_SetDigitalOutput()     SDI${SPIFunctions["msspInstance"]}_SetDigitalOutput()
#define SQ1_SetDigitalInput()      SDI${SPIFunctions["msspInstance"]}_SetDigitalInput()
#define SQ1_SetHigh()              SDI${SPIFunctions["msspInstance"]}_SetHigh()
#define SQ1_SetLow()               SDI${SPIFunctions["msspInstance"]}_SetLow()
#define SQ1_GetValue()             SDI${SPIFunctions["msspInstance"]}_GetValue()

#define SQ0_SetDigitalOutput()     SDO${SPIFunctions["msspInstance"]}_SetDigitalOutput()
#define SQ0_SetDigitalInput()      SDO${SPIFunctions["msspInstance"]}_SetDigitalInput()
#define SQ0_SetHigh()              SDO${SPIFunctions["msspInstance"]}_SetHigh()
#define SQ0_SetLow()               SDO${SPIFunctions["msspInstance"]}_SetLow()
#define SQ0_GetValue()             SDO${SPIFunctions["msspInstance"]}_GetValue()

#define SQICLK_SetHigh()           SCK${SPIFunctions["msspInstance"]}_SetHigh()
#define SQICLK_SetLow()            SCK${SPIFunctions["msspInstance"]}_SetLow()

void setQuadPinsInput(void);
void setQuadPinsOutput(void);

bool sqi_open(void) { 
    <#if sckPPSRegister?has_content>
    //    Give control to LAT
    ${sckPPSRegister} = ${sckPPSDefault};
    </#if>
    <#if sdoPPSRegister?has_content>
    ${sdoPPSRegister} = ${sdoPPSDefault};
    </#if>
    
    return true;
}

void sqi_close(void) {    
    SQ0_SetDigitalOutput();
    SQ1_SetDigitalInput();
}

void sqi_writeByte(uint8_t out) {
    setQuadPinsOutput();
    if (out & 0x80) SQ3_SetHigh(); else SQ3_SetLow();
    if (out & 0x40) SQ2_SetHigh(); else SQ2_SetLow();
    if (out & 0x20) SQ1_SetHigh(); else SQ1_SetLow();
    if (out & 0x10) SQ0_SetHigh(); else SQ0_SetLow();
    
    SQICLK_SetHigh();
    SQICLK_SetLow();
    
    if (out & 0x08) SQ3_SetHigh(); else SQ3_SetLow();
    if (out & 0x04) SQ2_SetHigh(); else SQ2_SetLow();
    if (out & 0x02) SQ1_SetHigh(); else SQ1_SetLow();
    if (out & 0x01) SQ0_SetHigh(); else SQ0_SetLow();
    
    SQICLK_SetHigh();
    SQICLK_SetLow();
}

uint8_t sqi_readByte(void) {
    uint8_t byte = 0;
    
    setQuadPinsInput();
    if (SQ3_GetValue()) byte |= 0x80;
    if (SQ2_GetValue()) byte |= 0x40;
    if (SQ1_GetValue()) byte |= 0x20;
    if (SQ0_GetValue()) byte |= 0x10;
    
    SQICLK_SetHigh();
    setQuadPinsOutput();
    SQICLK_SetLow();
    
    setQuadPinsInput();
    if (SQ3_GetValue()) byte |= 0x08;
    if (SQ2_GetValue()) byte |= 0x04;
    if (SQ1_GetValue()) byte |= 0x02;
    if (SQ0_GetValue()) byte |= 0x01;

    SQICLK_SetHigh();
    setQuadPinsOutput();
    SQICLK_SetLow();
    
    return byte;
}

void sqi_writeBlock(void *block, size_t blockSize) {
    uint8_t *out = block;

    while (blockSize--) {
        sqi_writeByte(*out++);
    }
}

void sqi_readBlock(void *block, size_t blockSize) {
    uint8_t *in = block;
    
    while (blockSize--) {
        *in++ = sqi_readByte();
    }
}

void setQuadPinsInput() {
    SQ3_SetDigitalInput();
    SQ2_SetDigitalInput();
    SQ1_SetDigitalInput();
    SQ0_SetDigitalInput();
}

void setQuadPinsOutput() {
    SQ3_SetDigitalOutput();
    SQ2_SetDigitalOutput();
    SQ1_SetDigitalOutput();
    SQ0_SetDigitalOutput();
}
