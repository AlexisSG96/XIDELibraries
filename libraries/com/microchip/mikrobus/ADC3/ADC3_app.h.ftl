/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _ADC3_H
#define _ADC3_H

/**
  Section: Included Files
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>

/**
  Section: ADC3 Click Driver (MCP3428) APIs
 */

uint16_t ADC3_getConversionCH1(void);
uint16_t ADC3_getConversionCH2(void);
uint16_t ADC3_getConversionCH3(void);
uint16_t ADC3_getConversionCH4(void);

#endif // _ADC3_H
