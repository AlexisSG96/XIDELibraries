/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <math.h>
#include "airquality.h"
#include "${ANOUTFunctions["adcheader"]}"

#define ADC_VREF                        (${referenceVoltage})
#define ADC_RANGE_VALUE                 (${adcRange})


static double Rs_CleanAir;
static double Ro_Air;
static uint8_t isInitialized = 2;

void AirQuality_Initialize(void)
{
    double sensorValue;
    double sensorAverage;
    double sensorVoltage;
    uint8_t x;
    
    // Use 16 for faster averaging
    const uint8_t totalSamplesToAverage = 16;

    sensorValue = 0.0;

    for(x = 0; x < totalSamplesToAverage; x++)
    {
        sensorValue = sensorValue + ${ANOUTFunctions["getConversion"]}(${adc_channel});
    }
    sensorAverage = sensorValue/totalSamplesToAverage;

    //Scale ADC reading to the voltage range
    sensorVoltage = (ADC_VREF * sensorAverage)/ADC_RANGE_VALUE;
    
    // Compute the value of Rs in clean air
    Rs_CleanAir = (ADC_VREF - sensorVoltage)/sensorVoltage;
    
    // From the MQ-135 datasheet, the ratio of Rs/Ro in clean air is 3.7
    Ro_Air = Rs_CleanAir/3.7;

    isInitialized = 1;
}

double AirQuality_GetReadings(void)
{
    double sensorValue;
    double sensorVoltage;

    double Rs_Air;
    double ratio;

    if (isInitialized != 1)
    {
        AirQuality_Initialize();
    }

    // Store the conversion result to sensorValue
    sensorValue = ${ANOUTFunctions["getConversion"]}(${adc_channel});
    
    // Convert the value to its equivalent voltage
    sensorVoltage = (ADC_VREF * sensorValue)/ADC_RANGE_VALUE;
        
    // Compute the value of RS in AirQuality
    Rs_Air = (ADC_VREF - sensorVoltage)/sensorVoltage;
        
    // Compute the ratio(Rs/Ro) in AirQuality
    ratio = Rs_Air/Ro_Air;
    
    return ratio;
}

double AirQuality_GetPPM(void)
{
    double PPM;
    double logPPM;
    double PPMratio;

    PPMratio = AirQuality_GetReadings();

    // Calculate the PPM. Values are computed from datasheet approximation
    logPPM = (log10(PPMratio) * -0.8)+ 0.9;   
    PPM = pow(10,logPPM);

    return PPM;
}

