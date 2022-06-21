/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "heartrate.h"
#include "max30100.h"

/**
  Section: Variable Definitions
 */

static uint8_t heartrate_initialized = 0;

/**
  Section: Private function prototypes
 */

static void HeartRate_initializeClick(void);

/**
  Section: Driver APIs
 */

void HeartRate_readSensors(void) 
{
    if (!heartrate_initialized) {
        HeartRate_initializeClick();
    }
    MAX30100_readSensors();
}

uint16_t HeartRate_getIRdata(void) 
{
    return MAX30100_getIRdata();
}

uint16_t HeartRate_getREDdata(void) 
{
    return MAX30100_getREDdata();
}

float HeartRate_getTemperature(void) 
{
    if (!heartrate_initialized) 
	{
        HeartRate_initializeClick();
    }

    MAX30100_readTemp();
    return MAX30100_getTemp();
}

static void HeartRate_initializeClick(void) 
{
    MAX30100_setSpo2RdyInterrupt(SPO2_INTERRUPT_EN);
    MAX30100_setHrRdyInterrupt(HR_INTERRUPT_EN);
    MAX30100_setTempRdyInterrupt(TEMP_INTERRUPT_EN);
    MAX30100_setFifoAfullInterrupt(FIFO_INTERRUPT_EN);

    MAX30100_setMode(DEFAULT_MODE);
    MAX30100_setHiResEnabled(DEFAULT_HIRES_SET);
    MAX30100_setSampleRate(DEFAULT_SAMP_RATE);
    MAX30100_setPulseWidth(DEFAULT_PWIDTH);
    MAX30100_setIRLEDCurrent(DEFAULT_IR_CURRENT);
    MAX30100_setREDLEDCurrent(DEFAULT_RED_CURRENT);

    MAX30100_initializeSensor();

    heartrate_initialized = 1;
}
