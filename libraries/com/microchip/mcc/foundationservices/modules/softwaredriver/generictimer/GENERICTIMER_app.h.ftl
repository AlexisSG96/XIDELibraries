/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _GENERIC_TMR_H
#define _GENERIC_TMR_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>

//#define TMR_INTERRUPT_TICKER_FACTOR    1
typedef void (*interruptHandler)(void);
/**
  Section: TMR APIs
*/

//For ALL TMRs

void TMR_Initialize(void);
uint16_t TMR_ReadTimer(void);   //TODO: should adapt to 8/16-bit timers
void TMR_WriteTimer(uint16_t timerVal);
void TMR_Reload(void);
void TMR_ISR(void);
void TMR_CallBack(void);

//For TMR1/3/2/4/6

void TMR_StartTimer(void);
void TMR_StopTimer(void);
void TMR_SetInterruptHandler(interruptHandler handler);
void (*TMR_InterruptHandler)(void);
void TMR_DefaultInterruptHandler(void);

//For TMR2/4/6

void TMR_LoadPeriodRegister(uint8_t periodVal);

//For TMR1/3

void TMR_StartSinglePulseAcquisition(void);
uint8_t TMR_CheckGateValueStatus(void);
void TMR_GATE_ISR(void);

#endif // _GENERIC_TMR_H
/**
 End of File
*/
