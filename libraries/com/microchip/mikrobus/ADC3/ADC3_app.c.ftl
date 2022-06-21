/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "adc3.h"
#include <stdbool.h>
#include "drivers/${I2CFunctions["simpleheader"]}"

// Slave Addresses
#define MCP3428_ADDR    0x68
#define GENCALL_ADDR    0x00

// Status
#define ADC3_READY      0x01
#define ADC3_N_READY    0x00
#define ADC3_RESET      0x06
#define TRUE            1
#define FALSE           0

// Channel Selection
#define ADC3_CH1        0x00
#define ADC3_CH2        0x01
#define ADC3_CH3        0x02
#define ADC3_CH4        0x03

// Conversion Mode
#define ONESHOT         0x00
#define CONTINUOUS      0x01

// Sample Rate
#define SPS240_12B      0x00
#define SPS60_14B       0x01
#define SPS15_16B       0x02

// PGA Gain
#define PGA_X1          0x00
#define PGA_X2          0x01
#define PGA_X4          0x02
#define PGA_X8          0x03

/**
  Section: Variable Definitions
 */

typedef union {

    struct {
        uint8_t gain : 2;
        uint8_t resolution : 2;
        uint8_t mode : 1;
        uint8_t input : 2;
        uint8_t ready : 1;
    };
    uint8_t configReg;
} adc3_config_t;

static bool adc3_initialized = false;
static uint8_t adc3_resetCmd;
static uint16_t adc3_result;
static uint8_t adc3_resultBuff[3];
static uint8_t adc3_resultReg;
static adc3_config_t adc3_defConfig;
static adc3_config_t adc3_ch1Config;
static adc3_config_t adc3_ch2Config;
static adc3_config_t adc3_ch3Config;
static adc3_config_t adc3_ch4Config;
static bool adc3_writeConfig;

/**
  Section: Private function prototypes
 */

uint16_t ADC3_getConversionResult(uint8_t channel);
void ADC3_initializeClick(void);
void ADC3_initializeChannels(void);
void ADC3_setInput(uint8_t input);
bool ADC3_stillBusy(void);

/**
  Section: Driver APIs
 */

uint16_t ADC3_getConversionCH1(void) {
    return ADC3_getConversionResult(ADC3_CH1);
}

uint16_t ADC3_getConversionCH2(void) {
    return ADC3_getConversionResult(ADC3_CH2);
}

uint16_t ADC3_getConversionCH3(void) {
    return ADC3_getConversionResult(ADC3_CH3);
}

uint16_t ADC3_getConversionCH4(void) {
    return ADC3_getConversionResult(ADC3_CH4);
}

uint16_t ADC3_getConversionResult(uint8_t channel) {
    if (!adc3_initialized) {
        ADC3_initializeClick();
    }

    adc3_writeConfig = false;
    
    if (adc3_defConfig.input != channel) {        
        ADC3_setInput(channel);
    }

    adc3_defConfig.ready = ADC3_READY;
    ${I2CFunctions["writeNBytes"]}(MCP3428_ADDR, &adc3_defConfig.configReg, 1);

    while (ADC3_stillBusy());
    adc3_result = (adc3_resultBuff[0] << 8) | adc3_resultBuff[1];
    return adc3_result;
}

void ADC3_initializeClick(void) {
    ADC3_initializeChannels();
    ADC3_setInput(ADC3_${inputSelect});
    adc3_resetCmd = ADC3_RESET;

    // General Call Reset
    ${I2CFunctions["writeNBytes"]}(GENCALL_ADDR, &adc3_resetCmd, 1);

    // Send Initial Commands
    ${I2CFunctions["writeNBytes"]}(MCP3428_ADDR, &adc3_defConfig.configReg, 1);

    adc3_initialized = true;
}

void ADC3_initializeChannels(void) {
    // Channel 1
    adc3_ch1Config.mode = ONESHOT;
    adc3_ch1Config.input = ADC3_CH1;
    adc3_ch1Config.resolution = ${ch1ResSelect};
    adc3_ch1Config.gain = ${ch1GainSelect};
    // Channel 2
    adc3_ch2Config.mode = ONESHOT;
    adc3_ch2Config.input = ADC3_CH2;
    adc3_ch2Config.resolution = ${ch2ResSelect};
    adc3_ch2Config.gain = ${ch2GainSelect};
    // Channel 3
    adc3_ch3Config.mode = ONESHOT;
    adc3_ch3Config.input = ADC3_CH3;
    adc3_ch3Config.resolution = ${ch3ResSelect};
    adc3_ch3Config.gain = ${ch3GainSelect};
    // Channel 4
    adc3_ch4Config.mode = ONESHOT;
    adc3_ch4Config.input = ADC3_CH4;
    adc3_ch4Config.resolution = ${ch4ResSelect};
    adc3_ch4Config.gain = ${ch4GainSelect};
}

void ADC3_setInput(uint8_t input) {
    switch (input) {
        case ADC3_CH1: adc3_defConfig.configReg = adc3_ch1Config.configReg;
            break;
        case ADC3_CH2: adc3_defConfig.configReg = adc3_ch2Config.configReg;
            break;
        case ADC3_CH3: adc3_defConfig.configReg = adc3_ch3Config.configReg;
            break;
        case ADC3_CH4: adc3_defConfig.configReg = adc3_ch4Config.configReg;
            break;
        default: break;
    }
}

bool ADC3_stillBusy(void) {
    ${I2CFunctions["readNBytes"]}(MCP3428_ADDR, adc3_resultBuff, 3);
    adc3_defConfig.configReg = adc3_resultBuff[2];
    return adc3_defConfig.ready;
}
