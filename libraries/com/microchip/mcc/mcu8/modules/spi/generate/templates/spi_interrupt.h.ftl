/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  3.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_MASTER_H
#define ${moduleNameUpperCase}_MASTER_H

/**
  Section: Included Files
*/

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

/* SPI interfaces */
typedef enum { 
<#list spiConfgurationNames?keys as config>
    ${spiConfgurationNames[config]["configName"]}<#if config?has_next>,</#if>
</#list>
} ${moduleNameLowerCase}_modes_t;

typedef void (*${moduleNameLowerCase}InterruptHandler_t)(void);

void ${moduleNameUpperCase}_Initialize(void);
bool ${moduleNameUpperCase}_Open(${moduleNameLowerCase}_modes_t ${moduleNameLowerCase}UniqueConfiguration);
void ${moduleNameUpperCase}_Close(void);
uint8_t ${moduleNameUpperCase}_ExchangeByte(uint8_t data);
void ${moduleNameUpperCase}_ExchangeBlock(void *block, size_t blockSize);
void ${moduleNameUpperCase}_WriteBlock(void *block, size_t blockSize);
void ${moduleNameUpperCase}_ReadBlock(void *block, size_t blockSize);
void ${moduleNameUpperCase}_WriteByte(uint8_t byte);
uint8_t ${moduleNameUpperCase}_ReadByte(void);

<#if useInterrupt>
void (*${moduleNameUpperCase}_InterruptHandler)(void);
void ${moduleNameUpperCase}_SetInterruptHandler(${moduleNameLowerCase}InterruptHandler_t handler);
</#if>
<#if useRxInterrupt>
void (*${moduleNameUpperCase}_RxInterruptHandler)(void);
void ${moduleNameUpperCase}_SetRxInterruptHandler(${moduleNameLowerCase}InterruptHandler_t handler);
</#if>
<#if useTxInterrupt>
void (*${moduleNameUpperCase}_TxInterruptHandler)(void);
void ${moduleNameUpperCase}_SetTxInterruptHandler(${moduleNameLowerCase}InterruptHandler_t handler);
</#if>
#endif //${moduleNameUpperCase}_H