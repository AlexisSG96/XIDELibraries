/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include <stdbool.h>
#include <stdlib.h>
#include "${i2cMasterFunctions["masterheader"]}"
#include "i2c_types.h"
#include "../${msspI2cFunctions["i2cHeader"]}"
<#if timeoutDriverEnabled>
#include "timeout.h"  // TODO: Add timeout integration
</#if>

/***************************************************************************/
// I2C STATES
typedef enum {
    I2C_IDLE = 0,
    I2C_SEND_ADR_READ,
    I2C_SEND_ADR_WRITE,
    I2C_TX,
    I2C_RX,
    I2C_RCEN,
    I2C_TX_EMPTY,
    I2C_SEND_RESTART_READ,
    I2C_SEND_RESTART_WRITE,
    I2C_SEND_RESTART,
    I2C_SEND_STOP,
    I2C_RX_DO_ACK,
    I2C_RX_DO_NACK_STOP,
    I2C_RX_DO_NACK_RESTART,
    I2C_RESET,
    I2C_ADDRESS_NACK
} i2c_fsm_states_t;

// I2C Event Callback List
typedef enum
{
    i2c_dataComplete = 0,
    i2c_writeCollision,
    i2c_addressNACK,
    i2c_dataNACK,
    i2c_timeOut,
    i2c_NULL
} i2c_callbackIndex;

// I2C Status Structure
typedef struct
{
    unsigned busy:1;
    unsigned inUse:1;
    unsigned bufferFree:1;
    unsigned addressNACKCheck:1;
    i2c_address_t address;       /// The I2C Address
    uint8_t *data_ptr;           /// pointer to a data buffer
    size_t data_length;          /// Bytes in the data buffer
    uint16_t time_out;           /// I2C Timeout Counter between I2C Events.
    uint16_t time_out_value;     /// Reload value for the timeouts
    i2c_fsm_states_t state;      /// Driver State
    i2c_error_t error;
    <#if timeoutDriverEnabled>
    timerStruct_t timeout;
    </#if>
    i2c_callback callbackTable[6];
    void *callbackPayload[6];    ///  each callback can have a payload
} i2c_status_t;

i2c_status_t ${i2cMasterFunctions["status"]} = {0};

static void setCallBack(i2c_callbackIndex idx, i2c_callback cb, void *p);
static i2c_operations_t returnStop(void *p);
static i2c_operations_t returnReset(void *p);

inline void ${i2cMasterFunctions["poller"]}(void);

<#if timeoutDriverEnabled>
ABSOLUTETIME_t ${i2cMasterFunctions["timeoutHandler"]}(void *p);

// place this function someplace in a periodic interrupt
ABSOLUTETIME_t ${i2cMasterFunctions["timeoutHandler"]}(void *p)
{
    ${msspI2cFunctions["disableIRQ"]}();
    ${i2cMasterFunctions["status"]}.state = I2C_RESET; // Jump to the Timeout state
    ${msspI2cFunctions["enableIRQ"]}();
    ${msspI2cFunctions["setIRQ"]}(); // force an interrupt to handle the timeout
    return 0;
}
</#if>

void ${i2cMasterFunctions["setDataCompleteCallback"]}(i2c_callback cb, void *p)
{
    setCallBack(i2c_dataComplete,cb,p);
}

void ${i2cMasterFunctions["setWriteCollisionCallback"]}(i2c_callback cb, void *p)
{
    setCallBack(i2c_writeCollision,cb,p);
}

void ${i2cMasterFunctions["setAddressNACKCallback"]}(i2c_callback cb, void *p)
{
    setCallBack(i2c_addressNACK,cb,p);
}

void ${i2cMasterFunctions["setDataNACKCallback"]}(i2c_callback cb, void *p)
{
    setCallBack(i2c_dataNACK,cb,p);
}

void ${i2cMasterFunctions["setTimeOutCallback"]}(i2c_callback cb, void *p)
{
    setCallBack(i2c_timeOut,cb,p);    
}

