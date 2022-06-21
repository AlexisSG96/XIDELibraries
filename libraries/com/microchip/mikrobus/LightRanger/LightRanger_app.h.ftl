 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef LR_H
#define	LR_H

#include <stdint.h>
#include <stdbool.h>

#define INT_DISABLED 0
#define INT_LOW 1
#define INT_HIGH 2
#define INT_OUT 3
#define INT_NEW 4

#define SINGLE_SHOT 0b01
#define CONTINUOUS 0b11
#define OFF 0b00

void LR_ConfigGpio(uint8_t als, uint8_t range);
void LR_InterruptClear(uint8_t mask);
bool LR_IsReset(void);
void LR_StartRange(uint8_t mode);
void LR_SetRangeHigh(uint8_t range);
void LR_SetRangeLow(uint8_t range);
void LR_SetRangeMeasPer(uint8_t period);
void LR_SetMaxConvTime(uint8_t time);
void LR_IgnoreHeight(uint8_t height);
void LR_IgnoreThresh(uint8_t height);
void LR_MaxAmbientLevelMult(uint8_t mult);
void LR_RangeCheckEnables(uint8_t mask);
void LR_StartAls(uint8_t mode);
void LR_SetAlsHigh(uint8_t range);
void LR_SetAlsLow(uint8_t range);
void LR_SetAlsMeasPer(uint8_t period);
void LR_SetAnalogGain(uint8_t gain);
void LR_SetIntegrationPeriod(uint8_t period);
uint8_t LR_RangeStatus(void);
uint8_t LR_AlsStatus(void);
uint8_t LR_InterruptStatus(void);
uint16_t LR_ReadAls(void);
uint8_t LR_ReadRange(void);
void LR_InterleavedMode(bool enabled);
void LR_Initialize(void);

#endif

