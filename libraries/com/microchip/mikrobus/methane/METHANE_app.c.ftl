/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <math.h>
#include "methane.h"
#include "${ANOUTFunctions["adcheader"]}"


static double Rs_CleanAir;
static double Ro_Methane;
static uint8_t isInitialized = 2; 

void METHANE_Initialize(void){

    double sensorValue;
    double sensorAverage;
    double sensorVoltage;

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
 
    // Compute the value of Ro in Methane
    // From the MQ-3 datasheet, the ratio of Rs/Ro in clean air is 1
    Ro_Methane = Rs_CleanAir/1.0;  

    isInitialized = 1;
}

double METHANE_GetReadings(void){
    
    double sensorValue;
    double sensorAverage;
    double sensorVoltage;

    double Rs_Methane;
    double ratio;

    if (isInitialized != 1)
    {
        METHANE_Initialize();
    }

    // Store the conversion result to sensorValue
    sensorValue = ${ANOUTFunctions["getConversion"]}(${adc_channel});
    
    // Convert the average to its equivalent voltage
    sensorVoltage = (ADC_VREF * sensorValue)/ADC_RANGE_VALUE;
        
    // Compute the value of RS in Methane
    Rs_Methane = (ADC_VREF - sensorVoltage)/sensorVoltage;
        
    // Compute the ratio(Rs/Ro) in Methane
    ratio = Rs_Methane/Ro_Methane;
    
    return ratio;
}

double METHANE_GetPPM(void){
    double PPM;
    double logPPM;
    double PPMratio;

    PPMratio = METHANE_GetReadings();

    // Calculate the PPM. Values are computed from datasheet approximation
    logPPM = 1.435 - 1.6355*log10(PPMratio);   
    PPM = pow(10,logPPM);

    return PPM; 
}