/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include <stdbool.h>
#include <stdlib.h>
#include "${i2cMasterFunctions["masterheader"]}"
#include "i2c_types.h"
#include "../${i2cFunctions["i2cDriverHeader"]}"

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
    unsigned addressNACKCheck:2;
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
static i2c_fsm_states_t do_I2C_RX_EMPTY(void);
static i2c_fsm_states_t do_I2C_SEND_ADR_READ(void);
static i2c_fsm_states_t do_I2C_SEND_ADR_WRITE(void);

<#if timeoutDriverEnabled>
ABSOLUTETIME_t ${i2cMasterFunctions["timeoutHandler"]}(void *p);

// place this function someplace in a periodic interrupt
ABSOLUTETIME_t ${i2cMasterFunctions["timeoutHandler"]}(void *p)
{
    ${i2cFunctions["disableIRQ"]}();
    ${i2cMasterFunctions["status"]}.state = I2C_RESET; // Jump to the Timeout state
    ${i2cFunctions["enableIRQ"]}();
    ${i2cFunctions["setIRQ"]}(); // force an interrupt to handle the timeout
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
        
        ${i2cFunctions["initMasterHardware"]}();
        ${i2cFunctions["clearIRQ"]}();
        
        ${i2cFunctions["setBusCollisionISR"]}(${i2cMasterFunctions["busCollisionISR"]});
        ${i2cFunctions["setI2cISR"]}(${i2cFunctions["i2cIsrFunction"]});
        
        // uncomment the IRQ enable for an interrupt driven driver.
//        ${i2cFunctions["enableIRQ"]}();

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
        ${i2cFunctions["clearIRQ"]}();
        ${i2cFunctions["disableIRQ"]}();
        ret = ${i2cMasterFunctions["status"]}.error;
        ${i2cFunctions["close"]}();
    }
    return ret;
}

void ${i2cMasterFunctions["setTimeOut"]}(uint8_t to)
{
    ${i2cFunctions["disableIRQ"]}();
    ${i2cMasterFunctions["status"]}.time_out_value = to;
    ${i2cFunctions["enableIRQ"]}();
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

void ${i2cMasterFunctions["setI2cCounter"]}(size_t bufferSize)
{
    ${i2cFunctions["setCounter"]}(bufferSize);
}

void ${i2cMasterFunctions["enableI2cRestart"]}()
{
    ${i2cFunctions["enableRestart"]}();
}

void ${i2cMasterFunctions["disableI2cRestart"]}()
{
    ${i2cFunctions["disableRestart"]}();
}


i2c_error_t ${i2cMasterFunctions["masterOperation"]}(bool read)
{
    i2c_error_t ret = I2C_BUSY;
    if(!${i2cMasterFunctions["status"]}.busy)
    {
        ${i2cMasterFunctions["status"]}.busy = true;
        ret = I2C_NOERR;
        ${i2cFunctions["setCounter"]}(i2c_status.data_length);

        if(read)
        {
            ${i2cMasterFunctions["status"]}.state = I2C_RX;
            do_I2C_SEND_ADR_READ();
        }
        else
        {
            ${i2cMasterFunctions["status"]}.state = I2C_TX;
            do_I2C_SEND_ADR_WRITE();
        }
        
        if(! ${i2cFunctions["isIRQEnabled"]}())
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
        ${i2cFunctions["waitForEvent"]}(NULL);
        ${i2cFunctions["i2cIsrFunction"]}();
    }
}

static i2c_fsm_states_t do_I2C_RESET(void)
{
    ${i2cFunctions["resetBus"]}();
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
    ${i2cFunctions["setCounter"]}(i2c_status.data_length);
    return do_I2C_SEND_ADR_READ();
}

static i2c_fsm_states_t do_I2C_SEND_RESTART_WRITE(void)
{
   // ${i2cFunctions["restart"]}();
    return I2C_SEND_ADR_WRITE;
}

static i2c_fsm_states_t do_I2C_SEND_RESTART(void)
{
   // ${i2cFunctions["restart"]}();
    return I2C_SEND_ADR_READ;
}

static i2c_fsm_states_t do_I2C_SEND_STOP(void)
{
    ${i2cFunctions["stop"]}();
    if(${i2cFunctions["getCounter"]}())
    {
        ${i2cFunctions["setCounter"]}(0);
        ${i2cFunctions["sendTxData"]}(0);
    }
    return I2C_IDLE;
}

static i2c_fsm_states_t do_I2C_SEND_ADR_READ(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 2;
    if(${i2cMasterFunctions["status"]}.data_length ==  1)
    {
        //This device doesn't fire RXIF after the first byte is read so we must setup the callback first.
        do_I2C_RX_EMPTY();
    }
    ${i2cFunctions["sendTxData"]}(${i2cMasterFunctions["status"]}.address << 1 | 1);
    return I2C_RX;
}

static i2c_fsm_states_t do_I2C_SEND_ADR_WRITE(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 2;
    ${i2cFunctions["sendTxData"]}(${i2cMasterFunctions["status"]}.address << 1);
    return I2C_TX;
}

static i2c_fsm_states_t do_I2C_RCEN(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 0;
    //${i2cFunctions["startRX"]}();
    return I2C_RX;
}

static i2c_fsm_states_t do_I2C_DO_ACK(void)
{
    ${i2cFunctions["sendACK"]}();
    return I2C_RCEN;
}

static i2c_fsm_states_t do_I2C_DO_NACK_STOP(void)
{
    ${i2cFunctions["sendNACK"]}();
    return I2C_SEND_STOP;
}

static i2c_fsm_states_t do_I2C_DO_NACK_RESTART(void)
{
    ${i2cFunctions["sendNACK"]}();
    return I2C_SEND_RESTART;
}

// TODO: probably need 2 addressNACK's one from read and one from write.
//       the do NACK before RESTART or STOP is a special case that a new state simplifies.
static i2c_fsm_states_t do_I2C_DO_ADDRESS_NACK(void)
{
    ${i2cMasterFunctions["status"]}.addressNACKCheck = 0;
    ${i2cMasterFunctions["status"]}.error = I2C_FAIL;
    ${i2cMasterFunctions["status"]}.busy = false;
    switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_addressNACK](${i2cMasterFunctions["status"]}.callbackPayload[i2c_addressNACK]))
    {
        default:
            return I2C_RESET;
    }
}


