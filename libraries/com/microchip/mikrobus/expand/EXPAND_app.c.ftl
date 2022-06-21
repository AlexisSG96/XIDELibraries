/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "expand.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${portHeader}"
#include "${DELAYFunctions.delayHeader}"

#define SPI_ADDRESS     0x40
#define SPI_WRITE       SPI_ADDRESS
#define SPI_READ        SPI_ADDRESS | 0x01

void EXPAND_Initialize(void)
{
    ${resetPin.setOutputLevelLow}
    ${DELAYFunctions.delayUs}(10);
    ${resetPin.setOutputLevelHigh}
    ${DELAYFunctions.delayUs}(10);

    //Initialize PortA
    EXPAND_SetRegister(IO_CONA, 0x60); 
    EXPAND_SetRegister(OLATA, 0x00);
    
    //Initialize PortB
    EXPAND_SetRegister(IO_CONB, 0x60);
    EXPAND_SetRegister(OLATB, 0x00);
}

void EXPAND_SetGPIOA(uint8_t value)
{
    EXPAND_SetRegister(OLATA, value);
}

void EXPAND_SetGPIOB(uint8_t value)
{
    EXPAND_SetRegister(OLATB, value);
}

uint8_t EXPAND_ReadGPIOA(void)
{
    return EXPAND_ReadRegister(GPIOA);
}

uint8_t EXPAND_ReadGPIOB(void)
{
    return EXPAND_ReadRegister(GPIOB);
}

void EXPAND_SetRegister(EXPAND_GPIO_t reg, uint8_t value)
{
    ${SPIFunctions["spiOpen"]}(EXPAND);
    ${spiSSPinSettings.setOutputLevelLow}
    
    ${SPIFunctions["exchangeByte"]}(SPI_WRITE);
    ${SPIFunctions["exchangeByte"]}(reg);
    ${SPIFunctions["exchangeByte"]}(value);
    
    ${spiSSPinSettings.setOutputLevelHigh}
    ${SPIFunctions["spiClose"]}();
}

void EXPAND_SetRegisterBits(EXPAND_GPIO_t reg, uint8_t bitNumber)
{
    uint8_t value = EXPAND_ReadRegister(reg);
    
    value |= (1 << bitNumber);
    
    EXPAND_SetRegister(reg, value);
}

void EXPAND_ClearRegisterBits(EXPAND_GPIO_t reg, uint8_t bitNumber)
{
    uint8_t value = EXPAND_ReadRegister(reg);
    
    value &= ~(1 << bitNumber);
    
    EXPAND_SetRegister(reg, value);
}

uint8_t EXPAND_ReadRegister(EXPAND_GPIO_t reg)
{
    uint8_t retVal = 0;
    
    ${SPIFunctions["spiOpen"]}(EXPAND);
    ${spiSSPinSettings.setOutputLevelLow}
    
    ${SPIFunctions["exchangeByte"]}(SPI_READ);
    ${SPIFunctions["exchangeByte"]}(reg);
    retVal = ${SPIFunctions["exchangeByte"]}(0x00);
    
    ${spiSSPinSettings.setOutputLevelHigh}
    ${SPIFunctions["spiClose"]}();
    
    return retVal;
}

bool EXPAND_ReadRegisterBits(EXPAND_GPIO_t reg, uint8_t bitNumber)
{
    return EXPAND_ReadRegister(reg) && (1 << bitNumber);
}
