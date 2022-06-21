/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "voltmeter_example.h"
#include "voltmeter.h"

float VOLTMETER_getVoltage(void);

// From R10-R9 divider; ideal is 1024, may change depending on resistor tolerance.
static const int16_t Vgnd_mV = 1019;    

void VOLTMETER_example(void) {
    float voltage = VOLTMETER_getVoltage();
    int16_t v = (int16_t)(10 * voltage);
    printf("%d.%d V\r\n", v / 10, (v < 0 ? -v : v) % 10);
}

float VOLTMETER_getVoltage(void) {
    uint16_t adcAvg = 0;
    
    // Average 16 samples
    for (uint8_t i = 16; i != 0; i--) {
        adcAvg += VOLTMETER_getADCResult();
    }
    adcAvg >>= 4;
    
    // Convert ADC result to ADC input voltage
    int16_t Vadc_mV = adcAvg >> 1; 
    
    // Compute Voltmeter click input voltage
    float Vin = (Vadc_mV - Vgnd_mV) / 30.0;
    
    return Vin;
}
