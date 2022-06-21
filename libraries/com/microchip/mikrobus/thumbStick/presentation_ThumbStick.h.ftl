/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef EXAMPLE_PRESENTATION_H
#define	EXAMPLE_PRESENTATION_H

//*************************************************************
// Vertical/Horizontal Channel Reference for 12-bit Hex Values
//*************************************************************
<#if (mccUpPosition == "Top") || (mccUpPosition == "Bottom")>
#define VERTICAL    MCP3204_CH0
#define HORIZONTAL  MCP3204_CH1
<#else>
#define VERTICAL    MCP3204_CH1
#define HORIZONTAL  MCP3204_CH0
</#if>

//*************************************************************
// Coordinate Direction Threshold Limit
//*************************************************************
<#if (mccThresholdValue == "10")>
#define stickThreshold      0x080
<#elseif (mccThresholdValue == "20")>
#define stickThreshold      0x160
<#elseif (mccThresholdValue == "30")>
#define stickThreshold      0x240
<#elseif (mccThresholdValue == "40")>
#define stickThreshold      0x320
<#elseif (mccThresholdValue == "50")>
#define stickThreshold      0x400
<#elseif (mccThresholdValue == "60")>
#define stickThreshold      0x480
<#elseif (mccThresholdValue == "70")>
#define stickThreshold      0x560
<#elseif (mccThresholdValue == "80")>
#define stickThreshold      0x640
<#elseif (mccThresholdValue == "90")>
#define stickThreshold      0x720
</#if>
//*************************************************************
// Coordinate Direction Look-up Table
//*************************************************************
<#if ( ((mccHorizontalMode == "Default") && (mccVerticalMode == "Default") && (mccUpPosition == "Top"))
    || ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Bottom")) )>
typedef enum 
{
    stickUpLeft = 0x00, stickUp  = 0x01, stickUpRight  = 0x02,
    stickLeft = 0x10, stickCentered = 0x11, stickRight  = 0x12,
    stickDownLeft = 0x20, stickDown = 0x21, stickDownRight = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Default") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Top"))
    || ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Default") && (mccUpPosition == "Bottom")) )>
typedef enum 
{
    stickDownLeft = 0x00, stickDown  = 0x01, stickDownRight  = 0x02,
    stickLeft = 0x10, stickCentered = 0x11, stickRight  = 0x12,
    stickUpLeft = 0x20, stickUp = 0x21, stickUpRight = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Default") && (mccUpPosition == "Top"))
    || ((mccHorizontalMode == "Default") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Bottom")) )>
typedef enum 
{
    stickUpRight = 0x00, stickUp  = 0x01, stickUpLeft  = 0x02,
    stickRight = 0x10, stickCentered = 0x11, stickLeft  = 0x12,
    stickDownRight = 0x20, stickDown = 0x21, stickDownLeft = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Top"))
    || ((mccHorizontalMode == "Default") && (mccVerticalMode == "Default") && (mccUpPosition == "Bottom")) )>
typedef enum 
{
    stickDownRight = 0x00, stickDown  = 0x01, stickDownLeft  = 0x02,
    stickRight = 0x10, stickCentered = 0x11, stickLeft  = 0x12,
    stickUpRight = 0x20, stickUp = 0x21, stickUpLeft = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Default") && (mccVerticalMode == "Default") && (mccUpPosition == "Left"))
    || ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Right")) )>
typedef enum 
{
    stickUpRight = 0x00, stickRight  = 0x01, stickDownRight  = 0x02,
    stickUp = 0x10, stickCentered = 0x11, stickDown  = 0x12,
    stickUpLeft = 0x20, stickLeft = 0x21, stickDownLeft = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Default") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Left"))
    || ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Default") && (mccUpPosition == "Right")) )>
typedef enum 
{
    stickUpLeft = 0x00, stickLeft  = 0x01, stickDownLeft  = 0x02,
    stickUp = 0x10, stickCentered = 0x11, stickDown  = 0x12,
    stickUpRight = 0x20, stickRight = 0x21, stickDownRight = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Default") && (mccUpPosition == "Left"))
    || ((mccHorizontalMode == "Default") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Right")) )>
typedef enum 
{
    stickDownRight = 0x00, stickRight  = 0x01, stickUpRight  = 0x02,
    stickDown = 0x10, stickCentered = 0x11, stickUp  = 0x12,
    stickDownLeft = 0x20, stickLeft = 0x21, stickUpLeft = 0x22,
}stickCoordinateDirections_t;
<#elseif ( ((mccHorizontalMode == "Mirrored") && (mccVerticalMode == "Mirrored") && (mccUpPosition == "Left"))
    || ((mccHorizontalMode == "Default") && (mccVerticalMode == "Default") && (mccUpPosition == "Right")) )>
typedef enum 
{
    stickDownLeft = 0x00, stickLeft  = 0x01, stickUpLeft  = 0x02,
    stickDown = 0x10, stickCentered = 0x11, stickUp  = 0x12,
    stickDownRight = 0x20, stickRight = 0x21, stickUpRight = 0x22,
}stickCoordinateDirections_t;
</#if>

#endif	/* EXAMPLE_PRESENTATION_H */