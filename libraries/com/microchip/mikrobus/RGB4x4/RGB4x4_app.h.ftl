/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _RGB4X4_H
#define _RGB4X4_H

#include <stdint.h>
#include <stddef.h>

// Transmit seq: green -> red -> blue
typedef struct RGB4x4_s 
{
    uint8_t green;
    uint8_t red;
    uint8_t blue;
} RGB4x4_t;

void RGB4x4_SetBuffer(RGB4x4_t *b, size_t s);
void RGB4x4_Update(void);
void RGB4x4_Clear(void);

#endif // _RGB4X4_H
