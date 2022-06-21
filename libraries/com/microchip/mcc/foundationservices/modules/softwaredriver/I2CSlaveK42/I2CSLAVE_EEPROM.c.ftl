/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include "../${i2cDriverFunctions["i2cDriverHeader"]}"
#include "i2c_slave.h"

#define I2C1_SLAVE_ADDRESS ${deviceAddress} 
#define I2C1_SLAVE_MASK    ${addressMask}


/**
 Section: Global Variables
 */
typedef enum {ADDRESS, I2C_TX, I2C_RX} i2c_state_t;

static volatile uint8_t i2cSlaveAdd;
static volatile i2c_state_t state = ADDRESS;
static volatile bool eepromRegFlag = false;
static volatile uint8_t eepromAddress = 0x00;

static volatile uint8_t EEPROM_Buffer[0xFF] =
{
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,
    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,
    0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,
    0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,
    0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F,
    0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F,
    0x80,0x81,0x82,0x83,0x84,0x85,0x86,0x87,0x88,0x89,0x8A,0x8B,0x8C,0x8D,0x8E,0x8F,
    0x90,0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98,0x99,0x9A,0x9B,0x9C,0x9D,0x9E,0x9F,
    0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF,
    0xB0,0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7,0xB8,0xB9,0xBA,0xBB,0xBC,0xBD,0xBE,0xBF,
    0xC0,0xC1,0xC2,0xC3,0xC4,0xC5,0xC6,0xC7,0xC8,0xC9,0xCA,0xCB,0xCC,0xCD,0xCE,0xCF,
    0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7,0xD8,0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,0xDF,
    0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,0xE8,0xE9,0xEA,0xEB,0xEC,0xED,0xEE,0xEF,
    0xF0,0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE
};

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

void ${i2cSlaveFunctions["close"]}(void) 
{
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
        ${i2cDriverFunctions["clearBuffFlag"]}();
        ${i2cDriverFunctions["clearIRQ"]}();
        ${i2cDriverFunctions["setCounter"]}(0xFF);
        ${i2cDriverFunctions["releaseClock"]}();
        state = ADDRESS;
        eepromRegFlag = false;
        eepromAddress = 0x00; 
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
                    if(eepromRegFlag == false)
                    {    
                        eepromAddress = ${i2cDriverFunctions["getRxData"]}();
                        eepromRegFlag = true;   
                    }
                    else
                    {
                        ${moduleName}_RdCallBack();
                    }
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
    EEPROM_Buffer[eepromAddress] = ${i2cDriverFunctions["getRxData"]}();
    if(++eepromAddress == 0xFF)
        eepromAddress = 0x00;
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
    ${i2cDriverFunctions["sendTxData"]}(EEPROM_Buffer[eepromAddress]);
    if(++eepromAddress == 0xFF)
        eepromAddress = 0x00;
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
