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
    uint8_t con1; 
    uint8_t stat;
    uint8_t add;
    uint8_t operation;
} ${moduleNameLowerCase}_configuration_t;

//con1 == SSPxCON1, stat == SSPxSTAT, add == SSPxADD, operation == Master/Slave
static const ${moduleNameLowerCase}_configuration_t ${moduleNameLowerCase}_configuration[] = {   
<#list spiConfgurationValues?keys as config>
    { ${spiConfgurationValues[config]["CON1"]}, ${spiConfgurationValues[config]["STAT"]}, ${spiConfgurationValues[config]["ADD"]}, ${spiConfgurationValues[config]["OPERATION"]} }<#if config?has_next>,</#if>
</#list>
};

void ${moduleNameUpperCase}_Initialize(void)
{
    <#if (isPPS == "true")>
    //Setup PPS Pins
    ${spiClkPPSRegister} = ${spiClkPPSValue};
    ${spiDatPPSRegister} = ${spiDatPPSValue};
    ${spiSckPPSRegister}    = ${spiSckPPSValue};
    <#if spiSdoPPSRegister?has_content>
    ${spiSdoPPSRegister}    = ${spiSdoPPSValue};
    </#if>
    </#if>
    //SPI setup
    <#if SSPSTAT??>
    ${SSPSTAT.name} = ${SSPSTAT.hexValue};
    </#if>
    <#if SSPCON1??>
    ${SSPCON1.name} = ${SSPCON1.hexValue};
    </#if>
    <#if SSPADD??>
    ${SSPADD.name} = ${SSPADD.hexValue};
    </#if>
    ${spiSckPinDirection} = ${spiClkPinDirectionValue};
    <#if SSPCON1??>
    ${SSPCON1.name}bits.SSPEN = 0;
    </#if>
}

bool ${moduleNameUpperCase}_Open(${moduleNameLowerCase}_modes_t ${moduleNameLowerCase}UniqueConfiguration)
{
    if(!${SSPCON1.name}bits.SSPEN)
    {
        <#if SSPSTAT??>
        ${SSPSTAT.name} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].stat;
        </#if>
        <#if SSPCON1??>
        ${SSPCON1.name} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].con1;
        </#if>
        <#if SSPCON2??>
        ${SSPCON2.name} = 0x00;
        </#if>
        <#if SSPADD??>
        ${SSPADD.name}  = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].add;
        </#if>
        ${spiSckPinDirection} = ${moduleNameLowerCase}_configuration[${moduleNameLowerCase}UniqueConfiguration].operation;
        <#if SSPCON1??>
        ${SSPCON1.name}bits.SSPEN = 1;
        </#if>
        return true;
    }
    return false;
}

void ${moduleNameUpperCase}_Close(void)
{
    <#if SSPCON1??>
    ${SSPCON1.name}bits.SSPEN = 0;
    </#if>
}

uint8_t ${moduleNameUpperCase}_ExchangeByte(uint8_t data)
{
    <#if SSPBUF??>
    ${SSPBUF.name} = data;
    </#if>
    while(!${SSPI_FLAG.name});
    ${SSPI_FLAG.name} = 0;
    <#if SSPBUF??>
    return ${SSPBUF.name};
    </#if>
}

void ${moduleNameUpperCase}_ExchangeBlock(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        <#if SSPBUF??>
        ${SSPBUF.name} = *data;
        </#if>
        while(!${SSPI_FLAG.name});
        ${SSPI_FLAG.name} = 0;
        <#if SSPBUF??>
        *data++ = ${SSPBUF.name};
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
    <#if SSPBUF??>
    ${SSPBUF.name} = byte;
    </#if>
}

uint8_t ${moduleNameUpperCase}_ReadByte(void)
{
    <#if SSPBUF??>
    return ${SSPBUF.name};
    </#if>
}