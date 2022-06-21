/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
<#if spiEnable == "enabled" >
#include <stdbool.h>
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"
<#elseif i2cEnable == "enabled">
#include "drivers/${I2CFunctions["simpleheader"]}"
</#if>

//  Read/Write Registers
#define CTRL_REG1               0x20
#define CTRL_REG2               0x21
#define CTRL_REG3               0x22
#define CTRL_REG4               0x23
#define CTRL_REG5               0x24
#define STATUS_REG              0x27
#define OUT_X_L                 0x28
#define OUT_X_H                 0x29
#define OUT_Y_L                 0x2A
#define OUT_Y_H                 0x2B
#define OUT_Z_L                 0x2C
#define OUT_Z_H                 0x2D

<#if i2cEnable == "enabled">
// I2C Slave Address
#define SLAVE_ADDRESS           0b1100${addrSelect}
<#elseif spiEnable == "enabled" >
// Address Masks
#define SPI_PERFORM_READ        0x80
#define SPI_INCREMENT_ADDRESS   0x40
</#if>

// STATUS_REG Bit Positions
#define XDA                     0x1
#define YDA                     0x2
#define ZDA                     0x4

static uint8_t performRead(uint8_t reg)
{
<#if spiEnable == "enabled">
    /* Using SPI for read */
    uint8_t sendData[3];
    sendData[0] = (reg & 0x3F) | SPI_PERFORM_READ | SPI_INCREMENT_ADDRESS;
    while(${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen() == false)
    {
        //wait until SPI is available. If stuck here check that all clients are calling spiClose()
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(sendData, 2);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return (sendData[1]);
<#elseif i2cEnable == "enabled">
    /* Using I2C for read */
    return ${I2CFunctions["read1ByteRegister"]}(SLAVE_ADDRESS, reg);
</#if>
}

static int16_t performDimRead(uint8_t reg_h, uint8_t reg_l)
{
<#if spiEnable == "enabled">
    /* Using SPI for read */
    uint8_t sendData[3];
    sendData[0] = (reg_l & 0x3F) | SPI_PERFORM_READ | SPI_INCREMENT_ADDRESS;
    while(${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen() == false)
    {
        //wait until SPI is available. If stuck here check that all clients are calling spiClose()
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeBlock(sendData, 3);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return (int16_t)((sendData[2] << 8) + sendData[1]);
<#elseif i2cEnable == "enabled">
    /* Using I2C for read */
    return (int16_t) ((performRead(reg_h) << 8) | performRead(reg_l));
</#if>
}

static void performWrite(uint8_t reg, uint8_t value)
{
<#if spiEnable == "enabled">
    /* Using SPI for write */
    uint8_t sendData[2];
    sendData[0] = reg & 0x3F;
    sendData[1] = value;
    while(${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen() == false)
    {
        //wait until SPI is available. If stuck here check that all clients are calling spiClose()
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].writeBlock(sendData, 2);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
<#elseif i2cEnable == "enabled">
    /* Using I2C for write */
    ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, reg, value);
</#if>
}

void ACCEL3_Initialize(void)
{
    performWrite(CTRL_REG1, 0x27);    // 0 0 1 0 0 1 1 1 = 0x27
                                      // | | | | | | | |
                                      // | | | | | | | x---> X-axis enabled
                                      // | | | | | | x-----> Y-axis enabled
                                      // | | | | | x-------> Z-axis enabled
                                      // | | | x x---------> Data rate is set to Default
                                      // x x x-------------> Power mode is set to Normal
}

int16_t ACCEL3_ReadX(void)
{
    performDimRead(OUT_X_H, OUT_X_L);
    while (!(performRead(STATUS_REG) & XDA))
    {
        //wait until new X-axis data is available
    }
    return performDimRead(OUT_X_H, OUT_X_L);
}

int16_t ACCEL3_ReadY(void)
{
    performDimRead(OUT_Y_H, OUT_Y_L);
    while (!(performRead(STATUS_REG) & YDA))
    {
        //wait until new Y-axis data is available
    }
    return performDimRead(OUT_Y_H, OUT_Y_L);
}

int16_t ACCEL3_ReadZ(void)
{
    performDimRead(OUT_Z_H, OUT_Z_L);
    while (!(performRead(STATUS_REG) & ZDA))
    {
        //wait until new Z-axis data is available
    }
    return performDimRead(OUT_Z_H, OUT_Z_L);
}
