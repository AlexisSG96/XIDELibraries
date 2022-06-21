/**
\file
\brief This file contains the API that implements the SPI slave driver configurations.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

// This is a guard condition so that contents of this file are not included
// more than once.  
#ifndef SPI_SLAVE_H
#define	SPI_SLAVE_H

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This function sets up the SPI Slave Select interrupt on change pins if SS is located
    on an IOC capable pin. It should be called during device initialization.
 * @Example
    ${SPISlaveFunctions["init"]}();
 */
void ${SPISlaveFunctions["init"]}(void);

<#list spiConfigurationNames as name>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This function is responsible for handling incoming messages for the ${name} Slave Configuration.
    This handler will be called automatically if Interrupt on Change is enabled for the 
    Slave Select pin. Otherwise it should be called from the main while(1) loop.
 * @Example
    ${moduleName}_SSHandler${name}();
 */
void ${moduleName}_SSHandler${name}(void);

</#list>

#endif	/* XC_HEADER_TEMPLATE_H */