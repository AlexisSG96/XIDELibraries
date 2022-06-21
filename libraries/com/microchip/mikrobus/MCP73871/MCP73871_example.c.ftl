/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "MCP73871.h"
#include "MCP73871_example.h"

void MCP73871_example(void){
     MCP73871_setChargingCurrent(High);
     MCP73871_SafetyTimerEnable();
     MCP73871_ChargeEnable();
}

