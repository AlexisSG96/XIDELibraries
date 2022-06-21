/*
<#include "MicrochipDisclaimer.ftl">
*/
#ifdef __XC
#include <xc.h>
#endif
#include "CAPTOUCH_driver.h"
#include "${pinHeader}"


/**
 * Mandatory pins to be interfaced with MCU:
 * Pin Mode Pin: Enable mode for Cap Touch (Ouput from MCU)
 * Pin Output : Touch indication Pin from CAP Touch click (Input to MCU)
 */

/**
 * @brief  This is an Initialization function for CAP TOUCH.
 * @param  None
 * @return None
 */
void CAPTOUCH_Initialize()
{
    //Set the mode of the CAP touch 
    CAPTOUCH_SetFastMode();
}

/**
 * @brief  This sets the Fast mode for CAP TOUCH click and click response is fast
 * @param  None
 * @return None
 */
void CAPTOUCH_SetFastMode()
{
    CAPTOUCH_MODE_SetHigh();
}

/**
 * @brief  This sets the Low Power mode for CAP TOUCH click and click response is slow
 * @param  None
 * @return None
 */
void CAPTOUCH_SetLowPowerMode()
{
    CAPTOUCH_MODE_SetLow();
}

/**
 * @brief  Read the Touch state from Cap Touch click
 * @param  None
 * @return [Out] Touch state: Touch state of the Digital Pin
 */
uint8_t CAPTOUCH_GetTouchState()
{
    return CAPTOUCH_STATE_GetValue();
}