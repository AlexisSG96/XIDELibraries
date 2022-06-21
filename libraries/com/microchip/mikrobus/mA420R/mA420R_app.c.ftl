/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>

#include "${SPIFunctions.spiHeader}"
#include "${portHeader}"

// Constants

// 102.4 / 4096.0 / 4.99 from Vref=2048 A=20 Vref/A = 102.4 ; 12bit=4096 ; Shunt R = 4R99
#define mA420R_ADC_to_mA		0.00501002004 

uint16_t mA420R_RawADC(void)
{
    uint16_t adc_res;
    ${SPIFunctions.spiOpen}(${spi_configuration});
    ${spiSSPinSettings.setOutputLevelLow}
    adc_res = ${SPIFunctions.exchangeByte}(0xFF) & 0x1F; 
    adc_res <<= 8;
    adc_res += ${SPIFunctions.exchangeByte}(0xFF);       
    ${spiSSPinSettings.setOutputLevelHigh};
    ${SPIFunctions.spiClose}();

    // We get bit1 again, so we will drop it
    return (adc_res >> 1);
}

// Returns 0..4095
uint16_t mA420R_RawADCAvg(void) 
{				
    uint16_t adc_s[18], adc_sum = 0;
    uint8_t i, min_i = 0, max_i = 0;
	
    for(i = 0; i < 18 ; i++ )
    {                                        
        adc_s[i] = mA420R_RawADC();          
        adc_sum += adc_s[i];                 
    }

    // Search the array for MIN/Max value
    for(i = 0; i < 18 ; i++ )
    {							
        if(adc_s[min_i] > adc_s[i])
        {
            min_i = i;
        }

        if(adc_s[max_i] < adc_s[i])
        {
            max_i = i;
        }
    }

    // Remove the MIN value from sum
    adc_sum -= adc_s[min_i];

    // Remove the MAX value from sum
    adc_sum -= adc_s[max_i];       
             
    // Shift bits 4 places - divide the sum by 16 (2 to the power of 4)
    adc_sum >>= 4;

    // Final value correction ~1% (Shunt resistor tolerance )
    adc_sum += (adc_sum / 100);

    return adc_sum;
}

float mA420R_Single(void)
{
    float mA_val = 0;
    uint16_t adc_val = mA420R_RawADC();

    // ADC value should be in range 800-4095 (4-20mA)
    if ((adc_val <= 4095) && (adc_val >= 800))
    {
        // Vref=2048 A=20 Vref/A = 102.4 ; 12bit=4096 ; Shunt R = 4R99
        mA_val = adc_val * mA420R_ADC_to_mA;   
    }

    return mA_val;
}

float mA420R_Avg(void)
{
    float mA_val = 0;
    uint16_t adc_val = mA420R_RawADCAvg();

    // ADC value should be in range 800-4095 (4-20mA)
    if ((adc_val <= 4095) && (adc_val >= 800))
    {    		
        // Vref=2048 A=20 Vref/A = 102.4 ; 12bit=4096 ; Shunt R = 4R99
        mA_val = adc_val * mA420R_ADC_to_mA;
    }

    return mA_val;
}

void ME_Click_420mAR_Initialize(void)
{
    ${spiSSPinSettings.setOutputLevelHigh};
    ${spiSSPinSettings.setOutput};
}