/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MCP4291_H
#define	MCP4291_H

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>

// Functions
void DAC_Set(uint16_t dacValue);

#endif /* MCP4291_H */