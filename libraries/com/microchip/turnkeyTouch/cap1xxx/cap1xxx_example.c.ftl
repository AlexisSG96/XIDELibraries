/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "cap1xxx_example.h"

const uint8_t CAP_Configuration[][2] =   
{   //  Address     Value
    {   0x00,       0x00    },      // Main Control
    {   0x1F,       0x2F    },      // Sensitivity Control
    {   0x20,       0x20    },      // General Configuration
    {   0x21,       0xFF    },      // Sensor Input Enable
    {   0x22,       0xA4    },      // Sensor Input Configuration
    {   0x23,       0x07    },      // Sensor Input Configuration 2
    {   0x24,       0x39    },      // Averaging and Sampling Config
    {   0x26,       0x00    },      // Calibration Activate
    {   0x27,       0xFF    },      // Interrupt Enable
    {   0x28,       0xFF    },      // Repeat Rate Enable
};

/*
 *  The CAP1xxx stores configuration in volatile memory, so the desired configuration
 *  has to be loaded every time after device reset.
 *  
 *  The CAP_init() takes the configuration array like shown below to initialize the device.
 *  The CAP_Configuration array can be generated directly using CAP1xxx GUI.
 *  http://ww1.microchip.com/downloads/en/DeviceDoc/CAP1xxx%20GUI%20and%20documentation.zip
 *
 */
void CAP1xxx_initializationExample(void)
{
    if(CAP_init(CAP_Configuration,sizeof(CAP_Configuration)/2)!=CAP_error_None)
    {
        printf("CAP1xxx Initialization failed! \r\n");
    }
    else
    {
        printf("CAP1xxx is Initialized. \r\n");
    }
}

/*
 *   This example reads out the sensor status from CAP1xxx device.
 *
 *   This could be called periodically(polling method), 
 *   or called when the ALERT line is pulled low by CAP1xxx(interrupt driven).
 *   The interrupt driven method needs to configure the ALERT pin on MCU side to trigger 
 *   an MCU interrupt. For example, interrupt-on-change feature for PIC. 
 */  
void CAP1xxx_readSensorStatusExample(void)
{        
    /*-----------------------------------------
     * Read the current state mask value
     *-----------------------------------------
     */
    CAP_SENSOR_INPUT_STATUSbits_t CAP_sensor_input_status;
    
    CAP_sensor_input_status.value = CAP_getSensorStatus();
    printf("Sensor Status = %d \r\n",CAP_sensor_input_status.value);
    
    
    /* Process the button */
    if (CAP_sensor_input_status.CS1)
    {
        /* application process if CS1 is pressed */
    }
    else
    {
        /* application process if CS1 is released */
    }
    
    if (CAP_sensor_input_status.CS2)
    {
        /* application process if CS2 is pressed */
    }
    else
    {
        /* application process if CS2 is released */
    }
    
    
    /* The CAP1xxx status bit has to be cleared by firmware */
    if(CAP_sensor_input_status.value)
    {
        CAP_resetSensorStatus();
    }
}

/*
 *   This example reads out the sensor delta values from CAP1xxx device.
 *
 *   This is useful when tuning the performance of the CAP1xxx, 
 *   or using these data for further post processing.
 */ 
void CAP1xxx_outputDebuggingExample(void)
{
    /*-----------------------------------------
     * Read all sensor values
     *-----------------------------------------
     */
    uint8_t sensor;
    for(sensor= 0; sensor < NUMBER_OF_SENSORS; sensor++)
    {
        printf("delta%d = %d, ",sensor,CAP_getSensorDelta(sensor));
    }
    
    printf("\r\n");
}

/*
 *   This example checks if all sensors are calibrated.
 */ 
void CAP1xxx_checkCalibrationStatusExample(void)
{
    if(CAP_isCalibrated())
        printf("the device is calibrated.\r\n");
    else
        printf("the device is calibrating.\r\n");
}

/*
 *   This example checks the general status of the device.
 *   
 *   Besides simple touch, the device can recognize multiple touch and multiple
 *   touch pattern, also it reports calibration error.
 */
void CAP1xxx_handleGeneralStatusExample(void)
{
    CAP_GENERAL_STATUSbits_t CAP_current_status;
    
    CAP_current_status.value = CAP_getGeneralStatus();

    
    if(CAP_current_status.TOUCH)
    {
        /* Touch Event */
        /* Add application handling code here */
    }
    
    if(CAP_current_status.MTP)
    {
        /* Multiple Touch Pattern Event */
        /* Add application handling code here */
    }

    if (CAP_current_status.MULT)
    {
        /* Multi Touch Event */
        /* Add application handling code here */
    }
    
    <#if hasLED=="true">
    if (CAP_current_status.LED)
    {
        /* LED activity status */
        /* Add application handling code here */
    }
    </#if>

    if (CAP_current_status.RESET)
    {
        /* CAP RESET status */
        /* Add application handling code here */
    }
    
    <#if deviceFamily =="CAP12">
    if (CAP_current_status.ACAL_FAIL)
    {
        /* CAP analog calibration failed */
        /* Please check the sensor pin capacitance */
    }

    if (CAP_current_status.BC_OUT)
    {
        /* digital calibration failed */
    }
    </#if>
}