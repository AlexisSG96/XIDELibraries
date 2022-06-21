/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}_master.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#include "${moduleNameLowerCase}_master.h"
#include <xc.h>

// ${moduleNameUpperCase} STATES
typedef enum {
    ${moduleNameUpperCase}_IDLE = 0,
    ${moduleNameUpperCase}_SEND_ADR_READ,
    ${moduleNameUpperCase}_SEND_ADR_WRITE,
    ${moduleNameUpperCase}_TX,
    ${moduleNameUpperCase}_RX,
    ${moduleNameUpperCase}_TX_EMPTY,
    ${moduleNameUpperCase}_RX_EMPTY,        
    ${moduleNameUpperCase}_SEND_RESTART_READ,
    ${moduleNameUpperCase}_SEND_RESTART_WRITE,
    ${moduleNameUpperCase}_SEND_RESTART,
    ${moduleNameUpperCase}_SEND_STOP,
    ${moduleNameUpperCase}_RX_ACK,
    ${moduleNameUpperCase}_TX_ACK,
    ${moduleNameUpperCase}_RX_NACK_STOP,
    ${moduleNameUpperCase}_RX_NACK_RESTART,
    ${moduleNameUpperCase}_RESET,
    ${moduleNameUpperCase}_ADDRESS_NACK,
    ${moduleNameUpperCase}_BUS_COLLISION,
    ${moduleNameUpperCase}_BUS_ERROR
} ${moduleNameLowerCase}_fsm_states_t;

// ${moduleNameUpperCase} Event callBack List
typedef enum {
    ${moduleNameUpperCase}_DATA_COMPLETE = 0,
    ${moduleNameUpperCase}_WRITE_COLLISION,
    ${moduleNameUpperCase}_ADDR_NACK,
    ${moduleNameUpperCase}_DATA_NACK,
    ${moduleNameUpperCase}_TIMEOUT,
    ${moduleNameUpperCase}_NULL
} ${moduleNameLowerCase}_callbackIndex_t;

// ${moduleNameUpperCase} Status Structure
typedef struct
{
    ${moduleNameLowerCase}_callback_t callbackTable[6];
    void *callbackPayload[6];           //  each callBack can have a payload
    uint16_t time_out;                  // ${moduleNameUpperCase} Timeout Counter between ${moduleNameUpperCase} Events.
    uint16_t time_out_value;            // Reload value for the timeouts
    ${moduleNameLowerCase}_address_t address;             // The ${moduleNameUpperCase} Address
    uint8_t *data_ptr;                  // pointer to a data buffer
    size_t data_length;                 // Bytes in the data buffer
    ${moduleNameLowerCase}_fsm_states_t state;            // Driver State
    ${moduleNameLowerCase}_error_t error;
    unsigned addressNackCheck:2;
    unsigned busy:1;
    unsigned inUse:1;
    unsigned bufferFree:1;

} ${moduleNameLowerCase}_status_t;

static void ${moduleNameUpperCase}_SetCallback(${moduleNameLowerCase}_callbackIndex_t idx, ${moduleNameLowerCase}_callback_t cb, void *ptr);
static void ${moduleNameUpperCase}_MasterIsr(void);
static inline void ${moduleNameUpperCase}_ClearInterruptFlags(void);
static inline void ${moduleNameUpperCase}_MasterFsm(void);

