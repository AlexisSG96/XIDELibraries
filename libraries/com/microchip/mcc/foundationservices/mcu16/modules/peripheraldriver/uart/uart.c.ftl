 <#assign settings = pcgConfiguration.configuration.settings>
<#assign data = pcgConfiguration.configuration.data>
<#assign moduleNameUpperCase = data.moduleName?upper_case>
<#assign moduleNameLowerCase = data.moduleName?lower_case>
<#assign instanceNumber = settings.instanceNumber>
<#assign moduleName = data.moduleName>
<#assign UTXREG = data.getRegisterByAlias("UTXREG").name>
<#assign URXREG = data.getRegisterByAlias("URXREG").name>
<#assign StatusReg = data.getRegisterByAlias("USTA").name>
<#assign interruptTransmit = data.getInterrupt("UTXI")>
<#if settings.usesInterrupt("UTXI")>
	<#assign transmitInterrupt = settings.getInterrupt("UTXI")>
</#if>
<#assign interruptReceive = data.getInterrupt("URXI")>
<#if settings.usesInterrupt("URXI")>
	<#assign receiveInterrupt = settings.getInterrupt("URXI")>
</#if>
<#assign interruptError = data.getInterrupt("UERI")>
<#if settings.usesInterrupt("UERI")>
	<#assign errorInterrupt = settings.getInterrupt("UERI")>
</#if>
<#assign version = 0.5>
/**
  ${data.moduleName} Generated Driver File 

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated source file for the ${data.moduleName} driver using ${pcgConfiguration.productName}

  @Description
    This source file provides APIs for driver for ${data.moduleName}. 

    Generation Information : 
        Product Revision  :  ${pcgConfiguration.productName} - ${pcgConfiguration.productVersion}
        Device            :  ${pcgConfiguration.selectedDevice}
    The generated drivers are tested against the following:
        Compiler          :  ${pcgConfiguration.compiler}
        MPLAB 	          :  ${pcgConfiguration.tool}
*/

${pcgConfiguration.disclaimer}

/**
  Section: Included Files
*/
#include <stdbool.h>
#include <stdint.h>
#include "xc.h"
#include "${moduleNameLowerCase}.h"

/**
  Section: Data Type Definitions
*/

/** UART Driver Queue Status

  @Summary
    Defines the object required for the status of the queue.
*/

static uint8_t * volatile rxTail;
static uint8_t *rxHead;
static uint8_t *txTail;
static uint8_t * volatile txHead;
static bool volatile rxOverflowed;

/** UART Driver Queue Length

  @Summary
    Defines the length of the Transmit and Receive Buffers

*/

#define ${moduleNameUpperCase}_CONFIG_TX_BYTEQ_LENGTH (${settings.transmitBufferSize}+1)
#define ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH (${settings.receiveBufferSize}+1)

/** UART Driver Queue

  @Summary
    Defines the Transmit and Receive Buffers

*/

