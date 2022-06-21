/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "mcc.h"
#include "${spiHeader}"

void (*${moduleNameLowerCase}_interruptHandler)(void); 

void ${spiClose}(void)
{
    ${spiEnable} = 0;
}

//con == SPIxCON, con2 == SPIxCON2, stat == SPIxSTAT, brg == SPIxBRG, operation == Master/Slave
typedef struct { uint32_t con; uint32_t con2; uint32_t stat; uint32_t brg; uint8_t operation;} ${moduleNameLowerCase}_configuration_t;
static const ${moduleNameLowerCase}_configuration_t ${moduleNameLowerCase}_configuration[] = {   
<#list spiConfgurationValues?keys as config>
    { ${spiConfgurationValues[config]["CON"]}, ${spiConfgurationValues[config]["CON2"]}, ${spiConfgurationValues[config]["STAT"]}, ${spiConfgurationValues[config]["BRG"]}, ${spiConfgurationValues[config]["OPERATION"]} }<#if config?has_next>,</#if>
</#list>
};

bool ${initSpiMasterHardware}(${moduleNameLowerCase}_modes spiUniqueConfiguration)
{
    if(!${spiEnable})
    {
        ${spiControlRegister} = ${moduleNameLowerCase}_configuration[spiUniqueConfiguration].con;
        ${spiControlRegister2} = ${moduleNameLowerCase}_configuration[spiUniqueConfiguration].con2;
        ${spiStatusRegister} = ${moduleNameLowerCase}_configuration[spiUniqueConfiguration].stat;
        ${spiBrgRegister} = ${moduleNameLowerCase}_configuration[spiUniqueConfiguration].brg;
        
        ${SpiSckPinDirection} = ${moduleNameLowerCase}_configuration[spiUniqueConfiguration].operation;
        ${spiEnable} = 1;
        return true;
    }
    return false;
}

// Full Duplex SPI Functions
uint8_t ${exchangeByte}(uint8_t b)
{
    ${spiTransmitReg} = b;
    while(!${spiReceiveBufferFullFlag});
    return ${spiReceiveReg};
}

void ${exchangeBlock}(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        *data = ${exchangeByte}(*data );
        data++;
    }
}

// Half Duplex SPI Functions
void ${writeBlock}(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        ${exchangeByte}(*data++);
    }
}

void ${readBlock}(void *block, size_t blockSize)
{
    uint8_t *data = block;
    while(blockSize--)
    {
        *data++ = ${exchangeByte}(0);
    }
}

void ${writeByte}(uint8_t byte)
{
    ${spiTransmitReg} = byte;
}

uint8_t ${readByte}(void)
{
    return ${spiReceiveReg};
}

/**
 * Interrupt from SPI on bit 8 received and SR moved to buffer
 * If interrupts are not being used, then call this method from the main while(1) loop
 */
void ${spiISR}(void)
{
    if(${spiReceiveInterruptFlag} == 1){
        if(${moduleNameLowerCase}_interruptHandler){
            ${moduleNameLowerCase}_interruptHandler();
        }
        ${spiReceiveInterruptFlag} = 0;
    }
}

void ${setSpiISR}(void(*handler)(void))
{
    ${moduleNameLowerCase}_interruptHandler = handler;
}
