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
/*----------------------------------------------------------------------------
  include files
----------------------------------------------------------------------------*/

#include "mtouch_memory_2D.h"

#if (MTOUCH_DEBUG_COMM_ENABLE == 1u)
/* 
 * =======================================================================
 * Macros
 * =======================================================================
 */

#define readByte(baseAddress,offset)  *((uint8_t*) baseAddress +offset)

/* 
 * =======================================================================
 * Local Variables
 * =======================================================================
 */
static uint8_t writeback_req = 0u;

static touchRam_t touchRam = {0};

static coreRam_t coreRam = {ID_MAJOR, ID_MINOR, ID_HI, ID_LO, 0u, (MODE_TOUCH | MODE_GESTURE), 1u, 0u};

static cfgRam_t cfgRam = {
    SURFACE_CS_NUM_SEGMENTS_H, // X
    SURFACE_CS_NUM_SEGMENTS_V, // Y
    0, // oversampling
    0, // X threshold
    0, // Y threshold
<#if mtouch.gesture.enabled??>
    (uint8_t) (DEF_GESTURE_TIME_BASE_MS),
    (uint8_t) (DEF_GESTURE_TIME_BASE_MS >> 8),
    (uint8_t) (DEF_GESTURE_TIME_BASE_MS),
    (uint8_t) (DEF_GESTURE_TIME_BASE_MS >> 8),
<#else>
    0,0,0,0,
</#if>
    (uint8_t) (SURFACE_CS_RESOLUTION)
};
/*
 * =======================================================================
 * LOCAL FUNCTIONS
 * =======================================================================
 */
static inline void Memory_updateCFGRam(void);
static inline void Memory_updateTouchRam(void);

void MTOUCH_Memory_Update(void)
{
    static uint8_t previousSurfaceStatus = 0u;

    if (MTOUCH_Surface_Status_Get() != previousSurfaceStatus)
    {
        SetIRQPin();
        previousSurfaceStatus = MTOUCH_Surface_Status_Get();
    }

    Memory_updateCFGRam();
    Memory_updateTouchRam();
}

static inline void Memory_updateTouchRam(void)
{
    static uint8_t frameCount = 0u;

<#if mtouch.gesture.enabled??>
    touchRam.gestureValue = MTOUCH_Gesture_GestureValue_Get();
    touchRam.gestureID = MTOUCH_Gesture_GestureID_Get();
</#if>
    touchRam.touchStatus = 0x00;

<#if mtouch.gesture.enabled??>
    if (MTOUCH_Gesture_isGestureDetected())
    {
        touchRam.touchStatus |= TOUCHSTATE_GES;
        SetIRQPin();
    }
</#if>

    if (MTOUCH_Surface_Status_Get() & TOUCH_ACTIVE)
    {
<#if mtouch.surface.num_contacts == 2>
        if ((MTOUCH_Surface_Contact_Status_Get(0) & TOUCH_ACTIVE) && (MTOUCH_Surface_Contact_Status_Get(1) & TOUCH_ACTIVE))
            touchRam.touchStatus |= TOUCHSTAT_TCH_DUAL;
        else
            touchRam.touchStatus |= TOUCHSTATE_TCH;
<#else>
        touchRam.touchStatus |= TOUCHSTATE_TCH;
</#if>
        SetIRQPin();
    }
    else
    {
        touchRam.touchStatus &= TOUCHSTATE_nTCH;
    }

    touchRam.touchStatus |= frameCount;
    frameCount += 0x10;

<#if mtouch.surface.num_contacts == 2>    
    /* dual finger touch*/
    if (touchRam.touchStatus & 0x04)
    {
        uint16_t x_position = 
                  (uint16_t) (MTOUCH_Surface_Position_Get(HORIZONTAL, 0u) >> 1u)
                + (uint16_t) (MTOUCH_Surface_Position_Get(HORIZONTAL, 1u) >> 1u);

        uint16_t y_position = 
                  (uint16_t) (MTOUCH_Surface_Position_Get(VERTICAL, 0u) >> 1u)
                + (uint16_t) (MTOUCH_Surface_Position_Get(VERTICAL, 1u) >> 1u);
        touchRam.touchX = (uint8_t) (x_position >> 4u);
        touchRam.touchY = (uint8_t) (y_position >> 4u);
        touchRam.touchLSB = 0;
        touchRam.touchLSB = (uint8_t) ((x_position & 0x000F) << 4u);
        touchRam.touchLSB |= (uint8_t) ((y_position & 0x000F));
    }
    else
    {
        touchRam.touchX = (uint8_t) ((MTOUCH_Surface_Position_Get(HORIZONTAL, 0u) >> 4) & 0x00FF);
        touchRam.touchY = (uint8_t) ((MTOUCH_Surface_Position_Get(VERTICAL, 0u) >> 4) & 0x00FF);
        touchRam.touchLSB = 0u;
        touchRam.touchLSB = (uint8_t) ((MTOUCH_Surface_Position_Get(HORIZONTAL, 0u) & 0x000F) << 4u); /* Append LSB for X */
        touchRam.touchLSB |= (uint8_t) ((MTOUCH_Surface_Position_Get(VERTICAL, 0u) & 0x000F)); /* Append MSB for Y */
    }
<#else>
    touchRam.touchX = (uint8_t) ((MTOUCH_Surface_Position_Get(HORIZONTAL) >> 4) & 0x00FF);
    touchRam.touchY = (uint8_t) ((MTOUCH_Surface_Position_Get(VERTICAL) >> 4) & 0x00FF);
    touchRam.touchLSB = 0u;
    touchRam.touchLSB = (uint8_t) ((MTOUCH_Surface_Position_Get(HORIZONTAL) & 0x000F) << 4u); /* Append LSB for X */
    touchRam.touchLSB |= (uint8_t) ((MTOUCH_Surface_Position_Get(VERTICAL) & 0x000F)); /* Append MSB for Y */
</#if>
}

