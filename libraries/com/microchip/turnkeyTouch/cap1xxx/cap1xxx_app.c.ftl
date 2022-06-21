/*
<#include "MicrochipDisclaimer.ftl">
*/
#include "cap1xxx_app.h"
#include "../drivers/i2c_simple_master.h"

<#if resetPinSettings??>
/*  
 *  Hold the reset pin of CAP1xxx in reset mode 
 */
inline void CAP_holdInReset(void)
{
    CAP1xxx_RESET_SetHigh();
    CAP1xxx_RESET_SetDigitalOutput();
}

/* 
 *  Release the reset pin of CAP1xxx to start operation 
 */
inline void CAP_resetRelease(void)
{
    CAP1xxx_RESET_SetLow();
    CAP1xxx_RESET_SetDigitalOutput();
}

</#if>
/*
 * Generic register read function
 */
inline uint8_t CAP_readRegister(uint8_t addr)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, addr);
}

/*
 * Generic register write function
 */
inline void CAP_writeRegister(uint8_t addr, uint8_t data)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, addr, data);
}

/*=============================================================================
 *  Initializes the I2C module, verifies communications are active,
 *  validates the Device ID value, and loads the configuration.
 *  The CAP1xxx device can have maximum 200ms power-up time, so it might not be able
 *  to communicate via i2c during the power-up.
 *=============================================================================
 */
uint8_t CAP_init(uint8_t CAP_Configuration[][2],uint8_t numberOfConfigRegister)
{
    uint8_t value   = 0;
    
    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetDigitalInput();
    </#if>
    
    <#if resetPinSettings??>
    CAP_resetRelease();
    </#if>
    
    /* -----------------------------------------
     * Verify the CAPxxxx's Device ID
     * -----------------------------------------
     */
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, 0xFD);
        
    /* Invalid Device ID */
    if (value != CAPxxxx_ID)      
    {    
        return CAP_error_DeviceIDMismatch;
    } 
    
    /* -----------------------------------------
     * Load the Default Configuration
     * -----------------------------------------
     */
    uint8_t i;
    for ( i = 0; i < numberOfConfigRegister; i++)
    {
        ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_Configuration[i][0], CAP_Configuration[i][1]);
    }
    
    return CAP_error_None;
}

/* 
 * Returns the value of the sensor delta
 */
int8_t CAP_getSensorDelta(uint8_t sensor)
{
    if (sensor >= NUMBER_OF_SENSORS)
        return 0;
    else
        return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, (uint8_t)(0x10 + sensor));
}

/*
 *  Returns the value of the general status register
 */
uint8_t CAP_getGeneralStatus(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_GENERAL_STATUS_ADDRESS);
}

/*
 * Returns the value of the sensor status register
 */
uint8_t CAP_getSensorStatus(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SENSOR_INPUT_STATUS_ADDRESS);
}

/* 
* Reset the Sensor Status register , Clear the INT bit.
*/
void CAP_resetSensorStatus(void)
{
    uint8_t value;

    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS);

    value &= 0xFE; /* Clear the INT bit (bit 0) */
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS, value);
}

/*
 * Returns the Main Control Register
 */
uint8_t CAP_getMainControl(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS);
}

/*
 * Returns the Configuration2 Register
 */
uint8_t CAP_getConfiguration2(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_CONFIGURATION_2_ADDRESS);
}

/*
 *Enter Standby mode
 */
void CAP_enterStandby(void)
{
    uint8_t value;

    /* Get the current value of the general status register */
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS);

    value |= 0b00100000; /* Set the Standby bit */

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS, value);
}

/*
 *Exit Standby mode
 */
void CAP_exitStandby(void)
{
    uint8_t value = 0;

    /* Get the current value of the general status register */
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS);

    value &= 0b11011111;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS, value);
}

/*
 * Enter Deep Sleep mode
 */
void CAP_enterDeepSleep(void)
{
    uint8_t value = 0;

    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetLow();
    CAP1xxx_WAKE_SetDigitalOutput();
    </#if>

    /* Get the current value of the general status register */
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS);

    value |= 0b00010000;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS, value);
}

/*
 * Exit Deep Sleep mode
 */
void CAP_exitDeepSleep(void)
{
    uint8_t value = 0;

    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetHigh();
    CAP1xxx_WAKE_SetDigitalOutput();
    </#if>
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS, value);

    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetDigitalInput();
    </#if>
}

/*
 * =======================================================================
 * CAP_isCalibrated
 * This function will check the CALIBRATION ACTIVATE REGISTER @26h
 * If all sensors are calibrated, it will return true. otherwise, false
 * =======================================================================
 */
bool CAP_isCalibrated(void)
{

    CAP_CALIBRATION_ACTIVATE_AND_STATUSbits_t calibration_status;

    calibration_status.value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_CALIBRATION_ACTIVATE_AND_STATUS_ADDRESS);

    if (calibration_status.value == 0x00)
    {
        return true;
    }
    else
    {
        return false;
    }
}

 /* =======================================================================
  * CAP_setGain
  * =======================================================================
  */
