/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
#include "${pinHeader}"
#include "MCP73871.h"

/**
  Section: MCP73871 Driver APIs
 */

 void MCP73871_Initialize(void){
     MCP73871_setChargingCurrent(${InitPG2Val});
<#if CE_Mode == "enabled">
     MCP73871_ChargeEnable();
<#else>
     MCP73871_ChargeDisable();
</#if>
<#if TE_Mode == "enabled">
     MCP73871_SafetyTimerEnable();
<#else>
     MCP73871_SafetyTimerDisable();
</#if>
 }

 void MCP73871_setChargingCurrent(current c){
     ${PG2PinSettings["LAT"]} = c;
 }	
 void MCP73871_ChargeEnable(void){
     ${CEPinSettings["LAT"]} = 1;
 }
 
 void MCP73871_ChargeDisable(void){
     ${CEPinSettings["LAT"]} = 0;
 }
 
 void MCP73871_SafetyTimerEnable(void){
     ${TESettings["LAT"]} = 1;
 }
 
 void MCP73871_SafetyTimerDisable(void){
     ${TESettings["LAT"]} = 0;
 }