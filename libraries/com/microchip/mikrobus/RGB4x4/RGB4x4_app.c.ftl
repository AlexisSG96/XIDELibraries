/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "RGB4x4.h"
#include "${pinHeader}"
#include "${DELAYFunctions.delayHeader}"
<#list headers as header>
${header}
</#list>

#define INST_CYC_NANOSEC        ${instructionCycleNanoseconds}

#define PERIOD_NANOSEC          ${transmitPeriodNanoseconds}
#define T1H_NANOSEC             ${transmitT1HNanoseconds}
#define T0H_NANOSEC             ${transmitT0HNanoseconds}

#define ${PERIOD_TICKS}         (PERIOD_NANOSEC/INST_CYC_NANOSEC)
#define ${T1H_TICKS}            (T1H_NANOSEC/INST_CYC_NANOSEC)
#define ${T0H_TICKS}            (T0H_NANOSEC/INST_CYC_NANOSEC)
#define ${T1L_TICKS}            (${PERIOD_TICKS} - ${T1H_TICKS})
#define ${T0L_TICKS}            (${PERIOD_TICKS} - ${T0H_TICKS})

#define LATCH_MICROSEC          50

void RGB4x4_transmit(void);

static RGB4x4_t *buffer_start;
static size_t buffer_size;

void RGB4x4_SetBuffer(RGB4x4_t *b, size_t s) 
{
    buffer_start = b;
    buffer_size = s;
}

void RGB4x4_Update(void) 
{
    RGB4x4_transmit();
    ${DELAYFunctions.delayUs}(LATCH_MICROSEC);
}

void RGB4x4_Clear(void) 
{
    uint8_t i;
    uint8_t j;

    for (i = buffer_size; i != 0; --i) 
    {
        for (j = 3*8; j != 0; --j) 
        {
            ${outputPinSettings["setOutputLevelHigh"]}
            ${transmissionDelay["T0H"]}
            ${outputPinSettings["setOutputLevelLow"]}
            ${transmissionDelay["T0L"]}
        }
    }
    ${DELAYFunctions.delayUs}(LATCH_MICROSEC);
}

void RGB4x4_transmit(void) 
{
    uint8_t *txPtr = (uint8_t *)buffer_start;
    uint8_t i;
    uint8_t mask;
    
    for (i = 3*buffer_size; i != 0; --i) 
    {
        for (mask = 0x80; mask != 0; mask >>= 1) 
        {
            if (*txPtr & mask) 
            {
                // Transmit logic 1
                ${outputPinSettings["setOutputLevelHigh"]}
                ${transmissionDelay["T1H"]}
                ${outputPinSettings["setOutputLevelLow"]}
                ${transmissionDelay["T1L"]}
            } 
            else 
            {
                // Transmit logic 0
                ${outputPinSettings["setOutputLevelHigh"]}
                ${transmissionDelay["T0H"]}
                ${outputPinSettings["setOutputLevelLow"]}
                ${transmissionDelay["T0L"]}
            }
        }
        ++txPtr;
    }
}
