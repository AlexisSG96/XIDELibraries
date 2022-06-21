/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _MCP73213_H
#define _MCP73213_H
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: Macro Declarations
 */
#define MCP73213_INIT_VALUE     ${InitCVal}

typedef enum {
    mA130 = 10000,
    mA150 = 8450,
    mA200 = 6200,
    mA250 = 4990,
    mA300 = 4020,
    mA350 = 3400,
    mA400 = 3000,
    mA450 = 2610,
    mA500 = 2320,
    mA550 = 2100,
    mA600 = 1910,
    mA650 = 1780,
    mA700 = 1620,
    mA750 = 1500,
    mA800 = 1400,
    mA850 = 1330,
    mA900 = 1240,
    mA950 = 1180,
    mA1000 = 1100,
    mA1100 = 1000
} current;

/**
  Section: MCP73213 Click Driver APIs
 */

void MCP73213_setChargingCurrent(current);

#endif // _MCP73213_H
