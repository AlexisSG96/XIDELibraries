/**
  ${moduleNameUpperCase} Generated Example Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}_master_example.c

  @Summary
    This is the generated driver examples implementation file for the ${moduleNameUpperCase} driver using ${productName}

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

#include "${moduleNameLowerCase}_master_example.h"


typedef struct
{
    size_t len;
    uint8_t *data;
}${moduleNameLowerCase}_buffer_t;

static ${moduleNameLowerCase}_operations_t rd1RegCompleteHandler(void *ptr);
static ${moduleNameLowerCase}_operations_t rd2RegCompleteHandler(void *ptr);
static ${moduleNameLowerCase}_operations_t wr1RegCompleteHandler(void *ptr);
static ${moduleNameLowerCase}_operations_t wr2RegCompleteHandler(void *ptr);
static ${moduleNameLowerCase}_operations_t rdBlkRegCompleteHandler(void *ptr);


uint8_t ${moduleNameUpperCase}_Read1ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg)
{
    uint8_t returnValue = 0x00;
    
    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetDataCompleteCallback(rd1RegCompleteHandler,&returnValue);
    ${moduleNameUpperCase}_SetBuffer(&reg,1);
    ${moduleNameUpperCase}_SetAddressNackCallback(NULL,NULL); //NACK polling?
    ${moduleNameUpperCase}_MasterWrite();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
    
    return returnValue;
}

uint16_t ${moduleNameUpperCase}_Read2ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg)
{
    uint16_t returnValue =0x00; // returnValue is little endian

    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetDataCompleteCallback(rd2RegCompleteHandler,&returnValue);
    ${moduleNameUpperCase}_SetBuffer(&reg,1);
    ${moduleNameUpperCase}_SetAddressNackCallback(NULL,NULL); //NACK polling?
    ${moduleNameUpperCase}_MasterWrite();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
  
    return (returnValue << 8 | returnValue >> 8);
}

void ${moduleNameUpperCase}_Write1ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg, uint8_t data)
{
    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetDataCompleteCallback(wr1RegCompleteHandler,&data);
    ${moduleNameUpperCase}_SetBuffer(&reg,1);
    ${moduleNameUpperCase}_SetAddressNackCallback(NULL,NULL); //NACK polling?
    ${moduleNameUpperCase}_MasterWrite();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
}

void ${moduleNameUpperCase}_Write2ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg, uint16_t data)
{
    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetDataCompleteCallback(wr2RegCompleteHandler,&data);
    ${moduleNameUpperCase}_SetBuffer(&reg,1);
    ${moduleNameUpperCase}_SetAddressNackCallback(NULL,NULL); //NACK polling?
    ${moduleNameUpperCase}_MasterWrite();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
}

void ${moduleNameUpperCase}_WriteNBytes(${moduleNameLowerCase}_address_t address, uint8_t* data, size_t len)
{
    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetBuffer(data,len);
    ${moduleNameUpperCase}_SetAddressNackCallback(NULL,NULL); //NACK polling?
    ${moduleNameUpperCase}_MasterWrite();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
}

void ${moduleNameUpperCase}_ReadNBytes(${moduleNameLowerCase}_address_t address, uint8_t *data, size_t len)
{
    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetBuffer(data,len);
    ${moduleNameUpperCase}_MasterRead();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
}

void ${moduleNameUpperCase}_ReadDataBlock(${moduleNameLowerCase}_address_t address, uint8_t reg, uint8_t *data, size_t len)
{
    ${moduleNameLowerCase}_buffer_t bufferBlock; // result is little endian
    bufferBlock.data = data;
    bufferBlock.len = len;

    while(!${moduleNameUpperCase}_Open(address)); // sit here until we get the bus..
    ${moduleNameUpperCase}_SetDataCompleteCallback(rdBlkRegCompleteHandler,&bufferBlock);
    ${moduleNameUpperCase}_SetBuffer(&reg,1);
    ${moduleNameUpperCase}_SetAddressNackCallback(NULL,NULL); //NACK polling?
    ${moduleNameUpperCase}_MasterWrite();
    while(${moduleNameUpperCase}_BUSY == ${moduleNameUpperCase}_Close()); // sit here until finished.
}

static ${moduleNameLowerCase}_operations_t rd1RegCompleteHandler(void *ptr)
{
    ${moduleNameUpperCase}_SetBuffer(ptr,1);
    ${moduleNameUpperCase}_SetDataCompleteCallback(NULL,NULL);
    return ${moduleNameUpperCase}_RESTART_READ;
}

static ${moduleNameLowerCase}_operations_t rd2RegCompleteHandler(void *ptr)
{
    ${moduleNameUpperCase}_SetBuffer(ptr,2);
    ${moduleNameUpperCase}_SetDataCompleteCallback(NULL,NULL);
    return ${moduleNameUpperCase}_RESTART_READ;
}

static ${moduleNameLowerCase}_operations_t wr1RegCompleteHandler(void *ptr)
{
    ${moduleNameUpperCase}_SetBuffer(ptr,1);
    ${moduleNameUpperCase}_SetDataCompleteCallback(NULL,NULL);
    return ${moduleNameUpperCase}_CONTINUE;
}

static ${moduleNameLowerCase}_operations_t wr2RegCompleteHandler(void *ptr)
{
    ${moduleNameUpperCase}_SetBuffer(ptr,2);
    ${moduleNameUpperCase}_SetDataCompleteCallback(NULL,NULL);
    return ${moduleNameUpperCase}_CONTINUE;
}

static ${moduleNameLowerCase}_operations_t rdBlkRegCompleteHandler(void *ptr)
{
    ${moduleNameUpperCase}_SetBuffer(((${moduleNameLowerCase}_buffer_t *)ptr)->data,((${moduleNameLowerCase}_buffer_t*)ptr)->len);
    ${moduleNameUpperCase}_SetDataCompleteCallback(NULL,NULL);
    return ${moduleNameUpperCase}_RESTART_READ;
}