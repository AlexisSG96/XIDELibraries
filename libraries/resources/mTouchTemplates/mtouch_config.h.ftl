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
#ifndef MTOUCH_CONFIG_H
#define MTOUCH_CONFIG_H

#include <stdint.h>
#include <stdbool.h>
#include "mtouch_sensor.h"
<#if mtouch.button.enabled??>
#include "mtouch_button.h"
</#if>
<#if mtouch.prox.enabled??>
#include "mtouch_proximity.h"
</#if>
<#if mtouch.slider.enabled??>
#include "mtouch_slider.h"
</#if>
<#if mtouch.surface.enabled??>
#include "mtouch_surface.h"
</#if>
<#if mtouch.gesture.enabled??>
#include "mtouch_gesture.h"
</#if>
<#if mtouch.dataStreamer??>
#include "mtouch_datastreamer.h"
</#if>
<#if mtouch.surfaceUtility??>
#include "mtouch_memory_2D.h"
</#if>
<#if mtouch.hostInterfaceComms??>
<#if mtouch.hostInterfaceComms.hostInterruptMode??>
<#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
#include "mtouch_memory.h"
</#if>
</#if>
</#if>

/*
 * =======================================================================
 * Application / Configuration Settings
 * =======================================================================
 */
<#if mtouch.scangroup??>
    #define MTOUCH_SCAN_GROUPS      ${mtouch.scangroup.items?size}u
</#if>
<#if mtouch.button.enabled??>
    #define MTOUCH_BUTTONS_ENABLE   1u
</#if>
<#if mtouch.prox.enabled??>
    #define MTOUCH_PROXIMITY_ENABLE 1u
</#if>

<#if mtouch.button.enabled??>
#if (MTOUCH_BUTTONS_ENABLE == 1u)    
    #define MTOUCH_BUTTONS          ${mtouch.button.items?size}u
#else
    #define MTOUCH_BUTTONS          0u
#endif
</#if>
<#if mtouch.prox.enabled??>
#if (MTOUCH_PROXIMITY_ENABLE == 1u)
    #define MTOUCH_PROXIMITY        ${mtouch.prox.items?size}u
#else
    #define MTOUCH_PROXIMITY        0u
#endif
</#if>
<#if mtouch.prox.enabled?? && mtouch.button.enabled??>
    #define MTOUCH_SENSORS          (MTOUCH_BUTTONS + MTOUCH_PROXIMITY)
<#elseif mtouch.prox.enabled?? && !mtouch.button.enabled??>
    #define MTOUCH_SENSORS          (MTOUCH_PROXIMITY)
<#elseif !mtouch.prox.enabled?? && mtouch.button.enabled??>
    #define MTOUCH_SENSORS          (MTOUCH_BUTTONS)
</#if>
<#if mtouch.slider.enabled??>
    #define MTOUCH_SLIDERS          ${mtouch.slider.items?size}u
</#if>
<#if mtouch.surface.enabled??>
    #define MTOUCH_SURFACES         ${mtouch.surface.num_surfaces}u
    #define SURFACE_NUM_CONTACTS    ${mtouch.surface.num_contacts}u
</#if>
    #define MTOUCH_DEBUG_COMM_ENABLE      1u


