/*
<#include "MicrochipDisclaimer.ftl">
*/
#ifdef __XC
#include <xc.h>
#endif
#include "CAPEXTEND3_driver.h"
#include "${pinHeader}"

/**
 * Mandatory pins to be interfaced with MCU:
 * Pin Output0 : Touch 0 Pin from CAP EXTEND3 click (Input to MCU)
 * Pin Output1 : Touch 1 Pin from CAP EXTEND3 click (Input to MCU)
 * Pin Output2 : Touch 2 Pin from CAP EXTEND3 click (Input to MCU)
 * Pin Output3 : Touch 3 Pin from CAP EXTEND3 click (Input to MCU)
 * Pin Output4 : Touch 4 Pin from CAP EXTEND3 click (Input to MCU)
 */

/**
 * @brief  Read the Touch 0 from CAP EXTEND3 click
 * @param  None
 * @return [Out] Touch Status: State of Touch 0 Pin
 */
uint8_t CAPEXTEND3_GetTouch0()
{
    return !CAPEXTEND3_TOUCH0_GetValue();
}

/**
 * @brief  Read the Touch 1 from CAP EXTEND3 click
 * @param  None
 * @return [Out] Touch Status: State of Touch 1 Pin
 */
uint8_t CAPEXTEND3_GetTouch1()
{
    return !CAPEXTEND3_TOUCH1_GetValue();
}

/**
 * @brief  Read the Touch 2 from CAP EXTEND3 click
 * @param  None
 * @return [Out] Touch Status: State of Touch 2 Pin
 */
uint8_t CAPEXTEND3_GetTouch2()
{
    return !CAPEXTEND3_TOUCH2_GetValue();
}

/**
 * @brief  Read the Touch 3 from CAP EXTEND3 click
 * @param  None
 * @return [Out] Touch Status: State of Touch 3 Pin
 */
uint8_t CAPEXTEND3_GetTouch3()
{
    return !CAPEXTEND3_TOUCH3_GetValue();
}

/**
 * @brief  Read the Touch 4 from CAP EXTEND3 click
 * @param  None
 * @return [Out] Touch Status: State of Touch 4 Pin
 */
uint8_t CAPEXTEND3_GetTouch4()
{
    return !CAPEXTEND3_TOUCH4_GetValue();
}

