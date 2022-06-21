
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
<#if mtouch.hostInterfaceComms??>
#ifndef MTOUCH_MEMORY_H
#define	MTOUCH_MEMORY_H

#include "mtouch_config.h"

<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
typedef uint8_t (*readHandler)(uint8_t address);
typedef void    (*writeHandler)(uint8_t address,uint8_t data);
</#if>
</#list>

/*
 * =======================================================================
 *  mTouch virtual memory mapping
 * =======================================================================
 */
<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Touch Reset")>
#define TOUCH_RESET_START_ADDR          ${mtouch.hostInterfaceComms.items[i].address}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Touch State")>
#define TOUCH_STATE_START_ADDR          ${mtouch.hostInterfaceComms.items[i].address}
#define TOUCH_STATE_END_ADDR            ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Slider Status")>
#define SLIDER_STATUS_START_ADDR        ${mtouch.hostInterfaceComms.items[i].address}
#define SLIDER_STATUS_END_ADDR          ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Slider Position")>
#define SLIDER_POSITION_START_ADDR      ${mtouch.hostInterfaceComms.items[i].address}
#define SLIDER_POSITION_END_ADDR        ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Status")>
#define SURFACE_STATUS_START_ADDR       ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_STATUS_END_ADDR         ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Horizontal Position 1")>
#define SURFACE_H1_START_ADDR           ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_H1_END_ADDR             ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Vertical Position 1")>
#define SURFACE_V1_START_ADDR           ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_V1_END_ADDR             ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Horizontal Position 2")>
#define SURFACE_H2_START_ADDR           ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_H2_END_ADDR             ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Vertical Position 2")>
#define SURFACE_V2_START_ADDR           ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_V2_END_ADDR             ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Gesture State")>
#define SURFACE_GESTURE_STATE_START_ADDR  ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_GESTURE_STATE_END_ADDR    ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Gesture ID")>
#define SURFACE_GESTURE_ID_START_ADDR  ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_GESTURE_ID_END_ADDR    ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Surface Gesture Value")>
#define SURFACE_GESTURE_VALUE_START_ADDR  ${mtouch.hostInterfaceComms.items[i].address}
#define SURFACE_GESTURE_VALUE_END_ADDR    ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name=="Touch Deviation">
#define TOUCH_DEVIATION_START_ADDR      ${mtouch.hostInterfaceComms.items[i].address}
#define TOUCH_DEVIATION_END_ADDR        ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Touch Threshold")>
#define TOUCH_TRESHOLD_START_ADDR       ${mtouch.hostInterfaceComms.items[i].address}
#define TOUCH_TRESHOLD_END_ADDR         ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Deviation Scaling")>
#define TOUCH_SCALING_START_ADDR        ${mtouch.hostInterfaceComms.items[i].address}
#define TOUCH_SCALING_END_ADDR          ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Touch Reading")>
#define TOUCH_READING_START_ADDR        ${mtouch.hostInterfaceComms.items[i].address}
#define TOUCH_READING_END_ADDR          ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Touch Baseline")>
#define TOUCH_BASELINE_START_ADDR       ${mtouch.hostInterfaceComms.items[i].address}
#define TOUCH_BASELINE_END_ADDR         ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Sensor Raw Value")>
#define SENSOR_RAW_START_ADDR           ${mtouch.hostInterfaceComms.items[i].address}
#define SENSOR_RAW_END_ADDR             ${mtouch.hostInterfaceComms.items[i].endAddress}

<#elseif mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
#define CUSTOM_FIELD_START_ADDR         ${mtouch.hostInterfaceComms.items[i].address}
</#if>
</#list>

#define DEVICEADDRESS ${mtouch.hostInterfaceComms.deviceAddress}
#define DEVICEADDRESSMASK ${mtouch.hostInterfaceComms.addressMask}
/*
 * =======================================================================
 * Global Functions
 * =======================================================================
 */
void MTOUCH_Memory_Initialize(void);

<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
void MTOUCH_Memory_i2cSetCustomAddrReadHandler(readHandler handler);
void MTOUCH_Memory_i2cSetCustomAddrWriteHandler(writeHandler handler);
</#if>
</#list>

<#if mtouch.hostInterfaceComms.hostInterruptMode??>
<#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
void Notify_INT_Host(void);
</#if>
</#if>

</#if>
#endif	// MTOUCH_MEMORY_H