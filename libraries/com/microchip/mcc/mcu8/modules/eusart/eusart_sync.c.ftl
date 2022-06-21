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
        Driver Version    :  2.1.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler}
        MPLAB 	          :  ${tool}
*/

${disclaimer}

/**
  Section: Included Files
*/
#include "${moduleNameLowerCase}.h"

<#if usesInterrupt>
/**
  Section: Macro Declarations
*/

#define ${moduleNameUpperCase}_TX_BUFFER_SIZE ${transmitBufferSize}
#define ${moduleNameUpperCase}_RX_BUFFER_SIZE ${receiveBufferSize}

/**
  Section: Global Variables
*/
<#if usesInterruptTXI>
volatile uint8_t ${moduleNameLowerCase}TxHead = 0;
volatile uint8_t ${moduleNameLowerCase}TxTail = 0;
volatile uint8_t ${moduleNameLowerCase}TxBuffer[${moduleNameUpperCase}_TX_BUFFER_SIZE];
volatile uint8_t ${moduleNameLowerCase}TxBufferRemaining;
</#if>

<#if usesInterruptRCI>
volatile uint8_t ${moduleNameLowerCase}RxHead = 0;
volatile uint8_t ${moduleNameLowerCase}RxTail = 0;
volatile uint8_t ${moduleNameLowerCase}RxBuffer[${moduleNameUpperCase}_RX_BUFFER_SIZE];
volatile ${moduleNameLowerCase}_status_t ${moduleNameLowerCase}RxStatusBuffer[${moduleNameUpperCase}_RX_BUFFER_SIZE];
volatile uint8_t ${moduleNameLowerCase}RxCount;
</#if>
</#if>
volatile ${moduleNameLowerCase}_status_t ${moduleNameLowerCase}RxLastError;

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
<#if usesInterrupt>
    // disable interrupts before changing states
<#if usesInterruptRCI>
    ${receiveInterruptEnable} = 0;
    ${moduleNameUpperCase}_SetRxInterruptHandler(${moduleNameUpperCase}_${interruptReceiveFunctionName});
</#if>
<#if usesInterruptTXI>
    ${transmitInterruptEnable} = 0;
    ${moduleNameUpperCase}_SetTxInterruptHandler(${moduleNameUpperCase}_${interruptTransmitFunctionName});
</#if>
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

<#if usesInterruptTXI>    
    // initializing the driver state
    ${moduleNameLowerCase}TxHead = 0;
    ${moduleNameLowerCase}TxTail = 0;
    ${moduleNameLowerCase}TxBufferRemaining = sizeof(${moduleNameLowerCase}TxBuffer);
</#if>
<#if usesInterruptRCI>

    ${moduleNameLowerCase}RxHead = 0;
    ${moduleNameLowerCase}RxTail = 0;
    ${moduleNameLowerCase}RxCount = 0;

    // enable receive interrupt
    ${receiveInterruptEnable} = 1;
</#if>
}
</#list>

bool ${functionAPI["TransmitReady"]}(void)
{
    <#if usesInterruptTXI>
    return (${moduleNameLowerCase}TxBufferRemaining ? true : false);
    <#else>
    return (bool)(${interruptTransmitFlagName} && ${transmitEnable});
    </#if>
}

bool ${functionAPI["DataReady"]}(void)
{
    <#if usesInterruptRCI>
    return (${moduleNameLowerCase}RxCount ? true : false);
    <#else>
    return (bool)(${interruptReceiveFlagName});
    </#if>
}

bool ${functionAPI["TransmitDone"]}(void)
{
    return ${tsrStatusFlag};
}

${moduleNameLowerCase}_status_t ${functionAPI["getLastStatus"]}(void){
    return ${moduleNameLowerCase}RxLastError;
}

<#if usesInterruptRCI>
uint8_t ${functionAPI["Read"]}(void)
{
    uint8_t readValue  = 0;
    ${singleReceiveEnable} = 1;
    
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
    ${singleReceiveEnable} = 1;
    while(!${interruptReceiveFlagName})
    {
    }

    ${moduleNameLowerCase}RxLastError.status = 0;

    if(${framingError}){
        ${moduleNameLowerCase}RxLastError.ferr = 1;
        ${dataHandlers["framingErrorHandler"]}();
    }
    
    if(${overrunError}){
        ${moduleNameLowerCase}RxLastError.oerr = 1;
        ${dataHandlers["overrunErrorHandler"]}();
    }

    if(${moduleNameLowerCase}RxLastError.status){
        ${dataHandlers["errorHandler"]}();
    }

    return ${receiveDataRegister};
}
</#if>

<#if usesInterruptTXI>
void ${functionAPI["Write"]}(uint8_t txData)
{
    ${singleReceiveEnable} = 0;
    ${continousReceiveEnable} = 0;	
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
    ${singleReceiveEnable} = 0;
    ${continousReceiveEnable} = 0;	
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
<#if usesInterruptTXI>
void ${moduleNameUpperCase}_${interruptTransmitFunctionName}(void)
{

    // add your ${moduleNameUpperCase} interrupt custom code
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
}
</#if>
<#if usesInterruptRCI>
void ${moduleNameUpperCase}_${interruptReceiveFunctionName}(void)
{
    
    ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].status = 0;

    if(${framingError}){
        ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].ferr = 1;
        ${dataHandlers["framingErrorHandler"]}();
    }
    
    if(${overrunError}){
        ${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].oerr = 1;
        ${dataHandlers["overrunErrorHandler"]}();
    }
    
    if(${moduleNameLowerCase}RxStatusBuffer[${moduleNameLowerCase}RxHead].status){
        ${dataHandlers["errorHandler"]}();
    } else {
        ${functionAPI["rxDataHandler"]}();
    }
    
    // or set custom function using ${moduleNameLowerCase}_SetRxInterruptHandler()
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

void ${moduleNameUpperCase}_DefaultOverrunErrorHandler(void){
    // ${moduleNameUpperCase} error - restart

    ${continousReceiveEnable} = 0;
    ${continousReceiveEnable} = 1;

}

void ${moduleNameUpperCase}_DefaultErrorHandler(void){
<#if usesInterruptRCI>
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

<#if usesInterruptTXI>
void ${moduleNameUpperCase}_SetTxInterruptHandler(void (* interruptHandler)(void)){
    ${moduleNameUpperCase}_TxDefaultInterruptHandler = interruptHandler;
}
</#if>

<#if usesInterruptRCI>
void ${moduleNameUpperCase}_SetRxInterruptHandler(void (* interruptHandler)(void)){
    ${moduleNameUpperCase}_RxDefaultInterruptHandler = interruptHandler;
}
</#if>
/**
  End of File
*/