/* ${moduleNameUpperCase} interfaces */
static inline bool ${moduleNameUpperCase}_MasterOpen(void);
static inline void ${moduleNameUpperCase}_MasterClose(void);    
static inline uint8_t ${moduleNameUpperCase}_MasterGetRxData(void);
static inline void ${moduleNameUpperCase}_MasterSendTxData(uint8_t data);
static inline void ${moduleNameUpperCase}_MasterSetCounter(uint8_t counter);
static inline uint8_t ${moduleNameUpperCase}_MasterGetCounter();
static inline void ${moduleNameUpperCase}_MasterResetBus(void);
static inline void ${moduleNameUpperCase}_MasterEnableRestart(void);
static inline void ${moduleNameUpperCase}_MasterDisableRestart(void);
static inline void ${moduleNameUpperCase}_MasterStop(void);
static inline bool ${moduleNameUpperCase}_MasterIsNack(void);
static inline void ${moduleNameUpperCase}_MasterSendAck(void);
static inline void ${moduleNameUpperCase}_MasterSendNack(void);
static inline void ${moduleNameUpperCase}_MasterClearBusCollision(void);
static inline bool ${moduleNameUpperCase}_MasterIsRxBufFull(void);
static inline bool ${moduleNameUpperCase}_MasterIsTxBufEmpty(void);
static inline bool ${moduleNameUpperCase}_MasterIsStopFlagSet(void);
static inline bool ${moduleNameUpperCase}_MasterIsCountFlagSet(void);
static inline bool ${moduleNameUpperCase}_MasterIsNackFlagSet(void);
static inline void ${moduleNameUpperCase}_MasterClearStopFlag(void);
static inline void ${moduleNameUpperCase}_MasterClearCountFlag(void);
static inline void ${moduleNameUpperCase}_MasterClearNackFlag(void);