// when you call open, you supply a device address.
// if you get the bus, the function returns true
i2c_error_t ${i2cMasterFunctions["open"]}(i2c_address_t address)
{
    i2c_error_t ret = I2C_BUSY;
    
    if(!${i2cMasterFunctions["status"]}.inUse)
    {
        ${i2cMasterFunctions["status"]}.address = address;
        ${i2cMasterFunctions["status"]}.busy = 0;
        ${i2cMasterFunctions["status"]}.inUse = 1;
        ${i2cMasterFunctions["status"]}.addressNACKCheck = 0;
        ${i2cMasterFunctions["status"]}.state = I2C_RESET;
        ${i2cMasterFunctions["status"]}.time_out_value = 500; // MCC should determine a reasonable starting value here.
        ${i2cMasterFunctions["status"]}.bufferFree = 1;
        <#if timeoutDriverEnabled>
        ${i2cMasterFunctions["status"]}.timeout.callbackPtr = ${i2cMasterFunctions["timeoutHandler"]};
        </#if>

        // set all the call backs to a default of sending stop
        ${i2cMasterFunctions["status"]}.callbackTable[i2c_dataComplete]=returnStop;
        ${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataComplete] = NULL;
        ${i2cMasterFunctions["status"]}.callbackTable[i2c_writeCollision]=returnStop;
        ${i2cMasterFunctions["status"]}.callbackPayload[i2c_writeCollision] = NULL;
        ${i2cMasterFunctions["status"]}.callbackTable[i2c_addressNACK]=returnStop;
        ${i2cMasterFunctions["status"]}.callbackPayload[i2c_addressNACK] = NULL;
        ${i2cMasterFunctions["status"]}.callbackTable[i2c_dataNACK]=returnStop;
        ${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataNACK] = NULL;
        ${i2cMasterFunctions["status"]}.callbackTable[i2c_timeOut]=returnReset;
        ${i2cMasterFunctions["status"]}.callbackPayload[i2c_timeOut] = NULL;
        
        ${msspI2cFunctions["initMasterHardware"]}();
        ${msspI2cFunctions["clearIRQ"]}();
        
        ${msspI2cFunctions["setBusCollisionISR"]}(${i2cMasterFunctions["busCollisionISR"]});
        ${msspI2cFunctions["setI2cISR"]}(${i2cMasterFunctions["masterISR"]});
        
        // uncomment the IRQ enable for an interrupt driven driver.
//        ${msspI2cFunctions["enableIRQ"]}();

        ret = I2C_NOERR;
    }
    return ret;
}

void ${i2cMasterFunctions["setAddress"]}(i2c_address_t address)
{
    ${i2cMasterFunctions["status"]}.address = address;
}

// close the bus if it is not busy and it is my address
i2c_error_t ${i2cMasterFunctions["close"]}(void)
{
    i2c_error_t ret = I2C_BUSY;
    if(!${i2cMasterFunctions["status"]}.busy)
    {
        ${i2cMasterFunctions["status"]}.inUse = 0;
        // close it down
        ${i2cMasterFunctions["status"]}.address = 0xff; // 8-bit address is invalid so this is FREE
        ${msspI2cFunctions["clearIRQ"]}();
        ${msspI2cFunctions["disableIRQ"]}();
        ret = ${i2cMasterFunctions["status"]}.error;
    }
    return ret;
}

void ${i2cMasterFunctions["setTimeOut"]}(uint8_t to)
{
    ${msspI2cFunctions["disableIRQ"]}();
    ${i2cMasterFunctions["status"]}.time_out_value = to;
    ${msspI2cFunctions["enableIRQ"]}();
}

void ${i2cMasterFunctions["setBuffer"]}(void *buffer, size_t bufferSize)
{
    if(${i2cMasterFunctions["status"]}.bufferFree)
    {
        ${i2cMasterFunctions["status"]}.data_ptr = buffer;
        ${i2cMasterFunctions["status"]}.data_length = bufferSize;
        ${i2cMasterFunctions["status"]}.bufferFree = false;
    }
}
i2c_error_t ${i2cMasterFunctions["masterOperation"]}(bool read)
{
    i2c_error_t ret = I2C_BUSY;
    if(!${i2cMasterFunctions["status"]}.busy)
    {
        ${i2cMasterFunctions["status"]}.busy = true;
        ret = I2C_NOERR;
        
        if(read)
        {
            ${i2cMasterFunctions["status"]}.state = I2C_SEND_ADR_READ;
        }
        else
        {
            ${i2cMasterFunctions["status"]}.state = I2C_SEND_ADR_WRITE;
        }
        ${msspI2cFunctions["start"]}();
        
        if(! ${msspI2cFunctions["IRQisEnabled"]}())
            ${i2cMasterFunctions["poller"]}();
    }
    return ret;
}