static uint8_t txQueue[${moduleNameUpperCase}_CONFIG_TX_BYTEQ_LENGTH] ;
static uint8_t rxQueue[${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH] ;

void (*${moduleNameUpperCase}_TxDefaultInterruptHandler)(void);
void (*${moduleNameUpperCase}_RxDefaultInterruptHandler)(void);

/**
  Section: Driver Interface
*/

<#list settings.initializers as initializer>

void ${moduleNameUpperCase}_${initializer.customName} (void)
{
   <#if transmitInterrupt??>${transmitInterrupt.enableBitName} = 0;</#if>
   <#if receiveInterrupt??>${receiveInterrupt.enableBitName} = 0;</#if>
   
   <#list initializer.registers as reg>
   <#if (reg.name!=UTXREG) && (reg.name!=URXREG) >
    <#if (reg.alias=="UMODE") >
   // ${reg.comment}
   ${reg.name} = (${reg.value} & ~(1<<15));  // disabling UART
    <#else>
   // ${reg.comment}
   ${reg.name} = ${reg.value};
    </#if>  
   </#if>
   </#list>
   
   txHead = txQueue;
   txTail = txQueue;
   rxHead = rxQueue;
   rxTail = rxQueue;
   
   rxOverflowed = 0;

   <#if transmitInterrupt??>${moduleNameUpperCase}_SetTxInterruptHandler(${moduleNameUpperCase}_Transmit_ISR);</#if>

   <#if receiveInterrupt??>
   ${moduleNameUpperCase}_SetRxInterruptHandler(${moduleNameUpperCase}_Receive_ISR);
   ${receiveInterrupt.enableBitName} = 1;
   </#if>
   
    //Make sure to set LAT bit corresponding to TxPin as high before UART initialization
   <#assign reg = data.getRegisterByAlias("UMODE")>
   ${reg.name}bits.${reg.getSettingByAlias("UARTEN").name} = 1;  // enabling UART ON bit
   <#assign reg = data.getRegisterByAlias("USTA")>
   ${reg.name}bits.${reg.getSettingByAlias("UTXEN").name} = 1;
}

</#list>
/**
    Maintains the driver's transmitter state machine and implements its ISR
*/
<#if transmitInterrupt??>
void ${moduleNameUpperCase}_SetTxInterruptHandler(void* handler){
    ${moduleNameUpperCase}_TxDefaultInterruptHandler = handler;
}

void __attribute__ ( ( interrupt, no_auto_psv ) ) ${transmitInterrupt.handlerName} ( void )
{
    (*${moduleNameUpperCase}_TxDefaultInterruptHandler)();
}

void ${moduleNameUpperCase}_Transmit_ISR(void)
<#else>
void ${moduleNameUpperCase}_TasksTransmit ( void )
</#if>
{ 
    if(txHead == txTail)
    {
        <#if transmitInterrupt??>${transmitInterrupt.enableBitName} = 0;</#if>
        return;
    }

    ${interruptTransmit.flagName} = 0;

    while(!(${StatusReg}bits.UTXBF == 1))
    {
        ${UTXREG} = *txHead++;

        if(txHead == (txQueue + ${moduleNameUpperCase}_CONFIG_TX_BYTEQ_LENGTH))
        {
            txHead = txQueue;
        }

        // Are we empty?
        if(txHead == txTail)
        {
            break;
        }
    }
}

<#if receiveInterrupt??>
void ${moduleNameUpperCase}_SetRxInterruptHandler(void* handler){
    ${moduleNameUpperCase}_RxDefaultInterruptHandler = handler;
}

void __attribute__ ( ( interrupt, no_auto_psv ) ) ${receiveInterrupt.handlerName}( void )
{
    (*${moduleNameUpperCase}_RxDefaultInterruptHandler)();
}

void ${moduleNameUpperCase}_Receive_ISR(void)
<#else>
void ${moduleNameUpperCase}_TasksReceive ( void )
</#if>
{
    while((${StatusReg}bits.URXDA == 1))
    {
        *rxTail = ${URXREG};

        // Will the increment not result in a wrap and not result in a pure collision?
        // This is most often condition so check first
        if ( ( rxTail    != (rxQueue + ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH-1)) &&
             ((rxTail+1) != rxHead) )
        {
            rxTail++;
        } 
        else if ( (rxTail == (rxQueue + ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH-1)) &&
                  (rxHead !=  rxQueue) )
        {
            // Pure wrap no collision
            rxTail = rxQueue;
        } 
        else // must be collision
        {
            rxOverflowed = true;
        }

    }

    ${interruptReceive.flagName} = 0;
}

<#if errorInterrupt??>
void __attribute__ ( ( interrupt, no_auto_psv ) ) ${errorInterrupt.handlerName} ( void )
<#else>
void ${moduleNameUpperCase}_TasksError ( void )
</#if>
{
    if ((${StatusReg}bits.${reg.getSettingByAlias("OERR").name} == 1))
    {
        ${StatusReg}bits.${reg.getSettingByAlias("OERR").name} = 0;
    }

    ${interruptError.flagName} = 0;
}

/**
  Section: ${data.moduleGroup} Driver Client Routines
*/

uint8_t ${moduleNameUpperCase}_Read( void)
{
    uint8_t data = 0;

    while (rxHead == rxTail )
    {
    }
    
    data = *rxHead;

    rxHead++;

    if (rxHead == (rxQueue + ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH))
    {
        rxHead = rxQueue;
    }
    return data;
}

void ${moduleNameUpperCase}_Write( uint8_t byte)
{
    while(${moduleNameUpperCase}_IsTxReady() == 0)
    {
    }

    *txTail = byte;

    txTail++;
    
    if (txTail == (txQueue + ${moduleNameUpperCase}_CONFIG_TX_BYTEQ_LENGTH))
    {
        txTail = txQueue;
    }

    <#if transmitInterrupt??>${transmitInterrupt.enableBitName} = 1;</#if>
}

bool ${moduleNameUpperCase}_IsRxReady(void)
{    
    return !(rxHead == rxTail);
}

bool ${moduleNameUpperCase}_IsTxReady(void)
{
    uint16_t size;
    uint8_t *snapshot_txHead = (uint8_t*)txHead;
    
    if (txTail < snapshot_txHead)
    {
        size = (snapshot_txHead - txTail - 1);
    }
    else
    {
        size = ( ${moduleNameUpperCase}_CONFIG_TX_BYTEQ_LENGTH - (txTail - snapshot_txHead) - 1 );
    }
    
    return (size != 0);
}

bool ${moduleNameUpperCase}_IsTxDone(void)
{
    if(txTail == txHead)
    {
        return (bool)${data.getRegisterByAlias("USTA").name}bits.${data.getSettingByAlias("TRMT").name};
    }
    
    return false;
}

<#if settings.usePrintf>
int __attribute__((__section__(".libc.write"))) write(int handle, void *buffer, unsigned int len) {
    unsigned int i;
    uint8_t *data = buffer;

    for(i=0; i<len; i++)
    {
        while(${moduleNameUpperCase}_IsTxReady() == false)
        {
        }

        ${moduleNameUpperCase}_Write(*data++);
    }
  
    return(len);
}
</#if>

/* !!! Deprecated API - This function may not be supported in a future release !!! */
static uint8_t ${moduleNameUpperCase}_RxDataAvailable(void)
{
    uint16_t size;
    uint8_t *snapshot_rxTail = (uint8_t*)rxTail;
    
    if (snapshot_rxTail < rxHead) 
    {
        size = ( ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH - (rxHead-snapshot_rxTail));
    }
    else
    {
        size = ( (snapshot_rxTail - rxHead));
    }
    
    if(size > 0xFF)
    {
        return 0xFF;
    }
    
    return size;
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
uint8_t __attribute__((deprecated)) ${moduleNameUpperCase}_is_rx_ready(void)
{
    return ${moduleNameUpperCase}_RxDataAvailable();
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
static uint8_t ${moduleNameUpperCase}_TxDataAvailable(void)
{
    uint16_t size;
    uint8_t *snapshot_txHead = (uint8_t*)txHead;
    
    if (txTail < snapshot_txHead)
    {
        size = (snapshot_txHead - txTail - 1);
    }
    else
    {
        size = ( ${moduleNameUpperCase}_CONFIG_TX_BYTEQ_LENGTH - (txTail - snapshot_txHead) - 1 );
    }
    
    if(size > 0xFF)
    {
        return 0xFF;
    }
    
    return size;
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
uint8_t __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_ready(void)
{
    return ${moduleNameUpperCase}_TxDataAvailable();
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${moduleNameUpperCase}_is_tx_done(void)
{
    return ${moduleNameUpperCase}_IsTxDone();
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
unsigned int __attribute__((deprecated)) ${moduleNameUpperCase}_ReadBuffer( uint8_t *buffer ,  unsigned int numbytes)
{
    unsigned int rx_count = ${moduleNameUpperCase}_RxDataAvailable();
    unsigned int i;
    
    if(numbytes < rx_count)
    {
        rx_count = numbytes;
    }
    
    for(i=0; i<rx_count; i++)
    {
        *buffer++ = ${moduleNameUpperCase}_Read();
    }
    
    return rx_count;    
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
unsigned int __attribute__((deprecated)) ${moduleNameUpperCase}_WriteBuffer( uint8_t *buffer , unsigned int numbytes )
{
    unsigned int tx_count = ${moduleNameUpperCase}_TxDataAvailable();
    unsigned int i;
    
    if(numbytes < tx_count)
    {
        tx_count = numbytes;
    }
    
    for(i=0; i<tx_count; i++)
    {
        ${moduleNameUpperCase}_Write(*buffer++);
    }
    
    return tx_count;  
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
${moduleNameUpperCase}_TRANSFER_STATUS __attribute__((deprecated)) ${moduleNameUpperCase}_TransferStatusGet (void )
{
    ${moduleNameUpperCase}_TRANSFER_STATUS status = 0;
    uint8_t rx_count = ${moduleNameUpperCase}_RxDataAvailable();
    uint8_t tx_count = ${moduleNameUpperCase}_TxDataAvailable();
    
    switch(rx_count)
    {
        case 0:
            status |= ${moduleNameUpperCase}_TRANSFER_STATUS_RX_EMPTY;
            break;
        case ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH:
            status |= ${moduleNameUpperCase}_TRANSFER_STATUS_RX_FULL;
            break;
        default:
            status |= ${moduleNameUpperCase}_TRANSFER_STATUS_RX_DATA_PRESENT;
            break;
    }
    
    switch(tx_count)
    {
        case 0:
            status |= ${moduleNameUpperCase}_TRANSFER_STATUS_TX_FULL;
            break;
        case ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH:
            status |= ${moduleNameUpperCase}_TRANSFER_STATUS_TX_EMPTY;
            break;
        default:
            break;
    }

    return status;    
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
uint8_t __attribute__((deprecated)) ${moduleNameUpperCase}_Peek(uint16_t offset)
{
    uint8_t *peek = rxHead + offset;
    
    while(peek > (rxQueue + ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH))
    {
        peek -= ${moduleNameUpperCase}_CONFIG_RX_BYTEQ_LENGTH;
    }
    
    return *peek;
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${moduleNameUpperCase}_ReceiveBufferIsEmpty (void)
{
    return (${moduleNameUpperCase}_RxDataAvailable() == 0);
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
bool __attribute__((deprecated)) ${moduleNameUpperCase}_TransmitBufferIsFull (void)
{
    return (${moduleNameUpperCase}_TxDataAvailable() == 0);
}

/* !!! Deprecated API - This function may not be supported in a future release !!! */
${moduleNameUpperCase}_STATUS __attribute__((deprecated)) ${moduleNameUpperCase}_StatusGet (void )
{
    return ${StatusReg};
}

