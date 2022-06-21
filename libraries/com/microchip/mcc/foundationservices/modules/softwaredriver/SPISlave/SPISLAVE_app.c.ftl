/**
\file
\brief This file contains the functions that implement the SPI slave driver functionalities.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#include <xc.h>
#include "spi_slave_app.h"
#include "${spiPinHeader}"

<#list spiConfigurationNames as name>
uint8_t xchgHandler${name}(uint8_t byte);
void startHandler${name}(void);
void endHandler${name}(void);

</#list>
// Configure the callbacks for each slave device we implement
const ${SPISlaveFunctions["configurationType"]} slaveList[] = {
<#list spiConfigurationNames as name>
    {xchgHandler${name}, startHandler${name}, endHandler${name}}<#if name?has_next>,</#if> // ${name}
</#list>
};

<#list spiConfigurationNames as name>
uint8_t xchgHandler${name}(uint8_t byte) {
    return (byte); //echoes back the received byte.
}

void startHandler${name}(void) {
    // Add user code
}

void endHandler${name}(void) {
    // Add user code
}

</#list>
