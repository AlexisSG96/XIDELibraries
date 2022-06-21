/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <stdbool.h>

#include "noise.h"
#include "${portHeader}"
#include "${SPIFunctions.spiHeader}"

#define NOISE_CONFIGURATION_WRITE       (0 << 15)
#define NOISE_CONFIGURATION_IGNORE      (1 << 15)

#define NOISE_CONFIGURATION_BUFFERED    (1 << 14)
#define NOISE_CONFIGURATION_UNBUFFERED  (0 << 14)

#define NOISE_CONFIGURATION_OUTPUT_1X   (1 << 13)
#define NOISE_CONFIGURATION_OUTPUT_2X   (0 << 13)

#define NOISE_CONFIGURATION_ACTIVE      (1 << 12)
#define NOISE_CONFIGURATION_SHUTDOWN    (0 << 12)

<#if (bufferedState == "Buffered")>
#define NOISE_CONFIGURATION_BUFFERED_DEFAULT    NOISE_CONFIGURATION_BUFFERED
<#else>
#define NOISE_CONFIGURATION_BUFFERED_DEFAULT    NOISE_CONFIGURATION_UNBUFFERED
</#if>
<#if (outputState == "1x")>
#define NOISE_CONFIGURATION_OUTPUT_DEFAULT      NOISE_CONFIGURATION_OUTPUT_1X
<#else>
#define NOISE_CONFIGURATION_OUTPUT_DEFAULT      NOISE_CONFIGURATION_OUTPUT_2X
</#if>

#define NOISE_CONFIGURATION_DEFAULT     (NOISE_CONFIGURATION_WRITE | NOISE_CONFIGURATION_BUFFERED_DEFAULT | NOISE_CONFIGURATION_OUTPUT_DEFAULT | NOISE_CONFIGURATION_ACTIVE)

static void NOISE_Write(uint16_t writeValue);

void NOISE_Initialize(void)
{
    uint16_t defaultThreshold = ${thresholdValue};
    ${spiSSPinSettings.setOutputLevelHigh};
    ${enablePinSettings.setOutputLevelLow};
    NOISE_SetThreshold(defaultThreshold);
}

void NOISE_SetThreshold(uint16_t threshold)
{
    if(threshold > 4095)
    {
        threshold = 4095;
    }
    
    NOISE_Write(threshold | NOISE_CONFIGURATION_DEFAULT);
}

bool NOISE_IsNoisy(void)
{
    return ${intPinSettings.getInputValue};
}

static void NOISE_Write(uint16_t writeValue)
{
    ${SPIFunctions.spiOpen}(NOISE);
    ${spiSSPinSettings.setOutputLevelLow};
    ${SPIFunctions.exchangeByte}(writeValue >> 8);
    ${SPIFunctions.exchangeByte}(writeValue);
    ${spiSSPinSettings.setOutputLevelHigh};
    ${SPIFunctions.spiClose}();
}