<#if mtouch.sensor.enabled??>
    /* 
     * =======================================================================
     * Sensor Parameters
     * =======================================================================
     */

    <#if mtouch.scanRateControl.enabled??>
    /*
     *  Defines the scan interval (milliseconds)
     *  Range - 1 to 255
     */
    #define MTOUCH_SCAN_INTERVAL    ${mtouch.scanRateControl.scanInterval}u      //unit ms
    </#if>
    
    <#if mtouch.sensor.adc_type == "ADCC_12bit" || mtouch.sensor.adc_type == "ADCC" || mtouch.sensor.adc_type == "ADC3_12bit" >
    <#list 0..mtouch.sensor.items?size-1 as i>
    #define MTOUCH_SENSOR_ADPCH_${mtouch.sensor.items[i].name}              ${mtouch.sensor.items[i].adpch_value}
    #define MTOUCH_SENSOR_PRECHARGE_${mtouch.sensor.items[i].name}          ${mtouch.sensor.items[i].time.precharge}u
    #define MTOUCH_SENSOR_ACQUISITION_${mtouch.sensor.items[i].name}        ${mtouch.sensor.items[i].time.acquisition}u
    #define MTOUCH_SENSOR_OVERSAMPLING_${mtouch.sensor.items[i].name}       ${mtouch.sensor.items[i].oversampling}u
    #define MTOUCH_SENSOR_ADDITIONALCAP_${mtouch.sensor.items[i].name}      ${mtouch.sensor.items[i].additionalCap}u
    /*-----------------------------------------------------------------------------*/
    </#list>
    <#if mtouch.lowPower.enabled??>
    #define MTOUCH_SENSOR_ACTIVE_THRESHOLD               MTOUCH_LOWPOWER_DETECT_THRESHOLD 
    <#else>
    #define MTOUCH_SENSOR_ACTIVE_THRESHOLD               100u  
    </#if>
    <#elseif mtouch.sensor.adc_type == "dual_ADC">
    <#list 0..mtouch.sensor.items?size-1 as i>
    #define MTOUCH_SENSOR_ADCON0_${mtouch.sensor.items[i].name}             ${mtouch.sensor.items[i].adcon0_value}
    <#if mtouch.sensor.adxchImplemented??>
    #define MTOUCH_SENSOR_ADXCH_${mtouch.sensor.items[i].name}              ${mtouch.sensor.items[i].adxch}
    <#elseif mtouch.sensor.adxch0Implemented??>
    #define MTOUCH_SENSOR_ADXCH0_${mtouch.sensor.items[i].name}             ${mtouch.sensor.items[i].adxch0}
    #define MTOUCH_SENSOR_ADXCH1_${mtouch.sensor.items[i].name}             ${mtouch.sensor.items[i].adxch1}
    </#if>
    #define MTOUCH_SENSOR_PRECHARGE_${mtouch.sensor.items[i].name}          ${mtouch.sensor.items[i].time.precharge}u
    #define MTOUCH_SENSOR_ACQUISITION_${mtouch.sensor.items[i].name}        ${mtouch.sensor.items[i].time.acquisition}u
    #define MTOUCH_SENSOR_OVERSAMPLING_${mtouch.sensor.items[i].name}       ${mtouch.sensor.items[i].oversampling}u
    #define MTOUCH_SENSOR_ADDITIONALCAP_${mtouch.sensor.items[i].name}      ${mtouch.sensor.items[i].additionalCap}u
    /*-----------------------------------------------------------------------------*/
    </#list>
    <#if mtouch.lowPower.enabled??>
    #define MTOUCH_SENSOR_ACTIVE_THRESHOLD               MTOUCH_LOWPOWER_DETECT_THRESHOLD 
    <#else>
    #define MTOUCH_SENSOR_ACTIVE_THRESHOLD               100u  
    </#if>
    <#else> <#--  normal_ADC  -->
    <#list 0..mtouch.sensor.items?size-1 as i>
    /*** ${mtouch.sensor.items[i].name} ***/
    #define MTOUCH_S${i}_ADCON0_SENSOR              ${mtouch.sensor.items[i].adcon0_value}
    #define MTOUCH_S${i}_REF_ADCON0                 ${mtouch.sensor.items[i].reference.adcon0_value}
    #define MTOUCH_S${i}_LAT                        LAT${mtouch.sensor.items[i].port}
    #define MTOUCH_S${i}_TRIS                       TRIS${mtouch.sensor.items[i].port}
    #define MTOUCH_S${i}_PIN                        ${mtouch.sensor.items[i].pin}
    #define MTOUCH_S${i}_REF_LAT                    LAT${mtouch.sensor.items[i].reference.port}
    #define MTOUCH_S${i}_REF_PIN                    ${mtouch.sensor.items[i].reference.pin}
    #define MTOUCH_S${i}_GUARD_LAT                  LAT${mtouch.sensor.items[i].guard.port}
    #define MTOUCH_S${i}_GUARD_PIN                  ${mtouch.sensor.items[i].guard.pin}
    #define MTOUCH_S${i}_PRECHARGE_TIME             ${mtouch.sensor.items[i].time.precharge}u
    #define MTOUCH_S${i}_ACQUISITION_TIME           ${mtouch.sensor.items[i].time.acquisition}u
    #define MTOUCH_S${i}_SWITCH_TIME                ${mtouch.sensor.items[i].time.switch}u
    #define MTOUCH_S${i}_DISCON_TIME                ${mtouch.sensor.items[i].time.disconnect}u
    /*-----------------------------------------------------------------------------*/
    <#if mtouch.sensor.items[i].xcharge??>
    #define MTOUCH_S${i}_XCHARGE_TIME               ${mtouch.sensor.items[i].xcharge.time}u
    </#if>
    #define MTOUCH_S${i}_OVERSAMPLING               ${mtouch.sensor.items[i].oversampling}u
    </#list>
    <#if mtouch.lowPower.enabled??>
    #define MTOUCH_SENSOR_ACTIVE_THRESHOLD               MTOUCH_LOWPOWER_DETECT_THRESHOLD 
    <#else>
    #define MTOUCH_SENSOR_ACTIVE_THRESHOLD               100u  
    </#if>
    </#if>
    <#if mtouch.sensor.bist??>  
    /* 
     * Based on the short condition and noise, the BIST need to have a 
     * tolerance threshold for robust detection.
     * 
     * The range is from 0-1023.
     * 
     */
    #define BIST_THRESHOLD 10
    </#if>
