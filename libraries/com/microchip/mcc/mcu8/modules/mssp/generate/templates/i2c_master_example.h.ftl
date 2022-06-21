/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}_master_example.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver example using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_MASTER_EXAMPLE_H
#define ${moduleNameUpperCase}_MASTER_EXAMPLE_H

#include <stdint.h>
#include <stdio.h>
#include "../${moduleNameLowerCase}_master.h"

uint8_t  ${moduleNameUpperCase}_Read1ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg);
uint16_t ${moduleNameUpperCase}_Read2ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg);
void ${moduleNameUpperCase}_Write1ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg, uint8_t data);
void ${moduleNameUpperCase}_Write2ByteRegister(${moduleNameLowerCase}_address_t address, uint8_t reg, uint16_t data);
void ${moduleNameUpperCase}_WriteNBytes(${moduleNameLowerCase}_address_t address, uint8_t *data, size_t len);
void ${moduleNameUpperCase}_ReadNBytes(${moduleNameLowerCase}_address_t address, uint8_t *data, size_t len);
void ${moduleNameUpperCase}_ReadDataBlock(${moduleNameLowerCase}_address_t address, uint8_t reg, uint8_t *data, size_t len);

#endif /* ${moduleNameUpperCase}_MASTER_EXAMPLE_H */