/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
*/

#include "ADC2.h"
#include "mcc.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

/**
  Section: ADC2 Function Prototypes
*/

void ADC2_Start_Conversion(void);
void ADC2_Stop_Conversion(void);

/**
  Section: Macro Declarations for MCP3551 Constants
*/

#define POWER_UP_DELAY          300     //us
#define CONVERSION_TIME         75      //ms

/**
  Section: ADC2 Module APIs for Single Conversion
*/

uint32_t ADC2_GetConversion_Result (void){
    uint8_t  readData[3];
    uint32_t conversionResult;

    ADC2_Start_Conversion();
 
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;

    for (uint8_t i = 0; i<3; i++){
        readData[i] = ${SPIFunctions["exchangeByte"]}(0x00);
    }
    
    ADC2_Stop_Conversion();
    
    conversionResult = readData[0];
    conversionResult = (conversionResult << 8) | readData[1];
    conversionResult = (conversionResult << 8) | readData[2];
    
    return conversionResult;
}

void ADC2_Start_Conversion(void){
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    <#if (isAVR == "true")>
	_delay_us(POWER_UP_DELAY);
	<#else>
	__delay_us(POWER_UP_DELAY);
	</#if>
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    <#if (isAVR == "true")>
	_delay_ms(CONVERSION_TIME);
	<#else>
	__delay_ms(CONVERSION_TIME);
	</#if>
}

void ADC2_Stop_Conversion(void){
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
}
