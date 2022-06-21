/*
<#include "MicrochipDisclaimer.ftl">
*/
#include "cap1x14_app.h"
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
 *  Generic register read function
 */
inline uint8_t CAP_readRegister(uint8_t addr)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, addr);
}

/*
 *  Generic register write function
 */
inline void CAP_writeRegister(uint8_t addr,uint8_t data)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, addr, data);
}

/*=============================================================================
 *  Initializes the I2C module, verifies communications are active,
 *  validates the Device ID value, and loads the configuration.
 *  The CAP1xxx device can have maximum 200ms power-up time, so it might
 *  not be able to communicate via I2C during the power-up.
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
    
    //-----------------------------------------
    // Verify the CAPxxxx's Device ID
    //-----------------------------------------
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, 0xFD);
        
    // Invalid Device ID
    if (value != CAPxxxx_ID)      
    {    
        return CAP_error_DeviceIDMismatch;
    } 
    
    //-----------------------------------------
    // Load the Default Configuration
    //-----------------------------------------
    uint8_t i;
    for (i = 0; i < numberOfConfigRegister; i++)
    {
        ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_Configuration[i][0], CAP_Configuration[i][1]);
    }
    
    return CAP_error_None;
}

/* 
 *  Returns the value of the sensor delta
 */
int8_t CAP_getSensorDelta(uint8_t sensor)
{
    if(sensor>=NUMBER_OF_SENSORS)
        return 0;
    else
        return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, (0x10+sensor));
}

/*
 *  Returns the value of the main control register
 */
uint8_t CAP_getMainStatusControl(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS);
}

/*
 *  Returns the value of the group status register
 */
uint8_t CAP_getGroupStatus(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_GROUP_STATUS_ADDRESS);
}

/*
 *  Returns the value of the sensor status register
 */
uint16_t CAP_getSensorStatus(void)
{
    uint16_t status;
    
    ${I2CFunctions["readDataBlock"]}(CAPxxxx_ADDRESS, CAP_BUTTON_STATUS_1_ADDRESS, &status, 2);
    
    return status;
}

/* 
 *  Reset the Sensor Status register , Clear the INT bit.
 */
void CAP_resetSensorStatus(void)
{
    uint8_t value;

    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS);
    
    value &= 0xFE;  // Clear the INT bit (bit 0)
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS, value);
}

/*
 *  Returns the value of the slider position register
 */    
uint8_t CAP_getSliderPosition(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SLIDER_POSITION_VOLUMETRIC_DATA_ADDRESS);
}

/*
 *  Returns the value of the Configuration2 register
 */
uint8_t CAP_getConfiguration2(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_CONFIGURATION_2_ADDRESS);
}

/*
 *  Enter Sleep Mode
 */
void CAP_enterSleep(void)
{
    uint8_t value;
    
    // Get the current value of the general status register
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS);
    
    value |= 0b00100000;    // Set the Sleep bit
    
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS, value);
}

/*
 *  Exit Sleep Mode
 */
void CAP_exitSleep(void)
{
    uint8_t value = 0;
    
    // Get the current value of the general status register
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS);
    
    value &= 0b11011111;
    
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS, value);
}

/*
 *  Enter Deep Sleep Mode
 */
void CAP_enterDeepSleep(void)
{
    uint8_t value = 0;

    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetLow();
    CAP1xxx_WAKE_SetDigitalOutput();
    </#if>
    
    // Get the current value of the general status register
    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS);
    
    value |= 0b00010000;
    
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS, value);
}

/*
 *  Exit Deep Sleep Mode
 */
void CAP_exitDeepSleep(void)
{
    uint8_t value = 0;
    
    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetHigh();
    CAP1xxx_WAKE_SetDigitalOutput();
    </#if>
    
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_MAIN_STATUS_CONTROL_ADDRESS, value);
    
    <#if wakePinSettings??>
    CAP1xxx_WAKE_SetDigitalInput();
    </#if>
}

/*
 * =======================================================================
 *  CAP_isCalibrated
 *  
 *  This function will check the CALIBRATION ACTIVATE REGISTER @26h and 0x46
 *  If all sensor is  calibrated, it will return true. otherwise, false
 * =======================================================================
 */
bool CAP_isCalibrated(void)
{

    CAP_CALIBRATION_ACTIVATEbits_t calibration_status;
    CAP_GROUPED_SENSOR_CALIBRATION_ACTIVATEbits_t grouped_calibration_status;
    
    calibration_status.value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_CALIBRATION_ACTIVATE_ADDRESS);
    grouped_calibration_status.value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_GROUPED_SENSOR_CALIBRATION_ACTIVATE_ADDRESS);
            
    if ((calibration_status.value && grouped_calibration_status.value) == 0x00)
    {
        return true;
    }
    else
    {
        return false;
    }
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
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SAMPLING_CONFIGURATION_ADDRESS, config); 
}

