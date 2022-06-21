/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "altitude.h"
#include "drivers/${I2CFunctions["simpleheader"]}"

#define ALTITUDE_I2C_ADDRESS (0xC0 >> 1)

#define STATUS      0x00
#define OUT_P_MSB   0x01
#define OUT_P_CSB   0x02
#define OUT_P_LSB   0x03
#define OUT_T_MSB   0x04
#define OUT_T_LSB   0x05
#define PT_DATA_CFG 0x13
#define CTRL_REG1   0x26

static __bit initialized = 0;
static __bit altitude_ready = 0;
static __bit temperature_ready = 0;

static void sampleData(void)
{
    uint8_t sta = 0;
    if(!initialized)
    {
        ${I2CFunctions["write1ByteRegister"]}(ALTITUDE_I2C_ADDRESS,CTRL_REG1, 0x88);
        ${I2CFunctions["write1ByteRegister"]}(ALTITUDE_I2C_ADDRESS,PT_DATA_CFG, 0x07);
        initialized = 1;
        altitude_ready = 0;
        temperature_ready = 0;
    }
    
    ${I2CFunctions["write1ByteRegister"]}(ALTITUDE_I2C_ADDRESS,CTRL_REG1,0x89);

    do
    {
        sta = ${I2CFunctions["read1ByteRegister"]}(ALTITUDE_I2C_ADDRESS,0x00);
    } while(!(sta & 0x08));
    
    altitude_ready = 1;
    temperature_ready = 1;
}

int16_t altitude_readAltitude(void)
{    
    if(altitude_ready == 0)
    {
        sampleData();
    }
    altitude_ready = 0;
    return (int16_t) ${I2CFunctions["read2ByteRegister"]}(ALTITUDE_I2C_ADDRESS,OUT_P_MSB);
}

int8_t altitude_readTemperature(void)
{
    int8_t result = 0;
    if(temperature_ready == 0)
    {
        sampleData();
    }
    temperature_ready = 0;
    result = ${I2CFunctions["read1ByteRegister"]}(ALTITUDE_I2C_ADDRESS,OUT_T_MSB);
    return result;
}

void altitude_shutdown(void)
{
    if(initialized)
    {
        initialized = 0;
        ${I2CFunctions["write1ByteRegister"]}(ALTITUDE_I2C_ADDRESS,CTRL_REG1,0);
        altitude_ready = 0;
        temperature_ready = 0;
    }
}