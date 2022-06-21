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
        Driver Version    :  1.0.2
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
    ${moduleNameUpperCase}_RCEN,
    ${moduleNameUpperCase}_TX_EMPTY,      
    ${moduleNameUpperCase}_SEND_RESTART_READ,
    ${moduleNameUpperCase}_SEND_RESTART_WRITE,
    ${moduleNameUpperCase}_SEND_RESTART,
    ${moduleNameUpperCase}_SEND_STOP,
    ${moduleNameUpperCase}_RX_ACK,
    ${moduleNameUpperCase}_RX_NACK_STOP,
    ${moduleNameUpperCase}_RX_NACK_RESTART,
    ${moduleNameUpperCase}_RESET,
    ${moduleNameUpperCase}_ADDRESS_NACK,

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
    unsigned addressNackCheck:1;
    unsigned busy:1;
    unsigned inUse:1;
    unsigned bufferFree:1;

} ${moduleNameLowerCase}_status_t;

static void ${moduleNameUpperCase}_SetCallback(${moduleNameLowerCase}_callbackIndex_t idx, ${moduleNameLowerCase}_callback_t cb, void *ptr);
static void ${moduleNameUpperCase}_MasterIsr(void);
static inline void ${moduleNameUpperCase}_MasterFsm(void);

/* ${moduleNameUpperCase} interfaces */
static inline bool ${moduleNameUpperCase}_MasterOpen(void);
static inline void ${moduleNameUpperCase}_MasterClose(void);    
static inline uint8_t ${moduleNameUpperCase}_MasterGetRxData(void);
static inline void ${moduleNameUpperCase}_MasterSendTxData(uint8_t data);
static inline void ${moduleNameUpperCase}_MasterEnableRestart(void);
static inline void ${moduleNameUpperCase}_MasterDisableRestart(void);
static inline void ${moduleNameUpperCase}_MasterStartRx(void);
static inline void ${moduleNameUpperCase}_MasterStart(void);
static inline void ${moduleNameUpperCase}_MasterStop(void);
static inline bool ${moduleNameUpperCase}_MasterIsNack(void);
static inline void ${moduleNameUpperCase}_MasterSendAck(void);
static inline void ${moduleNameUpperCase}_MasterSendNack(void);
static inline void ${moduleNameUpperCase}_MasterClearBusCollision(void);

