/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "EMG_driver.h"
#include "${ANOUTFunctions["adcheader"]}"
/**
 * Mandatory pins to be interfaced with MCU:
 * Pin ADC_OUTPUT : Analog input from EMG click to ADC channel (Input to MCU)
 */

/**
 * @brief  Read the ADC result from EMG click
 * @param  None
 * @return [Out] EMG_RESULT: ADC result of the EMG click pin
 */
uint16_t EMG_GetReading()
{
    // Read the ADC channel of the EMG Sensor pin
    return ((${ANOUTFunctions["getConversion"]}(${adc_channel})) & 0x3FF);
}