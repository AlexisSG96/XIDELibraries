/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <math.h>
#include "alcohol.h"
#include "${ANOUTFunctions["adcheader"]}"


static double Rs_CleanAir;
static double Ro_Alcohol;
static uint8_t isInitialized = 2; 

void ALCOHOL_Initialize(void){

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
 
    // Compute the value of Ro in Alcohol
    // From the MQ-3 datasheet, the ratio of Rs/Ro in clean air is 60
    Ro_Alcohol = Rs_CleanAir/60.0;  

    isInitialized = 1;
}

double ALCOHOL_GetReadings(void){
    
    double sensorValue;
    double sensorAverage;
    double sensorVoltage;

    double Rs_Alcohol;
    double ratio;

    if (isInitialized != 1)
    {
        ALCOHOL_Initialize();
    }

    // Store the conversion result to sensorValue
    sensorValue = ${ANOUTFunctions["getConversion"]}(${adc_channel});
    
    // Convert the average to its equivalent voltage
    sensorVoltage = (ADC_VREF * sensorValue)/ADC_RANGE_VALUE;

    // Compute the value of RS in Alcohol
    Rs_Alcohol = (ADC_VREF - sensorVoltage)/sensorVoltage;
        
    // Compute the ratio(Rs/Ro) in Alcohol
    ratio = Rs_Alcohol/Ro_Alcohol;
    
    return ratio;
}

double ALCOHOL_GetPPM(void){
    double PPM;
    double logPPM;
    double PPMratio;

    PPMratio = ALCOHOL_GetReadings();

    // Calculate the PPM. Values are computed from datasheet approximation
    logPPM = -0.386512 - 1.499653*log10(PPMratio);   
    PPM = pow(10,logPPM);

    return PPM; 
}

double ALCOHOL_GetBACLevel(void){       
    double PPMvalue;
    double BACvalue;

    PPMvalue = ALCOHOL_GetPPM();

    // Convert the PPM to %BAC
    BACvalue = PPMvalue*100/26;

    return BACvalue;
}
