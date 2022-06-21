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
 Section: Function declarations
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
static inline void ${moduleNameUpperCase}_SlaveClearAddrFlag(void);
static inline void ${moduleNameUpperCase}_SlaveClearStartFlag(void);
static inline bool ${moduleNameUpperCase}_SlaveIsStop(void);
static inline void ${moduleNameUpperCase}_SlaveClearBuff(void);
static inline void ${moduleNameUpperCase}_SlaveClearIrq(void);
static inline void ${moduleNameUpperCase}_SlaveSetCounter(uint8_t counter);
static inline void ${moduleNameUpperCase}_SlaveReleaseClock(void);
static inline bool ${moduleNameUpperCase}_SlaveIsWriteCollision(void);
static inline bool ${moduleNameUpperCase}_SlaveIsTxBufEmpty(void);
static inline bool ${moduleNameUpperCase}_SlaveIsData(void);
static inline bool ${moduleNameUpperCase}_SlaveIsRxBufFull(void);
static inline void ${moduleNameUpperCase}_SlaveSendTxData(uint8_t data);
static inline uint8_t ${moduleNameUpperCase}_SlaveGetRxData(void);
static inline uint8_t ${moduleNameUpperCase}_SlaveGetAddr(void);
static inline void ${moduleNameUpperCase}_SlaveSendAck(void);
static inline void ${moduleNameUpperCase}_SlaveSendNack(void);
static inline bool ${moduleNameUpperCase}_SlaveIsNack(void);
static inline void ${moduleNameUpperCase}_SlaveClearNack(void);

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
    <#if I2CCNT??>
    //${I2CCNT.csvComment}
    ${I2CCNT.name} = ${I2CCNT.hexValue};
    <#elseif I2CCNTL??>
    //${I2CCNTL.csvComment}
    ${I2CCNTL.name} = ${I2CCNTL.hexValue};
    <#if I2CCNTH??>
    ${I2CCNTH.name} = ${I2CCNTH.hexValue};
    </#if>
    </#if>
    <#if I2CBAUD??>
    //${I2CBAUD.csvComment}
    ${I2CBAUD.name} = ${I2CBAUD.hexValue};
    </#if>
    <#if isI2cClockPadRegExists>
    //Clock PadReg Configuration
    ${i2cClockPadCtlRegister}   = ${i2cClockPadCtlRegValue};
    </#if>
    <#if isI2cDataPadRegExists>
    //Data PadReg Configuration
    ${i2cDataPadCtlRegister}   = ${i2cDataPadCtlRegValue};
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

uint8_t ${moduleNameUpperCase}_ReadAddr()
{
   return I2C1_SlaveGetAddr();
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
    if(${moduleNameUpperCase}_SlaveIsStop())
    {
        ${moduleNameUpperCase}_SlaveClearIrq();
        ${moduleNameUpperCase}_SlaveClearBuff();
        ${moduleNameUpperCase}_SlaveSetCounter(0xFF);
        ${moduleNameUpperCase}_SlaveReleaseClock();
        ${moduleNameLowerCase}SlaveState = ${moduleNameUpperCase}_IDLE;
    }
    else
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
                ${moduleNameUpperCase}_SlaveClearBuff();
                if(${moduleNameUpperCase}_SlaveIsTxBufEmpty())
                {
                    ${moduleNameUpperCase}_SlaveWrCallBack();
                }
                break;
            case ${moduleNameUpperCase}_ADDR_RX:
                ${moduleNameUpperCase}_SlaveAddrCallBack();
                ${moduleNameUpperCase}_SlaveClearBuff();
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
}

// Common Event Interrupt Handlers
void ${moduleNameUpperCase}_SlaveSetIsrHandler(${moduleNameLowerCase}InterruptHandler handler)
{
    ${moduleNameUpperCase}_InterruptHandler = handler;
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
    ${moduleNameLowerCase}SlaveAddr = ${moduleNameUpperCase}_SlaveGetAddr();
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
    if(!${I2CCON0.name}bits.EN)
    {  
        <#if I2CCON0??>
        ${I2CCON0.name}bits.EN = 1;
        </#if>
        return true;
    }
    return false;
}

