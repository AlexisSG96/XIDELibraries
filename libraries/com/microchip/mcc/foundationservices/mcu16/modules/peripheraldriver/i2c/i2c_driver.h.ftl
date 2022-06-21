/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef __${i2cName?upper_case}_H
#define __${i2cName?upper_case}_H

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
 
typedef void (*interruptHandler)(void);

/* arbitration interface */
void ${i2cClose}(void);

/* Interrupt interfaces */
void ${enableIRQ}(void);
bool ${IRQisEnabled}(void);
void ${disableIRQ}(void);
void ${clearIRQ}(void);
void ${setIRQ}(void);
void ${waitForEvent}(uint16_t*);

/* I2C interfaces */
bool  ${initMasterHardware}(void);
char ${getRXData}(void);
void ${TXData}(uint8_t);
void ${resetBus}(void);
void ${start}(void);
void ${restart}(void);
void ${stop}(void);
bool ${isNACK}(void);
void ${startRX}(void);
void ${sendACK}(void);
void ${sendNACK}(void);
void ${clearBusCollision}(void);

bool  ${initSlaveHardware}(void);
void ${releaseClock}(void);
bool ${isBuferFull}(void);
bool ${isStart}(void);
bool ${isStop}(void);
bool ${isAddress}(void);
bool ${isData}(void);
bool ${isRead}(void);
void ${enableStartIRQ}(void);
void ${disableStartIRQ}(void);
void ${enableStopIRQ}(void);
void ${disableStopIRQ}(void);

void ${setBusCollisionISR}(interruptHandler handler);
void ${setMasterI2cISR}(interruptHandler handler);
void ${setSlaveI2cISR}(interruptHandler handler);

#endif // __${i2cName?upper_case}_H