void CAP_setGain(uint8_t gain)
{
    CAP_MAIN_CONTROLbits_t value;
    /* Get the current value of main control register */
    value.value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS);

    value.GAIN = gain;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_CONTROL_ADDRESS, value.value);
}

/*
 * =======================================================================
 *  CAP_setInputThresholds
 * =======================================================================
 */
void CAP_setInputThresholds(uint8_t sensorChannel, uint8_t sensorThreshold)
{

    if(sensorChannel >= NUMBER_OF_SENSORS)
        return;  

    CAP_SENSOR_INPUT_THRESHOLD01bits_t reg_data;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, sensorChannel + CAP_SENSOR_INPUT_THRESHOLD01_ADDRESS, sensorThreshold);
}
/*
 * =======================================================================
 *  CAP_setDeltaSensitivity
 *
 *  Set the touch sensitivity
 *  Range 0 - 7 (0 being the most sensitive)
 *  sensitivity multiplier = 2 ^ (7 - sensitivityCode) 
 * =======================================================================
 */
void CAP_setDeltaSensitivity(uint8_t sensitivityCode)
{
    CAP_SENSITIVITY_CONTROLbits_t reg_data;

    reg_data.value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SENSITIVITY_CONTROL_ADDRESS);
  
    if (sensitivityCode > 7)
    {
        sensitivityCode = 7;
    }

    reg_data.DELTA_SENSE = sensitivityCode;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SENSITIVITY_CONTROL_ADDRESS, reg_data.value);
}

/*
 * =======================================================================
 *  CAP_setSamplingConfig
 *
 *  Cycle time / Sample time / Average 
 *  User could dynamically change the setting to adapt to different noise condition.  
 * =======================================================================
 */
void CAP_setSamplingConfig(uint8_t config)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_AVERAGING_AND_SAMPLING_CONFIGURATION_ADDRESS, config); 
}

/*
 * =======================================================================
 *  CAP_getNoiseFlag
 *
 *  return the data read from Noise_Flag_Status
 * =======================================================================
 */
uint8_t CAP_getNoiseFlag(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_NOISE_FLAG_STATUS_ADDRESS);
}

/*
 * =======================================================================
 *  CAP_disableRFNoise
 * 
 *  Disable RF Noise as the RF detector can be too sensitive, which blocks the 
 *  touch detection.
 * =======================================================================
 */
void CAP_disableRFNoise(void)
{
    CAP_CONFIGURATION_2bits_t reg_data;

    reg_data.value = i2c_read1ByteRegister(CAPxxxx_ADDRESS, CAP_CONFIGURATION_2_ADDRESS);
    reg_data.DIS_RF_NOISE = 1;
    i2c_write1ByteRegister(CAPxxxx_ADDRESS, CAP_CONFIGURATION_2_ADDRESS, reg_data.value);
}
<#if hasLED=="true">

/* =============================================================================
 *  LED Drive API.
 * =======================================================================
 *  CAP_LED_Output_Type_Set
 *
 *  Example: 
 *  
 *  CAP_LED_OUTPUT_TYPE_REGISTERbits_t reg_data;
 *
 *  reg_data.LED1_OT = 1; //LED1 set as push pull ;
 *  reg_data.LED2_OT = 0; //LED2 set as open drain ;
 *
 *  CAP_LED_Output_Type_Set(reg_data.value);    
 * 
 * 
 *  ‘0’ (default) - The LED8 pin is an open-drain output with an external pull-up resistor. When the appropriate pin is
 *     set to the “active” state (logic ‘1’), the pin will be driven low. Conversely, when the pin is set to the “inactive” state
 *      (logic ‘0’), then the pin will be left in a High Z state and pulled high via an external pull-up resistor.
 *  ‘1’ - The LED8 pin is a push-pull output. When driving a logic ‘1’, the pin is driven high. When driving a logic ‘0’, the
 *       pin is driven low.
 * =======================================================================
 */
void CAP_LED_Output_Type_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_OUTPUT_TYPE_REGISTER_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Sensor_Linking_Set
 *
 *  Example: 
 *  
 *  CAP_SENSOR_INPUT_LED_LINKING_REGISTERbits_t reg_data;
 *
 *  reg_data.CS1_LED1 = 1; //LED1 linked  ;
 *  reg_data.CS2_LED1 = 0; //LED2 not linked ;
 *
 *  CAP_LED_Sensor_Linking_Set(reg_data.value);    
 *
 *  ‘0’ (default) - The LED8 output is not associated with the CS8 input. If a touch is detected on the CS8 input, then
 *      the LED will not automatically be actuated. The LED is enabled and controlled via the LED Output Control register
 *       (see Section 6.28) and the LED Behavior registers (see Section 6.31).
 *  ‘1’ - The LED8 output is associated with the CS8 input. If a touch is detected on the CS8 input, the LED will be
 *       actuated and behave as defined in Table 6-52.
 * 
 * =======================================================================
 */
