/**
\file
\defgroup doc_driver_spi_code SPI Driver Source Code Reference
\ingroup doc_driver_spi
\brief This file contains the API that implements the SPI master driver functionalities.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">

*/

#ifndef _SPI_MASTER_H
#define _SPI_MASTER_H

/**
  Section: Included Files
 */
#include <stdint.h>
#include <stdbool.h>
<#list spiHeaders as item>
#include "../${item}"
</#list>

/**
*   \ingroup doc_driver_spi_code
*   \enum spi_master_configurations_t spi_master.h
*/
typedef enum { 
<#list spiConfgurationValues?keys as config>
    ${config}<#if config?has_next>,</#if>
</#list>
} spi_master_configurations_t;

/**
*   \ingroup doc_driver_spi_code
*   \struct spi_master_functions_t spi_master.h
*/
typedef struct {    ${spiMasterFunctionNames["spiClose"]};
                    ${spiMasterFunctionNames["spiOpen"]};
                    ${spiMasterFunctionNames["exchangeByte"]};
                    ${spiMasterFunctionNames["exchangeBlock"]};
                    ${spiMasterFunctionNames["writeBlock"]};
                    ${spiMasterFunctionNames["readBlock"]};
                    ${spiMasterFunctionNames["writeByte"]};
                    ${spiMasterFunctionNames["readByte"]};
                    ${spiMasterFunctionNames["setSpiISR"]};
                    ${spiMasterFunctionNames["spiISR"]};
} spi_master_functions_t;

extern const spi_master_functions_t spiMaster[];

bool ${legacyFunctions["initHardware"]}(spi_master_configurations_t config);   //for backwards compatibility


#endif	// _SPI_MASTER_H