/* Interrupt interfaces */
static inline void ${moduleNameUpperCase}_MasterEnableIrq(void);
static inline bool ${moduleNameUpperCase}_MasterIsIrqEnabled(void);
static inline void ${moduleNameUpperCase}_MasterDisableIrq(void);
static inline void ${moduleNameUpperCase}_MasterClearIrq(void);
static inline void ${moduleNameUpperCase}_MasterSetIrq(void);
static inline void ${moduleNameUpperCase}_MasterWaitForEvent(void);

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_IDLE(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_READ(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_WRITE(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RCEN(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX_EMPTY(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_READ(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_STOP(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_ACK(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_STOP(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_RESTART(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RESET(void);
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_ADDRESS_NACK(void);


typedef ${moduleNameLowerCase}_fsm_states_t (*${moduleNameLowerCase}FsmHandler)(void);
const ${moduleNameLowerCase}FsmHandler ${moduleNameLowerCase}_fsmStateTable[] = {
    ${moduleNameUpperCase}_DO_IDLE,
    ${moduleNameUpperCase}_DO_SEND_ADR_READ,
    ${moduleNameUpperCase}_DO_SEND_ADR_WRITE,
    ${moduleNameUpperCase}_DO_TX,
    ${moduleNameUpperCase}_DO_RX,
    ${moduleNameUpperCase}_DO_RCEN,
    ${moduleNameUpperCase}_DO_TX_EMPTY,
    ${moduleNameUpperCase}_DO_SEND_RESTART_READ,
    ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE,
    ${moduleNameUpperCase}_DO_SEND_RESTART,
    ${moduleNameUpperCase}_DO_SEND_STOP,
    ${moduleNameUpperCase}_DO_RX_ACK,
    ${moduleNameUpperCase}_DO_RX_NACK_STOP,
    ${moduleNameUpperCase}_DO_RX_NACK_RESTART,
    ${moduleNameUpperCase}_DO_RESET,
    ${moduleNameUpperCase}_DO_ADDRESS_NACK,
};

${moduleNameLowerCase}_status_t ${moduleNameUpperCase}_Status = {0};

void ${moduleNameUpperCase}_Initialize()
{
    <#if SSPSTAT??>
    ${SSPSTAT.name} = ${SSPSTAT.hexValue};
    </#if>
    <#if SSPCON1??>
    ${SSPCON1.name} = ${SSPCON1.hexValue};
    </#if>
    <#if SSPCON2??>
    ${SSPCON2.name} = ${SSPCON2.hexValue};
    </#if>
    <#if SSPADD??>
    ${SSPADD.name}  = ${SSPADD.hexValue};
    </#if>
    <#if SSPCON1??>
    ${SSPCON1.name}bits.SSPEN = 0;
    </#if>
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

        if(read)
        {
            ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_SEND_ADR_READ;
        }
        else
        {
            ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_SEND_ADR_WRITE;
        }
        ${moduleNameUpperCase}_MasterStart();
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
    ${moduleInstance}_InterruptHandler = InterruptHandler;
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
    ${moduleNameUpperCase}_MasterClearIrq();

    if(${moduleNameUpperCase}_Status.addressNackCheck && ${moduleNameUpperCase}_MasterIsNack())
    {
        ${moduleNameUpperCase}_Status.state = ${moduleNameUpperCase}_ADDRESS_NACK;
    }
    ${moduleNameUpperCase}_Status.state = ${moduleNameLowerCase}_fsmStateTable[${moduleNameUpperCase}_Status.state]();
}


static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_IDLE(void)
{
    ${moduleNameUpperCase}_Status.busy = false;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_NOERR;
    return ${moduleNameUpperCase}_RESET;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_READ(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 1;
    ${moduleNameUpperCase}_MasterSendTxData((uint8_t) (${moduleNameUpperCase}_Status.address << 1 | 1));
    return ${moduleNameUpperCase}_RCEN;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_ADR_WRITE(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 1;
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
                return ${moduleNameUpperCase}_DO_SEND_STOP();
        }
    }
    else
    {
        ${moduleNameUpperCase}_Status.addressNackCheck = 0;
        ${moduleNameUpperCase}_MasterSendTxData(*${moduleNameUpperCase}_Status.data_ptr++);
        return (--${moduleNameUpperCase}_Status.data_length)?${moduleNameUpperCase}_TX:${moduleNameUpperCase}_TX_EMPTY;
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX(void)
{
    *${moduleNameUpperCase}_Status.data_ptr++ = ${moduleNameUpperCase}_MasterGetRxData();
    if(--${moduleNameUpperCase}_Status.data_length)
    {
        ${moduleNameUpperCase}_MasterSendAck();
        return ${moduleNameUpperCase}_RCEN;
    }
    else
    {
        ${moduleNameUpperCase}_Status.bufferFree = true;
        switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_COMPLETE](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_COMPLETE]))
        {
            case ${moduleNameUpperCase}_RESTART_WRITE:
            case ${moduleNameUpperCase}_RESTART_READ:
                return ${moduleNameUpperCase}_DO_RX_NACK_RESTART();
            default:
            case ${moduleNameUpperCase}_CONTINUE:
            case ${moduleNameUpperCase}_STOP:
                return ${moduleNameUpperCase}_DO_RX_NACK_STOP();
        }
    }
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RCEN(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 0;
    ${moduleNameUpperCase}_MasterStartRx();
    return ${moduleNameUpperCase}_RX;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_TX_EMPTY(void)
{
    ${moduleNameUpperCase}_Status.bufferFree = true;
    switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_DATA_COMPLETE](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_DATA_COMPLETE]))
    {
        case ${moduleNameUpperCase}_RESTART_READ:
        case ${moduleNameUpperCase}_RESTART_WRITE:
            return ${moduleNameUpperCase}_DO_SEND_RESTART();
        case ${moduleNameUpperCase}_CONTINUE:
            ${moduleNameUpperCase}_MasterSetIrq();
            return ${moduleNameUpperCase}_TX;
        default:
        case ${moduleNameUpperCase}_STOP:
            return ${moduleNameUpperCase}_DO_SEND_STOP();
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
    ${moduleNameUpperCase}_MasterEnableRestart();
    return ${moduleNameUpperCase}_SEND_ADR_READ;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART_WRITE(void)
{
    ${moduleNameUpperCase}_MasterEnableRestart();
    return ${moduleNameUpperCase}_SEND_ADR_WRITE;
}


static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_RESTART(void)
{
    ${moduleNameUpperCase}_MasterEnableRestart();
    return ${moduleNameUpperCase}_SEND_ADR_READ;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_SEND_STOP(void)
{
    ${moduleNameUpperCase}_MasterStop();
    return ${moduleNameUpperCase}_IDLE;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_ACK(void)
{
    ${moduleNameUpperCase}_MasterSendAck();
    return ${moduleNameUpperCase}_RCEN;
}


static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_STOP(void)
{
    ${moduleNameUpperCase}_MasterSendNack();
    return ${moduleNameUpperCase}_SEND_STOP;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RX_NACK_RESTART(void)
{
    ${moduleNameUpperCase}_MasterSendNack();
    return ${moduleNameUpperCase}_SEND_RESTART;
}

static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_RESET(void)
{
    ${moduleNameUpperCase}_Status.busy = false;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_NOERR;
    return ${moduleNameUpperCase}_RESET;
}
static ${moduleNameLowerCase}_fsm_states_t ${moduleNameUpperCase}_DO_ADDRESS_NACK(void)
{
    ${moduleNameUpperCase}_Status.addressNackCheck = 0;
    ${moduleNameUpperCase}_Status.error = ${moduleNameUpperCase}_FAIL;
    switch(${moduleNameUpperCase}_Status.callbackTable[${moduleNameUpperCase}_ADDR_NACK](${moduleNameUpperCase}_Status.callbackPayload[${moduleNameUpperCase}_ADDR_NACK]))
    {
        case ${moduleNameUpperCase}_RESTART_READ:
        case ${moduleNameUpperCase}_RESTART_WRITE:
            return ${moduleNameUpperCase}_DO_SEND_RESTART();
        default:
            return ${moduleNameUpperCase}_DO_SEND_STOP();
    }
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
    if(!${SSPCON1.name}bits.SSPEN)
    {
        <#if SSPSTAT??>
        ${SSPSTAT.name} = ${SSPSTAT.hexValue};
        </#if>
        <#if SSPCON1??>
        ${SSPCON1.name} = ${SSPCON1.hexValue};
        </#if>
        <#if SSPCON2??>
        ${SSPCON2.name} = ${SSPCON2.hexValue};
        </#if>
        <#if SSPADD??>
        ${SSPADD.name} = ${SSPADD.hexValue};
        </#if>
        <#if SSPCON1??>
        ${SSPCON1.name}bits.SSPEN = 1;
        </#if>
        return true;
    }
    return false;
}

static inline void ${moduleNameUpperCase}_MasterClose(void)
{
    <#if SSPCON1??>
    //Disable ${moduleNameUpperCase}
    ${SSPCON1.name}bits.SSPEN = 0;
    </#if>
}

static inline uint8_t ${moduleNameUpperCase}_MasterGetRxData(void)
{
    <#if SSPBUF??>
    return ${SSPBUF.name};
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSendTxData(uint8_t data)
{
    <#if SSPBUF??>
    ${SSPBUF.name}  = data;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterEnableRestart(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.RSEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterDisableRestart(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.RSEN = 0;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterStartRx(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.RCEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterStart(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.SEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterStop(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.PEN = 1;
    </#if>
}

static inline bool ${moduleNameUpperCase}_MasterIsNack(void)
{
    <#if SSPCON2??>
    return ${SSPCON2.name}bits.ACKSTAT;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSendAck(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.ACKDT = 0;
    ${SSPCON2.name}bits.ACKEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterSendNack(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.ACKDT = 1;
    ${SSPCON2.name}bits.ACKEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterClearBusCollision(void)
{
    ${BCLI_FLAG.name} = 0;
}


static inline bool ${moduleNameUpperCase}_MasterIsRxBufFull(void)
{
    <#if SSPSTAT??>
    return ${SSPSTAT.name}bits.BF;
    </#if>
}

static inline void ${moduleNameUpperCase}_MasterEnableIrq(void)
{
    ${SSPI_ENABLE.name} = 1;
}

static inline bool ${moduleNameUpperCase}_MasterIsIrqEnabled(void)
{
    return ${SSPI_ENABLE.name};
}

static inline void ${moduleNameUpperCase}_MasterDisableIrq(void)
{
    ${SSPI_ENABLE.name} = 0;
}

static inline void ${moduleNameUpperCase}_MasterClearIrq(void)
{
    ${SSPI_FLAG.name} = 0;
}

static inline void ${moduleNameUpperCase}_MasterSetIrq(void)
{
    ${SSPI_FLAG.name} = 1;
}

static inline void ${moduleNameUpperCase}_MasterWaitForEvent(void)
{
    while(1)
    {
        if(${SSPI_FLAG.name})
        {    
            break;
        }
    }
}