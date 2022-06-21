/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "ammeter.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

/**
  Section: Macro Declarations
 */

#define VREF1   2.048   //v
#define VREF2   1.024   //v
#define STEPS   4096    //us

/**
  Section: Variable Definitions
 */

static __bit amm_initialized = 0;

/**
  Section: Private function prototypes
 */

uint16_t Ammeter_getADCResult(void);
void Ammeter_initializeClick(void);
void Ammeter_startConversion(void);
void Ammeter_stopConversion(void);

/**
  Section: Driver APIs
 */

uint16_t Ammeter_getmACurrent(void) {
    uint16_t adcResult = Ammeter_getADCResult();
    uint16_t mAConverted = (uint16_t) ((((float) adcResult * (VREF1 / STEPS)) - VREF2)*1000);

    return mAConverted;
}

uint16_t Ammeter_getADCResult(void) {
    if (!amm_initialized) {
        Ammeter_initializeClick();
    }

    uint8_t readData[2];
    uint16_t conversionResult;

    Ammeter_startConversion();

    readData[0] = ${SPIFunctions["exchangeByte"]}(0x00);
    readData[1] = ${SPIFunctions["exchangeByte"]}(0x00);

    Ammeter_stopConversion();

    conversionResult = (uint16_t) (readData[0] & 0x1F) << 8;
    conversionResult = (conversionResult | readData[1]) >> 1;

    return conversionResult;
}

void Ammeter_initializeClick(void) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiOpen"]}(Ammeter_CLICK);
    amm_initialized = 1;
}

void Ammeter_startConversion(void) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
}

void Ammeter_stopConversion(void) {
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
}
