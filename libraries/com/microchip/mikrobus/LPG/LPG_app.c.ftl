/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdint.h>
#include <math.h>
#include "lpg.h"
#include "${ANOUTFunctions["adcheader"]}"

static double Rs_CleanAir;
static double Ro_LPG = ${textSettings};
static uint8_t isInitialized = 2;

void LPG_Initialize(void){

    double sensorValue;
    double sensorAverage;
    double sensorVoltage;
    double ratio;

    sensorValue = 0.0;
    
    // Use 16 for faster averaging
    for(int x = 0; x < 16; x++)
    {
        sensorValue = sensorValue + ${ANOUTFunctions["getConversion"]}(${adc_channel});
    }
    sensorAverage = sensorValue/16;

    //Scale 16-bit ADC reading to the voltage range
    sensorVoltage = (ADC_VREF * sensorAverage)/ADC_RANGE_VALUE;
    
    // Compute the value of Rs in clean air
    Rs_CleanAir = (ADC_VREF - sensorVoltage)/sensorVoltage;

    isInitialized = 1;

}

double LPG_GetReadings(void){
    
    double sensorValue;
    double sensorAverage;
    double sensorVoltage;

    double Rs_LPG;
    double ratio;

    if (isInitialized != 1)
    {
        LPG_Initialize();
    }

    // Store the conversion result to sensorValue
    sensorValue = ${ANOUTFunctions["getConversion"]}(${adc_channel});
    
    // Convert the average to its equivalent voltage
    sensorVoltage = (ADC_VREF * sensorValue)/ADC_RANGE_VALUE;
        
    // Compute the value of RS in LPG
    Rs_LPG = (ADC_VREF - sensorVoltage)/sensorVoltage;
        
    // Compute the ratio(Rs/Ro) in LPG
    ratio = Rs_LPG/Ro_LPG;
    
    return ratio;
}

double LPG_GetPPM(void){
        double PPM;
        double logPPM;
        double PPMratio;

        PPMratio = LPG_GetReadings();

        // Calculate the PPM. Values are computed from datasheet approximation
        logPPM = (log10(PPMratio) * -2.8)+ 3.2;   
        PPM = pow(10,logPPM);

        return PPM;
}

