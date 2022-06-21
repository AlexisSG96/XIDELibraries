/**
\file
\addtogroup doc_driver_spi_code
\brief This file contains the functions that implement the SPI master driver functionalities.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "spi_master.h"

<#list spiConfgurationValues?keys as config>
bool ${spiConfgurationValues[config]["masterOpen"]}(void);
</#list>

const spi_master_functions_t spiMaster[] = {   
<#list spiConfgurationValues?keys as config>
    { ${spiConfgurationValues[config]["spiClose"]}, ${spiConfgurationValues[config]["masterOpen"]}, ${spiConfgurationValues[config]["exchangeByte"]}, ${spiConfgurationValues[config]["exchangeBlock"]}, ${spiConfgurationValues[config]["writeBlock"]}, ${spiConfgurationValues[config]["readBlock"]}, ${spiConfgurationValues[config]["writeByte"]}, ${spiConfgurationValues[config]["readByte"]}, ${spiConfgurationValues[config]["setSpiISR"]}, ${spiConfgurationValues[config]["spiISR"]} }<#if config?has_next>,</#if>
</#list>
};

<#list spiConfgurationValues?keys as config>
bool ${spiConfgurationValues[config]["masterOpen"]}(void){
    return ${spiConfgurationValues[config]["spiOpen"]}(${spiConfgurationValues[config]["configName"]});
}

</#list>
/**
 *  \ingroup doc_driver_spi_code
 *  \brief Open the SPI interface.
 *
 *  This function is to keep the backward compatibility with older API users
 *  \param[in] configuration The configuration to use in the transfer
 *
 *  \return Initialization status.
 *  \retval false The SPI open was unsuccessful
 *  \retval true  The SPI open was successful
 */
bool ${legacyFunctions["initHardware"]}(spi_master_configurations_t config){
    switch(config){
<#list spiConfgurationValues?keys as config>
        case ${config}:
            return ${spiConfgurationValues[config]["masterOpen"]}();
</#list>
        default:
            return 0;
    }
}

/**
 End of File
 */
