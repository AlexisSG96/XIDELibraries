/**
\file
\brief This file contains the functions that implement the SPI slave driver configurations.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
<#list headers as header>
#include "${header}"
</#list>
#include "${SPISlaveFunctions["spiHeader"]}"
#include "spi_slave_app.h"
#include "${spiPinHeader}"

#define DUMMY_DATA 0x33

<#list spiConfigurationNames as name>
void ${moduleName}_DataHandler${name}(void);

</#list>
void ${SPISlaveFunctions["init"]}(void) {
<#list spiConfigurationNames as name>
<#if (spiPins["${name}"]["IOCF"] != "")>
    ${spiPins["${name}"]["IOCF"]}_SetInterruptHandler(${moduleName}_SSHandler${name});
    ${spiPins["${name}"]["enablePositiveInterrupt"]};
    ${spiPins["${name}"]["enableNegativeInterrupt"]};
<#elseif (spiPins["${name}"]["IOC"] != "")>
    ${spiPins["${name}"]["IOC"]}_SetInterruptHandler(${moduleName}_SSHandler${name});
    ${spiPins["${name}"]["enableAnyEdgeInterrupt"]} = 1;
<#else>
    //No change notification available for ${name}. To ensure proper
    //functionality, please call ${moduleName}_SSHandler${name} 
    //from the main while(1) loop.
</#if>
</#list>
}

<#list spiConfigurationNames as name>
void ${moduleName}_SSHandler${name}(void) {
    if (0 == ${spiPins["${name}"]["getInputValue"]}) {
        if (${SPIDriverFunctions["${name}"]["spiOpen"]}(${SPIDriverFunctions["${name}"]["configName"]})) { //open appropriate slave
            //only run the handler if we have the bus

<#if (SPIDriverFunctions["${name}"]["setSpiISR"] != "NULL")>
            ${SPIDriverFunctions["${name}"]["setSpiISR"]}(${moduleName}_DataHandler${name});
<#else>
            //No SPI Interrupt enabled. 
            //Call ${moduleName}_DataHandler${name} from the main while(1) loop manually when SPI has received a byte
</#if>

            // Stuff the first dummy byte here, if you need something else do it here
            //    Note: We are considering stuffing the dummy byte inside the handler instead,
            //          that means if you do not stuff it you get something random. 
            ${SPIDriverFunctions["${name}"]["writeByte"]}(DUMMY_DATA);
            if (slaveList[${SPIDriverFunctions["${name}"]["configName"]}].SPI_beginHandler) {
                slaveList[${SPIDriverFunctions["${name}"]["configName"]}].SPI_beginHandler();
            }
        }
    } else {
        if (slaveList[${SPIDriverFunctions["${name}"]["configName"]}].SPI_endHandler) {
            slaveList[${SPIDriverFunctions["${name}"]["configName"]}].SPI_endHandler();
        }
        ${SPIDriverFunctions["${name}"]["spiClose"]}();
    }
}

void ${moduleName}_DataHandler${name}(void) {
    if (slaveList[${SPIDriverFunctions["${name}"]["configName"]}].SPI_xchgHandler) {
        ${SPIDriverFunctions["${name}"]["writeByte"]}(slaveList[${SPIDriverFunctions["${name}"]["configName"]}].SPI_xchgHandler(${SPIDriverFunctions["${name}"]["readByte"]}()));
    }
}

</#list>