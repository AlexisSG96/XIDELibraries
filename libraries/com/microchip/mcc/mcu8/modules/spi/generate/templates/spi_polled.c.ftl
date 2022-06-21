/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#include "${moduleNameLowerCase}.h"
#include <xc.h>

typedef struct { 
    uint8_t con0; 
    uint8_t con1; 
    uint8_t con2; 
    uint8_t baud; 
    uint8_t operation;
} ${moduleNameLowerCase}_configuration_t;


//con0 == SPIxCON0, con1 == SPIxCON1, con2 == SPIxCON2, baud == SPIxBAUD, operation == Master/Slave
static const ${moduleNameLowerCase}_configuration_t ${moduleNameLowerCase}_configuration[] = {   
<#list spiConfgurationValues?keys as config>
    { ${spiConfgurationValues[config]["CON0"]}, ${spiConfgurationValues[config]["CON1"]}, ${spiConfgurationValues[config]["CON2"]}, ${spiConfgurationValues[config]["BAUD"]}, ${spiConfgurationValues[config]["OPERATION"]} }<#if config?has_next>,</#if>
</#list>
};

void ${moduleNameUpperCase}_Initialize(void)
{
    <#if SPICON0??>
    //${SPICON0.csvComment}
    ${SPICON0.name} = ${SPICON0.hexValue};
    </#if>
    <#if SPICON1??>
    //${SPICON1.csvComment}
    ${SPICON1.name} = ${SPICON1.hexValue};
    </#if>
    <#if SPICON2??>
    //${SPICON2.csvComment}
    ${SPICON2.name} = ${SPICON2.hexValue};
    </#if>
    <#if SPICLK??>
    //${SPICLK.csvComment}
    ${SPICLK.name} = ${SPICLK.hexValue};
    </#if>
    <#if SPIBAUD??>
    //${SPIBAUD.csvComment}
    ${SPIBAUD.name} = ${SPIBAUD.hexValue};
    </#if>
    ${spiClkPinDirection} = ${spiClkPinDirectionValue};
}

bool ${moduleNameUpperCase}_Open(${moduleNameLowerCase}_modes_t ${moduleNameLowerCase}UniqueConfiguration)
{
    if(!SPI${instanceNumber}CON0bits.EN)
    {
        <#if SPICON0??>
        ${SPICON0.name} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].con0;
        </#if>
        <#if SPICON1??>
        ${SPICON1.name} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].con1;
        </#if>
        <#if SPICON2??>
        ${SPICON2.name} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].con2 | (_SPI${instanceNumber}CON2_SPI${instanceNumber}RXR_MASK | _SPI${instanceNumber}CON2_SPI${instanceNumber}TXR_MASK);
        </#if>
        <#if SPIBAUD??>
        ${SPIBAUD.name} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].baud;        
        </#if>
        ${spiClkPinDirection} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].operation;
        <#if SPICON0??>
        ${SPICON0.name}bits.EN = 1;
        </#if>
        return true;
    }
    return false;
}

void ${moduleNameUpperCase}_Close(void)
{
    <#if SPICON0??>
    ${SPICON0.name}bits.EN = 0;
    </#if>
}

uint8_t ${moduleNameUpperCase}_ExchangeByte(uint8_t data)
{
    <#if SPITCNTL??>
    ${SPITCNTL.name} = 1;
    </#if>
    <#if SPITXB??>
    ${SPITXB.name} = data;
    </#if>
    while(!${SPIRXI_FLAG.name});
    <#if SPIRXB??>
    return ${SPIRXB.name};
    </#if>
}

void ${moduleNameUpperCase}_ExchangeBlock(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        <#if SPITCNTL??>
        ${SPITCNTL.name} = 1;
        </#if>
        <#if SPITXB??>
        ${SPITXB.name} = *data;
        </#if>
        while(!${SPIRXI_FLAG.name});
        <#if SPIRXB??>
        *data++ = ${SPIRXB.name};
        </#if>
    }
}

// Half Duplex SPI Functions
void ${moduleNameUpperCase}_WriteBlock(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        ${moduleNameUpperCase}_ExchangeByte(*data++);
    }
}

void ${moduleNameUpperCase}_ReadBlock(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        *data++ = ${moduleNameUpperCase}_ExchangeByte(0);
    }
}

void ${moduleNameUpperCase}_WriteByte(uint8_t byte)
{
    <#if SPITXB??>
    ${SPITXB.name} = byte;
    </#if>
}

uint8_t ${moduleNameUpperCase}_ReadByte(void)
{
    <#if SPIRXB??>
    return ${SPIRXB.name};
    </#if>
}