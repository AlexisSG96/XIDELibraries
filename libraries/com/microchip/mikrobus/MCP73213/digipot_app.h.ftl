/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _DIGIPOT_H
#define _DIGIPOT_H

/**
  Section: Included Files
 */

#include <stdint.h>

/**
  Section: DigiPot Click Driver (MCP4161) APIs
 */

void DIGIPOT_setChannel(uint8_t channel); // This selects the wiper we talk to, default will be 0 at startup
void DIGIPOT_set(uint16_t val); // Left justified 16-bit value write to Volatile only. Reads selected wiper.
uint16_t DIGIPOT_get(void); // Left justified 16-bit value read from Volatile only. Writes selected wiper
void DIGIPOT_save(void); // Copy Volatile value to NV value
void DIGIPOT_load(void); // Copy NV value to V value
void DIGIPOT_lock(); // Lock the currently selected wiper
void DIGIPOT_unlock(); // Unlock the currently selected wiper

#endif // _DIGIPOT_H