static void inline Memory_updateCFGRam(void)
{
    uint8_t new_setting;
    uint8_t temp_i_var = 0u;
    static uint8_t initialized = 0u;

    /* CfgRam update */
    if (initialized == 0u)
    {
        cfgRam.oversampling = MTOUCH_Button_Oversampling_Get(SURFACE_CS_START_SEGMENT_H);
        cfgRam.touchThreshX = MTOUCH_Button_Threshold_Get(SURFACE_CS_START_SEGMENT_H);
        cfgRam.touchThreshY = MTOUCH_Button_Threshold_Get(SURFACE_CS_START_SEGMENT_V);
        initialized = 1u;
    }
    else if (0u != writeback_req)
    {
        /* Check if any valid parameters have been written to RAM Buffer */
        new_setting = cfgRam.oversampling;
        if (new_setting != (uint8_t) MTOUCH_Button_Oversampling_Get(SURFACE_CS_START_SEGMENT_H))
        {
            /* Write actual setting back to RAM Buffer */
            cfgRam.oversampling = (uint8_t) (new_setting);

            /* Write oversampling to each node in config */
            for (temp_i_var = 0; temp_i_var < SURFACE_CS_NUM_SEGMENTS_H; temp_i_var++)
            {
                MTOUCH_Button_Oversampling_Set((SURFACE_CS_START_SEGMENT_H + temp_i_var), new_setting);
            }

            for (temp_i_var = 0; temp_i_var < SURFACE_CS_NUM_SEGMENTS_V; temp_i_var++)
            {
                MTOUCH_Button_Oversampling_Set((SURFACE_CS_START_SEGMENT_V + temp_i_var), new_setting);
            }

            /* Only need to Re-initialize the button for new baseline */
            MTOUCH_Button_InitializeAll();
        }

        /* X  Threshold */
        if (cfgRam.touchThreshX != MTOUCH_Button_Threshold_Get(SURFACE_CS_START_SEGMENT_H))
        {
            for (temp_i_var = 0; temp_i_var < SURFACE_CS_NUM_SEGMENTS_H; temp_i_var++)
            {
                MTOUCH_Button_Threshold_Set((SURFACE_CS_START_SEGMENT_H + temp_i_var), cfgRam.touchThreshX);
            }
        }
        /* Y Threshold */
        if (cfgRam.touchThreshY != MTOUCH_Button_Threshold_Get(SURFACE_CS_START_SEGMENT_V))
        {
            for (temp_i_var = 0; temp_i_var < SURFACE_CS_NUM_SEGMENTS_V; temp_i_var++)
            {
                MTOUCH_Button_Threshold_Set((SURFACE_CS_START_SEGMENT_V + temp_i_var), cfgRam.touchThreshY);
            }
        }
        /* Resolution */
        if (cfgRam.resolution != MTOUCH_Surface_Resolution_Get())
        {
            MTOUCH_Surface_Resolution_Set(cfgRam.resolution);
        }

        writeback_req = 0u;
    }

    /* Force re-calibration of the whole system */
    if (coreRam.cmd & 0x01)
    {
        MTOUCH_Button_InitializeAll();
        coreRam.cmd &= 0xFE;
    }
}

