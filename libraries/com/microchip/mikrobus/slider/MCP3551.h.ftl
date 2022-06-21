/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MCP3551_H
#define MCP3551_H

#include <stdint.h>
#include <stdbool.h>

#define MCP3551_CONVERSION_TIME_MILLISECONDS    75

void MCP3551_startConversion(void);
void MCP3551_stopConversion(void);
bool MCP3551_isSingleConversionDone(void);
uint32_t MCP3551_getConversionResult(void);

// Starts a single conversion, waits until done, and returns the result
uint32_t MCP3551_getSingleConversion(void);

#endif // MCP3551_H
