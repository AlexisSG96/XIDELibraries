/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef ${moduleNameUpperCase}_DRIVER_H
#define ${moduleNameUpperCase}_DRIVER_H

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "${spiTypesHeader}"

/* arbitration interface */
void ${spiClose}(void);

bool ${spiOpen}(${moduleNameLowerCase}_modes spiUniqueConfiguration);
/* SPI native data exchange function */
uint8_t ${exchangeByte}(uint8_t b);
/* SPI Block move functions }(future DMA support will be here) */
void ${exchangeBlock}(void *block, size_t blockSize);
void ${writeBlock}(void *block, size_t blockSize);
void ${readBlock}(void *block, size_t blockSize);

void ${writeByte}(uint8_t byte);
uint8_t ${readByte}(void);

void ${spiISR}(void);
void ${setSpiISR}(void(*handler)(void));

#endif // ${moduleNameUpperCase}_DRIVER_H
