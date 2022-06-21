/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdbool.h>
#include <stdint.h>
#include "${portHeader}"
#include "${SPIFunctions.spiHeader}"

/**
  Section: Macro Declarations
 */

//Input Mode
#define SINGLE  0x01
#define DIFF    0x00

//Input Channel Selection
#define ADC_CH0     0x00
#define ADC_CH1     0x01
#define ADC_CH2     0x02
#define ADC_CH3     0x03

/**
  Section: Variable Definitions
 */

static bool adc_initialized = false;

/**
  Section: Private function prototypes
 */

static uint16_t ADC_CLICK_getConversionResult(uint8_t channel, uint8_t input_mode);
static void ADC_CLICK_initializeClick(void);
static void ADC_CLICK_startConversion(void);
static void ADC_CLICK_stopConversion(void);

/**
  Section: Driver APIs
 */

uint16_t ADC_CLICK_getConversionCH0(void)
{
    return ADC_CLICK_getConversionResult(ADC_CH0, ${ch0ModeSelect});
}

uint16_t ADC_CLICK_getConversionCH1(void)
{
    return ADC_CLICK_getConversionResult(ADC_CH1, ${ch1ModeSelect});
}

uint16_t ADC_CLICK_getConversionCH2(void)
{
    return ADC_CLICK_getConversionResult(ADC_CH2, ${ch2ModeSelect});
}

uint16_t ADC_CLICK_getConversionCH3(void)
{
    return ADC_CLICK_getConversionResult(ADC_CH3, ${ch3ModeSelect});
}

static uint16_t ADC_CLICK_getConversionResult(uint8_t channel, uint8_t input_mode)
{
    if (adc_initialized == false)
    {
        ADC_CLICK_initializeClick();
    }

    uint8_t readData[3];
    uint16_t configBits = 0x0400 | (input_mode << 9) | (channel << 6);
    uint16_t conversionResult;

    ${SPIFunctions.spiOpen}(${spi_configuration});

    ADC_CLICK_startConversion();

    readData[0] = ${SPIFunctions.exchangeByte}(configBits >> 8);
    readData[1] = ${SPIFunctions.exchangeByte}(configBits);
    readData[2] = ${SPIFunctions.exchangeByte}(0x00);

    ADC_CLICK_stopConversion();

    ${SPIFunctions.spiClose}();

    conversionResult = ((uint16_t)readData[1]) << 8 | readData[2];

    return conversionResult;
}

static void ADC_CLICK_initializeClick(void)
{
    ${spiSSPinSettings.setOutput};
    adc_initialized = true;
}

static void ADC_CLICK_startConversion(void)
{
    ${spiSSPinSettings.setOutputLevelLow};
}

static void ADC_CLICK_stopConversion(void)
{
    ${spiSSPinSettings.setOutputLevelHigh};
}
