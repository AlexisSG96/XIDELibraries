/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _GENERIC_I2C_H
#define _GENERIC_I2C_H

/**
  Section: Included Files
 */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

#define INLINE  inline

/**
  Section: I2C Driver APIs
 */ 

/* Arbitration Interface */
INLINE void MSSP_Close(void);

/* Interrupt Interfaces */
INLINE void MSSP_EnableIRQ(void);
INLINE __bit  MSSP_IRQisEnabled(void);
INLINE void MSSP_DisableIRQ(void);
INLINE void MSSP_ClearIRQ(void);
INLINE void MSSP_SetIRQ(void);
INLINE void MSSP_WaitForEvent(uint16_t*);

/* I2C Interfaces */
__bit  GI2C_InitMasterHardware(void);
INLINE char GI2C_GetRXData(void);
INLINE void GI2C_TXData(uint8_t);
INLINE void GI2C_ResetBus(void);
INLINE void GI2C_Start(void);
INLINE void GI2C_Restart(void);
INLINE void GI2C_Stop(void);
INLINE __bit  GI2C_IsNACK(void);
INLINE void GI2C_StartRX(void);
INLINE void GI2C_SendACK(void);
INLINE void GI2C_SendNACK(void);
INLINE void GI2C_ClearBusCollision(void);

__bit  GI2C_InitSlaveHardware(void);
INLINE void GI2C_ReleaseClock(void);
INLINE __bit GI2C_IsBuferFull(void);
INLINE __bit GI2C_IsStart(void);
INLINE __bit GI2C_IsStop(void);
INLINE __bit GI2C_IsAddress(void);
INLINE __bit GI2C_IsData(void);
INLINE __bit GI2C_IsRead(void);
INLINE void GI2C_EnableStartIRQ(void);
INLINE void GI2C_EisableStartIRQ(void);
INLINE void GI2C_EnableStopIRQ(void);
INLINE void GI2C_DisableStopIRQ(void);

#endif // _GENERIC_I2C_H
/**
 End of File
*/

