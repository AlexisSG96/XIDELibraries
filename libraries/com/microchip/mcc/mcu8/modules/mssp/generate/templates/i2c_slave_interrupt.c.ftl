/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}_slave.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.0.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#include "${moduleNameLowerCase}_slave.h"
#include <xc.h>

#define ${moduleNameUpperCase}_SLAVE_ADDRESS      ${i2cSlaveAddr}
#define ${moduleNameUpperCase}_SLAVE_MASK         ${i2cMaskAddr}

typedef enum
{
    ${moduleNameUpperCase}_IDLE,
    ${moduleNameUpperCase}_ADDR_TX,
    ${moduleNameUpperCase}_ADDR_RX,
    ${moduleNameUpperCase}_DATA_TX,
    ${moduleNameUpperCase}_DATA_RX
} ${moduleNameLowerCase}_slave_state_t;

/**
 Section: Global Variables
 */
volatile uint8_t ${moduleNameLowerCase}WrData;
volatile uint8_t ${moduleNameLowerCase}RdData;
volatile uint8_t ${moduleNameLowerCase}SlaveAddr;
static volatile ${moduleNameLowerCase}_slave_state_t ${moduleNameLowerCase}SlaveState = ${moduleNameUpperCase}_IDLE;

/**
 Section: Functions declaration
 */
static void ${moduleNameUpperCase}_Isr(void);
static void ${moduleNameUpperCase}_SlaveDefRdInterruptHandler(void);
static void ${moduleNameUpperCase}_SlaveDefWrInterruptHandler(void);
static void ${moduleNameUpperCase}_SlaveDefAddrInterruptHandler(void);
static void ${moduleNameUpperCase}_SlaveDefWrColInterruptHandler(void);
static void ${moduleNameUpperCase}_SlaveDefBusColInterruptHandler(void);

static void ${moduleNameUpperCase}_SlaveRdCallBack(void);
static void ${moduleNameUpperCase}_SlaveWrCallBack(void);
static void ${moduleNameUpperCase}_SlaveAddrCallBack(void);
static void ${moduleNameUpperCase}_SlaveWrColCallBack(void);
static void ${moduleNameUpperCase}_SlaveBusColCallBack(void);

static inline bool ${moduleNameUpperCase}_SlaveOpen();
static inline void ${moduleNameUpperCase}_SlaveClose();
static inline void ${moduleNameUpperCase}_SlaveSetSlaveAddr(uint8_t slaveAddr);
static inline void ${moduleNameUpperCase}_SlaveSetSlaveMask(uint8_t maskAddr);
static inline void ${moduleNameUpperCase}_SlaveEnableIrq(void);
static inline bool ${moduleNameUpperCase}_SlaveIsAddr(void);
static inline bool ${moduleNameUpperCase}_SlaveIsRead(void);
static inline void ${moduleNameUpperCase}_SlaveClearBuff(void);
static inline void ${moduleNameUpperCase}_SlaveClearIrq(void);
static inline void ${moduleNameUpperCase}_SlaveReleaseClock(void);
static inline bool ${moduleNameUpperCase}_SlaveIsWriteCollision(void);
static inline bool ${moduleNameUpperCase}_SlaveIsTxBufEmpty(void);
static inline bool ${moduleNameUpperCase}_SlaveIsData(void);
static inline void ${moduleNameUpperCase}_SlaveRestart(void);
static inline bool ${moduleNameUpperCase}_SlaveIsRxBufFull(void);
static inline void ${moduleNameUpperCase}_SlaveSendTxData(uint8_t data);
static inline uint8_t ${moduleNameUpperCase}_SlaveGetRxData(void);
static inline uint8_t ${moduleNameUpperCase}_SlaveGetAddr(void);
static inline void ${moduleNameUpperCase}_SlaveSendAck(void);
static inline void ${moduleNameUpperCase}_SlaveSendNack(void);
static inline bool ${moduleNameUpperCase}_SlaveIsOverFlow(void);

