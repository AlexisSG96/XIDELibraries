/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _DIGIPOT_H
#define _DIGIPOT_H

/**
  Section: Included Files
 */

#ifdef __XC
#include <xc.h> // include processor files - each processor file is guarded.  
#endif
#include <stdint.h>
#include <math.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
/**
  Section: Macro Declarations
 */

#define DIGIPOT_INIT_VALUE      ${InitDPVal}
#define DIGIPOT_RAB             10000   //Ohms
#define DIGIPOT_RW              75      //Ohms
#define DIGIPOT_STEPS           256

/**
  Section: DigiPot Click Driver (MCP4161) APIs
 */

/**
 * DigiPot_setResistance(DIGIPOT_INIT_VALUE);
 * must be called to initialize the click
 * with the default value from MCC
 */
void DigiPot_setResistance(float dp_value);
void DigiPot_stepIncrement(uint8_t steps);
void DigiPot_stepDecrement(uint8_t steps);
static inline uint16_t DigiPot_getMaxStep(void) {return DIGIPOT_STEPS;}
static inline uint32_t DigiPot_getMaxResistance(void) {return DIGIPOT_RAB;}

#endif // _DIGIPOT_H