</#if>

<#if mtouch.button.enabled??>
    /* 
     * =======================================================================
     * Button Parameters
     * =======================================================================
     */

    #define MTOUCH_BUTTON_READING_GAIN              ((uint8_t)${mtouch.button.reading.gain}u)
    #define MTOUCH_BUTTON_BASELINE_GAIN             ((uint8_t)${mtouch.button.baseline.gain}u)
    #define MTOUCH_BUTTON_BASELINE_INIT             ((mtouch_button_baselinecounter_t)${mtouch.button.baseline.init}u)
    #define MTOUCH_BUTTON_BASELINE_RATE             ((mtouch_button_baselinecounter_t)${mtouch.button.baseline.rate}u)
    #define MTOUCH_BUTTON_BASELINE_HOLD             ((mtouch_button_baselinecounter_t)1024u)
    <#if mtouch.button.negativeDeviation != "0">
    #define MTOUCH_BUTTON_NEGATIVEDEVIATION         ((mtouch_button_statecounter_t)${mtouch.button.negativeDeviation}u)
    </#if>
    <#if mtouch.button.pressTimeout != "0">
    #define MTOUCH_BUTTON_PRESSTIMEOUT              ((mtouch_button_statecounter_t)${mtouch.button.pressTimeout}u)
    </#if>
    <#if mtouch.button.debounce_enabled == true>
    #define MTOUCH_BUTTON_DEBOUNCE_COUNT            (${mtouch.button.debounce_count}u)
    </#if>

    <#list 0..mtouch.button.items?size-1 as i>
    #define MTOUCH_BUTTON_SENSOR_${mtouch.button.items[i].name}             ${mtouch.button.items[i].sensor}
    </#list>

    <#list 0..mtouch.button.items?size-1 as i>
    #define MTOUCH_BUTTON_THRESHOLD_${mtouch.button.items[i].name}          ${mtouch.button.items[i].threshold}u
    </#list>
    
    <#list 0..mtouch.button.items?size-1 as i>
    #define MTOUCH_BUTTON_SCALING_${mtouch.button.items[i].name}            ${mtouch.button.items[i].deviation_scaling}u
    </#list>

    <#if mtouch.button.individual_hysteresis_enabled == false>
    <#list 0..0 as i>
    #define MTOUCH_BUTTON_COMMON_HYSTERESIS         ${mtouch.button.items[i].hysteresis}
    </#list>
    <#else>
    <#list 0..mtouch.button.items?size-1 as i>
    #define MTOUCH_BUTTON_HYSTERESIS_${mtouch.button.items[i].name}     ${mtouch.button.items[i].hysteresis}
    </#list>
    </#if>
</#if>
    
