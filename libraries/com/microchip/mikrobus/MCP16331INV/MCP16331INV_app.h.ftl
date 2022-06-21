 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef MCP16331INV_H
#define	MCP16331INV_H

#include <stdint.h>
#include <stdbool.h>

void MCP16331INV_Initialize(void);
void MCP16331INV_Enable(void);
void MCP16331INV_Disable(void);
void MCP16331INV_SetVoltage(float voltage);
float MCP16331INV_GetOutputVoltage(void);

#endif	/* MCP16331INV_H */