/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _MCP1664_H
#define _MCP1664_H

/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: MCP1664 Click Driver APIs
 */

void MCP1664_Initialize(void);
void MCP1664_setBrightness(uint16_t Brightness);

#endif // _MCP1664_H