static inline void ${moduleNameUpperCase}_SlaveClose()
{
    <#if I2CCON0??>
    ${I2CCON0.name}bits.EN = 0;
    </#if>
    <#if I2CPIR??>
    ${I2CPIR.name} = 0x00;
    </#if>
    <#if I2CSTAT1??>
    ${I2CSTAT1.name}bits.CLRBF = 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSetSlaveAddr(uint8_t slaveAddr)
{
    <#if I2CADR0??>
    ${I2CADR0.name} = (uint8_t) (slaveAddr << 1);
    </#if>
    <#if I2CADR2??>
    ${I2CADR2.name} = (uint8_t) (slaveAddr << 1);
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSetSlaveMask(uint8_t maskAddr)
{
    <#if I2CADR1??>
    ${I2CADR1.name} = (uint8_t) (maskAddr << 1);
    </#if>
    <#if I2CADR3??>
    ${I2CADR3.name} = (uint8_t) (maskAddr << 1);
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveEnableIrq()
{
    ${ICI_ENABLE.name}    = 1;
    ${ICEI_ENABLE.name}   = 1;
    ${ICRXI_ENABLE.name}  = 1;
    ${ICTXI_ENABLE.name}  = 1;
    <#if I2CPIE??>
    ${I2CPIE.name}bits.PCIE = 1; 
    </#if>
    <#if I2CPIE??>
    ${I2CPIE.name}bits.ADRIE = 1; 
    </#if>
    <#if I2CERR??>
    ${I2CERR.name}bits.NACKIE = 1; 
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsAddr()
{
    <#if I2CSTAT0??>
    return !(${I2CSTAT0.name}bits.D); 
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsRead()
{
    <#if I2CSTAT0??>
    return ${I2CSTAT0.name}bits.R; 
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveClearAddrFlag()
{
    <#if I2CPIR??>
    ${I2CPIR.name}bits.ADRIF = 0; 
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveClearStartFlag()
{
    <#if I2CPIR??>
    ${I2CPIR.name}bits.SCIF = 0; 
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsStop()
{
    <#if I2CPIR??>
    return ${I2CPIR.name}bits.PCIF; 
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveClearBuff()
{
    <#if I2CSTAT1??>
    ${I2CSTAT1.name}bits.CLRBF = 1; 
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveClearIrq()
{
    <#if I2CPIR??>
    ${I2CPIR.name} = 0x00; 
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSetCounter(uint8_t counter)
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

static inline void ${moduleNameUpperCase}_SlaveReleaseClock()
{
    <#if I2CCON0??>
    ${I2CCON0.name}bits.CSTR = 0;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsWriteCollision()
{
    <#if I2CERR??>
    return ${I2CERR.name}bits.BCLIF;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsTxBufEmpty()
{
    <#if I2CSTAT1??>
    return ${I2CSTAT1.name}bits.TXBE;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsData()
{
    <#if I2CSTAT0??>
    return ${I2CSTAT0.name}bits.D;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsRxBufFull()
{
    <#if I2CSTAT1??>
    return ${I2CSTAT1.name}bits.RXBF;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSendTxData(uint8_t data)
{
    <#if I2CTXB??>
    ${I2CTXB.name} = data;
    </#if>
}

static inline uint8_t ${moduleNameUpperCase}_SlaveGetRxData()
{
    <#if I2CRXB??>
    return ${I2CRXB.name};
    </#if>
}

static inline uint8_t ${moduleNameUpperCase}_SlaveGetAddr()
{
    <#if I2CADB0??>
    return ${I2CADB0.name} >> 1;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveSendAck()
{
    <#if I2CCON1??>
    ${I2CCON1.name}bits.ACKDT = 0;
    </#if>
}


static inline void ${moduleNameUpperCase}_SlaveSendNack()
{
    <#if I2CCON1??>
    ${I2CCON1.name}bits.ACKDT = 1;
    </#if>
}

static inline bool ${moduleNameUpperCase}_SlaveIsNack()
{
    <#if I2CERR??>
    return ${I2CERR.name}bits.NACKIF;
    </#if>
}

static inline void ${moduleNameUpperCase}_SlaveClearNack()
{
    <#if I2CERR??>
    ${I2CERR.name}bits.NACKIF = 0;
    </#if>
}

<#if isVectoredInterrupt>
<#if isHighPriority>
void __interrupt(irq(${transmitIrqName},${receiveIrqName},${errorIrqName},${i2cIrqName}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_ISR()
<#else>
void __interrupt(irq(${transmitIrqName},${receiveIrqName},${errorIrqName},${i2cIrqName}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_ISR()
</#if>
{
    ${moduleNameUpperCase}_Isr();
}
</#if>