/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _AMMETER_H
#define _AMMETER_H

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
  Section: Ammeter Click Driver (MCP3201) APIs
 */

uint16_t Ammeter_getmACurrent(void);

#endif // _AMMETER_H
