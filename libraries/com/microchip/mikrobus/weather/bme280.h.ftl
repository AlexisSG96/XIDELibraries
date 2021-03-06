/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _BM280_H
#define _BM280_H

/**
  Section: Included Files
 */

#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>

/**
  Section: Macro Declarations
 */

// Device Information
#define BME280_ADDR     0x76
#define BME280_CHIP_ID  0x60

// Sensor Modes
#define BME280_SLEEP_MODE           0x00
#define BME280_FORCED_MODE          0x01
#define BME280_NORMAL_MODE          0x03
#define BME280_SOFT_RESET           0xB6

// Oversampling Options
#define BME280_OVERSAMP_SKIPPED     0x00
#define BME280_OVERSAMP_X1          0x01
#define BME280_OVERSAMP_X2          0x02
#define BME280_OVERSAMP_X4          0x03
#define BME280_OVERSAMP_X8          0x04
#define BME280_OVERSAMP_X16         0x05

// Standby Time
#define BME280_STANDBY_HALFMS   0x00
#define BME280_STANDBY_62P5MS   0x01
#define BME280_STANDBY_125MS    0x02
#define BME280_STANDBY_250MS    0x03
#define BME280_STANDBY_500MS    0x04
#define BME280_STANDBY_1000MS   0x05
#define BME280_STANDBY_10MS     0x06
#define BME280_STANDBY_20MS     0x07

// Filter Coefficients
#define BME280_FILTER_COEFF_OFF     0x00
#define BME280_FILTER_COEFF_2       0x01
#define BME280_FILTER_COEFF_4       0x02
#define BME280_FILTER_COEFF_8       0x03
#define BME280_FILTER_COEFF_16      0x04

/**
  Section: BME280 Sensor Driver APIs
 */

uint8_t BME280_getID(void);
void BME280_reset(void);
void BME280_sleep(void);
void BME280_readFactoryCalibrationParams(void);
void BME280_setStandbyTime(uint8_t Value);
void BME280_setFilterCoefficient(uint8_t Value);
void BME280_setOversamplingTemperature(uint8_t Value);
void BME280_setOversamplingPressure(uint8_t Value);
void BME280_setOversamplingHumidity(uint8_t Value);
void BME280_setSensorMode(uint8_t Value);
void BME280_initializeSensor(void);
void BME280_startForcedSensing(void);
uint8_t BME280_isMeasuring(void);
void BME280_readMeasurements(void);
float BME280_getTemperature(void);
float BME280_getHumidity(void);
float BME280_getPressure(void);

#endif // _BM280_H
