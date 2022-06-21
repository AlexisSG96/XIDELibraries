/**
\file
\defgroup doc_driver_i2c_code I2C Simple Driver Source Code Reference
\ingroup doc_driver_i2c
\brief This file contains the API that implements the I2C simple master driver functionalities.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef I2C_SIMPLE_MASTER_H
#define	I2C_SIMPLE_MASTER_H

#include <stdint.h>
#include <stdio.h>
#include "../${headerDirectory}/${typeheader}"

uint8_t ${read1ByteRegister}(${address} address, uint8_t reg);
uint16_t ${read2ByteRegister}(${address} address, uint8_t reg);
void ${write1ByteRegister}(${address} address, uint8_t reg, uint8_t data);
void ${write2ByteRegister}(${address} address, uint8_t reg, uint16_t data);

void ${writeNBytes}(${address} address, void* data, size_t len);
void ${readDataBlock}(${address} address, uint8_t reg, void *data, size_t len);
void ${readNBytes}(${address} address, void *data, size_t len);

#endif	/* I2C_SIMPLE_MASTER_H */

