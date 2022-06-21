/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "mcc.h"
#include "touchkey3_driver.h"
#include "${SPIFunctions["spiHeader"]}"

void TOUCHKEY3_Initialize(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;       // chip select pulled high
    TOUCHKEY3_setTouchMode();
}

inline void TOUCHKEY3_setTouchMode(void)
{
    uint8_t data[2];
    ${SPIFunctions["spiOpen"]}(${spi_configuration});
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;       // chip select pulled low
    data[0] = ${SPIFunctions["exchangeByte"]}(0x91);
    <#if (isAVR == "true")>
	_delay_us(1000);
	<#else>
	__delay_us(1000);
	</#if>
    data[1] = ${SPIFunctions["exchangeByte"]}(0x02);
    <#if (isAVR == "true")>
	_delay_us(1000);
	<#else>
	__delay_us(1000);
	</#if>
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;       // chip select pulled high
    ${SPIFunctions["spiClose"]}();
}

key TOUCHKEY3_getButtonState(void)
{
    uint8_t data[3];
    uint8_t REPORTCOMMANDS[3] = {0xC1,0x00,0x00};
    ${SPIFunctions["spiOpen"]}(${spi_configuration});
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;       // chip select pulled low
    data[0] = ${SPIFunctions["exchangeByte"]}(REPORTCOMMANDS[0]);
    <#if (isAVR == "true")>
	_delay_us(1000);
	<#else>
	__delay_us(1000);
	</#if>
    data[1] = ${SPIFunctions["exchangeByte"]}(REPORTCOMMANDS[1]);
    <#if (isAVR == "true")>
	_delay_us(1000);
	<#else>
	__delay_us(1000);
	</#if>
    data[2] = ${SPIFunctions["exchangeByte"]}(REPORTCOMMANDS[2]);
    <#if (isAVR == "true")>
	_delay_us(1000);
	<#else>
	__delay_us(1000);
	</#if>
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;       // chip select pulled high
    ${SPIFunctions["spiClose"]}();
    return data[2];
}
