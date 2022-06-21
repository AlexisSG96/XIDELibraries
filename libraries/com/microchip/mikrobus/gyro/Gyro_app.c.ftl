/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <stdbool.h>
#include "gyro.h"
<#if gyroCommunicationsMode == "SPI" >
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"

uint8_t readGyroReg8(uint8_t reg_address)
{
    uint8_t ret = 0;
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x80 | reg_address);
    ret = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return ret;
}

int16_t readGyroReg16(uint8_t reg_address)
{
    int16_t ret = 0;
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x80 | 0x40 | reg_address);
    ret = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0) * 256;
    ret |= ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return ret;
}

void writeGyroReg(uint8_t reg_address, uint8_t data)
{
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(reg_address);
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(data);
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}
<#else>
#include "drivers/${I2CFunctions["simpleheader"]}"

#define GYRO_I2C_ADDRESS ${GYRO_I2C_ADDRESS}

uint8_t readGyroReg8(uint8_t reg_address)
{
    return ${I2CFunctions["read1ByteRegister"]}(GYRO_I2C_ADDRESS,reg_address);
}

int16_t readGyroReg16(uint8_t reg_address)
{
    return ${I2CFunctions["read2ByteRegister"]}(GYRO_I2C_ADDRESS,0x80 | reg_address);
}

void writeGyroReg(uint8_t reg_address, uint8_t data)
{
    ${I2CFunctions["write1ByteRegister"]}(GYRO_I2C_ADDRESS,reg_address,data);    
}
</#if>

static bool initialized = false;

#define CTRL_REG1  0x20
#define CTRL_REG2  0x21
#define CTRL_REG3  0x22
#define CTRL_REG4  0x23
#define CTRL_REG5  0x24
#define OUT_TEMP   0x26
#define STATUS_REG 0x27
#define OUT_X_L    0xA8
#define OUT_Y_L    0xAA
#define OUT_Z_L    0xAC

static inline void initialize(void)
{
    if(!initialized)
    {
        initialized = true;
        writeGyroReg(CTRL_REG1,0xFF);
        writeGyroReg(CTRL_REG2,0x29);
        writeGyroReg(CTRL_REG3,0x00);
        writeGyroReg(CTRL_REG4,0x40);
    }
}

void Gyro_Shutdown(void)
{
    initialized = false;
    writeGyroReg(CTRL_REG1,0x00);
    writeGyroReg(CTRL_REG2,0x00);
}

static int8_t gyro_readTemperature(void)
{
    return (int8_t) readGyroReg8(OUT_TEMP);
}

uint16_t Gyro_ReadX(void)
{
    initialize();
    return readGyroReg16(OUT_X_L);
}

uint16_t Gyro_ReadY(void)
{
    initialize();
    return readGyroReg16(OUT_Y_L);
}

uint16_t Gyro_ReadZ(void)
{
    initialize();
    return readGyroReg16(OUT_Z_L);
}