<#if mtouch.prox.enabled??>
    /* 
     * =======================================================================
     * Proximity Parameters
     * =======================================================================
     */
    #define MTOUCH_PROXIMITY_READING_GAIN           ((uint8_t)${mtouch.prox.reading.gain}u)
    #define MTOUCH_PROXIMITY_BASELINE_GAIN          ((uint8_t)${mtouch.prox.baseline.gain}u)
    #define MTOUCH_PROXIMITY_BASELINE_INIT          ((mtouch_prox_baselinecounter_t)${mtouch.prox.baseline.init}u)
    #define MTOUCH_PROXIMITY_BASELINE_RATE          ((mtouch_prox_baselinecounter_t)${mtouch.prox.baseline.rate}u)
    #define MTOUCH_PROXIMITY_BASELINE_HOLD          ((mtouch_prox_baselinecounter_t)1024u)
    #define MTOUCH_PROXIMITY_DEVIATION_GAIN         ((uint8_t)${mtouch.prox.deviation.deviationIntegrationFiltersGain}u);
    <#if mtouch.prox.negativeDeviation != "0">
    #define MTOUCH_PROXIMITY_NEGATIVEDEVIATION      ((mtouch_prox_statecounter_t)${mtouch.prox.negativeDeviation}u)
    </#if>
    <#if mtouch.prox.activityTimeout != "0">
    #define MTOUCH_PROXIMITY_ACTIVITYTIMEOUT        ((mtouch_prox_statecounter_t)${mtouch.prox.activityTimeout}u)
    </#if>
    <#if mtouch.prox.debounce_enabled == true>
    #define MTOUCH_PROXIMITY_DEBOUNCE_COUNT         ${mtouch.prox.debounce_count}u
    </#if>

    <#list 0..mtouch.prox.items?size-1 as i>
    #define MTOUCH_PROXIMITY_THRESHOLD_${mtouch.prox.items[i].name}   ${mtouch.prox.items[i].threshold}u
    </#list>
    
    <#list 0..mtouch.prox.items?size-1 as i>
    #define MTOUCH_PROXIMITY_SCALING_${mtouch.prox.items[i].name}     ${mtouch.prox.items[i].deviation_scaling}u
    </#list>
    
    <#if mtouch.prox.individual_hysteresis_enabled == false>
    <#list 0..0 as i>
    #define MTOUCH_PROXIMITY_COMMON_HYSTERESIS       ${mtouch.prox.items[i].hysteresis}
    </#list>
    <#else>
    <#list 0..mtouch.prox.items?size-1 as i>
    #define MTOUCH_PROXIMITY_HYSTERESIS_${mtouch.prox.items[i].name}    ${mtouch.prox.items[i].hysteresis}
    </#list>
    </#if>

</#if>

<#if mtouch.slider.enabled??>
    /* 
     * =======================================================================
     * Slider Parameters
     * =======================================================================
     */
<#list 0..mtouch.slider.items?size-1 as i>

  /**  Config:  ${mtouch.slider.items[i].name} **/
    /* Slider Type <0-65534>
     * Type of the slider
     * Range: MTOUCH_TYPE_SLIDER or MTOUCH_TYPE_WHEEL
     */
    #define ${mtouch.slider.items[i].name}_TYPE                 <#if mtouch.slider.items[i].sliderType == "Slider"> MTOUCH_TYPE_SLIDER <#else> MTOUCH_TYPE_WHEEL </#if>
    /* Start Segment <0-65534>
     * Start Segment of the slider
     * Range: 0 to 65534
     */
    #define ${mtouch.slider.items[i].name}_START_SEGMENT         ${mtouch.slider.items[i].startSegment}    
    /* Number of Channel <0-255>
     * Number of Channels for the slider
     * Range: 0 to 255
     */
    #define ${mtouch.slider.items[i].name}_NUM_SEGMENTS          ${mtouch.slider.items[i].segmentCount}u
    /*  Position Resolution 
     *  Full scale position resolution reported
     *  RESOL_2_BIT - RESOL_12_BIT
     */
    #define ${mtouch.slider.items[i].name}_RESOLUTION            ${mtouch.slider.items[i].resolution}
    /*  Position Deadband Percentage
     *  Full scale position deadband Percentage
     *  DB_NONE - DB_15_PERCENT
     */
    #define ${mtouch.slider.items[i].name}_DEADBAND              ${mtouch.slider.items[i].deadband}
    /* Position Hysteresis <0-255>
     * The minimum travel distance to be reported after contact or direction change
     */
    #define ${mtouch.slider.items[i].name}_POS_HYST              ${mtouch.slider.items[i].hysteresis}u
    /* Contact Threshold <0-65534>
     * The minimum contact size measurement for persistent contact tracking.
     * Contact size is the sum of neighbouring Segments touch deltas forming the touch contact.
     * By default, contact Threshold parameter should be set equal to threshold value of the underlying keys.
     * Then the parameter has to be tuned based on the actual contact size of the touch when moved over the slider.
     */
    #define ${mtouch.slider.items[i].name}_THRESHOLD             ${mtouch.slider.items[i].threshold}u

