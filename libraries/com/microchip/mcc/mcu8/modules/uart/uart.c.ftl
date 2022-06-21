/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This source file provides APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.4.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB             :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/
#include <xc.h>
#include "${moduleNameLowerCase}.h"
<#if usesInterruptUTXI>
<#if isTransmitVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
<#elseif usesInterruptURXI>
<#if isReceiveVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
<#elseif usesInterruptUEI>
<#if isframingErrorVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
<#elseif usesInterruptUI>
<#if isUartVectoredInterruptEnabled>
#include "interrupt_manager.h"
</#if>
</#if>

<#if usesInterruptURXI || usesInterruptUTXI>
/**
  Section: Macro Declarations
*/
#define ${moduleNameUpperCase}_TX_BUFFER_SIZE ${transmitBufferSize}
#define ${moduleNameUpperCase}_RX_BUFFER_SIZE ${receiveBufferSize}

/**
  Section: Global Variables
*/

<#if usesInterruptUTXI>
static volatile uint8_t ${moduleNameLowerCase}TxHead = 0;
static volatile uint8_t ${moduleNameLowerCase}TxTail = 0;
static volatile uint8_t ${moduleNameLowerCase}TxBuffer[${moduleNameUpperCase}_TX_BUFFER_SIZE];
volatile uint8_t ${moduleNameLowerCase}TxBufferRemaining;
</#if>

<#if usesInterruptURXI>
static volatile uint8_t ${moduleNameLowerCase}RxHead = 0;
static volatile uint8_t ${moduleNameLowerCase}RxTail = 0;
static volatile uint8_t ${moduleNameLowerCase}RxBuffer[${moduleNameUpperCase}_RX_BUFFER_SIZE];
static volatile ${moduleNameLowerCase}_status_t ${moduleNameLowerCase}RxStatusBuffer[${moduleNameUpperCase}_RX_BUFFER_SIZE];
volatile uint8_t ${moduleNameLowerCase}RxCount;
</#if>
</#if>
static volatile ${moduleNameLowerCase}_status_t ${moduleNameLowerCase}RxLastError;

/**
  Section: ${moduleNameUpperCase} APIs
*/
void (*${dataHandlers["framingErrorHandler"]})(void);
void (*${dataHandlers["overrunErrorHandler"]})(void);
void (*${dataHandlers["errorHandler"]})(void);

void ${moduleNameUpperCase}_DefaultFramingErrorHandler(void);
void ${moduleNameUpperCase}_DefaultOverrunErrorHandler(void);
void ${moduleNameUpperCase}_DefaultErrorHandler(void);

<#list initializers as initializer>
void ${initializer}(void)
{
    // Disable interrupts before changing states
    <#if usesInterruptURXI>
    ${receiveInterruptEnable} = 0;
    ${moduleNameUpperCase}_SetRxInterruptHandler(${moduleNameUpperCase}_${interruptReceiveFunctionName});
	</#if>
	<#if usesInterruptUTXI>
    ${transmitInterruptEnable} = 0;
    ${moduleNameUpperCase}_SetTxInterruptHandler(${moduleNameUpperCase}_${interruptTransmitFunctionName});
	</#if>
	<#if usesInterruptUEI>
    ${errorInterruptEnable} = 0;
    ${moduleNameUpperCase}_SetFramingErrorInterruptHandler(${moduleNameUpperCase}_${interruptFramingErrorFunctionName});
	</#if>
	<#if usesInterruptUI>
    ${uartInterruptEnable} = 0;
    ${moduleNameUpperCase}_SetUartInterruptHandler(${moduleNameUpperCase}_${interruptUartFunctionName});
	</#if>

    // Set the ${moduleNameUpperCase} module to the options selected in the user interface.

    <#list initRegisters as reg>
    // ${reg.comment}
    ${reg.name} = ${reg.value};

    </#list>

    ${functionAPI["setFramingErrorHandler"]}(${dataHandlers["defaultFramingErrorHandler"]});
    ${functionAPI["setOverrunErrorHandler"]}(${dataHandlers["defaultOverrunErrorHandler"]});
    ${functionAPI["setErrorHandler"]}(${dataHandlers["defaultErrorHandler"]});

    ${moduleNameLowerCase}RxLastError.status = 0;

    <#if usesInterruptUTXI>    
    // initializing the driver state
    ${moduleNameLowerCase}TxHead = 0;
    ${moduleNameLowerCase}TxTail = 0;
    ${moduleNameLowerCase}TxBufferRemaining = sizeof(${moduleNameLowerCase}TxBuffer);
    </#if>
    <#if usesInterruptURXI>
    ${moduleNameLowerCase}RxHead = 0;
    ${moduleNameLowerCase}RxTail = 0;
    ${moduleNameLowerCase}RxCount = 0;

    // enable receive interrupt
    ${receiveInterruptEnable} = 1;
    </#if>
    <#if usesInterruptUEI>
    // enable error interrupt
    ${errorInterruptEnable} = 1;
    </#if>
    <#if usesInterruptUI>
    // enable uart interrupt
    ${uartInterruptEnable} = 1;
    </#if>
}
</#list>

