/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "TOUCHKEY4_driver.h"
#include "drivers/${I2CFunctions["simpleheader"]}"


//Address Definitions
#define TOUCHKEY4_7BITS_ADDRESS           0x28
#define MODE_REG                          0x00
#define AVG_SAMP_REG                      0x24
#define TOUCH_STATE_REG                   0x00
#define BUTTON_STATE_REG                  0x03


/**
 * Mandatory pins to be interfaced with MCU:
 * I2C Module Pin: SCL and SDA must be interfaced with MCU and TOUCHKEY4 for Communication.
 */

 /**
 * @brief  This is an Initialization function for TOUCHKEY4 click
 * @param  None
 * @return None
 */
void TOUCHKEY4_Initialize(void)
{
    ${I2CFunctions["write1ByteRegister"]}(TOUCHKEY4_7BITS_ADDRESS, MODE_REG, 0b0000);
    ${I2CFunctions["write1ByteRegister"]}(TOUCHKEY4_7BITS_ADDRESS, AVG_SAMP_REG, 0b111001);
}

/**
 * @brief  This function is used for reading button state register value from TOUCHKEY4 click
 * @param  None
 * @return None
 */
uint8_t TOUCHKEY4_GetButtonState(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(TOUCHKEY4_7BITS_ADDRESS, BUTTON_STATE_REG);
}

/**
 * @brief  This function is used for reading touch state register value from TOUCHKEY4 click
 * @param  None
 * @return None
 */
uint8_t TOUCHKEY4_GetTouchState(void)
{
	return ${I2CFunctions["read1ByteRegister"]}(TOUCHKEY4_7BITS_ADDRESS, TOUCH_STATE_REG);
}