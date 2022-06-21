/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <math.h>
#include "hydrogen.h"
#include "${ANOUTFunctions["adcheader"]}"


static double Rs_CleanAir;
static double Ro_Hydrogen = ${textSettings};
static uint8_t isInitialized = 2;

void HYDROGEN_Initialize(void){

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

double HYDROGEN_GetReadings(void){
    
    double sensorValue;
    double sensorAverage;
    double sensorVoltage;

    double Rs_Hydrogen;
    double ratio;

    if (isInitialized != 1)
    {
        HYDROGEN_Initialize();
    }
    
    // Store the conversion result to sensorValue
    sensorValue = ${ANOUTFunctions["getConversion"]}(${adc_channel});
    
    // Convert the average to its equivalent voltage
    sensorVoltage = (ADC_VREF * sensorValue)/ADC_RANGE_VALUE;
        
    // Compute the value of RS in Hydrogen
    Rs_Hydrogen = (ADC_VREF - sensorVoltage)/sensorVoltage;
        
    // Compute the ratio(Rs/Ro) in Hydrogen
    ratio = Rs_Hydrogen/Ro_Hydrogen;
    
    return ratio;
}

double HYDROGEN_GetPPM(void){
        double PPM;
        double logPPM;
        double PPMratio;

        PPMratio = HYDROGEN_GetReadings();

        // Calculate the PPM. Values are computed from datasheet approximation
        logPPM = (log10(PPMratio) * -0.8)+ 0.9;   
        PPM = pow(10,logPPM);

        return PPM;
}

