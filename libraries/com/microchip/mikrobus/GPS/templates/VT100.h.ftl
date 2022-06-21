/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
 * File:   VT100.h
 */
#ifndef VT100_H
#define VT100_H

#include <stdint.h>

void VT100_ClearScreen(void);
void VT100_HomeCursor(void);
void VT100_ClearToEOL(void);
void VT100_SetCursorRC(uint8_t, uint8_t);  

#endif	/* VT100_H */