/*
<#include "MicrochipDisclaimer.ftl">
*/
#ifndef THUMBSTICK_DRIVER_H
#define	THUMBSTICK_DRIVER_H

#include <stdint.h>
<#if (thumbStickPressPinKey != "")>
#include <stdbool.h>
</#if>
//********************************************
// Measurement Type
//********************************************
// Single Ended:            Measures with reference to Ground
// Pseudo Differential:     Measures with reference to a different Channel
typedef enum
{
    SINGLE_ENDED = 0x06,
    PSEUDO_DIFFERENTIAL = 0x04,         
}MCP3204_MeasurementTypes_t;
//********************************************
// Available Channels
//********************************************
// Single: Channel 0 | Differential: CH0 = IN+ & CH1 = IN- 
// Single: Channel 1 | Differential: CH0 = IN- & CH1 = IN+ 
// Single: Channel 2 | Differential: CH2 = IN+ & CH3 = IN-
// Single: Channel 3 | Differential: CH2 = IN- & CH3 = IN+
typedef enum
{
    MCP3204_CH0 = 0x00,
    MCP3204_CH1 = 0x40,
    MCP3204_CH2 = 0x80,
    MCP3204_CH3 = 0xC0,
}MCP3204_Channels_t;

//********************************************
// Driver Function Prototypes 
//********************************************
uint16_t ThumbStick_MCP3402ReadChannel(MCP3204_MeasurementTypes_t, MCP3204_Channels_t);
<#if (thumbStickPressPinKey != "")>
bool ThumbStick_isPressed(void);
</#if> 
        
#endif	/* THUMBSTICK_DRIVER_H */