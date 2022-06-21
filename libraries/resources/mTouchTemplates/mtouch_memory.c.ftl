

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

#include <stdint.h>
#include <stdio.h>
#include <xc.h>
#include "mtouch.h"
#include "../i2c${mtouch.hostInterfaceComms.i2cIndex}_slave.h"
<#if mtouch.hostInterfaceComms.hostInterruptMode??>
<#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
#include "mtouch_config.h"
</#if>
</#if>
/*Local Macros*/


/* Local Variables */
static          uint8_t memoryAddress;
static          bool    startNewPacket;

/* Local Functions */
static void              Touch_Memory_Addr(void);
static void              Touch_Memory_Read(void);
static void              Touch_Memory_Write(void);
<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Touch State")>
static uint8_t           MTOUCH_Memory_getTouchState(uint8_t byteIndex);
</#if>
</#list>
<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
static uint8_t           (*readByteHandler)   (uint8_t address) = NULL;
static void              (*writeByteHandler)  (uint8_t address,uint8_t data) = NULL;
</#if>
</#list>
void MTOUCH_Memory_Initialize(void)
{
    I2C${mtouch.hostInterfaceComms.i2cIndex}_Open();
    I2C${mtouch.hostInterfaceComms.i2cIndex}_SlaveSetWriteIntHandler(Touch_Memory_Read);
    I2C${mtouch.hostInterfaceComms.i2cIndex}_SlaveSetReadIntHandler(Touch_Memory_Write);
    I2C${mtouch.hostInterfaceComms.i2cIndex}_SlaveSetAddrIntHandler(Touch_Memory_Addr);
    <#if mtouch.hostInterfaceComms.isMSSP??>
    SSP${mtouch.hostInterfaceComms.i2cIndex}CON2bits.SEN = 1; /* Enable clock stretching for I2C module */
    </#if>
}

