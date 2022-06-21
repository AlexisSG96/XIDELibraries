/*
    MICROCHIP SOFTWARE NOTICE AND DISCLAIMER:

    You may use this software, and any derivatives created by any person or
    entity by or on your behalf, exclusively with Microchip's products.
    Microchip and its subsidiaries ("Microchip"), and its licensors, retain all
    ownership and intellectual property rights in the accompanying software and
    in all derivatives hereto.

    This software and any accompanying information is for suggestion only. It
    does not modify Microchip's standard warranty for its products.  You agree
    that you are solely responsible for testing the software and determining
    its suitability.  Microchip has no obligation to modify, test, certify, or
    support the software.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE APPLY TO THIS SOFTWARE, ITS INTERACTION WITH MICROCHIP'S
    PRODUCTS, COMBINATION WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT, WILL MICROCHIP BE LIABLE, WHETHER IN CONTRACT, WARRANTY, TORT
    (INCLUDING NEGLIGENCE OR BREACH OF STATUTORY DUTY), STRICT LIABILITY,
    INDEMNITY, CONTRIBUTION, OR OTHERWISE, FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    EXEMPLARY, INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, FOR COST OR EXPENSE OF
    ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWSOEVER CAUSED, EVEN IF
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE
    FORESEEABLE.  TO THE FULLEST EXTENT ALLOWABLE BY LAW, MICROCHIP'S TOTAL
    LIABILITY ON ALL CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED
    THE AMOUNT OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR
    THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF
    THESE TERMS.
*/
#include <stdint.h>
#include "../mcc.h"

/*
 * =======================================================================
 * LOCAL FUNCTIONS
 * =======================================================================
 */

static void                 storeSensorData(void);
static mtouch_sensor_mask_t checkSensorData(uint8_t short_nOpen);
static void                 setAllSensorPinsLevel(bool high_low);

/*
 * =======================================================================
 * LOCAL VARIABLES
 * =======================================================================
 */
 
static mtouch_sensor_sample_t SensorData[MTOUCH_SENSORS];
 

/* Store current sensor data for later comparison */
static void storeSensorData(void)
{
    for(uint8_t i=0;i < MTOUCH_SENSORS;i++)
    {
        SensorData[i] = MTOUCH_Sensor_CVDSample_Get(i);
    }
}

/* Compare the current sensor data with threshold 
*  and previous sensor data under different condition
*/
static mtouch_sensor_mask_t checkSensorData(uint8_t short_nOpen)
{
    mtouch_sensor_mask_t errorSensor = 0;
    uint16_t maximumValue;
    uint16_t scaledThreshold;
    
    for(uint8_t i=0;i < MTOUCH_SENSORS;i++)
    {
        scaledThreshold = BIST_THRESHOLD * MTOUCH_Sensor_Oversampling_Get(i);
        maximumValue = (MTOUCH_Sensor_Oversampling_Get(i))<<9;
        
        /* Three short conditions :
           1. short to other sensor pins 
           2. short to GND
           3. Short to VDD 
         */
        if(short_nOpen) 
        {
            if((int16_t)abs(SensorData[i]-MTOUCH_Sensor_CVDSample_Get(i))>scaledThreshold ||
                SensorData[i] <  scaledThreshold ||
                SensorData[i] >  maximumValue - scaledThreshold)
            {
                errorSensor |= (mtouch_sensor_mask_t)1 << i;
            }
        }
        else
        /* the open condition will be tested by toggling on/off driven shield */
        {
            if((int16_t)abs(SensorData[i]-MTOUCH_Sensor_CVDSample_Get(i)) < scaledThreshold)
            {
                errorSensor |= (mtouch_sensor_mask_t)1 << i;
            }
        }
    }
    
    return errorSensor;
}

static void setAllSensorPinsLevel(bool high_low)
{
    <#list 0..mtouch.sensor.items?size-1 as i>
    LAT${mtouch.sensor.items[i].port}bits.LAT${mtouch.sensor.items[i].port}${mtouch.sensor.items[i].pin} = high_low;
    </#list>
}


mtouch_sensor_mask_t MTOUCH_BIST(void)
{
    mtouch_sensor_mask_t faultySensor;
    
    MTOUCH_BIST_modeEnable();

    MTOUCH_Sensor_DisableDS();
    while(!MTOUCH_Sensor_SampleAll());
    MTOUCH_Sensor_Sampled_ResetAll(); 
    storeSensorData();
    
    MTOUCH_Sensor_EnableDS();
    while(!MTOUCH_Sensor_SampleAll());
    MTOUCH_Sensor_Sampled_ResetAll(); 
    faultySensor = checkSensorData(0);
    
    /* Stop the test if fault is detected */
    if(faultySensor)
    {
        setAllSensorPinsLevel(false);
        MTOUCH_BIST_modeDisable();
        return faultySensor;
    }
    else
    {
        storeSensorData();
    }
    
    setAllSensorPinsLevel(true);
    while(!MTOUCH_Sensor_SampleAll());
    MTOUCH_Sensor_Sampled_ResetAll(); 
    faultySensor = checkSensorData(1);

    setAllSensorPinsLevel(false);
    MTOUCH_BIST_modeDisable();

    return faultySensor;
}