 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "fan.h"
#ifdef __XC
#include <xc.h>
#endif
#include "../drivers/${I2CFunctions["simpleheader"]}"
#include "../mcc.h"
#include <stdint.h>
#include <stdbool.h>

#define addr 0b0101111

#define CONFIGURATION 0x20
#define FAN_STATUS 0x24
#define FAN_STALL_STATUS 0x25
#define FAN_SPIN_STATUS 0x26
#define DRIVE_FAIL_STATUS 0x27
#define FAN_INTERRUPT_ENABLE_REGISTER 0x29
#define PWM_POLARITY_CONFIG 0x2A
#define PWM_OUTPUT_CONFIG 0x2B
#define PWM_BASE_FREQUENCY 0x2D
#define FAN_SETTING 0x30
#define PWM_DIVIDE 0x31
#define FAN_CONFIGURATION_1 0x32
#define FAN_CONFIGURATION_2 0x33
#define GAIN 0x35
#define FAN_SPIN_UP_CONFIGURATION 0x36
#define FAN_MAX_STEP 0x37
#define FAN_MINIMUM_DRIVE 0x38
#define FAN_VALID_TACH_COUNT 0x39
#define FAN_DRIVE_FAIL_BAND_LOW_BYTE 0x3A
#define FAN_DRIVE_FAIL_BAND_HIGH_BYTE 0x3B
#define TACH_TARGET_LOW_BYTE 0x3C
#define TACH_TARGET_HIGH_BYTE 0x3D
#define TACH_READING_HIGH_BYTE 0x3E
#define TACH_READING_LOW_BYTE 0x3F
#define SOFTWARE_LOCK 0xEF

void fan_write(uint8_t reg, uint8_t data) {
    ${I2CFunctions["write1ByteRegister"]}(addr, reg, data);
}

uint8_t fan_read(uint8_t reg) {
    return ${I2CFunctions["read1ByteRegister"]}(addr, reg);
}

<#if RPM_Mode == "enabled">
void fan_setSpeed(uint16_t speed) {
    fan_write(TACH_TARGET_LOW_BYTE, (speed % 32) << 3);
    fan_write(TACH_TARGET_HIGH_BYTE, speed >> 5);
}
<#else>
void fan_setPWM(uint8_t pwm){
    fan_write(FAN_SETTING, pwm);
}
</#if>

void fan_Initialize(void) {
    <#if (isAVR == "true")>
    _delay_ms(10);
    <#else>
    __delay_ms(10);
    </#if>
<#if RPM_Mode == "enabled">
    fan_write(FAN_CONFIGURATION_1, 0b10101011);
<#else>
    fan_write(FAN_CONFIGURATION_1, 0b00101011);
</#if>
}

bool fan_isStalled(void) {
    return fan_read(FAN_STALL_STATUS);
}

bool fan_spinUpFailed(void) {
    return fan_read(FAN_SPIN_STATUS);
}

bool fan_driveFailed(void) {
    return fan_read(DRIVE_FAIL_STATUS);
}

void fan_setValidTachCount(uint8_t count){
    fan_write(FAN_VALID_TACH_COUNT, count);
}

<#if RPM_Mode == "enabled">
void fan_setMaxStep(uint8_t step){
    fan_write(FAN_MAX_STEP, step);
}

void fan_setMinimumDrive(uint8_t minimum){
    fan_write(FAN_MINIMUM_DRIVE, minimum);
}

void fan_setFailBand(uint16_t band){
    fan_write(FAN_DRIVE_FAIL_BAND_LOW_BYTE, (band % 32) << 3);
    fan_write(FAN_DRIVE_FAIL_BAND_HIGH_BYTE, band >> 5);
}

</#if>
void fan_softwareLock(void){
    fan_write(SOFTWARE_LOCK, 1);
}

uint16_t fan_readTach(void){
    uint8_t highByte = fan_read(TACH_READING_HIGH_BYTE);
    uint8_t lowByte = fan_read(TACH_READING_LOW_BYTE);
    
    uint16_t reading = highByte * 32 + lowByte >> 3;
    return reading;
}

