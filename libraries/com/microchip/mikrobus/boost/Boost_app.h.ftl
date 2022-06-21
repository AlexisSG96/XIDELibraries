/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef BOOST_H
#define	BOOST_H

#include <stdint.h>
#ifdef __XC
#include <xc.h>
#endif
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
#define BOOST_enable()      ${enPin["LAT"]} = 1
#define BOOST_disable()     ${enPin["LAT"]}= 0
#define BOOST_isEnabled()   ${enPin["PORT"]}

void BOOST_setVoltage(uint8_t desiredVout);
uint8_t BOOST_readVoltage(void);
uint8_t BOOST_readVoltageSetpoint(void);

#endif	/* BOOST_H */