/*
 * =======================================================================
 *  CAP_getNoiseFlag
 * 
 *  return the data read from Noise_Flag_Status
 * =======================================================================
 */
uint16_t CAP_getNoiseFlag(void)
{
    uint16_t Noise_Flags;
    
    Noise_Flags = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_NOISE_STATUS_1_ADDRESS);
    Noise_Flags |= (${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_NOISE_STATUS_2_ADDRESS) << 8);
    
    return Noise_Flags;
}

/*
 * =======================================================================
 *  CAP_disableRFNoise
 * 
 *  Disable RF Noise as the RF detector can be too sensitivity, which blocks the 
 *  touch detection.
 * =======================================================================
 */
void CAP_disableRFNoise(void)
{
    CAP_CONFIGURATION_2bits_t reg_data;

    reg_data.value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_CONFIGURATION_2_ADDRESS);

<#if deviceName == "1114">
    reg_data.BLK_RF_NOISE = 1;
</#if>
<#if deviceName == "1214">
    reg_data.DIS_RF_NOISE = 1;
</#if>

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_CONFIGURATION_2_ADDRESS, reg_data.value);
}
<#if hasLED=="true">

/* =============================================================================
 *  LED Drive API.
 * =======================================================================
 *  CAP_LED_Output_Type_Set
 * 
 *  For example: 
 *  
 *  CAP_LED_GPIO_OUTPUT_TYPEbits_t reg_data;
 *
 *  reg_data.LED1_OT = 1; //LED1 set as push pull ;
 *  reg_data.LED2_OT = 0; //LED2 set as open drain ;
 *
 *  CAP_LED_Output_Type_Set(reg_data.value);    
 *
 * =======================================================================
 */
void CAP_LED_Output_Type_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_GPIO_OUTPUT_TYPE_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Sensor_Linking_Set
 * 
 *  For example: 
 *  
 *  CAP_SENSOR_LED_LINKINGbits_t reg_data;
 *
 *  reg_data.CS1_LED1 = 1; //LED1 linked
 *  reg_data.CS2_LED2 = 0; //LED2 not linked
 *  reg_data.UP_DOWN_LINK = 1; // LED9/LED10 linked to DOWN/UP events
 *  reg_data.UP_DOWN_LINK = 0; // LED9/LED10 not linked to DOWN/UP events
 * 
 *  CAP_LED_Sensor_Linking_Set(reg_data.value);    
 * 
 * =======================================================================
 */
void CAP_LED_Sensor_Linking_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_SENSOR_LED_LINKING_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Polarity_1_Set
 *      Sets polarity for LED1 - LED8
 * 
 *  For example: 
 *  
 *  CAP_LED_POLARITY_1bits_t reg_data;
 *
 *  reg_data.LED1_POL = 1; //LED1 output is non-inverted
 *  reg_data.LED2_POL = 0; //LED2 output is inverted
 *
 *  CAP_LED_Polarity_1_Set(reg_data.value);    
 * 
 * =======================================================================
 */
void CAP_LED_Polarity_1_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_POLARITY_1_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Polarity_2_Set
 *      Sets polarity for LED9 - LED11
 * 
 *  For example: 
 *  
 *  CAP_LED_POLARITY_2bits_t reg_data;
 *
 *  reg_data.LED9_POL = 1; //LED9 output is non-inverted
 *  reg_data.LED10_POL = 0; //LED10 output is inverted
 *
 *  CAP_LED_Polarity_2_Set(reg_data.value);    
 * 
 * =======================================================================
 */
void CAP_LED_Polarity_2_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_POLARITY_2_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Output_Control_1_Set
 * 
 *  For example: 
 *  
 *  CAP_LED_OUTPUT_CONTROL_1bits_t reg_data;
 *
 *  reg_data.LED1_DR = 1; //LED1
 *  reg_data.LED2_DR = 0; //LED2
 *
 *  CAP_LED_Output_Control_1_Set(reg_data.value);    
 *
 *  '0' (default) - The LEDx output is driven at the minimum duty cycle or not actuated.
 *  '1' - The LEDx output is driven at the maximum duty cycle or is actuated.
 * 
 * =======================================================================
 */
void CAP_LED_Output_Control_1_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_OUTPUT_CONTROL_1_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Output_Control_2_Set
 * 
 *  For example: 
 *  
 *  CAP_LED_OUTPUT_CONTROL_2bits_t reg_data;
 *  
 *  reg_data.LED9_DR = 1; //LED9
 *  reg_data.LED10_DR = 0; //LED10
 *
 *  CAP_LED_Output_Control_2_Set(reg_data.value);    
 *
 *  '0' (default) - The LEDx output is driven at the minimum duty cycle or not actuated.
 *  '1' - The LEDx output is driven at the maximum duty cycle or is actuated.
 * 
 * =======================================================================
 */