void ${moduleNameUpperCase}_Initialize()
{
    <#if SSPSTAT??>
    ${SSPSTAT.name}  = ${SSPSTAT.hexValue};
    </#if>
    <#if SSPCON1??>
    ${SSPCON1.name} |= ${SSPCON1.hexValue};
    </#if>
    <#if SSPCON2??>
    ${SSPCON2.name}  = ${SSPCON2.hexValue};
    </#if>
    <#if SSPCON1??>
    ${SSPCON1.name}bits.SSPEN = 0;
    </#if>
}

void ${moduleNameUpperCase}_Open() 
{
    ${moduleNameUpperCase}_SlaveOpen();
    ${moduleNameUpperCase}_SlaveSetSlaveAddr(${moduleNameUpperCase}_SLAVE_ADDRESS);
    ${moduleNameUpperCase}_SlaveSetSlaveMask(${moduleNameUpperCase}_SLAVE_MASK);
    ${moduleNameUpperCase}_SlaveSetIsrHandler(${moduleNameUpperCase}_Isr);
    ${moduleNameUpperCase}_SlaveSetBusColIntHandler(${moduleNameUpperCase}_SlaveDefBusColInterruptHandler);
    ${moduleNameUpperCase}_SlaveSetWriteIntHandler(${moduleNameUpperCase}_SlaveDefWrInterruptHandler);
    ${moduleNameUpperCase}_SlaveSetReadIntHandler(${moduleNameUpperCase}_SlaveDefRdInterruptHandler);
    ${moduleNameUpperCase}_SlaveSetAddrIntHandler(${moduleNameUpperCase}_SlaveDefAddrInterruptHandler);
    ${moduleNameUpperCase}_SlaveSetWrColIntHandler(${moduleNameUpperCase}_SlaveDefWrColInterruptHandler);
    ${moduleNameUpperCase}_SlaveEnableIrq();    
}

void ${moduleNameUpperCase}_Close() 
{
    ${moduleNameUpperCase}_SlaveClose();
}

uint8_t ${moduleNameUpperCase}_Read()
{
   return ${moduleNameUpperCase}_SlaveGetRxData();
}

void ${moduleNameUpperCase}_Write(uint8_t data)
{
    ${moduleNameUpperCase}_SlaveSendTxData(data);
}

bool ${moduleNameUpperCase}_IsRead()
{
    return ${moduleNameUpperCase}_SlaveIsRead();
}

void ${moduleNameUpperCase}_Enable()
{
    ${moduleNameUpperCase}_Initialize();
}

void ${moduleNameUpperCase}_SendAck()
{
    ${moduleNameUpperCase}_SlaveSendAck();
}

void ${moduleNameUpperCase}_SendNack()
{
    ${moduleNameUpperCase}_SlaveSendNack();
}

static void ${moduleNameUpperCase}_Isr() 
{ 
    ${moduleNameUpperCase}_SlaveClearIrq();

    if(${moduleNameUpperCase}_SlaveIsAddr())
    {
        if(${moduleNameUpperCase}_SlaveIsRead())
        {
            ${moduleNameLowerCase}SlaveState = ${moduleNameUpperCase}_ADDR_TX;
        }
        else
        {
            ${moduleNameLowerCase}SlaveState = ${moduleNameUpperCase}_ADDR_RX;
        }
    }
    else
    {
        if(${moduleNameUpperCase}_SlaveIsRead())
        {
            ${moduleNameLowerCase}SlaveState = ${moduleNameUpperCase}_DATA_TX;
        }
        else
        {
            ${moduleNameLowerCase}SlaveState = ${moduleNameUpperCase}_DATA_RX;
        }
    }

    switch(${moduleNameLowerCase}SlaveState)
    {
        case ${moduleNameUpperCase}_ADDR_TX:
            ${moduleNameUpperCase}_SlaveAddrCallBack();
            if(${moduleNameUpperCase}_SlaveIsTxBufEmpty())
            {
                ${moduleNameUpperCase}_SlaveWrCallBack();
            }
            break;
        case ${moduleNameUpperCase}_ADDR_RX:
            ${moduleNameUpperCase}_SlaveAddrCallBack();
            break;
        case ${moduleNameUpperCase}_DATA_TX:
            if(${moduleNameUpperCase}_SlaveIsTxBufEmpty())
            {
                ${moduleNameUpperCase}_SlaveWrCallBack();
            }
            break;
        case ${moduleNameUpperCase}_DATA_RX:
            if(${moduleNameUpperCase}_SlaveIsRxBufFull())
            {
                ${moduleNameUpperCase}_SlaveRdCallBack();
            }
            break;
        default:
            break;
    }
    ${moduleNameUpperCase}_SlaveReleaseClock();
}

