/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#ifdef __XC
#include <xc.h>
#endif
#include "digipot.h"
#include "MCP73213.h"
#include "stdint.h"
#include "math.h"

/**
  Section: Macro Declarations
 */

#define DIGIPOT_RAB             10000   //Ohms
#define DIGIPOT_RW              75      //Ohms
#define DIGIPOT_STEPS           256

const float RStep = (float) DIGIPOT_RAB / (float) DIGIPOT_STEPS;

/**
  Section: MCP73213 Click Driver 
 */

void MCP73213_setResistance(uint16_t dp_value);

void MCP73213_setChargingCurrent(current c){
    MCP73213_setResistance(c);
}

void MCP73213_setResistance(uint16_t dp_value) {

    uint16_t dpr_conv = (int16_t) (round((dp_value - DIGIPOT_RW) * (1 / RStep)));
    if (dpr_conv < 0) {
        dpr_conv = 0;
    } else if (dpr_conv > DIGIPOT_STEPS) {
        dpr_conv = DIGIPOT_STEPS;
    }
    DIGIPOT_set((uint16_t) dpr_conv);
}
