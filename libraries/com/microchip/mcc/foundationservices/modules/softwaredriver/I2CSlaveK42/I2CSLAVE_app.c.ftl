/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include "../${i2cDriverFunctions["i2cDriverHeader"]}"
#include "i2c_slave.h"

#define I2C1_SLAVE_ADDRESS    ${deviceAddress} 
#define I2C1_SLAVE_MASK       ${addressMask}

/**
 Section: Global Variables
 */

typedef enum {ADDRESS, I2C_TX, I2C_RX} i2c_state_t;

static volatile i2c_state_t state = ADDRESS;
volatile uint8_t i2cWrData;
volatile uint8_t i2cRdData;
volatile uint8_t i2cSlaveAdd;

/**
 Section: Local Functions
 */

void ${i2cSlaveFunctions["open"]}(void) {

    ${i2cDriverFunctions["initSlaveHardware"]}();
    ${i2cDriverFunctions["setSlaveAddr"]}(I2C1_SLAVE_ADDRESS << 1);
    ${i2cDriverFunctions["setSlaveMask"]}(I2C1_SLAVE_MASK << 1);
    ${i2cDriverFunctions["setBusCollisionISR"]}(${moduleName}_BusCollisionISR);
    ${i2cSlaveFunctions["setWriteIntHandler"]}(${moduleName}_DefWrInterruptHandler);
    ${i2cSlaveFunctions["setReadIntHandler"]}(${moduleName}_DefRdInterruptHandler);
    ${i2cSlaveFunctions["setAddrIntHandler"]}(${moduleName}_DefAddrInterruptHandler);
    ${i2cSlaveFunctions["setWCOLIntHandler"]}(${moduleName}_BusCollisionISR);
    ${i2cDriverFunctions["enableSlaveIRQ"]}();
}

void ${i2cSlaveFunctions["close"]}(void) {
    ${i2cDriverFunctions["close"]}();
}

void ${i2cDriverFunctions["i2cIsrFunction"]}()
{
    if(${i2cDriverFunctions["isAddress"]}())
    {
        if(${i2cDriverFunctions["isRead"]}())
        {
            state = I2C_TX;
        }
        else
        {
            state = I2C_RX;
        }
        ${i2cDriverFunctions["clearAddrFlag"]}();
        ${i2cDriverFunctions["clearStartFlag"]}();
    }
    
    if(${i2cDriverFunctions["isStop"]}())
    {
        ${i2cDriverFunctions["clearIRQ"]}();
        ${i2cDriverFunctions["setCounter"]}(0xFF);
        ${i2cDriverFunctions["releaseClock"]}();
        state = ADDRESS;
        return;
    }
    
    switch(state)
    {          
        case I2C_TX:
            if(!${i2cDriverFunctions["isWriteCollision"]}()) 
            {
                if(${i2cDriverFunctions["isTxBufEmpty"]}())
                {
                    ${moduleName}_WrCallBack();
                }
            }    
            else
            {
                ${moduleName}_WCOLCallBack();
                ${i2cDriverFunctions["resetBus"]}();
            }
            break;

        case I2C_RX:
            if(${i2cDriverFunctions["isData"]}())
            {
                if(${i2cDriverFunctions["isRxBufFull"]}())
                {
                    ${moduleName}_RdCallBack();
                }           
            }
            break;
        default:          
            break;
    }
    ${i2cDriverFunctions["releaseClock"]}();
}

void ${moduleName}_BusCollisionISR(void) {
    
}

uint8_t ${i2cSlaveFunctions["read"]}(void) {
    return ${i2cDriverFunctions["getRxData"]}();
}

void ${i2cSlaveFunctions["write"]}(uint8_t data) {
    ${i2cDriverFunctions["sendTxData"]}(data);
}

void ${i2cSlaveFunctions["enable"]}(void) {
    ${i2cDriverFunctions["initSlaveHardware"]}();
}

void ${i2cSlaveFunctions["sendAck"]}(void) {
    ${i2cDriverFunctions["sendACK"]}();
}

void ${i2cSlaveFunctions["sendNack"]}(void) {
    ${i2cDriverFunctions["sendNACK"]}();
}

// Read Event Interrupt Handlers
void ${moduleName}_RdCallBack(void) {
    // Add your custom callback code here
    if (${moduleName}_RdInterruptHandler) {
        ${moduleName}_RdInterruptHandler();
    }
}

void ${i2cSlaveFunctions["setIsrHandler"]}(interruptHandler handler) {
    ${i2cDriverFunctions["setI2cISR"]}(handler);
}

void ${i2cSlaveFunctions["setBusCollisionISR"]}(interruptHandler handler) {
    ${i2cDriverFunctions["setBusCollisionISR"]}(handler);
}

void ${i2cSlaveFunctions["setReadIntHandler"]}(interruptHandler handler) {
    ${moduleName}_RdInterruptHandler = handler;
}

void ${moduleName}_DefRdInterruptHandler(void) {
    i2cRdData = ${i2cDriverFunctions["getRxData"]}();
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
    ${i2cDriverFunctions["sendTxData"]}(i2cWrData);
    i2cWrData++;
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
    i2cSlaveAdd = ${i2cDriverFunctions["getAddr"]}();
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