// Common Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetIsrHandler(${moduleNameLowerCase}InterruptHandler handler)
{
    ${moduleInstance}_InterruptHandler = handler;
}

// Read Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetReadIntHandler(${moduleNameLowerCase}InterruptHandler handler) {
    ${moduleNameUpperCase}_SlaveRdInterruptHandler = handler;
}

static void ${moduleNameUpperCase}_SlaveRdCallBack() {
    // Add your custom callback code here
    if (${moduleNameUpperCase}_SlaveRdInterruptHandler) 
    {
        ${moduleNameUpperCase}_SlaveRdInterruptHandler();
    }
}

static void ${moduleNameUpperCase}_SlaveDefRdInterruptHandler() {
    ${moduleNameLowerCase}RdData = ${moduleNameUpperCase}_SlaveGetRxData();
}

// Write Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetWriteIntHandler(${moduleNameLowerCase}InterruptHandler handler) {
    ${moduleNameUpperCase}_SlaveWrInterruptHandler = handler;
}

static void ${moduleNameUpperCase}_SlaveWrCallBack() {
    // Add your custom callback code here
    if (${moduleNameUpperCase}_SlaveWrInterruptHandler) 
    {
        ${moduleNameUpperCase}_SlaveWrInterruptHandler();
    }
}

static void ${moduleNameUpperCase}_SlaveDefWrInterruptHandler() {
    ${moduleNameUpperCase}_SlaveSendTxData(${moduleNameLowerCase}WrData);
}

// ADDRESS Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetAddrIntHandler(${moduleNameLowerCase}InterruptHandler handler){
    ${moduleNameUpperCase}_SlaveAddrInterruptHandler = handler;
}

static void ${moduleNameUpperCase}_SlaveAddrCallBack() {
    // Add your custom callback code here
    if (${moduleNameUpperCase}_SlaveAddrInterruptHandler) {
        ${moduleNameUpperCase}_SlaveAddrInterruptHandler();
    }
}

static void ${moduleNameUpperCase}_SlaveDefAddrInterruptHandler() {
    ${moduleNameLowerCase}SlaveAddr = ${moduleNameUpperCase}_SlaveGetRxData();
}

// Write Collision Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetWrColIntHandler(${moduleNameLowerCase}InterruptHandler handler){
    ${moduleNameUpperCase}_SlaveWrColInterruptHandler = handler;
}

static void  ${moduleNameUpperCase}_SlaveWrColCallBack() {
    // Add your custom callback code here
    if ( ${moduleNameUpperCase}_SlaveWrColInterruptHandler) 
    {
         ${moduleNameUpperCase}_SlaveWrColInterruptHandler();
    }
}

static void ${moduleNameUpperCase}_SlaveDefWrColInterruptHandler() {
}

// Bus Collision Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetBusColIntHandler(${moduleNameLowerCase}InterruptHandler handler){
    ${moduleNameUpperCase}_SlaveBusColInterruptHandler = handler;
}

static void  ${moduleNameUpperCase}_SlaveBusColCallBack() {
    // Add your custom callback code here
    if ( ${moduleNameUpperCase}_SlaveBusColInterruptHandler) 
    {
         ${moduleNameUpperCase}_SlaveBusColInterruptHandler();
    }
}

static void ${moduleNameUpperCase}_SlaveDefBusColInterruptHandler() {
}