static i2c_fsm_states_t do_I2C_TX_EMPTY(void)
{
    ${i2cMasterFunctions["status"]}.bufferFree = true;
    switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_dataComplete](${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataComplete]))
    {
        case i2c_restart_read:
            ${i2cFunctions["enableRestart"]}();
            return I2C_SEND_RESTART_READ;
        case i2c_continue:
            // Avoid the counter stop condition , Counter is incremented by 1
            ${i2cFunctions["setCounter"]}(i2c_status.data_length + 1);
            return I2C_TX;
        default:
        case i2c_stop:
            ${i2cFunctions["disableRestart"]}();
            return I2C_SEND_STOP;
    }
}

static i2c_fsm_states_t do_I2C_RX_EMPTY(void)
{
    ${i2cMasterFunctions["status"]}.bufferFree = true;
    switch(${i2cMasterFunctions["status"]}.callbackTable[i2c_dataComplete](${i2cMasterFunctions["status"]}.callbackPayload[i2c_dataComplete]))
    {
        case i2c_restart_write:
            ${i2cFunctions["enableRestart"]}();
            return I2C_SEND_RESTART_WRITE;
        case i2c_restart_read:
            ${i2cFunctions["enableRestart"]}();
            return I2C_SEND_RESTART_READ;
        case i2c_continue:
            // Avoid the counter stop condition , Counter is incremented by 1
            ${i2cFunctions["setCounter"]}(i2c_status.data_length + 1);
            return I2C_RX;
        default:
        case i2c_stop:
            if(${i2cMasterFunctions["status"]}.state != I2C_SEND_RESTART_READ)
            {
                ${i2cFunctions["disableRestart"]}();
            }
            return I2C_RESET;
    }
}

static i2c_fsm_states_t do_I2C_TX(void)
{
    if(${i2cFunctions["isNACK"]}())
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
                return I2C_IDLE;
        }
    }
    else if(${i2cFunctions["isTxBufEmpty"]}())
    {
        if(${i2cMasterFunctions["status"]}.addressNACKCheck)
        {
            //make sure we don't disable the address nack check if 
            //the address was just sent
            ${i2cMasterFunctions["status"]}.addressNACKCheck--;
        }
        uint8_t dataTx = *i2c_status.data_ptr++;
        i2c_fsm_states_t retFsmState = (--${i2cMasterFunctions["status"]}.data_length)?I2C_TX:do_I2C_TX_EMPTY();
        ${i2cFunctions["sendTxData"]}(dataTx);
        return retFsmState;
    }
    else
    {
        return I2C_TX;
    }
}

static i2c_fsm_states_t do_I2C_RX(void)
{
    if(!${i2cFunctions["isRxBufFull"]}())
    {
        return I2C_RX;
    }
    if(${i2cMasterFunctions["status"]}.addressNACKCheck)
    {
        //make sure we don't disable the address nack check if 
        //the address was just sent
        ${i2cMasterFunctions["status"]}.addressNACKCheck--;
    }

    if(--${i2cMasterFunctions["status"]}.data_length)
    {
        *${i2cMasterFunctions["status"]}.data_ptr++ = ${i2cFunctions["getRxData"]}();
        return I2C_RX;
    }
    else
    {
        i2c_fsm_states_t retFsmState = do_I2C_RX_EMPTY();
        *${i2cMasterFunctions["status"]}.data_ptr++ = ${i2cFunctions["getRxData"]}();
        return retFsmState;
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

void ${i2cMasterFunctions["clearI2cFlags"]}(void)
{
    if(${i2cFunctions["isCountFlagSet"]}())
    {
        ${i2cFunctions["clearCountFlag"]}();
    }
    else if(${i2cFunctions["isStopFlagSet"]}())
    {
        ${i2cFunctions["clearStopFlag"]}();
    }
    else if(${i2cFunctions["isNackFlagSet"]}())
    {
        ${i2cFunctions["clearNackFlag"]}();
    }
}

void ${i2cFunctions["i2cIsrFunction"]}(void)
{
    ${i2cMasterFunctions["clearI2cFlags"]}();

    // NACK After address override Exception handler
    if(${i2cMasterFunctions["status"]}.addressNACKCheck && ${i2cFunctions["isNACK"]}())
    {
        ${i2cMasterFunctions["status"]}.state = I2C_ADDRESS_NACK; // State Override
    }

    ${i2cMasterFunctions["status"]}.state = fsmStateTable[${i2cMasterFunctions["status"]}.state]();
}

void ${i2cMasterFunctions["busCollisionISR"]}(void)
{
    ${i2cFunctions["clearBusCollision"]}();
    ${i2cMasterFunctions["status"]}.state = I2C_RESET;
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