void CAP_LED_Output_Control_2_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_OUTPUT_CONTROL_2_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Linked_Transition_1_Set
 * 
 *  For example: 
 *  
 *  CAP_LINKED_LED_TRANSITION_CONTROL_1bits_t reg_data;
 *
 *  reg_data.LED1_LTRAN = 1; //LED1
 *  reg_data.LED2_LTRAN = 0; //LED2
 *
 *  CAP_LED_Linked_Transition_1_Set(reg_data.value);     
 *
 *  '0' (default) - When the LED output control bit for LED8 is '1', and then LED8 is linked to CS8 and no touch is
 *  detected, the LED will change states.
 *       
 *  '1' - If the INV_LINK_TRAN bit is '1', when the LED output control bit for CS8 is '1', and then CS8 is linked to LED8
 *  and no touch is detected, the LED will not change states. In addition, the LED state will change when the sensor
 *  pad is touched. If the INV_LINK_TRAN bit is '0', when the LED output control bit for CS8 is '1', and then CS8 is
 *  linked to LED8 and no touch is detected, the LED will not change states. However, the LED state will not change
 *  when the sensor pad is touched.
 * 
 * =======================================================================
 */
void CAP_LED_Linked_Transition_1_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LINKED_LED_TRANSITION_CONTROL_1_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Linked_Transition_2_Set
 * 
 *  For example: 
 *  
 *  CAP_LINKED_LED_TRANSITION_CONTROL_2bits_t reg_data;
 *
 *  reg_data.LED9_LTRAN = 1; //LED9
 *  reg_data.LED10_LTRAN = 0; //LED10
 *
 *  CAP_LED_Linked_Transition_2_Set(reg_data.value);     
 *
 *  '0' (default) - When the LED output control bit for LED8 is '1', and then LED8 is linked to CS8 and no touch is
 *  detected, the LED will change states.
 *       
 *  '1' - If the INV_LINK_TRAN bit is '1', when the LED output control bit for CS8 is '1', and then CS8 is linked to LED8
 *  and no touch is detected, the LED will not change states. In addition, the LED state will change when the sensor
 *  pad is touched. If the INV_LINK_TRAN bit is '0', when the LED output control bit for CS8 is '1', and then CS8 is
 *  linked to LED8 and no touch is detected, the LED will not change states. However, the LED state will not change
 *  when the sensor pad is touched.
 * 
 * =======================================================================
 */
void CAP_LED_Linked_Transition_2_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LINKED_LED_TRANSITION_CONTROL_2_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Mirror_1_Set
 * 
 *  For example: 
 *  
 *  CAP_LED_MIRROR_CONTROL_1bits_t reg_data;
 *
 *  reg_data.LED1_MIR_EN = 1; //LED1
 *  reg_data.LED2_MIR_EN = 0; //LED2
 *
 *  CAP_LED_Mirror_1_Set(reg_data.value);   
 *
 *  '0' (default) - The duty cycle settings are determined relative to 0% and are determined directly with the settings.
 *  '1' - The duty cycle settings are determined relative to 100%.
 * 
 * =======================================================================
 */
void CAP_LED_Mirror_1_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_MIRROR_CONTROL_1_ADDRESS, value);
};

/*
 * =======================================================================
 *  CAP_LED_Mirror_2_Set
 * 
 *  For example: 
 *  
 *  CAP_LED_MIRROR_CONTROL_2bits_t reg_data;
 *
 *  reg_data.LED9_MIR_EN = 1; //LED9
 *  reg_data.LED10_MIR_EN = 0; //LED10
 *
 *  CAP_LED_Mirror_2_Set(reg_data.value);   
 *
 *  '0' (default) - The duty cycle settings are determined relative to 0% and are determined directly with the settings.
 *  '1' - The duty cycle settings are determined relative to 100%.
 * 
 * =======================================================================
 */
void CAP_LED_Mirror_2_Set(uint8_t value)
{
    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, CAP_LED_MIRROR_CONTROL_2_ADDRESS, value);
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
 *  
 *  CAP_LED_Behavior_Set(0, CAP_LED_PULSE1);   //LED1 set as PULSE1 mode
 *
 * =======================================================================
 */
void CAP_LED_Behavior_Set(uint8_t ledChannel, uint8_t behavior)
{
    uint8_t value;
    uint8_t b_mask = 0;

    uint8_t address = CAP_LED_BEHAVIOR_1_ADDRESS;
    if (ledChannel > 8)
    {
        address = CAP_LED_BEHAVIOR_3_ADDRESS;
        ledChannel -= 8;
    }
    else if (ledChannel > 4)
    {
        address = CAP_LED_BEHAVIOR_2_ADDRESS;
        ledChannel -= 4;
    }

    ledChannel = (uint8_t)(ledChannel << 1);

    value = ${I2CFunctions["read1ByteRegister"]}(CAPxxxx_ADDRESS, address);
    b_mask = behavior;
    b_mask = (uint8_t)(b_mask << ledChannel);

    value |= b_mask;

    ${I2CFunctions["write1ByteRegister"]}(CAPxxxx_ADDRESS, address, value);
};
</#if>