static inline bool ${moduleNameUpperCase}_SlaveOpen()
{
    if(!${SSPCON1.name}bits.SSPEN)
    {      
        <#if SSPSTAT??>
        ${SSPSTAT.name}  = ${SSPSTAT.hexValue};
        </#if>
        <#if SSPCON1??>
        ${SSPCON1.name} |= ${SSPCON1.hexValue};
        </#if>
        <#if SSPCON2??>
        ${SSPCON2.name}  = ${SSPCON2.hexValue};
        </#if>
        ${SSPCON1.name}bits.SSPEN = 1;
        return true;
    }
    return false;
}

static inline void ${moduleNameUpperCase}_SlaveClose()
{
    <#if SSPSTAT??>
    ${SSPSTAT.name}  = ${SSPSTAT.hexValue};
    </#if>
    <#if SSPCON1??>
    ${SSPCON1.name} |= ${SSPCON1.hexValue};
    </#if>
    <#if SSPCON2??>
    ${SSPCON2.name}  = ${SSPCON2.hexValue};
    </#if>
    ${SSPCON1.name}bits.SSPEN = 0;
}

static inline void ${moduleNameUpperCase}_SlaveSetSlaveAddr(uint8_t slaveAddr)
{
    <#if SSPADD??>
    ${SSPADD.name} = (uint8_t) (slaveAddr << 1);
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSetSlaveMask(uint8_t maskAddr)
{
    <#if msspVersion == 'v2'>
    <#if SSPCON2??>
    ${SSPCON2.name}bits.ADMSK = maskAddr & 0x1F;
    </#if>
    <#else>
    <#if selectedDevice?contains("K80") || selectedDevice?contains("K22") || selectedDevice?contains("K90")
         || selectedDevice?contains("J13") || selectedDevice?contains("J53")>
    <#if SSPCON1??>
    ${SSPCON1.name}bits.SSPM = 0b1001;
    </#if>
    </#if>
    <#if SSPMSK??>
    ${SSPMSK.name} = (uint8_t) (maskAddr << 1);
    </#if>
    <#if selectedDevice?contains("K80") || selectedDevice?contains("K22") || selectedDevice?contains("K90")
         || selectedDevice?contains("J13") || selectedDevice?contains("J53")>
    <#if SSPCON1??>
    ${SSPCON1.name}bits.SSPM = 0b0110;
    </#if>
    </#if>
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveEnableIrq()
{
    ${SSPI_ENABLE.name} = 1;
}

static inline bool ${moduleNameUpperCase}_SlaveIsAddr()
{
    <#if SSPSTAT??>
    return !(${SSPSTAT.name}bits.D_nA);
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsRead()
{
    <#if SSPSTAT??>
    return (${SSPSTAT.name}bits.R_nW);
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveClearIrq()
{
    ${SSPI_FLAG.name} = 0;
}

static inline void ${moduleNameUpperCase}_SlaveReleaseClock()
{
    <#if SSPCON1??>
    ${SSPCON1.name}bits.CKP = 1;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsWriteCollision()
{
    <#if SSPCON1??>
    return ${SSPCON1.name}bits.WCOL;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsData()
{
    <#if SSPSTAT??>
    return ${SSPSTAT.name}bits.D_nA;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveRestart(void)
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.RSEN = 1;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsTxBufEmpty()
{
    <#if SSPSTAT??>
    return !${SSPSTAT.name}bits.BF;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsRxBufFull()
{
    <#if SSPSTAT??>
    return ${SSPSTAT.name}bits.BF;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSendTxData(uint8_t data)
{
    <#if SSPBUF??>
    ${SSPBUF.name} = data;
    </#if>
}

static inline uint8_t ${moduleNameUpperCase}_SlaveGetRxData()
{
    <#if SSPBUF??>
    return ${SSPBUF.name};
    </#if>
}

static inline uint8_t ${moduleNameUpperCase}_SlaveGetAddr()
{
    <#if SSPADD??>
    return ${SSPADD.name};
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSendAck()
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.ACKDT = 0;
    ${SSPCON2.name}bits.ACKEN = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSendNack()
{
    <#if SSPCON2??>
    ${SSPCON2.name}bits.ACKDT = 1;
    ${SSPCON2.name}bits.ACKEN = 1;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsOverFlow()
{
    <#if SSPCON1??>
    return ${SSPCON1.name}bits.SSPOV;
    </#if>
}