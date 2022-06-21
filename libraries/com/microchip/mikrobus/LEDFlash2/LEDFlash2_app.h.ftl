/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _LEDFLASH2_H
#define _LEDFLASH2_H

/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: LED Flash 2 Click Driver APIs
 */
typedef enum {
    Flash = 0,
    Torch,
} Mode;

enum Brightness{
    p100 = 0,
    p90,
    p80,
    p70,
    p63,
    p56,
    p50,
    p45,
    p40,
    p36,
    p32,
    p28,
    p25,
    p22,
    p20,
    p18
};

enum Timeout{
    ms160 = 0,
    ms310,
    ms470,
    ms625,
    ms780,
    ms950,
    ms1100,
    ms1250
};

void LEDFlash2_Initialize(void);
void LEDFlash2_setMode(uint8_t Mode);
uint8_t LEDFlash2_setBrightness(uint8_t Brightness);
uint8_t LEDFlash2_setFlashTimer(uint8_t Timeout);

#endif // _LEDFLASH2_H