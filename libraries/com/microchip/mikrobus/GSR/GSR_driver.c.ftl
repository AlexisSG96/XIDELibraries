/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "GSR_driver.h"
#ifdef __XC
#include <xc.h>
#endif
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

static void GSR_nEnableChipSelect(void);
static void GSR_nDisableChipSelect(void);

/**
 * Mandatory pins to be interfaced with MCU:
 * Pin SPI Mode 0 : SPI communication between MCU and MCP3201
 */

/**
 * @brief  Read the ADC result from GSR click read by SPI 
 * @param  None
 * @return [Out] GSR_RESULT: 12 bit ADC result of the GSR click Data
 */
uint16_t GSR_GetReading()
{
    uint8_t  readData[2];
    uint16_t spiReadData;
    
    //12 bit SPI data read of the GSR Sensor.
    ${SPIFunctions["spiOpen"]}(${spi_configuration});        
    GSR_nEnableChipSelect();
    
    for (uint8_t i = 0; i<2; i++)
    {
        readData[i] = ${SPIFunctions["exchangeByte"]}(0x00);
    } 
    
    GSR_nDisableChipSelect();
    ${SPIFunctions["spiClose"]}();

    spiReadData = (uint16_t)((readData[0] << 8) | readData[1]); 
    // Shifting done here to eliminate the extra bit
    spiReadData = spiReadData >> 1;
    spiReadData = (spiReadData & 0x0FFF);
    return spiReadData;
}

/**
 * @brief  Enable the Chip Select Pin 
 * @param  None
 * @return None
 */
static void GSR_nEnableChipSelect(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
}

/**
 * @brief  Disable the Chip Select Pin 
 * @param  None
 * @return None
 */
static void GSR_nDisableChipSelect(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
}