void CAP_LED_Sensor_Linking_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SENSOR_INPUT_LED_LINKING_REGISTER_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Polarity_Set
 *  
 *  Example: 
 *  
 *  CAP_CAP_LED_POLARITY_REGISTERbits_t reg_data;
 *
 *  reg_data.LED1_POL = 1; //LED1  ;
 *  reg_data.LED2_POL = 0; //LED2  ;
 *
 *  CAP_LED_Polarity_Set(reg_data.value);    
 *
 *  The LED Polarity register controls the logical polarity of the LED outputs. When these bits are set or cleared, the corresponding
 *  LED Mirror controls are also set or cleared (unless the BLK_POL_MIR bit is set - see Section 6.6, "Configuration
 *  Registers"). Table 6-48, "LED Polarity Behavior" shows the interaction between the polarity controls, output
 *  controls, and relative brightness.
 * 
 * =======================================================================
 */
void CAP_LED_Polarity_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_POLARITY_REGISTER_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Output_Control_Set
 *
 *  Example: 
 *  
 *  CAP_LED_OUTPUT_CONTROL_REGISTERbits_t reg_data;
 *
 *  reg_data.LED1_DR = 1; //LED1
 *  reg_data.LED2_DR = 0; //LED2
 *
 *  CAP_LED_Output_Control_Set(reg_data.value);    
 *
 *  '0' (default) - The LEDx output is driven at the minimum duty cycle or not actuated.
 *  '1' - The LED8 output is driven at the maximum duty cycle or is actuated.
 * 
 * =======================================================================
 */
void CAP_LED_Output_Control_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_OUTPUT_CONTROL_REGISTER_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Linked_Transition_Set
 *
 *  Example: 
 *  
 *  CAP_LINKED_LED_TRANSITION_CONTROL_REGISTERbits_t reg_data;
 *
 *  reg_data.LED1_LTRAN = 1; //LED1
 *  reg_data.LED2_LTRAN = 0; //LED2
 *
 *  CAP_LED_Linked_Transition_Set(reg_data.value);     
 *
 *  '0' (default) - When the LED output control bit for LED8 is ‘1’, and then LED8 is linked to CS8 and no touch is
 *       detected, the LED will change states.
 *       
 *  '1' - If the INV_LINK_TRAN bit is ‘1’, when the LED output control bit for CS8 is ‘1’, and then CS8 is linked to LED8
 *      and no touch is detected, the LED will not change states. In addition, the LED state will change when the sensor
 *      pad is touched. If the INV_LINK_TRAN bit is ‘0’, when the LED output control bit for CS8 is ‘1’, and then CS8 is
 *      linked to LED8 and no touch is detected, the LED will not change states. However, the LED state will not change
 *      when the sensor pad is touched.
 * 
 * =======================================================================
 */
void CAP_LED_Linked_Transition_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LINKED_LED_TRANSITION_CONTROL_REGISTER_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Mirror_Set
 * 
 *  Example: 
 *  
 *  CAP_LED_MIRROR_CONTROL_REGISTERbits_t reg_data;
 *
 *  reg_data.LED1_MIR_EN = 1; //LED1
 *  reg_data.LED2_MIR_EN = 0; //LED2
 *
 *  CAP_LED_Mirror_Set(reg_data.value);   
 *
 *  '0' (default) - The duty cycle settings are determined relative to 0% and are determined directly with the settings.
 *  '1' - The duty cycle settings are determined relative to 100%.
 * 
 * =======================================================================
 */
void CAP_LED_Mirror_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_MIRROR_CONTROL_REGISTER_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Behavior_Set
 *
 *  Set the behavior for each individual LED. There are four behaviors
 *  CAP_LED_DIRECT 
 *  CAP_LED_PULSE1
 *  CAP_LED_PULSE2 
 *  CAP_LED_BREATHE
 *  
 *  Example: 
 *   CAP_LED_Behavior_Set(0;CAP_LED_PULSE1);   //LED1 set as PULSE1 mode . 
 *
 * =======================================================================
 */
void CAP_LED_Behavior_Set(uint8_t ledChannel, uint8_t behavior)
{
    uint8_t value;
    uint8_t b_mask = 0;

    uint8_t address = CAP_LED_BEHAVIOR_REGISTER1_ADDRESS;
    if (ledChannel > 4)
    {
        address = CAP_LED_BEHAVIOR_REGISTER2_ADDRESS;
        ledChannel -= 4;
    }

    ledChannel = (uint8_t)(ledChannel << 1);

    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, address);
    b_mask = behavior;
    b_mask = (uint8_t)(b_mask << ledChannel);

    value|= b_mask;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, address, value);
};
</#if>

