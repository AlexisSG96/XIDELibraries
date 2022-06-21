/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BUCK2_H
#define	BUCK2_H

#ifdef __XC
#include <xc.h>
#endif

#define BUCK2_enable()  ${enPin["setOutputLevelHigh"]}
#define BUCK2_disable() ${enPin["setOutputLevelLow"]}
#define BUCK2_getPowerGoodCondition()  ${pgPin["getInputValue"]}

void BUCK2_setVoltage_700mV(void);
void BUCK2_setVoltage_800mV(void);
void BUCK2_setVoltage_900mV(void);
void BUCK2_setVoltage_1000mV(void);
void BUCK2_setVoltage_1200mV(void);
void BUCK2_setVoltage_1500mV(void);
void BUCK2_setVoltage_1800mV(void);
void BUCK2_setVoltage_2500mV(void);
void BUCK2_setVoltage_3300mV(void);

#endif	/* BUCK2_H */