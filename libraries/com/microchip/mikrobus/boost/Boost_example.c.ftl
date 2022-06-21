/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "boost_example.h"
#include "boost.h"
#include "mcc.h"

void BOOST_Example(void){           
    BOOST_setVoltage(20);
    BOOST_enable(); 
    <#if (isAVR == "true")>
	_delay_ms(3000);
	<#else>
	__delay_ms(3000);
	</#if>
    uint8_t readVoltage = BOOST_readVoltage();
}