</#list>
</#if>

<#if mtouch.surface.enabled??>
    /* 
     * =======================================================================
     * Surface Parameters
     * =======================================================================
     */
    /*  Config: ${mtouch.surface.name} */
    /* Horizontal Start Segment <0-65534>
     * Start Segment of horizontal axis
     * Range: 0 to 65534
     */
    #define SURFACE_CS_START_SEGMENT_H      ${mtouch.surface.start_seg_h}
    /* Horizontal Number of Channel <0-255>
     * Number of Channels forming horizontal axis
     * Range: 0 to 255
     */
    #define SURFACE_CS_NUM_SEGMENTS_H       ${mtouch.surface.num_seg_h}u
    /* Vertical Start Segment <0-65534>
     * Start Segment of vertical axis
     * Range: 0 to 65534
     */
    #define SURFACE_CS_START_SEGMENT_V      ${mtouch.surface.start_seg_v}
    /* Vertical Number of Channel <0-255>
     * Number of Channels forming vertical axis
     * Range: 0 to 255
     */
    #define SURFACE_CS_NUM_SEGMENTS_V       ${mtouch.surface.num_seg_v}u
    /*  Position Resolution 
     *  Full scale position resolution reported for the axis 
     *  RESOL_2_BIT - RESOL_12_BIT
     */
    #define SURFACE_CS_RESOLUTION           ${mtouch.surface.resolution}
    /*  Position Deadband Percentage
     *  Full scale position deadband Percentage
     *  DB_NONE - DB_15_PERCENT
     */
    #define SURFACE_CS_DEADBAND             ${mtouch.surface.deadband}
    /* Median filter enable and  IIR filter Config
     * Median Filter <0-1>
     * Enable or Disable Median Filter
     * enable - 1
     * disable - 0
     * IIR filter <0-3>
     * Configure IIR filter
     *  0 - None
     *  1 - 25%
     *  2 - 50%
     *  3 - 75%
     */
    #define SURFACE_CS_FILT_CFG             SURFACE_MEDIAN_IIR(${mtouch.surface.median_filter_enable}u, ${mtouch.surface.iir_filter_conf}u)
    /* Position Hysteresis <0-255>
     * The minimum travel distance to be reported after contact or direction change
     * Applicable to Horizontal and Vertical directions
     */
    #define SURFACE_CS_POS_HYST             ${mtouch.surface.pos_hyst}u
    /* Minimum Contact <0-65534>
     * The minimum contact size measurement for persistent contact tracking.
     * Contact size is the sum of neighbouring Segments touch deltas forming the touch contact.
     */
    #define SURFACE_CS_MIN_CONTACT          ${mtouch.surface.min_contact}u
</#if>

