/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "digipot.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

/**
  Section: Macro Declarations
 */

//Addresses
#define DP_WPR0_V      0x00
#define DP_WPR0_NV     0x02
#define DP_TCON_REG    0x04

//Instruction
#define WRITE_DP    0x00
#define INC_DP      0x04
#define DEC_DP      0x08
#define INIT_WPR0   0x0F

/**
  Section: Variable Definitions
 */

static __bit digipot_initialized = 0;
const float RStep = (float) DIGIPOT_RAB / (float) DIGIPOT_STEPS;

/**
  Section: Private function prototypes
 */

void DigiPot_writeData(uint8_t dp_address, uint16_t dp_data);
void DigiPot_initializeClick(void);
void DigiPot_openLine(void);
void DigiPot_closeLine(void);

/**
  Section: Driver APIs
 */

void DigiPot_setResistance(float dp_value){
    if (!digipot_initialized) {
        DigiPot_initializeClick();
    }
    
    int16_t dpr_conv = (int16_t)(round((dp_value - DIGIPOT_RW) * (1/RStep)));
    if (dpr_conv < 0) {
        dpr_conv = 0;
    } else if (dpr_conv > DIGIPOT_STEPS) {
        dpr_conv = DIGIPOT_STEPS;
    }
    DigiPot_writeData(DP_WPR0_V, (uint16_t)dpr_conv);
}

void DigiPot_stepIncrement(uint8_t steps){
    if (!digipot_initialized) {
        DigiPot_setResistance(DIGIPOT_INIT_VALUE);
    }
    
    uint8_t transferData;
    uint8_t inc; 
    uint8_t cmdByte = (DP_WPR0_V << 4) | INC_DP;
    
    DigiPot_openLine();
    
    for (inc = 0; inc < steps; inc++) {
        transferData = ${SPIFunctions["exchangeByte"]}(cmdByte);
    }
    
    DigiPot_closeLine();
}

void DigiPot_stepDecrement(uint8_t steps){
    if (!digipot_initialized) {
        DigiPot_setResistance(DIGIPOT_INIT_VALUE);
    }
    
    uint8_t transferData;
    uint8_t dec; 
    uint8_t cmdByte = (DP_WPR0_V << 4) | DEC_DP;
    
    DigiPot_openLine();
    
    for (dec = 0; dec < steps; dec++) {
        transferData = ${SPIFunctions["exchangeByte"]}(cmdByte);
    }
    
    DigiPot_closeLine();
}

void DigiPot_writeData(uint8_t dp_address, uint16_t dp_data){    
    uint8_t transferData[2];
    uint8_t cmdByte = (dp_address << 4) | WRITE_DP | (dp_data >> 8);
    uint8_t dataByte = dp_data;
    
    DigiPot_openLine();
    
    transferData[0] = ${SPIFunctions["exchangeByte"]}(cmdByte);
    transferData[1] = ${SPIFunctions["exchangeByte"]}(dataByte);

    DigiPot_closeLine();
}

void DigiPot_initializeClick(void){    
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiOpen"]}(DIGIPOT_CLICK);    
    DigiPot_writeData(DP_TCON_REG,INIT_WPR0);
    
    digipot_initialized = 1;
}

void DigiPot_openLine(void){
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
}

void DigiPot_closeLine(void){
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
}
