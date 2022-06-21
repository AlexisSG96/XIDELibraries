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
#ifndef MTOUCH_MEMORY_H
#define MTOUCH_MEMORY_H

#include <stdint.h>
#include "mtouch.h"
#include "mtouch_comm.h"

/* 
 * =======================================================================
 * Global Functions
 * =======================================================================
 */
uint8_t MTOUCH_Memory_Read(uint8_t mem_map_address);
uint8_t MTOUCH_Memory_Write(uint8_t mem_map_address, uint8_t data);
void MTOUCH_Memory_Update(void);

void InitIRQPin(void);
void SetIRQPin(void);
void ClearIRQPin(void);

/* 
 * =======================================================================
 * Touch Memory Address
 * =======================================================================
 */
#define CORERAM_ADDR            0x00            
#define CORERAM_SIZE            8u
#define CORERAM_ADDR_END        (CORERAM_ADDR+CORERAM_SIZE)

<#if mtouch.gesture.enabled??>
#define GESTURECFGRAM_ADDR      0x37
#define GESTURECFGRAM_SIZE      14u
#define GESTURECFGRAM_ADDR_END  (GESTURECFGRAM_ADDR+GESTURECFGRAM_SIZE)
</#if>

#define CFGRAM_ADDR             0x20
#define CFGRAM_SIZE             10u
#define CFGRAM_ADDR_END         (CFGRAM_ADDR+CFGRAM_SIZE)

#define TOUCHRAM_ADDR           0x10
<#if mtouch.gesture.enabled??>
#define TOUCHRAM_SIZE           6u
<#else>
#define TOUCHRAM_SIZE           4u
</#if>
#define TOUCHRAM_ADDR_END       (TOUCHRAM_ADDR+TOUCHRAM_SIZE)

#define SVRAM_ADDR               0x8c
#define SVRAM_SIZE              (SURFACE_CS_NUM_SEGMENTS_V + SURFACE_CS_NUM_SEGMENTS_H)
#define SVRAM_ADDR_END          (SVRAM_ADDR+SVRAM_SIZE)

#define CMD_ADDR                0x04

/* maks for operating modes (used by coreRam.mode) */
#define MODE_STANDBY            0b0000
#define MODE_FULL               0b0011
#define MODE_TOUCH              0x02u
#define MODE_GESTURE            0x01u

#define ID_HI                   0u
#define ID_LO                   0x30

/* bit masks for touch flags (used by touchRam.touchState)*/
#define TOUCHSTATE_TCH          0x01
#define TOUCHSTAT_TCH_DUAL      0x04
#define TOUCHSTATE_nTCH         0xfe
<#if mtouch.gesture.enabled??>
#define TOUCHSTATE_GES          0x02
#define TOUCHSTATE_nGES         0xfd
</#if>
/* 
 * =======================================================================
 * Structure Definitions
 * =======================================================================
 */
typedef struct _CORERAM {
    uint8_t fwMajor;
    uint8_t fwMinor;
    uint8_t appIDhigh;
    uint8_t appIDlow;
    uint8_t cmd;
    uint8_t mode;
    uint8_t modeCon;
    uint8_t powerState;
} coreRam_t;

typedef struct _CFGRAM {
    uint8_t numberOfXChannels;
    uint8_t numberOfYChannels;
    uint8_t oversampling;
    uint8_t touchThreshX;
    uint8_t touchThreshY;
    uint8_t ActivePeriodL;
    uint8_t ActivePeriodH;
    uint8_t IdleperiodL;
    uint8_t IdlePeriodH;
    uint8_t resolution;
} cfgRam_t;

typedef struct _TOUCHRAM {
    uint8_t touchStatus;
    uint8_t touchX;
    uint8_t touchY;
    uint8_t touchLSB;
<#if mtouch.gesture.enabled??>
    uint8_t gestureID;
    uint8_t gestureValue;
</#if>
} touchRam_t;

#endif 
/**
 End of File
 */