uint8_t MTOUCH_Memory_Read(uint8_t mem_map_address)
{
    uint8_t return_this_byte = 0u;

    if (mem_map_address < CORERAM_ADDR_END)
    {
        return_this_byte = readByte(&coreRam,mem_map_address);
    }
    else if ((mem_map_address >= TOUCHRAM_ADDR) && (mem_map_address < TOUCHRAM_ADDR_END))
    {
        return_this_byte = readByte(&touchRam,(mem_map_address-TOUCHRAM_ADDR));
    }
    else if ((mem_map_address >= CFGRAM_ADDR) && (mem_map_address < CFGRAM_ADDR_END))
    {
        return_this_byte = readByte(&cfgRam,(mem_map_address- CFGRAM_ADDR));
    }
<#if mtouch.gesture.enabled??>
    else if ((mem_map_address >= GESTURECFGRAM_ADDR) && (mem_map_address < GESTURECFGRAM_ADDR_END))
    {
        return_this_byte = readByte(MTOUCH_Gesture_GestureConfigAddress_Get() ,(mem_map_address- GESTURECFGRAM_ADDR));
    }
</#if>
    else if ((mem_map_address >= SVRAM_ADDR) && (mem_map_address < SVRAM_ADDR_END))
    {
        mem_map_address -= SVRAM_ADDR;
        if (mem_map_address < SURFACE_CS_NUM_SEGMENTS_H)
            return_this_byte = (uint8_t)MTOUCH_Button_Deviation_Get(mem_map_address + (uint8_t)SURFACE_CS_START_SEGMENT_H);
        else
            return_this_byte = (uint8_t)MTOUCH_Button_Deviation_Get((uint8_t)SURFACE_CS_START_SEGMENT_V + mem_map_address - (uint8_t)SURFACE_CS_NUM_SEGMENTS_H);

        if ((int8_t) return_this_byte < 0)
            return_this_byte = 0;
    }
    else
    {
        /* Address not valid */
    }

    return return_this_byte;
}

uint8_t MTOUCH_Memory_Write(uint8_t mem_map_address, uint8_t data)
{
    uint8_t return_this_byte = 0u;
    uint8_t *data_pointer;

    /* CMD Byte */
    if (mem_map_address == CMD_ADDR)
    {
        data_pointer = (uint8_t*) & coreRam + mem_map_address;
        *data_pointer = data;
    } /* Touch Config - No access to NUM_SEGMENTS_V or NUM_SEGMENTS_H */
    else if ((mem_map_address >= (CFGRAM_ADDR + 2u)) && (mem_map_address < CFGRAM_ADDR_END))
    {
        data_pointer = (uint8_t*) & cfgRam + (mem_map_address - CFGRAM_ADDR);
        *data_pointer = data;
    }
<#if mtouch.gesture.enabled??>
    else if ((mem_map_address >= GESTURECFGRAM_ADDR) && (mem_map_address < GESTURECFGRAM_ADDR_END))
    {
        data_pointer = MTOUCH_Gesture_GestureConfigAddress_Get() + (mem_map_address - GESTURECFGRAM_ADDR);
        *data_pointer = data;
    }
</#if>
    else
    {
        /* Address not valid */
        return_this_byte = 1u;
    }

    if (0u == return_this_byte)
    {
        writeback_req = 1u;
    }

    return return_this_byte;
}

void InitIRQPin(void)
{
}

void SetIRQPin(void)
{
}

void ClearIRQPin(void)
{
}

#endif

