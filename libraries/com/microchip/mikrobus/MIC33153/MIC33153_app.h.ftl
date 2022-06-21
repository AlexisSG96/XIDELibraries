 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef MIC33153_H
#define	MIC33153_H

#include <stdint.h>
#include <stdbool.h>

void MIC33153_Initialize(void);
void MIC33153_Enable(void);
void MIC33153_Disable(void);
bool IsPowerGood(void);
float GetOutputVoltageCondition(void);
void MIC33153_SetVoltage(float voltage);

#endif	/* MIC33153_H */