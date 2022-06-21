/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "DiffPressure.h"
#include "mcc.h"
#include "${SPIFunctions["spiHeader"]}"

#define DIFFPRESSURE_SDI_PORT      ${spiSDIPinSetting}

void DIFFPRESSURE_CS_SET_HIGH()
{
    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 1; } while(0);
}

void DIFFPRESSURE_CS_SET_LOW()
{
    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 0; } while(0);
}

diffPressureError_t DiffPressure_Read(float *diffPressure)
{    
    uint8_t adcReadByte[3];
    __uint24 adcRead = 0;
    
    while (!${SPIFunctions["spiOpen"]}(${spi_configuration}));

    //Need to check RDY state (SDI Pin) before reading
    DIFFPRESSURE_CS_SET_LOW();
    //tRDY max = 50ns, max amount of time to wait before sampling SDI pin
        //after CS goes low
    <#if (isAVR == "true")>
	_delay_us(1);
	<#else>
	__delay_us(1);
	</#if>
    while (DIFFPRESSURE_SDI_PORT != 0)
    {
        //While SDI pin is HIGH, sensor is not ready
        //Need to toggle CS pin to refresh SDI state
        DIFFPRESSURE_CS_SET_HIGH();
        //tCSD = 90ns, minimum amount of time for CS to be disabled
        <#if (isAVR == "true")>
		_delay_us(1);
		<#else>
		__delay_us(1);
		</#if>
        DIFFPRESSURE_CS_SET_LOW();
        //tRDY max = 50ns, max amount of time to wait before sampling SDI pin
            //after CS goes low
        <#if (isAVR == "true")>
		_delay_us(1);
		<#else>
		__delay_us(1);
		</#if>
    }
    
    adcReadByte[2] = ${SPIFunctions["exchangeByte"]}(0xFF);
    adcReadByte[1] = ${SPIFunctions["exchangeByte"]}(0xFF);
    adcReadByte[0] = ${SPIFunctions["exchangeByte"]}(0xFF);
    
    DIFFPRESSURE_CS_SET_HIGH();
    ${SPIFunctions["spiClose"]}();
    
    if (adcReadByte[2] & 0x80)
    {
        return OVL;
    }
    else if (adcReadByte[2] & 0x40)
    {
        return OVH;
    }
    
    adcRead = adcReadByte[2];
    adcRead <<= 8;
    adcRead += adcReadByte[1];
    adcRead <<= 8;
    adcRead += adcReadByte[0];
    
    //ADC value returned has a 22 bit resolution, 2^22 = 0x400000
    //MPXV5010 sensor has a range of 0 - 10kPA, Max Difference = 10
    //Difference in Pressure = (Max Difference)*(ADCRRead/ADCResolution)
    *diffPressure = (10)*((float)adcRead/0x400000);
    
    return NO_ERROR;
}

void DiffPressure_Initialize(void)
{
    DIFFPRESSURE_CS_SET_HIGH();
}