<#if mtouch.gesture.enabled??>
    /* 
     * =======================================================================
     * Gesture Parameters
     * =======================================================================
     */

    /*	Tap Release timeout  <3-255>
     *	The TAP_RELEASE_TIMEOUT parameter limits the amount of time allowed between the initial finger press and the
     *liftoff. Exceeding this value will cause the firmware to not consider the gesture as a tap gesture.
     *  TAP_RELEASE_TIMEOUT should be lesser than the TAP_HOLD_TIMEOUT and SWIPE_TIMEOUT.
     *  Unit: x10 ms
     *  Example: if TAP_RELEASE_TIMEOUT is configured as 3, then the user should finish tapping within 30 ms to qualify the
     *gesture as tap.
     */
    #define TAP_RELEASE_TIMEOUT     ${mtouch.gesture.tap_release_timeout}u
    /*  Tap Hold timeout <0-255>
     *	If a finger stays within the bounds set by TAP_AREA and is not removed, the firmware will report a Tap Hold gesture
     *once the gesture timer exceeds the TAP_HOLD_TIMEOUT value. HOLD_TAP is a single finger gesture whereas HOLD_TAP_DUAL
     *is dual finger gesture. Ideally, TAP_HOLD_TIMEOUT should be greater than the TAP_RELEASE_TIMEOUT and SWIPE_TIMEOUT.
     *  Unit: x10 ms
     *  Example: if TAP_HOLD_TIMEOUT is configured as 6, then the user should tap and hold inside the TAP_AREA for 60 ms to
     *qualify the gesture as tap and hold.
     */
    #define TAP_HOLD_TIMEOUT        ${mtouch.gesture.tap_hold_timeout}u
    /*  Swipe timeout <0-255>
     *	The SWIPE_TIMEOUT limits the amount of time allowed for the swipe gesture (initial finger press, moving in a
     *particular direction crossing the distance threshold and the liftoff). Ideally, SWIPE_TIMEOUT should be greater than
     *TAP_RELEASE_TIMEOUT but smaller than the TAP_HOLD_TIMEOUT. Unit: x10 ms Example: if SWIPE_TIMEOUT is configured as 5,
     *then the user should swipe in a particular direction and liftoff within 50 ms to qualify the gesture as swipe.
     */
    #define SWIPE_TIMEOUT           ${mtouch.gesture.swipe_timeout}u
    /*  Horizontal Swipe distance threshold <0-255>
     *	HORIZONTAL_SWIPE_DISTANCE_THRESHOLD controls the distance travelled in the X axis direction for detecting Left and
     *Right Swipe gesture. Unit: X-coordinate Example: If HORIZONTAL_SWIPE_DISTANCE_THRESHOLD is configured as 50, and a
     *user places their finger at x-coordinate 100, they must move to at least x-coordinate 50 to record a left swipe
     *gesture.
     */
    #define HORIZONTAL_SWIPE_DISTANCE_THRESHOLD     ${mtouch.gesture.horiz_swipe_dist_threshold}u
    /* 	Vertical swipe distance threshold <0-255>
     *	VERTICAL_SWIPE_DISTANCE_THRESHOLD controls the distance travelled in the Y axis direction for detecting Up and Down
     *Swipe gesture. Unit: Y-coordinate Example: if VERTICAL_SWIPE_DISTANCE_THRESHOLD is configured as 30, and a user
     *places their finger at y-coordinate 100, they must move to at least y-coordinate 70 to record a down swipe gesture.
     */
    #define VERTICAL_SWIPE_DISTANCE_THRESHOLD       ${mtouch.gesture.vert_swipe_dist_threshold}u
    /* 	Tap area <0-255>
     *	The TAP_AREA bounds the finger to an area it must stay within to be considered a tap gesture when the finger is
     *removed and tap and hold gesture if the finger is not removed for sometime. Unit: coordinates Example: if TAP_AREA is
     *configured as 20, then user should tap within 20 coordinates to detect the tap gesture.
     */
    #define TAP_AREA                            ${mtouch.gesture.tap_area}u
    /* 	Seq Tap distance threshold <0-255>
     *	The SEQ_TAP_DIST_THRESHOLD parameter limits the allowable distance of the current touch's initial press from the
     *liftoff position of the previous touch. It is used for multiple taps (double-tap, triple-tap etc). If the taps
     *following the first are within this threshold, then the tap counter will be incremented. If the following tap
     *gesture exceed this threshold, the previous touch is sent as a single tap and the current touch will reset the tap
     *counter. Unit: coordinates Example: if SEQ_TAP_DIST_THRESHOLD is configured as 20, after the first tap, if the user
     *taps again within 20 coordinates, it is considered as double tap gesture.
     */
    #define SEQ_TAP_DIST_THRESHOLD              ${mtouch.gesture.seq_tap_dist_threshold}u
    /* 	Edge Boundary <0-255>
     *	The firmware can also be modified to define an edge region along the border of the touch sensor.
     *	With Edge Boundary defined, swipe gesture that start in an edge region will be reported as edge swipe gesture in
     *place of normal swipe gesture. To create an edge region, the EDGE_BOUNDARY is set with the size (in touch
     *coordinates) of the edge region. Unit: coordinates Example: Setting the EDGE_BOUNDARY parameter to 100 will designate
     *the area 100 units in from each edge as the edge region.
     */
    #define EDGE_BOUNDARY                       ${mtouch.gesture.edge_boundary}u
    /*  Wheel Post-scaler <0-255>
     *	The clockwise wheel is performed with 4 swipes (right->down->left->up). Similarly, the anti-clockwise wheel is
     *performed with 4 swipes (left->down->right->up). To detect a wheel, the minimum number of swipe required is wheel
     *start quadrant count + wheel post scaler. Once the wheel is detected, for post scaler number of swipe detections, the
     *wheel counter will be incremented by 1. Example: if wheel post scaler is 2, then for each two swipe detection, the
     *wheel counter will be incremented by 1.
     */
    #define WHEEL_POSTSCALER                    ${mtouch.gesture.wheel_postscaler}u
    /* 	Wheel Start Quadrant count <2-255>
     *	The wheel gesture movement can be broken down into 90 degree arcs.
     *	The firmware watches for a certain number of arcs to occur in a circular pattern before starting to report wheel
     *gesture information. The number of arcs that must be first detected is determined by the WHEEL_START_QUADRANT_COUNT
     *parameter. Lower values for this parameter make it faster to start a wheel gesture, but it also makes the firmware
     *prone to prematurely reporting wheel gesture information. Example: if WHEEL_START_QUADRANT_COUNT is configured as 2,
     *then after 180 degree, the gesture is updated as Wheel.
     */
    #define WHEEL_START_QUADRANT_COUNT          ${mtouch.gesture.wheel_start_quadrant_count}u
    /* 	Wheel Reverse Quadrant count <2-255>
     *	The WHEEL_REVERSE_QUADRANT_COUNT performs a similar function as WHEEL_START_QUADRANT_COUNT except it is used when
     *changing the direction of the wheel instead of starting it new. This is used to prevent quick toggling between
     *directions. Example: If WHEEL_REVERSE_QUADRANT_COUNT is set as 4 and after some wheel gesture, if the user changes
     *the direction of rotation, then only after 360 degree, it will be detected as one wheel gesture.
     */
    #define WHEEL_REVERSE_QUADRANT_COUNT        ${mtouch.gesture.wheel_reverse_quadrant_count}u

    <#if mtouch.surface.num_contacts == 2>
    /* Pinch Zoom Threshold <0-255>
     * The PINCH_ZOOM_THRESHOLD limits the allowable distance between the two fingers to detect the pinch and the zoom
     * gesture. After crossing the PINCH_ZOOM_THRESHOLD, if the distance between the contacts is reducing, then the gesture
     * is reported as 'PINCH'. After crossing the PINCH_ZOOM_THRESHOLD, if the distance between the contacts is increasing,
     * then the gesture is reported as 'ZOOM'. Unit: coordinates Example: if PINCH_ZOOM_THRESHOLD is configured as 20, then
     * after crossing 20 coordinates, it will be reported as the pinch gesture or the zoom gesture.
     */
    #define PINCH_ZOOM_THRESHOLD                ${mtouch.gesture.pinch_zoom_threshold}u
    </#if>
