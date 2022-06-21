/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
*/

#ifdef __XC
#include <xc.h>
#endif
#include "current.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

/**
  Section: Current Macro Declarations
*/

#define Vref            2048000                 // uV
#define Rshunt          ${RshuntmOhm}           // mOhm
#define Rcontacts       ${RcontactsmOhm}        // mOhm
#define IMonitor_Gain   20                      // V/V
#define ADCSize         4096

#define CURRENT_CS_SET_HIGH()    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 1; } while(0)
#define CURRENT_CS_SET_LOW()     do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 0; } while(0)

#define ADCResult_Mask  0x07FF

/**
  Section: Current Function Prototypes
*/

void Current_Initialize(void);
uint16_t Get_ADCResult(void);

/**
  Section: Current Module APIs
*/

uint32_t Current_Get_mAResult(void){
    uint16_t adcResult, Rtotal;
    uint32_t currentVal;
    uint32_t RGain,RGainSize;
    uint32_t RefRes;
    
    Current_Initialize();

    adcResult = Get_ADCResult();

    Rtotal = Rshunt + Rcontacts;
    RefRes = Vref*adcResult;
    RGain = Rtotal*IMonitor_Gain;
    RGainSize = RGain*ADCSize;
    currentVal = RefRes/RGainSize;
    
    return currentVal;              //in mA
}

void Current_Initialize(void){
    CURRENT_CS_SET_HIGH();
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
}

uint16_t Get_ADCResult(void){
    
    uint8_t readData[2];
    uint16_t ADCResult;
    
    CURRENT_CS_SET_LOW();
    
    for (uint8_t i = 0; i<2; i++){
        readData[i] = ${SPIFunctions["exchangeByte"]}(0x00);
    }
    
    CURRENT_CS_SET_HIGH();
    ${SPIFunctions["spiClose"]}();

    ADCResult = readData[0];
    ADCResult = (ADCResult << 8) | readData[1];
    ADCResult = (ADCResult >> 1) & ADCResult_Mask;
    
    return ADCResult;
}