bool ${functionAPI["DataReady"]}(void)
{
    <#if usesInterruptURXI>
    return (${moduleNameLowerCase}RxCount ? true : false);
    <#else>
    return (bool)(${interruptReceiveFlagName});
    </#if>
}

bool ${functionAPI["TransmitReady"]}(void)
{
    <#if usesInterruptUTXI>
    return (${moduleNameLowerCase}TxBufferRemaining ? true : false);
    <#else>
    return (bool)(${interruptTransmitFlagName} && ${transmitEnable});
    </#if>
}

bool ${functionAPI["TransmitDone"]}(void)
{
    return ${tsrStatusFlag};
}

${moduleNameLowerCase}_status_t ${functionAPI["getLastStatus"]}(void){
    return ${moduleNameLowerCase}RxLastError;
}

<#if usesInterruptURXI>
uint8_t ${functionAPI["Read"]}(void)
{
    uint8_t readValue  = 0;
    
    while(0 == ${moduleNameLowerCase}RxCount)
    {
    }

    ${moduleNameLowerCase}RxLastError = ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxTail];

    readValue = ${moduleNameLowerCase}RxBuffer[${moduleNameLowerCase}RxTail++];
   	if(sizeof(${moduleNameLowerCase}RxBuffer) <= ${moduleNameLowerCase}RxTail)
    {
        ${moduleNameLowerCase}RxTail = 0;
    }
    ${receiveInterruptEnable} = 0;
    ${moduleNameLowerCase}RxCount--;
    ${receiveInterruptEnable} = 1;

    return readValue;
}
<#else>
uint8_t ${functionAPI["Read"]}(void)
{
    while(!${interruptReceiveFlagName})
    {
    }

    ${moduleNameLowerCase}RxLastError.status = 0;

    if(${framingErrorInterruptFlag}){
        ${moduleNameLowerCase}RxLastError.ferr = 1;
        ${dataHandlers["framingErrorHandler"]}();
    }

    if(${overflowErrorInterruptFlag}){
        ${moduleNameLowerCase}RxLastError.oerr = 1;
        ${dataHandlers["overrunErrorHandler"]}();
    }

    if(${moduleNameLowerCase}RxLastError.status){
        ${dataHandlers["errorHandler"]}();
    }

    return ${receiveDataRegister};
}
</#if>

<#if usesInterruptUTXI>
void ${functionAPI["Write"]}(uint8_t txData)
{
    while(0 == ${moduleNameLowerCase}TxBufferRemaining)
    {
    }

    if(0 == ${transmitInterruptEnable})
    {
        ${transmitDataRegister} = txData;
    }
    else
    {
        ${transmitInterruptEnable} = 0;
        ${moduleNameLowerCase}TxBuffer[${moduleNameLowerCase}TxHead++] = txData;
        if(sizeof(${moduleNameLowerCase}TxBuffer) <= ${moduleNameLowerCase}TxHead)
        {
            ${moduleNameLowerCase}TxHead = 0;
        }
        ${moduleNameLowerCase}TxBufferRemaining--;
    }
    ${transmitInterruptEnable} = 1;
}
<#else>
void ${functionAPI["Write"]}(uint8_t txData)
{
    while(0 == ${interruptTransmitFlagName})
    {
    }

    ${transmitDataRegister} = txData;    // Write the data byte to the USART.
}
</#if>
<#if useStdio>

char getch(void)
{
    return ${functionAPI["Read"]}();
}

void putch(char txData)
{
    ${functionAPI["Write"]}(txData);
}
</#if>
<#if asynchronous9bit>

void ${moduleNameUpperCase}_SetAddresstoTransmit(uint8_t txAddress)
{
    ${uartParameter1LowRegister} = txAddress;
}
</#if>
<#if usesInterruptUTXI>