</#if>

<#if mtouch.lowPower.enabled??>
    /* 
     * =======================================================================
     * Low power Parameters
     * =======================================================================
     */
     #define MTOUCH_LOWPOWER_SENSORS                ${mtouch.lowPower.sensorList?size}u
     #define MTOUCH_LOWPOWER_SENSOR_LIST            {<#if mtouch.lowPower.sensorList?size != 0> <#list 0..mtouch.lowPower.sensorList?size-1 as i> ${mtouch.lowPower.sensorList[i]} <#if i != mtouch.lowPower.sensorList?size-1 >, </#if></#list></#if>}
     #define MTOUCH_LOWPOWER_DETECT_THRESHOLD       ${mtouch.lowPower.detectThreshold}u 
     #define MTOUCH_LOWPOWER_SCAN_INTERVAL          ${mtouch.lowPower.measurementPeriod}u   //unit ms
     #define MTOUCH_LOWPOWER_INACTIVE_TIMEOUT       ${mtouch.lowPower.touchInactivityTimeout}u   //unit ms   
     #define MTOUCH_LOWPOWER_BASELINEUPDATE_TIME    ${mtouch.lowPower.baselineUpdatePeriod}u   //unit ms  
</#if>
<#if mtouch.hostInterfaceComms??>
<#if mtouch.hostInterfaceComms.hostInterruptMode??>
<#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
    /* 
     * =======================================================================
     * Host Interface Parameters
     * =======================================================================
     */
    #define Notify_INT_SetLow                       ${mtouch.hostInterfaceComms.hostInterruptPin}_SetLow
    #define Notify_INT_SetHigh                      ${mtouch.hostInterfaceComms.hostInterruptPin}_SetHigh
    #define Notify_INT_PULSE_WIDTH                  ${mtouch.hostInterfaceComms.hostInterruptPulseWidth}
</#if>
</#if>
</#if>

#endif // MTOUCH_CONFIG_H
/**
 End of File
*/
