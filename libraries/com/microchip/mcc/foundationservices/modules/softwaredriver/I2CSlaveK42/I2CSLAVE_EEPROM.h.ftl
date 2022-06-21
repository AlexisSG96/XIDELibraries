/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef I2C_SLAVE_H
#define I2C_SLAVE_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/**
  Section: Macro Declarations
 */


/**
  Section: Function declaration
 */
void ${i2cSlaveFunctions["open"]}(void);
void ${i2cSlaveFunctions["close"]}(void);

void ${i2cDriverFunctions["i2cIsrFunction"]}(void);

uint8_t ${i2cSlaveFunctions["read"]}(void);
void ${i2cSlaveFunctions["write"]}(uint8_t data);
void ${i2cSlaveFunctions["enable"]}(void);
void ${i2cSlaveFunctions["sendAck"]}(void);
void ${i2cSlaveFunctions["sendNack"]}(void);

// Read Event Interrupt Handlers
void ${moduleName}_RdCallBack(void);
void ${i2cSlaveFunctions["setReadIntHandler"]}(interruptHandler handler);
void ${moduleName}_DefRdInterruptHandler(void);
void (*${moduleName}_RdInterruptHandler)(void);

// Write Event Interrupt Handlers
void ${moduleName}_WrCallBack(void);
void ${i2cSlaveFunctions["setWriteIntHandler"]}(interruptHandler handler);
void ${moduleName}_DefWrInterruptHandler(void);
void (*${moduleName}_WrInterruptHandler)(void);

// Address Event Interrupt Handlers
void ${moduleName}_AddrCallBack(void);
void ${i2cSlaveFunctions["setAddrIntHandler"]}(interruptHandler handler);
void ${moduleName}_DefAddrInterruptHandler(void);
void (*${moduleName}_AddrInterruptHandler)(void);

//ISR HANDLERS
void ${i2cSlaveFunctions["setIsrHandler"]}(interruptHandler handler);
void ${i2cSlaveFunctions["setBusCollisionISR"]}(interruptHandler handler);
void ${moduleName}_BusCollisionISR(void);
void ${i2cSlaveFunctions["setWCOLIntHandler"]}(interruptHandler handler);
void ${moduleName}_WCOLCallBack(void);
void (*${moduleName}_WCOLInterruptHandler)(void);

#endif  // I2CSLAVE_H
