/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef DAC3_CLICK
#define	DAC3_CLICK

#include <stdint.h>

//This function updates the volatile and nonvolatile voltage values
void DAC3_SetNonvolatile(uint16_t dacValue);

//This function only updates the volatile voltage value
void DAC3_Set(uint16_t dacValue);

uint16_t DAC3_Read(uint16_t *dacNonvolatile);

#endif	/* DAC3_CLICK */

