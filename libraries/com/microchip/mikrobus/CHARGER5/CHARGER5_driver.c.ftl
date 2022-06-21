/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "CHARGER5_driver.h"
#ifdef __XC
#include <xc.h>
#endif
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

#define CHARGER5_WRITE_DATA     0x00
#define CHARGER5_READ_DATA      0xC0
#define CHARGER5_INC_WIPER      0x04
#define CHARGER5_DEC_WIPER      0x08
#define VOLATILE_WIPER0_ADD     0x00
#define VOLATILE_WIPER1_ADD     0x01

static void CHARGER5_WriteReg(uint8_t regAddress, uint16_t value);
static uint16_t CHARGER5_ReadReg(uint8_t regAddress);
static void CHARGER5_nEnableChipSelect(void);
static void CHARGER5_nDisableChipSelect(void);

/**
 * Mandatory pins to be interfaced with MCU:
 * Pin SCK,CS,MOSI: COmmunication with MCP4161 (SPI MASTER MCU)
 */

/**
 * @brief  This is for Setting value of current to charger5 click
 * @param  currentValue [In]: Fixed setting value of current
 * @return None
 */
void CHARGER5_SetCurrent(uint16_t currentValue)
{
    // Writing Fixed Current Value to register based on Input voltage
    CHARGER5_WriteReg(VOLATILE_WIPER0_ADD,currentValue);
}

/**
 * @brief  This function is for Incrementing wiper of charger5 click
 * @param  numberOfSteps [In]: Steps of wiper increment
 * @return None
 */
void CHARGER5_IncrementWiper(uint8_t numberOfSteps)
{   
    uint8_t exchgByte;
    ${SPIFunctions["spiOpen"]}(${spi_configuration}); 
    CHARGER5_nEnableChipSelect();
    
    while(numberOfSteps--)
    {
        exchgByte = (uint8_t)((VOLATILE_WIPER0_ADD << 4) | CHARGER5_INC_WIPER);
        exchgByte = ${SPIFunctions["exchangeByte"]}(exchgByte);
    }
    CHARGER5_nDisableChipSelect();
    ${SPIFunctions["spiClose"]}();
}

/**
 * @brief  This function is for decrementing wiper of charger5 click
 * @param  numberOfSteps [In]: Steps of wiper decrement
 * @return None
 */
void CHARGER5_DecrementWiper(uint8_t numberOfSteps)
{
    uint8_t exchgByte;
    
    ${SPIFunctions["spiOpen"]}(${spi_configuration}); 
    CHARGER5_nEnableChipSelect();
    
    while(numberOfSteps--)
    {   
        exchgByte = (uint8_t)((VOLATILE_WIPER0_ADD << 4) | CHARGER5_DEC_WIPER);
        exchgByte = ${SPIFunctions["exchangeByte"]}(exchgByte);
    }   
    CHARGER5_nDisableChipSelect();
    ${SPIFunctions["spiClose"]}();    
}

/**
 * @brief  This function used for writing register configuration via SPI
 * @param  regAddress    [In]: Register address
 * @param  numberOfSteps [In]: 16 bit configuration value of register
 * @return None
 */
static void CHARGER5_WriteReg(uint8_t regAddress, uint16_t value)
{
    // SPI Register write API Call
    uint8_t exchgByte;

    exchgByte = (uint8_t)((regAddress << 4) | CHARGER5_WRITE_DATA);
    exchgByte = (uint8_t)(exchgByte | ((value >> 8) & 0x0003));   
    ${SPIFunctions["spiOpen"]}(${spi_configuration}); 
    CHARGER5_nEnableChipSelect();
    exchgByte = ${SPIFunctions["exchangeByte"]}(exchgByte);
    exchgByte = (uint8_t)(value & 0xFF);
    exchgByte = ${SPIFunctions["exchangeByte"]}(exchgByte); 
    CHARGER5_nDisableChipSelect();
    ${SPIFunctions["spiClose"]}(); 
}

/**
 * @brief  This function used for reading register configuration via SPI
 * @param  regAddress    [In] : Register address
 * @return retValue      [Out]:16 bit configured value of register
 */
static uint16_t CHARGER5_ReadReg(uint8_t regAddress)
{
    // SPI Register read API Call
    uint8_t  exchgByte = 0x00;
    uint16_t retValue = 0x0000;
    
    exchgByte = (uint8_t)((regAddress << 4) | CHARGER5_READ_DATA);
    
    ${SPIFunctions["spiOpen"]}(${spi_configuration}); 
    CHARGER5_nEnableChipSelect();
    exchgByte = ${SPIFunctions["exchangeByte"]}(exchgByte);
    retValue = (uint16_t)((exchgByte & 0x03) << 8);
    exchgByte = ${SPIFunctions["exchangeByte"]}(exchgByte);  
    CHARGER5_nDisableChipSelect();
    ${SPIFunctions["spiClose"]}(); 
    retValue = (retValue | (uint16_t)exchgByte);
    return retValue;
}

/**
 * @brief  Enable the Chip Select Pin 
 * @param  None
 * @return None
 */
static void CHARGER5_nEnableChipSelect(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
}

/**
 * @brief  Disable the Chip Select Pin 
 * @param  None
 * @return None
 */
static void CHARGER5_nDisableChipSelect(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
}