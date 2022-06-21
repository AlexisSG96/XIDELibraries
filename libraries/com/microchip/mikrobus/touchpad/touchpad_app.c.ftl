/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "touchpad.h"
#include "drivers/${I2CFunctions["simpleheader"]}"

//Address Definitions
#define SLAVE_ADDRESS           0x25  //7-bit I2C Address **Note: the i2c libraries will add automatically add the read or write bit 

#define FWMAJOR             0x00
#define FWMINOR             0x01
#define APPIDH              0x02
#define APPIDL              0x03
#define CMD                 0x04
#define MODE                0x05
#define MODECON             0x06
#define TOUCH_STATE         0x10
#define TOUCH_XREG          0x11
#define TOUCH_YREG          0x12


void TOUCHPAD_Initialize(void){
    <#if resetPinSettings.resetPinLat?has_content>
    ${resetPinSettings["resetPinLat"]} = 1;
    </#if>
    ${I2CFunctions["write1ByteRegister"]}(SLAVE_ADDRESS, MODE, 0b0010);
}

uint8_t TOUCHPAD_getX(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(SLAVE_ADDRESS, TOUCH_XREG);
}


uint8_t TOUCHPAD_getY(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(SLAVE_ADDRESS, TOUCH_YREG);
}

uint8_t TOUCHPAD_getTouchState(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(SLAVE_ADDRESS, TOUCH_STATE);
}