/* Interrupt interfaces */
static inline void ${moduleNameUpperCase}_MasterEnableIrq(void);
static inline bool ${moduleNameUpperCase}_MasterIsIrqEnabled(void);
static inline void ${moduleNameUpperCase}_MasterDisableIrq(void);
static inline void ${moduleNameUpperCase}_MasterClearIrq(void);
static inline void ${moduleNameUpperCase}_MasterWaitForEvent(void);

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_IDLE(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_READ(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_WRITE(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX_EMPTY(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_EMPTY(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_READ(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_STOP(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_ACK(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX_ACK(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_STOP(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_RESTART(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RESET(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_ADDRESS_NACK(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_BUS_COLLISION(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_BUS_ERROR(void);

typedef ${moduleNameLowerCase}_fsm_states_t (*${moduleNameLowerCase}FsmHandler)(void);
const ${moduleNameLowerCase}FsmHandler ${moduleNameLowerCase}_fsmStateTable[] = {
    ${moduleNameUpperCase}_DO_IDLE,
    ${moduleNameUpperCase}_DO_SEND_ADR_READ,
    ${moduleNameUpperCase}_DO_SEND_ADR_WRITE,
    ${moduleNameUpperCase}_DO_TX,
    ${moduleNameUpperCase}_DO_RX,
    ${moduleNameUpperCase}_DO_TX_EMPTY,
    ${moduleNameUpperCase}_DO_RX_EMPTY,
    ${moduleNameUpperCase}_DO_SEND_RESTART_READ,
    ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE,
    ${moduleNameUpperCase}_DO_SEND_RESTART,
    ${moduleNameUpperCase}_DO_SEND_STOP,
    ${moduleNameUpperCase}_DO_RX_ACK,
    ${moduleNameUpperCase}_DO_TX_ACK,
    ${moduleNameUpperCase}_DO_RX_NACK_STOP,
    ${moduleNameUpperCase}_DO_RX_NACK_RESTART,
    ${moduleNameUpperCase}_DO_RESET,
    ${moduleNameUpperCase}_DO_ADDRESS_NACK,
    ${moduleNameUpperCase}_DO_BUS_COLLISION,
    ${moduleNameUpperCase}_DO_BUS_ERROR
};

${moduleNameLowerCase}_status_t ${moduleNameUpperCase}_Status = {0};

void ${moduleNameUpperCase}_Initialize()
{
    <#if I2CCON0??>
    //${I2CCON0.csvComment}
    ${I2CCON0.name} = ${I2CCON0.hexValue};
    </#if>
    <#if I2CCON1??>
    //${I2CCON1.csvComment}
    ${I2CCON1.name} = ${I2CCON1.hexValue};
    </#if>
    <#if I2CCON2??>
    //${I2CCON2.csvComment}
    ${I2CCON2.name} = ${I2CCON2.hexValue};
    </#if>
    <#if I2CCLK??>
    //${I2CCLK.csvComment}
    ${I2CCLK.name} = ${I2CCLK.hexValue};
    </#if>
    <#if I2CPIR??>
    //${I2CPIR.csvComment}
    ${I2CPIR.name} = ${I2CPIR.hexValue};
    </#if>
    <#if I2CPIE??>
    //${I2CPIE.csvComment}
    ${I2CPIE.name} = ${I2CPIE.hexValue};
    </#if>
    <#if I2CERR??>
    //${I2CERR.csvComment}
    ${I2CERR.name} = ${I2CERR.hexValue};
    </#if>
    <#if I2CCNT??>
    //Count register 
    ${I2CCNT.name} = ${I2CCNT.hexValue};
    <#elseif I2CCNTL??>
    //Count register
    ${I2CCNTL.name} = ${I2CCNTL.hexValue};
    <#if I2CCNTH??>
    ${I2CCNTH.name} = ${I2CCNTH.hexValue};
    </#if>
    </#if>
    <#if I2CBAUD??>
    //${I2CBAUD.csvComment}
    ${I2CBAUD.name} = ${I2CBAUD.hexValue};
    </#if>
    return;
}

${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_Open(${moduleNameLowerCase}_address_t address)
{
    ${moduleNameLowerCase}_error_t returnValue = ${moduleNameUpperCase}_BUSY;
    
    if(!${moduleNameUpperCase}_Status.inUse)
    {
        ${moduleNameUpperCase}_Status.address = address;
        ${moduleNameUpperCase}_Status.busy = 0;
        ${moduleNameUpperCase}_Status.inUse = 1;
        ${moduleNameUpperCase}_Status.addressNackCheck = 0;
        ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_RESET;
        ${moduleNameUpperCase}_Status.time_out_value = 500; // MCC should determine a reasonable starting value here.
        ${moduleNameUpperCase}_Status.bufferFree = 1;

        // set all the call backs to a default of sending stop
        ${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_COMPLETE]=${moduleNameUpperCase}_CallbackReturnStop;
        ${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_COMPLETE] = NULL;
        ${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_WRITE_COLLISION]=${moduleNameUpperCase}_CallbackReturnStop;
        ${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_WRITE_COLLISION] = NULL;
        ${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_ADDR_NACK]=${moduleNameUpperCase}_CallbackReturnStop;
        ${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_ADDR_NACK] = NULL;
        ${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_NACK]=${moduleNameUpperCase}_CallbackReturnStop;
        ${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_NACK] = NULL;
        ${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_TIMEOUT]=${moduleNameUpperCase}_CallbackReturnReset;
        ${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_TIMEOUT] = NULL;

        ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameUpperCase}_MasterIsr);
        ${moduleNameUpperCase}_MasterClearIrq();
        ${moduleNameUpperCase}_MasterOpen();
        ${moduleNameUpperCase}_MasterEnableIrq();
        returnValue = ${moduleNameUpperCase}_NOERR;
    }
    return returnValue;
}

${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_Close(void)
{
    ${moduleNameLowerCase}_error_t returnValue = ${moduleNameUpperCase}_BUSY;
    if(!${moduleNameUpperCase}_Status.busy)
    {
        ${moduleNameUpperCase}_Status.inUse = 0;
        ${moduleNameUpperCase}_Status.address = 0xff;
        ${moduleNameUpperCase}_MasterClearIrq();
        ${moduleNameUpperCase}_MasterDisableIrq();
        ${moduleNameUpperCase}_MasterClose();
        returnValue = ${moduleNameUpperCase}_Status.error;
    }
    return returnValue;
}

${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_MasterOperation(bool read)
{
    ${moduleNameLowerCase}_error_t returnValue = ${moduleNameUpperCase}_BUSY;
    if(!${moduleNameUpperCase}_Status.busy)
    {
        ${moduleNameUpperCase}_Status.busy = true;
        returnValue = ${moduleNameUpperCase}_NOERR;
        ${moduleNameUpperCase}_MasterSetCounter((uint8_t) ${moduleNameUpperCase}_Status.data_length);

        if(read)
        {
            ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_RX;
            ${moduleNameUpperCase}_DO_SEND_ADR_READ();
        }
        else
        {
            ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_TX;
            ${moduleNameUpperCase}_DO_SEND_ADR_WRITE();
        }
    }
    return returnValue;
}

${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_MasterRead(void)
{
    return ${moduleNameUpperCase}_MasterOperation(true);
}

${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_MasterWrite(void)
{
    return ${moduleNameUpperCase}_MasterOperation(false);
}

void ${moduleNameUpperCase}_SetTimeOut(uint8_t timeOutValue)
{
    ${moduleNameUpperCase}_MasterDisableIrq();
    ${moduleNameUpperCase}_Status.time_out_value = timeOutValue;
    ${moduleNameUpperCase}_MasterEnableIrq();
}

void ${moduleNameUpperCase}_SetBuffer(void *buffer, size_t bufferSize)
{
    if(${moduleNameUpperCase}_Status.bufferFree)
    {
        ${moduleNameUpperCase}_Status.data_ptr = buffer;
        ${moduleNameUpperCase}_Status.data_length = bufferSize;
        ${moduleNameUpperCase}_Status.bufferFree = false;
    }
}

void ${moduleNameUpperCase}_SetDataCompleteCallback(${moduleNameLowerCase}_callback_t cb, void *ptr)
{
    ${moduleNameUpperCase}_SetCallback(${moduleNameUpperCase}_DATA_COMPLETE, cb, ptr);
}

void ${moduleNameUpperCase}_SetWriteCollisionCallback(${moduleNameLowerCase}_callback_t cb, void *ptr)
{
    ${moduleNameUpperCase}_SetCallback(${moduleNameUpperCase}_WRITE_COLLISION, cb, ptr);
}

void ${moduleNameUpperCase}_SetAddressNackCallback(${moduleNameLowerCase}_callback_t cb, void *ptr)
{
    ${moduleNameUpperCase}_SetCallback(${moduleNameUpperCase}_ADDR_NACK, cb, ptr);
}

void ${moduleNameUpperCase}_SetDataNackCallback(${moduleNameLowerCase}_callback_t cb, void *ptr)
{
    ${moduleNameUpperCase}_SetCallback(${moduleNameUpperCase}_DATA_NACK, cb, ptr);
}

void ${moduleNameUpperCase}_SetTimeoutCallback(${moduleNameLowerCase}_callback_t cb, void *ptr)
{
    ${moduleNameUpperCase}_SetCallback(${moduleNameUpperCase}_TIMEOUT, cb, ptr);
}

void ${moduleNameUpperCase}_SetInterruptHandler(void (* InterruptHandler)(void))
{
    ${moduleNameUpperCase}_InterruptHandler = InterruptHandler;
}

static void ${moduleNameUpperCase}_SetCallback(${moduleNameLowerCase}_callbackIndex_t idx, ${moduleNameLowerCase}_callback_t cb, void *ptr)
{
    if(cb)
    {
        ${moduleNameUpperCase}_Status.callbackTable[idx] = cb;
        ${moduleNameUpperCase}_Status.callbackPayload[idx] = ptr;
    }
    else
    {
        ${moduleNameUpperCase}_Status.callbackTable[idx] = ${moduleNameUpperCase}_CallbackReturnStop;
        ${moduleNameUpperCase}_Status.callbackPayload[idx] = NULL;
    }
}

static void ${moduleNameUpperCase}_MasterIsr()
{
    ${moduleNameUpperCase}_MasterFsm();
}

static inline void ${moduleNameUpperCase}_MasterFsm(void)
{
    ${moduleNameUpperCase}_ClearInterruptFlags();

    if(${moduleNameUpperCase}_Status.addressNackCheck && ${moduleNameUpperCase}_MasterIsNack())
    {
        ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_ADDRESS_NACK;
    }
    ${moduleNameUpperCase}_Status.state = ${moduleNameLowerCase}_fsmStateTable[${moduleNameUpperCase}_Status.state]();
}

static inline void ${moduleNameUpperCase}_ClearInterruptFlags(void)
{
    if(${moduleNameUpperCase}_MasterIsCountFlagSet())
    {
        ${moduleNameUpperCase}_MasterClearCountFlag();
    }
    else if(${moduleNameUpperCase}_MasterIsStopFlagSet())
    {
        ${moduleNameUpperCase}_MasterClearStopFlag();
    }
    else if(${moduleNameUpperCase}_MasterIsNackFlagSet())
    {
        ${moduleNameUpperCase}_MasterClearNackFlag();
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_IDLE(void)
{
    ${moduleNameUpperCase}_Status.busy = false;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_NOERR;
    return ${moduleNameUpperCase}_RESET;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_READ(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 2;
    if(${moduleNameUpperCase}_Status.data_length ==  1)
    {
        ${moduleNameUpperCase}_DO_RX_EMPTY();
    }
    ${moduleNameUpperCase}_MasterSendTxData((uint8_t) (${moduleNameUpperCase}_Status.address << 1 | 1));
    return ${moduleNameUpperCase}_RX;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_WRITE(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 2;
    ${moduleNameUpperCase}_MasterSendTxData((uint8_t) (${moduleNameUpperCase}_Status.address << 1));
    return ${moduleNameUpperCase}_TX;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX(void)
{
    if(${moduleNameUpperCase}_MasterIsNack())
    {
        switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_NACK](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_NACK]))
        {
            case ${moduleNameUpperCase}_RESTART_READ:
                return ${moduleNameUpperCase}_DO_SEND_RESTART_READ();
            case ${moduleNameUpperCase}_RESTART_WRITE:
                  return ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE();
            default:
            case ${moduleNameUpperCase}_CONTINUE:
            case ${moduleNameUpperCase}_STOP:
                return ${moduleNameUpperCase}_IDLE;
        }
    }
    else if(${moduleNameUpperCase}_MasterIsTxBufEmpty())
    {
        if(${moduleNameUpperCase}_Status.addressNackCheck)
        {
            ${moduleNameUpperCase}_Status.addressNackCheck--;
        }
        uint8_t dataTx = *${moduleNameUpperCase}_Status.data_ptr++;
        ${moduleNameLowerCase}_fsm_states_t retFsmState = (--${moduleNameUpperCase}_Status.data_length)?${moduleNameUpperCase}_TX:${moduleNameUpperCase}_DO_TX_EMPTY();
        ${moduleNameUpperCase}_MasterSendTxData(dataTx);
        return retFsmState;
    }
    else
    {
        return ${moduleNameUpperCase}_TX;
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX(void)
{
    if(!${moduleNameUpperCase}_MasterIsRxBufFull())
    {
        return ${moduleNameUpperCase}_RX;
    }
    if(${moduleNameUpperCase}_Status.addressNackCheck)
    {
        ${moduleNameUpperCase}_Status.addressNackCheck--;
    }

    if(--${moduleNameUpperCase}_Status.data_length)
    {
        *${moduleNameUpperCase}_Status.data_ptr++ = ${moduleNameUpperCase}_MasterGetRxData();
        return ${moduleNameUpperCase}_RX;
    }
    else
    {
        ${moduleNameLowerCase}_fsm_states_t retFsmState = ${moduleNameUpperCase}_DO_RX_EMPTY();
        *${moduleNameUpperCase}_Status.data_ptr++ = ${moduleNameUpperCase}_MasterGetRxData();
        return retFsmState;
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX_EMPTY(void)
{
    ${moduleNameUpperCase}_Status.bufferFree = true;
    switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_COMPLETE](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_COMPLETE]))
    {
        case ${moduleNameUpperCase}_RESTART_READ:
            ${moduleNameUpperCase}_MasterEnableRestart();
            return ${moduleNameUpperCase}_SEND_RESTART_READ;
        case ${moduleNameUpperCase}_CONTINUE:
            // Avoid the counter stop condition , Counter is incremented by 1
            ${moduleNameUpperCase}_MasterSetCounter((uint8_t) (${moduleNameUpperCase}_Status.data_length + 1));
            return ${moduleNameUpperCase}_TX;
        default:
        case ${moduleNameUpperCase}_STOP:
            ${moduleNameUpperCase}_MasterDisableRestart();
            return ${moduleNameUpperCase}_SEND_STOP;
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_EMPTY(void)
{
    ${moduleNameUpperCase}_Status.bufferFree = true;
    switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_COMPLETE](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_COMPLETE]))
    {
        case ${moduleNameUpperCase}_RESTART_WRITE:
            ${moduleNameUpperCase}_MasterEnableRestart();
            return ${moduleNameUpperCase}_SEND_RESTART_WRITE;
        case ${moduleNameUpperCase}_RESTART_READ:
            ${moduleNameUpperCase}_MasterEnableRestart();
            return ${moduleNameUpperCase}_SEND_RESTART_READ;
        case ${moduleNameUpperCase}_CONTINUE:
            // Avoid the counter stop condition , Counter is incremented by 1
            ${moduleNameUpperCase}_MasterSetCounter((uint8_t) ${moduleNameUpperCase}_Status.data_length + 1);
            return ${moduleNameUpperCase}_RX;
        default:
        case ${moduleNameUpperCase}_STOP:
            if(${moduleNameUpperCase}_Status.state != ${moduleNameUpperCase}_SEND_RESTART_READ)
            {
                ${moduleNameUpperCase}_MasterDisableRestart();
            }
            return ${moduleNameUpperCase}_RESET;
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_READ(void)
{
    ${moduleNameUpperCase}_MasterSetCounter((uint8_t) ${moduleNameUpperCase}_Status.data_length);
    return ${moduleNameUpperCase}_DO_SEND_ADR_READ();
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE(void)
{
    return ${moduleNameUpperCase}_SEND_ADR_WRITE;
}


static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART(void)
{
    return ${moduleNameUpperCase}_SEND_ADR_READ;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_STOP(void)
{
    ${moduleNameUpperCase}_MasterStop();
    if(${moduleNameUpperCase}_MasterGetCounter())
    {
        ${moduleNameUpperCase}_MasterSetCounter(0);
        ${moduleNameUpperCase}_MasterSendTxData(0);
    }
    return ${moduleNameUpperCase}_IDLE;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_ACK(void)
{
    ${moduleNameUpperCase}_MasterSendAck();
    return ${moduleNameUpperCase}_RX;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX_ACK(void)
{
    ${moduleNameUpperCase}_MasterSendAck();
    return ${moduleNameUpperCase}_TX;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_STOP(void)
{
    ${moduleNameUpperCase}_MasterSendNack();
    ${moduleNameUpperCase}_MasterStop();
    return ${moduleNameUpperCase}_DO_IDLE();
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_RESTART(void)
{
    ${moduleNameUpperCase}_MasterSendNack();
    return ${moduleNameUpperCase}_SEND_RESTART;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RESET(void)
{
    ${moduleNameUpperCase}_MasterResetBus();
    ${moduleNameUpperCase}_Status.busy = false;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_NOERR;
    return ${moduleNameUpperCase}_RESET;
}
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_ADDRESS_NACK(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 0;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_FAIL;
    ${moduleNameUpperCase}_Status.busy = false;
    switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_ADDR_NACK](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_ADDR_NACK]))
    {
        case ${moduleNameUpperCase}_RESTART_READ:
        case ${moduleNameUpperCase}_RESTART_WRITE:
            return ${moduleNameUpperCase}_DO_SEND_RESTART();
        default:
            return ${moduleNameUpperCase}_RESET;
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_BUS_COLLISION(void)
{
    // Clear bus collision status flag
    ${moduleNameUpperCase}_MasterClearIrq();

    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_FAIL;
    switch (${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_WRITE_COLLISION](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_WRITE_COLLISION])) {
    case ${moduleNameUpperCase}_RESTART_READ:
        return ${moduleNameUpperCase}_DO_SEND_RESTART_READ();
    case ${moduleNameUpperCase}_RESTART_WRITE:
        return ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE();
    default:
        return ${moduleNameUpperCase}_DO_RESET();
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_BUS_ERROR(void)
{
    ${moduleNameUpperCase}_MasterResetBus();
    ${moduleNameUpperCase}_Status.busy  = false;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_FAIL;
    return ${moduleNameUpperCase}_RESET;
}

void ${moduleNameUpperCase}_BusCollisionIsr(void)
{
    ${moduleNameUpperCase}_MasterClearBusCollision();
    ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_RESET;
}

${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackReturnStop(void *funPtr)
{
    return ${moduleNameUpperCase}_STOP;
}

${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackReturnReset(void *funPtr)
{
    return ${moduleNameUpperCase}_RESET_LINK;
}

${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackRestartWrite(void *funPtr)
{
    return ${moduleNameUpperCase}_RESTART_WRITE;
}

${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackRestartRead(void *funPtr)
{
    return ${moduleNameUpperCase}_RESTART_READ;
}


/* ${moduleNameUpperCase} Register Level interfaces */
static inline bool ${moduleNameUpperCase}_MasterOpen(void)
{
    if(!${I2CCON0.name}bits.EN)
    {
        <#if I2CPIR??>
        //${I2CPIR.csvComment}
        ${I2CPIR.name} = ${I2CPIR.hexValue};
        </#if>
        <#if I2CPIE??>
        //${I2CPIE.csvComment}
        ${I2CPIE.name} = ${I2CPIE.hexValue};
        </#if>
        <#if I2CERR??>
        //${I2CERR.csvComment}
        ${I2CERR.name} = ${I2CERR.hexValue};
        </#if>
        <#if I2CCNT??>
        //Count register 
        ${I2CCNT.name} = ${I2CCNT.hexValue};
        <#elseif I2CCNTL??>
        //Count register
        ${I2CCNTL.name} = ${I2CCNTL.hexValue};
        <#if I2CCNTH??>
        ${I2CCNTH.name} = ${I2CCNTH.hexValue};
        </#if>
        </#if>
        <#if I2CBAUD??>
        ${I2CBAUD.name} = ${I2CBAUD.hexValue};
        </#if>
        <#if isI2cClockPadRegExists>
        //Clock PadReg Configuration
        ${i2cClockPadCtlRegister}  = ${i2cClockPadCtlRegValue};
        </#if>
        <#if isI2cDataPadRegExists>
        //Data PadReg Configuration
        ${i2cDataPadCtlRegister}  = ${i2cDataPadCtlRegValue};
        </#if>
        <#if I2CCON0??>
        //Enable ${moduleNameUpperCase}
        ${I2CCON0.name}bits.EN = 1;
        </#if>
        return true;
    }
    return false;
}

static inline void ${moduleNameUpperCase}_MasterClose(void)
{
    <#if I2CCON0??>
    //Disable ${moduleNameUpperCase}
    ${I2CCON0.name}bits.EN = 0;
    </#if>
    <#if I2CPIR??>
    //${I2CPIR.csvComment}
    ${I2CPIR.name} = ${I2CPIR.hexValue};
    </#if>
    <#if I2CSTAT1??>
    //Set Clear Buffer Flag
    ${I2CSTAT1.name}bits.CLRBF = 1;
    </#if>   
}

static inline uint8_t ${moduleNameUpperCase}_MasterGetRxData(void)
{
    <#if I2CRXB??>
    return ${I2CRXB.name};
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSendTxData(uint8_t data)
{
    <#if I2CTXB??>
    ${I2CTXB.name}  = data;
    </#if>
}

static inline uint8_t ${moduleNameUpperCase}_MasterGetCounter()
{
    <#if I2CCNT??>
    return ${I2CCNT.name};
    <#elseif I2CCNTL??>
    return ${I2CCNTL.name};
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSetCounter(uint8_t counter)
{
    <#if I2CCNT??>
    ${I2CCNT.name} = counter;
    <#elseif I2CCNTL??>
    ${I2CCNTL.name} = counter;
    <#if I2CCNTH??>
    ${I2CCNTH.name} = 0x00;
    </#if>
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterResetBus(void)
{
    <#if I2CCON0??>
    //Disable ${moduleNameUpperCase}
    ${I2CCON0.name}bits.EN = 0;
    </#if>
    <#if I2CSTAT1??>
    //Set Clear Buffer Flag
    ${I2CSTAT1.name}bits.CLRBF = 1;
    </#if>
    <#if I2CCON0??>
    //Enable ${moduleNameUpperCase}
    ${I2CCON0.name}bits.EN = 1;
    </#if>   
}

static inline void ${moduleNameUpperCase}_MasterEnableRestart(void)
{
    <#if I2CCON0??>
    //Enable ${moduleNameUpperCase} Restart
    ${I2CCON0.name}bits.RSEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterDisableRestart(void)
{
    <#if I2CCON0??>
    //Disable ${moduleNameUpperCase} Restart
    ${I2CCON0.name}bits.RSEN = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterStop(void)
{
    <#if I2CCON0??>
    //Clear Start Bit
    ${I2CCON0.name}bits.S = 0;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsNack(void)
{
    <#if I2CCON1??>
    return ${I2CCON1.name}bits.ACKSTAT;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSendAck(void)
{
    <#if I2CCON1??>
    ${I2CCON1.name}bits.ACKDT = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSendNack(void)
{
    <#if I2CCON1??>
    ${I2CCON1.name}bits.ACKDT = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterClearBusCollision(void)
{
    <#if I2CERR??>
    ${I2CERR.name}bits.BCLIF = 0;
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.BTOIF = 0;
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.NACKIF = 0;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsRxBufFull(void)
{
    <#if I2CSTAT1??>
    return ${I2CSTAT1.name}bits.RXBF;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsTxBufEmpty(void)
{
    <#if I2CSTAT1??>
    return ${I2CSTAT1.name}bits.TXBE;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsStopFlagSet(void)
{
    <#if I2CPIR??>
    return ${I2CPIR.name}bits.PCIF;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsCountFlagSet(void)
{
    <#if I2CPIR??>
    return ${I2CPIR.name}bits.CNTIF;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsNackFlagSet(void)
{
    <#if I2CERR??>
    return ${I2CERR.name}bits.NACKIF;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterClearStopFlag(void)
{
    <#if I2CPIR??>
    ${I2CPIR.name}bits.PCIF = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterClearCountFlag(void)
{
    <#if I2CPIR??>
    ${I2CPIR.name}bits.CNTIF = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterClearNackFlag(void)
{
    <#if I2CERR??>
    ${I2CERR.name}bits.NACKIF = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterEnableIrq(void)
{
    ${ICI_ENABLE.name}    = 1;
    ${ICEI_ENABLE.name}   = 1;
    ${ICRXI_ENABLE.name}  = 1;
    ${ICTXI_ENABLE.name}  = 1;

    <#if I2CPIE??>
    ${I2CPIE.name}bits.PCIE = 1; 
    </#if>
    <#if I2CPIE??>
    ${I2CPIE.name}bits.CNTIE = 1; 
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.NACKIE = 1; 
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsIrqEnabled(void)
{
    return (${ICRXI_ENABLE.name} && ${ICTXI_ENABLE.name} && ${ICI_ENABLE.name});
}

static inline void ${moduleNameUpperCase}_MasterDisableIrq(void)
{
    ${ICI_ENABLE.name}    = 0;
    ${ICEI_ENABLE.name}   = 0;
    ${ICRXI_ENABLE.name}  = 0;
    ${ICTXI_ENABLE.name}  = 0;
    <#if I2CPIE??>
    ${I2CPIE.name}bits.SCIE = 0;
    </#if>
    <#if I2CPIE??>
    ${I2CPIE.name}bits.PCIE = 0;
    </#if>
    <#if I2CPIE??>
    ${I2CPIE.name}bits.CNTIE = 0;
    </#if>
    <#if I2CPIE??>
    ${I2CPIE.name}bits.ACKTIE = 0;
    </#if>
    <#if I2CPIE??>
    ${I2CPIE.name}bits.RSCIE = 0;
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.BCLIE = 0;
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.BTOIE = 0;
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.NACKIE = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterClearIrq(void)
{
    <#if I2CPIR??>
    ${I2CPIR.name} = 0x00;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterWaitForEvent(void)
{
    while(1)
    {
        if(${ICTXI_FLAG.name})
        {    
            break;
        }
        if(${ICRXI_FLAG.name})
        {  
            break;
        } 
        if(${I2CPIR.name}bits.PCIF)
        {
            break;
        } 
        if(${I2CPIR.name}bits.CNTIF)
        {
            break;
        }
        if(${I2CERR.name}bits.NACKIF)
        {
            break;
        }
    }
}

<#if isVectoredInterrupt>
<#if isHighPriority>
void __interrupt(irq(${transmitIrqName},${receiveIrqName},${errorIrqName},${i2cIrqName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ISR()
<#else>
void __interrupt(irq(${transmitIrqName},${receiveIrqName},${errorIrqName},${i2cIrqName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ISR()
</#if>
{
    ${moduleNameUpperCase}_InterruptHandler();
}
</#if>
