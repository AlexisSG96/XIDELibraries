 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef MCP16331_H
#define	MCP16331_H

#include <stdint.h>
#include <stdbool.h>

void MCP16331_Initialize(void);
void MCP16331_Enable(void);
void MCP16331_Disable(void);
void MCP16331_SetVoltage(float voltage);
float MCP16331_GetOutputVoltage(void);

#endif	/* MCP16331_H */