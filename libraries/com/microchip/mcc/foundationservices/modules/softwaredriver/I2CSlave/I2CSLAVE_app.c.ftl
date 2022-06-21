/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include "i2c_slave.h"

#define I2C1_SLAVE_ADDRESS ${deviceAddress} 
#define I2C1_SLAVE_MASK    ${addressMask}

/**
 Section: Global Variables
 */

typedef enum {Address, I2C_TX, I2C_RX} i2c_state_t;

static volatile i2c_state_t state = Address;
static volatile i2c_state_t nextState =  Address;
volatile uint8_t i2c1Data;
volatile uint8_t sAddr;

/**
 Section: Local Functions
 */

void ${i2cSlaveFunctions["open"]}(void) {

    ${i2cSlaveFunctions["setIsrHandler"]}(${moduleName}_ISR);
    ${msspI2cFunctions["initI2cSlaveHardware"]}();
    ${msspI2cFunctions["setAddr"]}(I2C1_SLAVE_ADDRESS << 1);
    ${msspI2cFunctions["setMask"]}(I2C1_SLAVE_MASK);
    ${msspI2cFunctions["setBusCollisionISR"]}(${moduleName}_BusCollisionISR);
    ${i2cSlaveFunctions["setWriteIntHandler"]}(${moduleName}_DefWrInterruptHandler);
    ${i2cSlaveFunctions["setReadIntHandler"]}(${moduleName}_DefRdInterruptHandler);
    ${i2cSlaveFunctions["setAddrIntHandler"]}(${moduleName}_DefAddrInterruptHandler);
    ${i2cSlaveFunctions["setWCOLIntHandler"]}(${moduleName}_BusCollisionISR);
}

void ${i2cSlaveFunctions["close"]}(void) {
    ${msspI2cFunctions["i2cClose"]}();
}

void ${moduleName}_ISR(void) {
    ${msspI2cFunctions["clearIRQ"]}();  
 
    // read SSPBUF to clear BF
    i2c1Data = ${msspI2cFunctions["getRXData"]}(); 
    
    if (0 == ${msspI2cFunctions["isRead"]}()) 
    {
        state = I2C_RX;
    
    } else {
         state = I2C_TX;
    }
    
    switch(state)
    {
        case I2C_TX:
            if(0 == ${msspI2cFunctions["isWriteCollision"]}()) //if there is no write collision
                 ${moduleName}_WrCallBack();
            else
                {
                  ${moduleName}_WCOLCallBack();
                  ${msspI2cFunctions["restart"]}();
                }
            nextState = Address;
            break;
           
        case I2C_RX:
            if (1 == ${msspI2cFunctions["isData"]}()) 
            {
                ${moduleName}_RdCallBack();
                nextState = I2C_RX;
            } else {
                ${moduleName}_AddrCallBack();
                nextState = Address;
            }
            
            break;
        default:          
            break;
    }
    
    state = nextState;
    ${msspI2cFunctions["releaseClock"]}();
}

void ${moduleName}_BusCollisionISR(void) {
    
}

uint8_t ${i2cSlaveFunctions["read"]}(void) {
    return ${msspI2cFunctions["getRXData"]}();
}

void ${i2cSlaveFunctions["write"]}(uint8_t data) {
    ${msspI2cFunctions["TXData"]}(data);
}

void ${i2cSlaveFunctions["enable"]}(void) {
    ${msspI2cFunctions["initI2cSlaveHardware"]}();
}

void ${i2cSlaveFunctions["sendAck"]}(void) {
    ${msspI2cFunctions["sendACK"]}();
}

void ${i2cSlaveFunctions["sendNack"]}(void) {
    ${msspI2cFunctions["sendNACK"]}();
}

// Read Event Interrupt Handlers
void ${moduleName}_RdCallBack(void) {
    // Add your custom callback code here
    if (${moduleName}_RdInterruptHandler) {
        ${moduleName}_RdInterruptHandler();
    }
}

void ${i2cSlaveFunctions["setIsrHandler"]}(interruptHandler handler) {
    ${msspI2cFunctions["setI2cISR"]}(handler);
}

void ${i2cSlaveFunctions["setBusCollisionISR"]}(interruptHandler handler) {
    ${msspI2cFunctions["setBusCollisionISR"]}(handler);
}

void ${i2cSlaveFunctions["setReadIntHandler"]}(interruptHandler handler) {
    ${moduleName}_RdInterruptHandler = handler;
}

void ${moduleName}_DefRdInterruptHandler(void) {
    i2c1Data = ${msspI2cFunctions["getRXData"]}();
}

// Write Event Interrupt Handlers
void ${moduleName}_WrCallBack(void) {
    // Add your custom callback code here
    if (${moduleName}_WrInterruptHandler) {
        ${moduleName}_WrInterruptHandler();
    }
}

void ${i2cSlaveFunctions["setWriteIntHandler"]}(interruptHandler handler) {
    ${moduleName}_WrInterruptHandler = handler;
}

void ${moduleName}_DefWrInterruptHandler(void) {
    ${msspI2cFunctions["TXData"]}(${moduleName}_writeData);
}

// Address Event Interrupt Handlers
void ${moduleName}_AddrCallBack(void) {
    // Add your custom callback code here
    if (${moduleName}_AddrInterruptHandler) {
        ${moduleName}_AddrInterruptHandler();
    }
}

void ${i2cSlaveFunctions["setAddrIntHandler"]}(interruptHandler handler) {
    ${moduleName}_AddrInterruptHandler = handler;
}

void ${moduleName}_DefAddrInterruptHandler(void) {
    sAddr = ${msspI2cFunctions["getAddr"]}();
}

// Collision Event Interrupt Handlers
void  ${moduleName}_WCOLCallBack(void) {
    // Add your custom callback code here
    if ( ${moduleName}_WCOLInterruptHandler) {
         ${moduleName}_WCOLInterruptHandler();
    }
}

void ${i2cSlaveFunctions["setWCOLIntHandler"]}(interruptHandler handler) {
    ${moduleName}_WCOLInterruptHandler = handler;
}

void ${moduleName}_DefWCOLInterruptHandler(void) {
}
