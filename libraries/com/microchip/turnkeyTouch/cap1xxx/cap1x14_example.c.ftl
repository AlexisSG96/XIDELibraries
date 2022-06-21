/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "cap1x14_example.h"

const uint8_t CAP_Configuration[][2] =   
{   //  Address     Value
    {   0x00,       0x00    },      // Main Control
    {   0x1F,       0x2F    },      // Sensitivity Control
    {   0x20,       0x29    },      // General Configuration
    {   0x21,       0xFF    },      // Sensor Input Enable
    {   0x22,       0xA4    },      // Sensor Input Configuration
    {   0x23,       0x47    },      // Sensor Input Configuration 2
    {   0x24,       0xD4    },      // Averaging and Sampling Configuration
    {   0x26,       0x00    },      // Calibration Activate
    {   0x27,       0xFF    },      // Interrupt Enable 1
    {   0x28,       0x00    },      // Interrupt Enable 2
};

/* 
 *  The CAP1xxx stores configuration in volatile memory, so the desired configuration
 *  has to be loaded very time after device reset.
 *  
 *  The CAP_init() takes the configuration array like shown below to initialize the device.
 *  The CAP_Configuration array can be generated directly using CAP1xxx GUI.
 *  http://ww1.microchip.com/downloads/en/DeviceDoc/CAP1xxx%20GUI%20and%20documentation.zip
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
    CAP_BUTTON_STATUS_1bits_t CAP_button_status_1;
    CAP_BUTTON_STATUS_2bits_t CAP_button_status_2;
    
    CAP_button_status_1.value = CAP_getSensorStatus();
    CAP_button_status_2.value = (CAP_getSensorStatus() >> 8);

    printf("Button 1-6, Down, UP Status = %d \r\n",CAP_button_status_1.value);
    printf("Button 7-14 Status = %d \r\n",CAP_button_status_2.value);    
    
    /* Process status of buttons 1-6 and DOWN, UP status */
    if (CAP_button_status_1.CS1)
    {
        /* application process if CS1 is pressed */
    }
    else
    {
        /* application process if CS1 is released */
    }
    
    /* Process status of buttons 7-14 */
    if (CAP_button_status_2.CS7)
    {
        /* application process if CS7 is pressed */
    }
    else
    {
        /* application process if CS7 is released */
    }
    
    /* The CAP1xxx status bit has to be cleared by firmware */
    if(CAP_button_status_1.value || CAP_button_status_2.value)
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
 *   Beside simple touch, the device can recognize multiple touch and multiple
 *   touch pattern, also it reports calibration error.
 */
void CAP1xxx_handleGroupStatusExample(void)
{
    CAP_GROUP_STATUSbits_t CAP_group_status;
    
    CAP_group_status.value = CAP_getGroupStatus();

    if(CAP_group_status.PH)
    {
        /* Press and Hold Event */
        /* Add application handling code here */
    }
    
    if(CAP_group_status.TAP)
    {
        /* Tap Event */
        /* Add application handling code here */
    }

    if (CAP_group_status.MULT)
    {
        /* Multi Touch Event */
        /* Add application handling code here */
    }
    
    if (CAP_group_status.LID)
    {
        /* Lid Closure Event */
        /* Add application handling code here */
    }

    if (CAP_group_status.RESET)
    {
        /* CAP RESET status */
        /* Add application handling code here */
    }
}