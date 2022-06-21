/**
\file
\brief This file contains the API that implements the SPI slave driver functionalities.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SPI_SLAVE_INTERFACE_H
#define	SPI_SLAVE_INTERFACE_H

#include <stdint.h>
/**
\typedef This typdef is a list of all the functions available to the user.
*/
typedef struct {
    uint8_t(*SPI_xchgHandler)(uint8_t);
    void (*SPI_beginHandler)(void);
    void (*SPI_endHandler)(void);
} ${SPISlaveFunctions["configurationType"]};
extern const ${SPISlaveFunctions["configurationType"]} slaveList[];

#endif	/* SPI_SLAVE_INTERFACE_H */