static void Touch_Memory_Addr(void)
{
    I2C${mtouch.hostInterfaceComms.i2cIndex}_SendAck();
    <#if mtouch.hostInterfaceComms.isMSSP??>
    SSP${mtouch.hostInterfaceComms.i2cIndex}BUF;
    </#if>
    startNewPacket = true;
}
static void Touch_Memory_Read(void)
{
    uint8_t temp,output = 0;
    
    if(memoryAddress==TOUCH_RESET_START_ADDR)
    {
        output = (uint8_t)MTOUCH_requestInitGet();
    }
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Touch State")>
    else if((memoryAddress>=TOUCH_STATE_START_ADDR)&&(memoryAddress<=TOUCH_STATE_END_ADDR))
    {
        output = MTOUCH_Memory_getTouchState(memoryAddress-TOUCH_STATE_START_ADDR);
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Slider Status")>
    else if((memoryAddress>=SLIDER_STATUS_START_ADDR)&&(memoryAddress<=SLIDER_STATUS_END_ADDR))
    {
        output = MTOUCH_Slider_Status_Get(memoryAddress-SLIDER_STATUS_START_ADDR);
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Slider Position")>
    else if((memoryAddress>=SLIDER_POSITION_START_ADDR)&&(memoryAddress<=SLIDER_POSITION_END_ADDR))
    {
        output = MTOUCH_Slider_Position_Get(memoryAddress-SLIDER_POSITION_START_ADDR);
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface Status")>
    else if((memoryAddress>=SURFACE_STATUS_START_ADDR)&&(memoryAddress<=SURFACE_STATUS_END_ADDR))
    {
        <#if mtouch.surface.num_contacts == 2>
        output = MTOUCH_Surface_Contact_Status_Get(memoryAddress-SURFACE_STATUS_START_ADDR);
        <#else>
        output = MTOUCH_Surface_Status_Get();
        </#if>
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface H Position 1")>
    else if(memoryAddress==SURFACE_H1_START_ADDR)
    {
        <#if mtouch.surface.num_contacts == 2>
        output = MTOUCH_Surface_Position_Get(0,HORIZONTAL);
        <#else>
        output = MTOUCH_Surface_Position_Get(HORIZONTAL);
        </#if>
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface V Position 1")>
    else if(memoryAddress==SURFACE_V1_START_ADDR)
    {
        <#if mtouch.surface.num_contacts == 2>
        output = MTOUCH_Surface_Position_Get(0,VERTICAL);
        <#else>
        output = MTOUCH_Surface_Position_Get(VERTICAL);
        </#if>
    }
    </#if>
    </#list>
    <#if mtouch.surface.enabled??>
    <#if mtouch.surface.num_contacts == 2>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface H Position 2")>
    else if(memoryAddress==SURFACE_H2_START_ADDR)
    {
        output = MTOUCH_Surface_Position_Get(1,HORIZONTAL);
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface V Position 2")>
    else if(memoryAddress==SURFACE_V2_START_ADDR)
    {
        output = MTOUCH_Surface_Position_Get(1,VERTICAL);
    }
    </#if>
    </#list>
    </#if>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface Gesture State")>
    else if(memoryAddress==SURFACE_GESTURE_STATE_START_ADDR)
    {
        output = MTOUCH_Gesture_isGestureDetected();
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface Gesture ID")>
    else if(memoryAddress==SURFACE_GESTURE_ID_START_ADDR)
    {
        output = MTOUCH_Gesture_GestureID_Get();
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Surface Gesture Value")>
    else if(memoryAddress==SURFACE_GESTURE_VALUE_START_ADDR)
    {
        output = MTOUCH_Gesture_GestureValue_Get();
    }
    </#if>
    </#list>
    </#if>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name=="Touch Deviation">
    else if((memoryAddress >= TOUCH_DEVIATION_START_ADDR) && (memoryAddress <= TOUCH_DEVIATION_END_ADDR))
    {
        <#if mtouch.prox.enabled??>
        if(memoryAddress - TOUCH_DEVIATION_START_ADDR < MTOUCH_PROXIMITY)
        {
            output = MTOUCH_Proximity_Deviation_Get(memoryAddress-TOUCH_DEVIATION_START_ADDR);
        }
        <#if mtouch.button.enabled??>
        else 
        {
            output = MTOUCH_Button_Deviation_Get(memoryAddress - TOUCH_DEVIATION_START_ADDR - MTOUCH_PROXIMITY);
        }
        </#if>
        <#else>
        output = MTOUCH_Button_Deviation_Get(memoryAddress - TOUCH_DEVIATION_START_ADDR);
        </#if>
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Touch Threshold")>
    else if((memoryAddress >= TOUCH_TRESHOLD_START_ADDR) && (memoryAddress <= TOUCH_TRESHOLD_END_ADDR))
    {
        <#if mtouch.prox.enabled??>
        if(memoryAddress - TOUCH_TRESHOLD_START_ADDR < MTOUCH_PROXIMITY)
        {
            output = MTOUCH_Proximity_Threshold_Get(memoryAddress - TOUCH_TRESHOLD_START_ADDR);
        }
        <#if mtouch.button.enabled??>
        else 
        {
            output = MTOUCH_Button_Threshold_Get(memoryAddress - TOUCH_TRESHOLD_START_ADDR - MTOUCH_PROXIMITY);
        }
        </#if>
        <#else>
        output = MTOUCH_Button_Threshold_Get(memoryAddress - TOUCH_TRESHOLD_START_ADDR);
        </#if>
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Deviation Scaling")>
    else if((memoryAddress >= TOUCH_SCALING_START_ADDR) && (memoryAddress <= TOUCH_SCALING_END_ADDR))
    {
        <#if mtouch.prox.enabled??>
        if(memoryAddress - TOUCH_SCALING_START_ADDR < MTOUCH_PROXIMITY)
        {
            output = MTOUCH_Proximity_Scaling_Get(memoryAddress - TOUCH_SCALING_START_ADDR);
        }
        <#if mtouch.button.enabled??>
        else 
        {
            output = MTOUCH_Button_Scaling_Get(memoryAddress - TOUCH_SCALING_START_ADDR - MTOUCH_PROXIMITY);
        }
        </#if>
        <#else>
        output = MTOUCH_Button_Scaling_Get(memoryAddress - TOUCH_SCALING_START_ADDR);
        </#if>
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Touch Reading")>
    else if((memoryAddress >= TOUCH_READING_START_ADDR) && (memoryAddress <= TOUCH_READING_END_ADDR))
    {
        temp = memoryAddress - TOUCH_READING_START_ADDR;
        <#if mtouch.prox.enabled??>
        if((temp>>1) < MTOUCH_PROXIMITY)
        {
            if((temp&0x01) == 0)
            {
                output = (uint8_t)(MTOUCH_Proximity_Reading_Get((temp>>1)));
            }
            else
            {
                output = (uint8_t)(MTOUCH_Proximity_Reading_Get((temp>>1)) >> 8);
            }
        }
        <#if mtouch.button.enabled??>
        else 
        {
            temp = temp - (uint8_t)(MTOUCH_PROXIMITY<<1);
            if((temp&0x01) == 0)
            {
                output = (uint8_t)(MTOUCH_Button_Reading_Get((temp>>1)));
            }
            else
            {
                output = (uint8_t)(MTOUCH_Button_Reading_Get((temp>>1)) >> 8);
            }
        }
        </#if>
        <#else>
        if((temp&0x01) == 0)
        {
            output = (uint8_t)(MTOUCH_Button_Reading_Get((temp>>1)));
        }
        else
        {
            output = (uint8_t)(MTOUCH_Button_Reading_Get((temp>>1)) >> 8);
        }
        </#if>
    
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Touch Baseline")>
    else if((memoryAddress >= TOUCH_BASELINE_START_ADDR) && (memoryAddress <= TOUCH_BASELINE_END_ADDR))
    {
        temp = memoryAddress - TOUCH_BASELINE_START_ADDR;
        <#if mtouch.prox.enabled??>
        if((temp>>1) < MTOUCH_PROXIMITY)
        {
            if((temp&0x01) == 0)
            {
                output = (uint8_t)(MTOUCH_Proximity_Baseline_Get((temp>>1)));
            }
            else
            {
                output = (uint8_t)(MTOUCH_Proximity_Baseline_Get((temp>>1)) >> 8);
            }
        }
        <#if mtouch.button.enabled??>
        else 
        {
            temp = temp - (uint8_t)(MTOUCH_PROXIMITY<<1);
            if((temp&0x01) == 0)
            {
                output = (uint8_t)(MTOUCH_Button_Baseline_Get((temp>>1)));
            }
            else
            {
                output = (uint8_t)(MTOUCH_Button_Baseline_Get((temp>>1)) >> 8);
            }
        }
        </#if>
        <#else>
        if((temp&0x01) == 0)
        {
            output = (uint8_t)(MTOUCH_Button_Baseline_Get((temp>>1)));
        }
        else
        {
            output = (uint8_t)(MTOUCH_Button_Baseline_Get((temp>>1)) >> 8);
        }
        </#if>
    
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Sensor Raw Value")>
    else if((memoryAddress >= SENSOR_RAW_START_ADDR) && (memoryAddress <= SENSOR_RAW_END_ADDR))
    {
        temp = memoryAddress - SENSOR_RAW_START_ADDR;
        
        if((temp&0x01) == 0)
        {
            output = (uint8_t)(MTOUCH_Sensor_RawSample_Get((temp>>1)));
        }
        else
        {
            output = (uint8_t)(MTOUCH_Sensor_RawSample_Get((temp>>1)) >> 8);
        }
    }
    </#if>
    </#list>
    <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
    <#if mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
    else if(memoryAddress >= CUSTOM_FIELD_START_ADDR)
    {
        if(readByteHandler!=NULL)
        {
            output = readByteHandler(memoryAddress-CUSTOM_FIELD_START_ADDR);
        }
    }
    </#if>
    </#list>
    else
    {

    }
    
    memoryAddress++;
    
    I2C${mtouch.hostInterfaceComms.i2cIndex}_Write(output);
}

static void Touch_Memory_Write(void)
{   
    uint8_t value = I2C${mtouch.hostInterfaceComms.i2cIndex}_Read();
    
    if(startNewPacket)
    {
        memoryAddress = value;
        startNewPacket = false;
    }
    else
    {
        if((memoryAddress == TOUCH_RESET_START_ADDR) && (value !=0 ))
        {
            MTOUCH_requestInitSet();
        } 
        <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
        <#if mtouch.hostInterfaceComms.items[i].name?contains("Touch Threshold")>
        else if((memoryAddress >= TOUCH_TRESHOLD_START_ADDR) && (memoryAddress <= TOUCH_TRESHOLD_END_ADDR))
        {
            <#if mtouch.prox.enabled??>
            MTOUCH_Proximity_Threshold_Set(memoryAddress - TOUCH_TRESHOLD_START_ADDR,value);
            <#if mtouch.button.enabled??>
            MTOUCH_Button_Threshold_Set(memoryAddress - TOUCH_TRESHOLD_START_ADDR - MTOUCH_PROXIMITY,value);
            </#if>
            <#else>
            MTOUCH_Button_Threshold_Set(memoryAddress - TOUCH_TRESHOLD_START_ADDR,value);
            </#if>
        }
        </#if>
        </#list>
        <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
        <#if mtouch.hostInterfaceComms.items[i].name?contains("Deviation Scaling")>
        else if((memoryAddress >= TOUCH_SCALING_START_ADDR) && (memoryAddress <= TOUCH_SCALING_END_ADDR))
        {
            <#if mtouch.prox.enabled??>
            MTOUCH_Proximity_Scaling_Set(memoryAddress - TOUCH_SCALING_START_ADDR,value);
            <#if mtouch.button.enabled??>
            MTOUCH_Button_Scaling_Set(memoryAddress - TOUCH_SCALING_START_ADDR - MTOUCH_PROXIMITY,value);
            </#if>
            <#else>
            MTOUCH_Button_Scaling_Set(memoryAddress - TOUCH_SCALING_START_ADDR,value);
            </#if>
        }
        </#if>
        </#list>
        <#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
        <#if mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
        else if(memoryAddress >= CUSTOM_FIELD_START_ADDR)
        {
            if(writeByteHandler!=NULL)
            {
                writeByteHandler(memoryAddress-CUSTOM_FIELD_START_ADDR,value);
            }
        }
        </#if>
        </#list>
        else
        {
 
        }
        
        memoryAddress++;
    }
    I2C${mtouch.hostInterfaceComms.i2cIndex}_SendAck();
}

<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Custom Field")>
void MTOUCH_Memory_i2cSetCustomAddrReadHandler(readHandler handler)
{
    readByteHandler = handler;
}
void MTOUCH_Memory_i2cSetCustomAddrWriteHandler(writeHandler handler)
{
    writeByteHandler = handler;
}
</#if>
</#list>

<#list 0..mtouch.hostInterfaceComms.items?size-1 as i>
<#if mtouch.hostInterfaceComms.items[i].name?contains("Touch State")>
static uint8_t MTOUCH_Memory_getTouchState(uint8_t byteIndex)
{
    <#if mtouch.prox.enabled??>
    uint32_t touchState;
    
    touchState = MTOUCH_Proximity_Proximitymask_Get();
    <#if mtouch.button.enabled??>
    touchState |= (uint32_t)(((uint32_t)MTOUCH_Button_Buttonmask_Get())<< MTOUCH_PROXIMITY);
    </#if>
    <#else>
    mtouch_buttonmask_t touchState;
    
    touchState = MTOUCH_Button_Buttonmask_Get();
    </#if>
    
    return (uint8_t) (touchState >>(byteIndex<<3));
}
</#if>
</#list>

</#if>

<#if mtouch.hostInterfaceComms.hostInterruptMode??>
<#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
void Notify_INT_Host()
{
    Notify_INT_SetLow();
    _delay_us(Notify_INT_PULSE_WIDTH);
    Notify_INT_SetHigh();
}
</#if>
</#if>