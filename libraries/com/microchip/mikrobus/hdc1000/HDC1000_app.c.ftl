/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "hdc1000.h"
#include "device_config.h"
#include "drivers/${I2CFunctions["simpleheader"]}"
#include "${DELAYFunctions.delayHeader}"

#define HDC1000_I2C_ADDRESS  0x40

#define HDC1000_TRES_11     (1 << 10)
#define HDC1000_TRES_14     (0 << 10)

#define HDC1000_HRES_8      (0b10 << 8)
#define HDC1000_HRES_11     (0b01 << 8)
#define HDC1000_HRES_14     (0b00 << 8)

#define HDC1000_HEAT_DIS    (0 << 13)
#define HDC1000_HEAT_EN     (1 << 13)

#define HDC1000_TEMP_REG    0x00
#define HDC1000_HUM_REG     0x01
#define HDC1000_CONFIG_REG  0x02

<#if (tempResolution == "11 bits")>
#define HDC1000_TEMP_RESOLUTION     HDC1000_TRES_11
<#else>
#define HDC1000_TEMP_RESOLUTION     HDC1000_TRES_14
</#if>

<#if (HumidResolution == "8 bits")>
#define HDC1000_HUM_RESOLUTION      HDC1000_HRES_8
<#elseif (HumidResolution == "11 bits")>
#define HDC1000_HUM_RESOLUTION      HDC1000_HRES_11
<#else>
#define HDC1000_HUM_RESOLUTION      HDC1000_HRES_14
</#if>

<#if (heatSetting == "enabled")>
uint16_t HDC1000_HEAT_SETTING    =  HDC1000_HEAT_EN
<#else>
uint16_t HDC1000_HEAT_SETTING    =  HDC1000_HEAT_DIS;
</#if>

static uint16_t HDC1000_CalcData(uint16_t data);

void HDC1000_DataReady(){
    ${DELAYFunctions.delayMs}(8);
}

float HDC1000_GetTemp(){
    volatile uint16_t data = 0;
    uint8_t regAdd =0x00;
    //setup resolution
    ${I2CFunctions["write2ByteRegister"]}(HDC1000_I2C_ADDRESS, HDC1000_CONFIG_REG, HDC1000_CalcData(HDC1000_HEAT_SETTING | HDC1000_TEMP_RESOLUTION));
    ${I2CFunctions["writeNBytes"]}(HDC1000_I2C_ADDRESS,&regAdd,1);
    ${DELAYFunctions.delayMs}(10);
    ${I2CFunctions["readNBytes"]}(HDC1000_I2C_ADDRESS,(uint8_t)&data,2);
    data = ((data << 8) |(data >> 8));
    //T(ºC) = (temperature/(2^16))*165ºC - 40ºC
    return ((float)((((uint32_t)data)*16500/65535) - 4000))/100.0;
}

uint8_t HDC1000_GetHumidity(){
    volatile uint16_t data = 0;
    uint8_t regAdd =0x01;
    //setup resolution
    ${I2CFunctions["write2ByteRegister"]}(HDC1000_I2C_ADDRESS, HDC1000_CONFIG_REG, HDC1000_CalcData(HDC1000_HEAT_SETTING | HDC1000_HUM_RESOLUTION));
    ${I2CFunctions["writeNBytes"]}(HDC1000_I2C_ADDRESS,&regAdd,1);
    ${DELAYFunctions.delayMs}(10);
    __delay_ms(10);
    ${I2CFunctions["readNBytes"]}(HDC1000_I2C_ADDRESS,(uint8_t)&data,2);
    data = ((data << 8) |(data >> 8));
    //%RH = (humidity/(2^16))*100%RH
    return ((__uint24)data)*100/65535;
}

void HDC1000_EnableHeater(bool enable){
    if(enable){
        HDC1000_HEAT_SETTING = HDC1000_HEAT_EN;
    } else {
        HDC1000_HEAT_SETTING = HDC1000_HEAT_DIS;
    }
}

static uint16_t HDC1000_CalcData(uint16_t data){
    //data must be LSB (byte) first
    return (data << 8) | (data >> 8);
}
