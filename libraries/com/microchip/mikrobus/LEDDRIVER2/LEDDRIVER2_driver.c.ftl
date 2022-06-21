/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "LEDDRIVER2_driver.h"
#include "${PWMFunctions["pwmHeader"]}"
/**
 * Mandatory pins to be interfaced with MCU:
 * Pin PWM : PWM Output from MCU for Dimming control
 */

/**
 * @brief  Set the brightness of LED lights
 * @param  brightnessLevel : Set the Dimming
 * @return None
 */
void LEDDRIVER2_SetBrightness(uint16_t brightnessLevel)
{
    //Set duty cycle for PWM 
    ${PWMFunctions["LoadDutyValue"]}(brightnessLevel);
}