i2c_error_t ${i2cMasterFunctions["masterRead"]}(void)
{
    return ${i2cMasterFunctions["masterOperation"]}(true);
}

i2c_error_t ${i2cMasterFunctions["masterWrite"]}(void)
{
    return ${i2cMasterFunctions["masterOperation"]}(false);
}

/************************************************************************/
/* Helper Functions                                                     */
/************************************************************************/
inline void ${i2cMasterFunctions["poller"]}(void)
{
    while(${i2cMasterFunctions["status"]}.busy)
    {
        ${msspI2cFunctions["waitForEvent"]}(NULL);
        ${i2cMasterFunctions["masterISR"]}();
    }
}

static i2c_fsm_states_t do_I2C_RESET(void)
{
    ${msspI2cFunctions["resetBus"]}();
    ${i2cMasterFunctions["status"]}.busy = false; // Bus Free
    ${i2cMasterFunctions["status"]}.error = I2C_NOERR;
    return I2C_RESET; // park the FSM on reset
}

static i2c_fsm_states_t do_I2C_IDLE(void)
{
    ${i2cMasterFunctions["status"]}.busy = false; // Bus Free
    ${i2cMasterFunctions["status"]}.error = I2C_NOERR;
    return I2C_RESET; // park the FSM on reset
}

static i2c_fsm_states_t do_I2C_SEND_RESTART_READ(void)
{
    ${msspI2cFunctions["restart"]}();
    return I2C_SEND_ADR_READ;
}

static i2c_fsm_states_t do_I2C_SEND_RESTART_WRITE(void)
{
    ${msspI2cFunctions["restart"]}();
    return I2C_SEND_ADR_WRITE;
}

static i2c_fsm_states_t do_I2C_SEND_RESTART(void)
{
    ${msspI2cFunctions["restart"]}();
    return I2C_SEND_ADR_READ;
}

static i2c_fsm_states_t do_I2C_SEND_STOP(void)
{
    ${msspI2cFunctions["stop"]}();
    return I2C_IDLE;
}

static i2c_fsm_states_t do_I2C_SEND_ADR_READ(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 1;
    ${msspI2cFunctions["TXData"]}(${i2cMasterFunctions["status"]}.address << 1 | 1);
    return I2C_RCEN;
}

static i2c_fsm_states_t do_I2C_SEND_ADR_WRITE(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 1;
    ${msspI2cFunctions["TXData"]}(${i2cMasterFunctions["status"]}.address << 1);
    return I2C_TX;
}

static i2c_fsm_states_t do_I2C_RCEN(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 0;
    ${msspI2cFunctions["startRX"]}();
    return I2C_RX;
}

static i2c_fsm_states_t do_I2C_DO_ACK(void)
{
    ${msspI2cFunctions["sendACK"]}();
    return I2C_RCEN;
}

static i2c_fsm_states_t do_I2C_DO_NACK_STOP(void)
{
    ${msspI2cFunctions["sendNACK"]}();
    return I2C_SEND_STOP;
}

static i2c_fsm_states_t do_I2C_DO_NACK_RESTART(void)
{
    ${msspI2cFunctions["sendNACK"]}();
    return I2C_SEND_RESTART;
}

// TODO: probably need 2 addressNACK's one from read and one from write.
//       the do NACK before RESTART or STOP is a special case that a new state simplifies.
static i2c_fsm_states_t do_I2C_DO_ADDRESS_NACK(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 0;
    ${i2cMasterFunctions["status"]}.error = I2C_FAIL;
    switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_addressNACK](${i2cMasterFunctions["status"]}.callbackPayload[i2c_addressNACK]))
    {
        case i2c_restart_read:
        case i2c_restart_write:
            return do_I2C_SEND_RESTART();
        default:
            return do_I2C_SEND_STOP();
    }
}

static i2c_fsm_states_t do_I2C_TX(void)
{
    if(${msspI2cFunctions["isNACK"]}())
    {
        switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_dataNACK](${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataNACK]))
        {
            case i2c_restart_read:
                return do_I2C_SEND_RESTART_READ();
            case i2c_restart_write:
                return do_I2C_SEND_RESTART_WRITE();
            default:
            case i2c_continue:
            case i2c_stop:
                return do_I2C_SEND_STOP();
        }
    }
    else
    {
        ${i2cMasterFunctions["status"]}.addressNACKCheck = 0;
        ${msspI2cFunctions["TXData"]}(*${i2cMasterFunctions["status"]}.data_ptr++);
        return (--${i2cMasterFunctions["status"]}.data_length)?I2C_TX:I2C_TX_EMPTY;
    }
}

