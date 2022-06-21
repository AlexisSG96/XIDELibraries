/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#ifdef __XC
#include <xc.h>
#endif
#include "stdint.h"
#include "mcc.h"
#include "${pinHeader}"
#include "drivers/${I2CFunctions["simpleheader"]}"
#include "LEDFlash2.h"


/**
  Section: Macro Declarations
 */

#define SLAVE_ADDRESS	0x5A 

#define M_REG			0x00
#define F_REG			0x01
#define T_REG			0x02

#define M_EN			0x08
#define F_EN			0x10
#define T_EN			0x10
#define F_IN			0x20

/**
  Section: Variable Definitions
 */

uint8_t Current;
uint8_t Timer;

/**
  Section: Private function prototypes
 */

void LEDFlash2_Clear(void);

/**
  Section: Driver APIs
 */

void LEDFlash2_ChipEnable(void) {
    ${ENPinSettings["LAT"]} = 1;
}

void LEDFlash2_ChipDisable(void) {
    ${ENPinSettings["LAT"]} = 0;
}

void FlashInhibit_Enable(void) {
    ${FIPinSettings["LAT"]} = 1;
}

void FlashInhibit_Disable(void) {
    ${FIPinSettings["LAT"]} = 0;
}

void Flash_Enable(void) {
    ${FENPinSettings["LAT"]} = 1;
}

void Flash_Disable(void) {
    ${FENPinSettings["LAT"]} = 0;
}

void Torch_Enable(void) {
    ${TENPinSettings["LAT"]} = 1;
}

void Torch_Disable(void) {
    ${TENPinSettings["LAT"]} = 0;
}

void LEDFlash2_Initialize(void) {
    LEDFlash2_Clear();
    ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, M_REG, M_EN);
}

void LEDFlash2_Clear(void) {
    ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, F_REG, 0x00);
    ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, T_REG, 0x00);
}

void LEDFlash2_setMode(uint8_t Mode) {
    if (Mode == Torch) {
        LEDFlash2_Clear();
        ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, T_REG, (T_EN | (Current & 0x0F)));
    } else if (Mode == Flash) {
        LEDFlash2_Clear();
        ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, F_REG, ((Timer << 5) | F_EN | (Current & 0x0F)));
    }
}

uint8_t LEDFlash2_setBrightness(uint8_t Brightness) {
    Current = Brightness;
    return Current;
}

uint8_t LEDFlash2_setFlashTimer(uint8_t Timeout) {
    Timer = Timeout;
    return Timer;
}

