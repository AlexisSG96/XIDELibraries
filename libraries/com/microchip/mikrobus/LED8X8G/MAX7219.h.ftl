/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MAX7219_H
#define MAX7219_H

#include <stdint.h>

#define MAX7219_NO_OPERATION 0x0
#define MAX7219_DIGIT_0 0x1
#define MAX7219_DIGIT_1 0x2
#define MAX7219_DIGIT_2 0x3
#define MAX7219_DIGIT_3 0x4
#define MAX7219_DIGIT_4 0x5
#define MAX7219_DIGIT_5 0x6
#define MAX7219_DIGIT_6 0x7
#define MAX7219_DIGIT_7 0x8
#define MAX7219_DECODE_MODE 0x9
#define MAX7219_INTENSITY 0xA
#define MAX7219_SCAN_LIMIT 0xB
#define MAX7219_SHUTDOWN 0xC
#define MAX7219_DISPLAY_TEST 0xF

void MAX7219_Write(uint8_t addr, uint8_t value);

#endif