static i2c_fsm_states_t do_I2C_RX(void)
{
    *${i2cMasterFunctions["status"]}.data_ptr++ = ${msspI2cFunctions["getRXData"]}();
    if(--${i2cMasterFunctions["status"]}.data_length)
    {
        ${msspI2cFunctions["sendACK"]}();
        return I2C_RCEN;
    }
    else
    {
        ${i2cMasterFunctions["status"]}.bufferFree = true;
        switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_dataComplete](${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataComplete]))
        {
            case i2c_restart_write:
            case i2c_restart_read:
                return do_I2C_DO_NACK_RESTART();
            default:
            case i2c_continue:
            case i2c_stop:
                return do_I2C_DO_NACK_STOP();
        }

    }
}

static i2c_fsm_states_t do_I2C_TX_EMPTY(void)
{
    ${i2cMasterFunctions["status"]}.bufferFree = true;
    switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_dataComplete](${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataComplete]))
    {
        case i2c_restart_read:
        case i2c_restart_write:
            return do_I2C_SEND_RESTART();
        case i2c_continue:
            ${msspI2cFunctions["setIRQ"]}();
            return I2C_TX;
        default:
        case i2c_stop:
            return do_I2C_SEND_STOP();
    }
}

typedef i2c_fsm_states_t (*stateHandlerFunction)(void);
const stateHandlerFunction fsmStateTable[] = {
    do_I2C_IDLE,                //I2C_IDLE
    do_I2C_SEND_ADR_READ,       //I2C_SEND_ADR_READ
    do_I2C_SEND_ADR_WRITE,      //I2C_SEND_ADR_WRITE
    do_I2C_TX,                  //I2C_TX
    do_I2C_RX,                  //I2C_RX
    do_I2C_RCEN,                //I2C_RCEN
    do_I2C_TX_EMPTY,            //I2C_TX_EMPTY
    do_I2C_SEND_RESTART_READ,   //I2C_SEND_RESTART_READ
    do_I2C_SEND_RESTART_WRITE,  //I2C_SEND_RESTART_WRITE
    do_I2C_SEND_RESTART,        //I2C_SEND_RESTART
    do_I2C_SEND_STOP,           //I2C_SEND_STOP
    do_I2C_DO_ACK,              //I2C_RX_DO_ACK
    do_I2C_DO_NACK_STOP,        //I2C_RX_DO_NACK_STOP
    do_I2C_DO_NACK_RESTART,     //I2C_RX_DO_NACK_RESTART
    do_I2C_RESET,               //I2C_RESET
    do_I2C_DO_ADDRESS_NACK      //I2C_ADDRESS_NACK
};

void ${i2cMasterFunctions["masterISR"]}(void)
{       
    ${msspI2cFunctions["clearIRQ"]}();
    
    // NOTE: We are ignoring the Write Collision flag.
    // the write collision is when SSPBUF is written prematurely (2x in a row without sending)

    // NACK After address override Exception handler
    if(${i2cMasterFunctions["status"]}.addressNACKCheck && ${msspI2cFunctions["isNACK"]}())
    {
        ${i2cMasterFunctions["status"]}.state = I2C_ADDRESS_NACK; // State Override
    }

    ${i2cMasterFunctions["status"]}.state = fsmStateTable[${i2cMasterFunctions["status"]}.state]();
}

void ${i2cMasterFunctions["busCollisionISR"]}(void)
{
    ${msspI2cFunctions["clearBusCollision"]}();
}

/************************************************************************/
/* Helper Functions                                                     */
/************************************************************************/
static i2c_operations_t returnStop(void *p)
{
    return i2c_stop;
}

static i2c_operations_t returnReset(void *p)
{
    return i2c_reset_link;
}

static void setCallBack(i2c_callbackIndex idx, i2c_callback cb, void *p)
{
    if(cb)
    {
        ${i2cMasterFunctions["status"]}.callbackTable[idx] = cb;
        ${i2cMasterFunctions["status"]}.callbackPayload[idx] = p;
    }
    else
    {
        ${i2cMasterFunctions["status"]}.callbackTable[idx] = returnStop;
        ${i2cMasterFunctions["status"]}.callbackPayload[idx] = NULL;
    }
}
