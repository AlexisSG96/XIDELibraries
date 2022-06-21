/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef MCP73871_H
#define	MCP73871_H

/**
  Section: Included Files
 */
 
#include <stdint.h>

/**
  Section: Macro Declarations
 */
 
typedef enum {
	Low = 0,
	High,
} current;

/**
  Section: MCP73871 Driver APIs
 */
 
 void MCP73871_Initialize(void);
 void MCP73871_setChargingCurrent(current c);	
 void MCP73871_ChargeEnable(void);
 void MCP73871_ChargeDisable(void);
 void MCP73871_SafetyTimerEnable(void);
 void MCP73871_SafetyTimerDisable(void);  

#endif	/* MCP73871_H */