<#if isTransmitVectoredInterruptEnabled>
<#if transmitInterruptPriorityHigh>
void __interrupt(irq(${transmitIRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_tx_vect_isr()
<#else>
void __interrupt(irq(${transmitIRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_tx_vect_isr()
</#if>
{   
    if(${moduleNameUpperCase}_TxInterruptHandler)
    {
        ${moduleNameUpperCase}_TxInterruptHandler();
    }
}
</#if>
</#if>
<#if usesInterruptURXI>

<#if isReceiveVectoredInterruptEnabled>
<#if receiveInterruptPriorityHigh>
void __interrupt(irq(${receiveIRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_rx_vect_isr()
<#else>
void __interrupt(irq(${receiveIRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_rx_vect_isr()
</#if>
{
    if(${moduleNameUpperCase}_RxInterruptHandler)
    {
        ${moduleNameUpperCase}_RxInterruptHandler();
    }
}
</#if>
</#if>

<#if usesInterruptUEI>
<#if isframingErrorVectoredInterruptEnabled>
<#if framingErrorInterruptPriorityHigh>
void __interrupt(irq(${framingErrorIRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_framing_err_vect_isr()
<#else>
void __interrupt(irq(${framingErrorIRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_framing_err_vect_isr()
</#if>
{
    if(${moduleNameUpperCase}_FramingErrorInterruptHandler)
    {
        ${moduleNameUpperCase}_FramingErrorInterruptHandler();
    }
}
</#if>
</#if>

<#if usesInterruptUI>
<#if isUartVectoredInterruptEnabled>
<#if uartInterruptPriorityHigh>
void __interrupt(irq(${uartIRQname}),base(${IVTBaseAddress})) ${moduleNameUpperCase}_vect_isr()
<#else>
void __interrupt(irq(${uartIRQname}),base(${IVTBaseAddress}),low_priority) ${moduleNameUpperCase}_vect_isr()
</#if>
{
    if(${moduleNameUpperCase}_UARTInterruptHandler)
    {
        ${moduleNameUpperCase}_UARTInterruptHandler();
    }
}
</#if>
</#if>

<#if usesInterruptUTXI>
void ${moduleNameUpperCase}_Transmit_ISR(void)
{
    // use this default transmit interrupt handler code
    if(sizeof(${moduleNameLowerCase}TxBuffer) > ${moduleNameLowerCase}TxBufferRemaining)
    {
        ${transmitDataRegister} = ${moduleNameLowerCase}TxBuffer[${moduleNameLowerCase}TxTail++];
       if(sizeof(${moduleNameLowerCase}TxBuffer) <= ${moduleNameLowerCase}TxTail)
        {
            ${moduleNameLowerCase}TxTail = 0;
        }
        ${moduleNameLowerCase}TxBufferRemaining++;
    }
    else
    {
        ${transmitInterruptEnable} = 0;
    }
    
    // or set custom function using ${moduleNameUpperCase}_SetTxInterruptHandler()
}
</#if>

<#if usesInterruptURXI>
void ${moduleNameUpperCase}_Receive_ISR(void)
{
    // use this default receive interrupt handler code
    ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].status = 0;

    if(${framingErrorInterruptFlag}){
        ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].ferr = 1;
        ${dataHandlers["framingErrorHandler"]}();
    }
    
    if(${overflowErrorInterruptFlag}){
        ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].oerr = 1;
        ${dataHandlers["overrunErrorHandler"]}();
    }
    
    if(${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].status){
        ${dataHandlers["errorHandler"]}();
    } else {
        ${functionAPI["rxDataHandler"]}();
    }

    // or set custom function using ${moduleNameUpperCase}_SetRxInterruptHandler()
}

void ${functionAPI["rxDataHandler"]}(void){
    // use this default receive interrupt handler code
    ${moduleNameLowerCase}RxBuffer[${moduleNameLowerCase}RxHead++] = ${receiveDataRegister};
    if(sizeof(${moduleNameLowerCase}RxBuffer) <= ${moduleNameLowerCase}RxHead)
    {
        ${moduleNameLowerCase}RxHead = 0;
    }
    ${moduleNameLowerCase}RxCount++;
}
</#if>

void ${moduleNameUpperCase}_DefaultFramingErrorHandler(void){}

void ${moduleNameUpperCase}_DefaultOverrunErrorHandler(void){}

void ${moduleNameUpperCase}_DefaultErrorHandler(void){
<#if usesInterruptURXI>
    ${functionAPI["rxDataHandler"]}();
</#if>
}

void ${functionAPI["setFramingErrorHandler"]}(void (* interruptHandler)(void)){
    ${dataHandlers["framingErrorHandler"]} = interruptHandler;
}

void ${functionAPI["setOverrunErrorHandler"]}(void (* interruptHandler)(void)){
    ${dataHandlers["overrunErrorHandler"]} = interruptHandler;
}

void ${functionAPI["setErrorHandler"]}(void (* interruptHandler)(void)){
    ${dataHandlers["errorHandler"]} = interruptHandler;
}

<#if usesInterruptUEI>
void ${moduleNameUpperCase}_FramingError_ISR(void)
{
    // To clear the interrupt condition, all bits in the UxERRIR register must be cleared
    ${uartErrorInterruptFlagRegister} = 0;
    
    // add your ${moduleNameUpperCase} error interrupt custom code

}
</#if>

<#if usesInterruptUI>
void ${moduleNameUpperCase}_UartInterrupt_ISR(void)
{
    // WUIF must be cleared by software to clear UxIF
    ${uartWakeupInterruptFlagName} = 0;
    
    // add your ${moduleNameUpperCase} interrupt custom code
}
</#if>

<#if usesInterruptURXI>
void ${moduleNameUpperCase}_SetRxInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_RxInterruptHandler = InterruptHandler;
}
</#if>

<#if usesInterruptUTXI>
void ${moduleNameUpperCase}_SetTxInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_TxInterruptHandler = InterruptHandler;
}
</#if>

<#if usesInterruptUEI>
void ${moduleNameUpperCase}_SetFramingErrorInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_FramingErrorInterruptHandler = InterruptHandler;
}
</#if>

<#if usesInterruptUI>
void ${moduleNameUpperCase}_SetUartInterruptHandler(void (* InterruptHandler)(void)){
    ${moduleNameUpperCase}_UARTInterruptHandler = InterruptHandler;
}
</#if>
/**
  End of File
*/
