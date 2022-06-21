 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LightRanger.h"
#ifdef __XC
#include <xc.h>
#endif
#include "drivers/${I2CFunctions["simpleheader"]}"
#include "${pinHeader}"

#define LR_ADDR 0x29

#define SYSTEM_INTERRUPT_CONFIG_GPIO 0x14
#define SYSTEM_INTERRUPT_CLEAR 0x15
#define SYSTEM_FRESH_OUT_OF_RESET 0x16
#define SYSRANGE_START 0x18
#define SYSRANGE_THRESH_HIGH 0x19
#define SYSRANGE_THRESH_LOW 0x1A
#define SYSRANGE_INTERMEASUREMENT_PERIOD 0x1B
#define SYSRANGE_MAX_CONVERGENCE_TIME 0x1C
#define SYSRANGE_RANGE_IGNORE_VALID_HEIGHT 0x25
#define SYSRANGE_RANGE_IGNORE_THRESHOLD 0x26
#define SYSRANGE_MAX_AMBIENT_LEVEL_MULT 0x2C
#define SYSRANGE_RANGE_CHECK_ENABLES 0x2D
#define SYSALS_START 0x38
#define SYSALS_THRESH_HIGH 0x3A
#define SYSALS_THRESH_LOW 0x3C
#define SYSALS_INTERMEASUREMENT_PERIOD 0x3E
#define SYSALS_ANALOGUE_GAIN 0x3F
#define SYSALS_INTEGRATION_PERIOD 0x40
#define RESULT_RANGE_STATUS 0x4D
#define RESULT_ALS_STATUS 0x4E
#define RESULT_INTERRUPT_STATUS_GPIO 0x4F
#define RESULT_ALS_VAL 0x50
#define RESULT_RANGE_VAL 0x62
#define INTERLEAVED_MODE_ENABLE 0x2A3

bool isAlsRunning = false;
bool isRangeRunning = false;

void LR_Write(uint16_t reg, uint8_t packet) {
    uint8_t data[3];
    data[0] = reg >> 8;
    data[1] = reg & 0xFF;
    data[2] = packet;
    ${I2CFunctions["writeNBytes"]}(LR_ADDR, data, 3);
}

uint8_t LR_Read(uint16_t reg) {
    uint8_t data[2];
    data[0] = reg >> 8;
    data[1] = reg & 0xFF;
    ${I2CFunctions["writeNBytes"]}(LR_ADDR, data, 2);

    ${I2CFunctions["readNBytes"]}(LR_ADDR, data, 1);
    return data[0];
}

uint16_t LR_Read16(uint16_t reg) {
    uint8_t data[2];
    data[0] = reg >> 8;
    data[1] = reg & 0xFF;
    ${I2CFunctions["writeNBytes"]}(LR_ADDR, data, 2);

    ${I2CFunctions["readNBytes"]}(LR_ADDR, data, 2);
    uint16_t returnVal = data[1] + (data[0] << 8);
    return returnVal;
}

void LR_ConfigGpio(uint8_t als, uint8_t range) {
    uint8_t data = (als << 3 | range);
    LR_Write(SYSTEM_INTERRUPT_CONFIG_GPIO, data);
}

void LR_InterruptClear(uint8_t mask) {
    LR_Write(SYSTEM_INTERRUPT_CLEAR, mask);
}

bool LR_IsReset(void) {
    bool isReset = LR_Read(SYSTEM_FRESH_OUT_OF_RESET);
    if (isReset) {
        LR_Write(SYSTEM_FRESH_OUT_OF_RESET, 0);
    }
    return isReset;
}

void LR_StartRange(uint8_t mode) {
    if (isRangeRunning) {
        if (mode == OFF) {
            LR_Write(SYSRANGE_START, CONTINUOUS); // Writing 1 stops it
            isRangeRunning = false;
        }
    } else {
        if(mode == CONTINUOUS){
            isRangeRunning == true;
        }
        LR_Write(SYSRANGE_START, mode);
    }
}

void LR_SetRangeHigh(uint8_t range) {
    LR_Write(SYSRANGE_THRESH_HIGH, range);
}

void LR_SetRangeLow(uint8_t range) {
    LR_Write(SYSRANGE_THRESH_LOW, range);
}

void LR_SetRangeMeasPer(uint8_t period) {
    LR_Write(SYSRANGE_INTERMEASUREMENT_PERIOD, period);
}

void LR_SetMaxConvTime(uint8_t time) {
    if (time > 63) {
        time = 63;
    }
    LR_Write(SYSRANGE_MAX_CONVERGENCE_TIME, time);
}

void LR_IgnoreHeight(uint8_t height) {
    LR_Write(SYSRANGE_RANGE_IGNORE_VALID_HEIGHT, height);
}

void LR_IgnoreThresh(uint8_t height) {
    LR_Write(SYSRANGE_RANGE_IGNORE_THRESHOLD, height);
}

void LR_MaxAmbientLevelMult(uint8_t mult) {
    LR_Write(SYSRANGE_MAX_AMBIENT_LEVEL_MULT, mult);
}

void LR_RangeCheckEnables(uint8_t mask) {
    LR_Write(SYSRANGE_RANGE_CHECK_ENABLES, mask);
}

void LR_StartAls(uint8_t mode) {
    if (isAlsRunning) {
        if (mode == OFF) {
            LR_Write(SYSALS_START, CONTINUOUS); // Writing 1 stops it
            isAlsRunning = false;
        }
    } else {
        if(mode == CONTINUOUS){
            isAlsRunning = true;
        }
        LR_Write(SYSALS_START, mode);
    }
}

void LR_SetAlsHigh(uint8_t range) {
    LR_Write(SYSALS_THRESH_HIGH, range);
}

void LR_SetAlsLow(uint8_t range) {
    LR_Write(SYSALS_THRESH_LOW, range);
}

void LR_SetAlsMeasPer(uint8_t period) {
    LR_Write(SYSALS_INTERMEASUREMENT_PERIOD, period);
}

void LR_SetAnalogGain(uint8_t gain){
    uint8_t packet = gain | 0x40;
    LR_Write(SYSALS_ANALOGUE_GAIN, packet);
}

void LR_SetIntegrationPeriod(uint8_t period){
    LR_Write(SYSALS_INTEGRATION_PERIOD, period);
}

uint8_t LR_RangeStatus(void){
    return LR_Read(RESULT_RANGE_STATUS);
}

uint8_t LR_AlsStatus(void){
    return LR_Read(RESULT_ALS_STATUS);
}

uint8_t LR_InterruptStatus(void){
    return LR_Read(RESULT_INTERRUPT_STATUS_GPIO);
}

uint16_t LR_ReadAls(void){
    return LR_Read16(RESULT_ALS_VAL);
}

uint8_t LR_ReadRange(void){
    return LR_Read(RESULT_RANGE_VAL);
}

void LR_InterleavedMode(bool enabled){
    LR_Write(INTERLEAVED_MODE_ENABLE, enabled);
}

void LR_Initialize(void){
    LightRanger_EN_LAT = 1;
}
