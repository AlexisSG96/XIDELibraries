/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"
#include "${pinHeader}"
#include "boost.h"
#include <math.h>

/**
  Section: Macro Declarations
 */

//DAC Select
#define DAC_A  0x00
#define DAC_B  0x10

//VREF INPUT BUFF CTRL
#define BUFFERED     0x40
#define UNBUFFERED   0x00

//OUTPUT GAIN SELECT
#define GA1X   0x20
#define GA2X   0x00

//OUTPUT POWER DOWN
#define OUTPUT_POWER_DOWN   0x10
#define OUTPUT_HI_IMPEDANCE 0x00

#define R1  15000
#define R2  1000
#define R7  15000
#define R8  470
#define VREF  2.048f
#define DAC_RES  12
#define ADC_RES  22

#define DAC_RDIV 16 //(R1+R2)/R2
#define DAC_RESDIV 256 //2^RES/RDIV
#define ADC_RDIV 32.914893617f //(R7+R8)/R8
#define INIT_SETPOINT  ${InitCVal}

/**
  Section: Variable Definitions
 */

uint16_t configBits = (uint16_t) (DAC_A | BUFFERED | GA1X | OUTPUT_HI_IMPEDANCE) << 8;
uint8_t setVoltage = INIT_SETPOINT;
bit isSpiInitialized = false;

/**
  Section: Private function prototypes
 */

void BOOST_setDacOutput(uint16_t dacValue);
uint16_t BOOST_calcDacVal(uint8_t voltage);
uint32_t BOOST_getAdcConversion(void);
uint8_t BOOST_calcVout(uint32_t adcVal);
void BOOST_initializeSPI(void);

/**
  Section: Driver APIs
 */

void BOOST_setVoltage(uint8_t desiredVout) {
    setVoltage = desiredVout;

    uint16_t dacValue = BOOST_calcDacVal(desiredVout);
    BOOST_setDacOutput(dacValue);
}

uint8_t BOOST_readVoltage(void) {
    if (!BOOST_isEnabled()) {
        BOOST_enable();
    }

    uint32_t adcReadData = BOOST_getAdcConversion();
    return BOOST_calcVout(adcReadData);
}

uint8_t BOOST_readVoltageSetpoint(void) {
    return setVoltage;
}

void BOOST_setDacOutput(uint16_t dacValue) {
    if (!isSpiInitialized) {
        BOOST_initializeSPI();
    }

    uint16_t writeData = (configBits & 0xF000) | (dacValue & 0x0FFF);

    ${cs1Pin["LAT"]} = 0;
    ${SPIFunctions["exchangeByte"]}((uint8_t) ((writeData & 0xFF00) >> 8));
    ${SPIFunctions["exchangeByte"]}((uint8_t) writeData);
    ${cs1Pin["LAT"]} = 1;
    ${SPIFunctions["spiClose"]}();
    isSpiInitialized = false;
}

uint16_t BOOST_calcDacVal(uint8_t voltage) {
    uint16_t vinResDiv = voltage*DAC_RESDIV;
    uint16_t dacValue = (vinResDiv / VREF) ;
    return dacValue;
}

uint32_t BOOST_getAdcConversion(void) {
    if (!isSpiInitialized) {
        BOOST_initializeSPI();
    }
    uint8_t readDataBuff[3];

    ${cs2Pin["LAT"]} = 0;
    readDataBuff[2] = ${SPIFunctions["exchangeByte"]}(0x00);
    readDataBuff[1] = ${SPIFunctions["exchangeByte"]}(0x00);
    readDataBuff[0] = ${SPIFunctions["exchangeByte"]}(0x00);
    ${cs2Pin["LAT"]} = 1;
    ${SPIFunctions["spiClose"]}();
    isSpiInitialized = false;
    
    uint32_t readData = (((uint32_t) readDataBuff[2]) << 16) | (((uint32_t) readDataBuff[1]) << 8) | ((uint32_t) readDataBuff[0]);

    return readData;
}

uint8_t BOOST_calcVout(uint32_t adcVal) {
    uint32_t adcConv = adcVal & 0x003FFFFF;
    uint32_t oper1 = adcConv * VREF;
    uint32_t oper2 = (oper1 * ADC_RDIV);
    uint32_t oper3 = oper2;
    for (int i = 0; i < ADC_RES; i++) {
        oper3 = oper3/2;
    }
    uint8_t calcVal = oper3;
    return calcVal;
}

void BOOST_initializeSPI(void) {
    while (!${SPIFunctions["spiOpen"]}(BOOST_CLICK));
    isSpiInitialized = true;
}

