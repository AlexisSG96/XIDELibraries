/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <xc.h>
#include "../mssp_driver.h"
#include "generic_i2c.h"    

/**
  Section: Driver APIs
 */ 

INLINE void MSSP_Close(void)
{
    ${close}();
}

/* Interrupt Control */
INLINE void MSSP_EnableIRQ(void)
{
    ${enableIRQ}();
}

INLINE __bit MSSP_IRQisEnabled(void)
{
    ${IRQisEnabled}();
}

INLINE void MSSP_DisableIRQ(void)
{
    ${disableIRQ}();
}

INLINE void MSSP_ClearIRQ(void)
{
    ${clearIRQ}();
}

INLINE void MSSP_SetIRQ(void)
{
    ${setIRQ}();
}

INLINE void MSSP_WaitForEvent(uint16_t *timeout)
{
    ${waitForEvent}(timeout);
}

INLINE void GI2C_ResetBus(void)
{
    ${resetBus}();
}

__bit GI2C_InitMasterHardware(void)
{
    return ${initMasterHardware}();
}   

__bit GI2C_InitSlaveHardware(void)
{
    return ${initSlaveHardware}();
}

INLINE void GI2C_Start(void)
{
    ${start}();
}

INLINE void GI2C_Restart(void)
{
    ${restart}();
}

INLINE void GI2C_Stop(void)
{
    ${stop}();
}

INLINE __bit GI2C_IsNACK(void)
{
    ${isNACK}();
}

INLINE void GI2C_StartRX(void)
{
    ${startRX}();
}

INLINE char GI2C_GetRXData(void)
{
    ${getRXData}();
}

INLINE void GI2C_TXData(char d)
{
    ${TXData}(d);
}

INLINE void GI2C_SendACK(void)
{
    ${sendACK}();
}

INLINE void GI2C_SendNACK(void)
{
    ${sendNACK}();
}

INLINE void GI2C_ReleaseClock(void)
{
    ${releaseClock}();
}

INLINE __bit GI2C_IsBuferFull(void)
{
    ${isBuferFull}();
}

INLINE __bit GI2C_IsStart(void)
{
    ${isStart}();
}

INLINE __bit GI2C_IsAddress(void)
{
    ${isAddress}();
}

INLINE __bit GI2C_IsStop(void)
{
    ${isStop}();
}

INLINE __bit GI2C_IsData(void)
{
    ${isData}();
}

INLINE __bit GI2C_IsRead(void)
{
    ${isRead}();
}

INLINE void GI2C_ClearBusCollision(void)
{
    ${clearBusCollision}();
}

INLINE void GI2C_EnableStartIRQ(void)
{
    ${enableStartIRQ}();
}

INLINE void GI2C_DisableStartIRQ(void)
{
    ${disableStartIRQ}();
}

INLINE void GI2C_EnableStopIRQ(void)
{
    ${enableStopIRQ}();
}

INLINE void GI2C_DisableStopIRQ(void)
{
    ${disableStopIRQ}();
}

/**
 End of File
 */
