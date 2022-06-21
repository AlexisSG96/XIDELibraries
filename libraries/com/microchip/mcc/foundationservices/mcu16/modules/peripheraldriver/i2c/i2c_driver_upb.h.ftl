/*
Copyright (c) 2013 - 2015 released Microchip Technology Inc.  All rights reserved.

Microchip licenses to you the right to use, modify, copy and distribute
Software only when embedded on a Microchip microcontroller or digital signal
controller that is integrated into your product or third party product
(pursuant to the sublicense terms in the accompanying license agreement).

You should refer to the license agreement accompanying this Software for
additional information regarding your rights and obligations.

SOFTWARE AND DOCUMENTATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF
MERCHANTABILITY, TITLE, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE.
IN NO EVENT SHALL MICROCHIP OR ITS LICENSORS BE LIABLE OR OBLIGATED UNDER
CONTRACT, NEGLIGENCE, STRICT LIABILITY, CONTRIBUTION, BREACH OF WARRANTY, OR
OTHER LEGAL EQUITABLE THEORY ANY DIRECT OR INDIRECT DAMAGES OR EXPENSES
INCLUDING BUT NOT LIMITED TO ANY INCIDENTAL, SPECIAL, INDIRECT, PUNITIVE OR
CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF PROCUREMENT OF
SUBSTITUTE GOODS, TECHNOLOGY, SERVICES, OR ANY CLAIMS BY THIRD PARTIES
(INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF), OR OTHER SIMILAR COSTS.
 */

#ifndef __${i2cName}_H
#define __${i2cName}_H

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

#endif // __${i2cName}_H
