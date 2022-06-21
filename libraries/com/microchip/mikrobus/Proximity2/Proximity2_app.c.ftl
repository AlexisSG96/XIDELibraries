/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "Proximity2.h"
#include "drivers/${I2CFunctions["simpleheader"]}"

#define INTERRUPT_STATUS 0x00
#define MAIN_CONFIGURATION  0x01
#define RECEIVE_CONFIGURATION   0x02
#define TRANSMIT_CONFIGURATION  0x03
#define ADC_HIGH_ALS    0x04
#define ADC_LOW_ALS 0x05
#define ADC_BYTE_PROX   0x16
#define ALS_UPPER_THRESHOLD_HIGH 0x06
#define ALS_UPPER_THRESHOLD_LOW  0x07
#define ALS_LOWER_THRESHOLD_HIGH    0x08
#define ALS_LOWER_THRESHOLD_LOW 0x09
#define THRESHOLD_PERSIST_TIMER 0x0A
#define PROX_THRESHOLD_INDICATOR    0x0B
#define PROX_THRESHOLD  0x0C
#define DIGITAL_GAIN_TRIM_GREEN 0x0F
#define DIGITAL_GAIN_TRIM_INFRARED  0x10

static const uint8_t ADDRESS = 0b1001010;

// Read a byte from register 'reg'
static uint8_t Read_Proximity2_Register(uint8_t reg) 
{
    return ${I2CFunctions["read1ByteRegister"]}(ADDRESS, reg);
}

// Write byte 'byte' to register 'reg'
static void Write_Proximity2_Register(uint8_t reg, uint8_t byte) 
{
    ${I2CFunctions["write1ByteRegister"]}(ADDRESS, reg, byte);
}

int Proximity2_Read_Interrupt(void) 
{
    uint8_t val = Read_Proximity2_Register(INTERRUPT_STATUS);
    if (val & 0b1) 
    {
        return ALS_INT;
    } 
    else if (val & 0b10) 
    {
        return PROX_INT;
    } 
    else 
    {
        return NO_INT;
    }
}

<#if Proximity2_Mode_Key == "PROX Only" || Proximity2_Mode_Key == "ALS and PROX">
uint8_t Proximity2_Read_Proximity()
{
    uint8_t val = Read_Proximity2_Register(ADC_BYTE_PROX);
    return val;
}

void Proximity2_Set_Threshold(uint8_t  thresh)
{
    Write_Proximity2_Register(PROX_THRESHOLD, thresh);
}
</#if>

// Setup the chip for proximity sensing
void Proximity2_Initialize(void)
{
    <#if Proximity2_Mode_Key == "Standard ALS">
    <#if Proximity2_ALS_Int_Key == "enabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b100101);
    <#else>
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b100100);
    </#if>
    <#elseif Proximity2_Mode_Key == "Green Only">
    <#if Proximity2_ALS_Int_Key == "enabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b101001);
    <#else>
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b101000);
    </#if>
    <#elseif Proximity2_Mode_Key == "IR Only">
    <#if Proximity2_ALS_Int_Key == "enabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b101101);
    <#else>
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b101100);
    </#if>
    <#elseif Proximity2_Mode_Key == "ALS and PROX">
    <#if Proximity2_ALS_Int_Key == "enabled" && Proximity2_PROX_Int_Key == "enabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b110011);
    <#elseif Proximity2_ALS_Int_Key == "enabled" && Proximity2_PROX_Int_Key == "disabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b110001);
    <#elseif Proximity2_ALS_Int_Key == "disabled" && Proximity2_PROX_Int_Key == "enabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b110010);
    <#else>
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b110000);
    </#if>
    <#elseif Proximity2_Mode_Key == "PROX Only">
    <#if Proximity2_PROX_Int_Key == "enabled">
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b110110);
    <#else>
    Write_Proximity2_Register(MAIN_CONFIGURATION, 0b110100);
    </#if>
    </#if>
    <#if Proximity2_Mode_Key == "PROX Only" || Proximity2_Mode_Key == "ALS and PROX">
    Write_Proximity2_Register(PROX_THRESHOLD_INDICATOR, 0b01000000);
    Write_Proximity2_Register(PROX_THRESHOLD_INDICATOR, 0b01000000);
    Write_Proximity2_Register(TRANSMIT_CONFIGURATION, 0b00001111);
    </#if>
}

<#if Proximity2_Mode_Key == "Standard ALS" || Proximity2_Mode_Key == "Green Only" || Proximity2_Mode_Key == "IR Only" || Proximity2_Mode_Key == "ALS and PROX">
uint16_t Proximity2_Read_Als(void) 
{
    uint16_t val = (Read_Proximity2_Register(ADC_HIGH_ALS) << 8) | Read_Proximity2_Register(ADC_LOW_ALS);
    return val;
}

void Proximity2_Set_Als_Upper_Threshold(uint16_t thresh)
{
    Write_Proximity2_Register( ALS_UPPER_THRESHOLD_HIGH, thresh >> 8);;
    Write_Proximity2_Register( ALS_UPPER_THRESHOLD_LOW, thresh & 0xFF);
}

void Proximity2_Set_Als_Lower_Threshold(uint16_t thresh)
{
    Write_Proximity2_Register( ALS_LOWER_THRESHOLD_HIGH, thresh >> 8);
    Write_Proximity2_Register( ALS_LOWER_THRESHOLD_LOW, thresh & 0xFF);
}
</#if>
