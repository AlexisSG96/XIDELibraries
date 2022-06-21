/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <stdint.h>
#include "${DELAYFunctions.delayHeader}"
#include "ThumbStick_presentation.h"
#include "ThumbStick_driver.h"

//********************************************
// Define Values used for EXAMPLE
//********************************************
#define stickMaxValue       0xFFF
#define stickCenterValue    0x7FF

//********************************************
// Local (Static) Functions Prototypes
//********************************************
static stickCoordinateDirections_t EXAMPLE_GetDirection(void);
static uint8_t EXAMPLE_CoordinateState(uint16_t);
<#if (mccHorizontalMode == "Mirrored") || (mccVerticalMode == "Mirrored")>
static uint16_t EXAMPLE_MirrorValue (uint16_t);
</#if>

//********************************************
// EXAMPLE Implementation Function
//********************************************
void EXAMPLE_ThumbStick_Implementation(void)            // Call within while(1) loop in Main.c
{
<#if (thumbStickPressPinKey != "")>
    if (! ThumbStick_isPressed())
    {
        printf("Button Press Event!!! \r\n");
    }
</#if>
    // Coordinate Direction Example Implementation
    switch (EXAMPLE_GetDirection())
    {
        case stickUp:
            printf("Up \r\n");
        break;
        case stickDown:
            printf("Down \r\n");
        break;
        case stickLeft:
            printf("Left \r\n");
        break;
        case stickRight:
            printf("Right \r\n");
        break;
        case stickCentered:
            printf("Center \r\n");
        break;
        case stickUpLeft:
            printf("Up-Left \r\n");
        break;
        case stickUpRight:
            printf("Up-Right \r\n");
        break;
        case stickDownLeft:
            printf("Down-Left \r\n");
        break;
        case stickDownRight:
            printf("Down-Right \r\n");
        break;
    }
    // Hex Value Example Implementation
<#if (mccVerticalMode == "Mirrored")>
    printf("\tVertical: %x \r\n", EXAMPLE_MirrorValue(ThumbStick_MCP3402ReadChannel(SINGLE_ENDED, VERTICAL)));
<#else>
    printf("\tVertical: %x \r\n", ThumbStick_MCP3402ReadChannel(SINGLE_ENDED, VERTICAL));
</#if>
<#if (mccHorizontalMode == "Mirrored")>
    printf("\tHorizontal: %x \r\n", EXAMPLE_MirrorValue(ThumbStick_MCP3402ReadChannel(SINGLE_ENDED, HORIZONTAL)));
<#else>
    printf("\tHorizontal: %x \r\n", ThumbStick_MCP3402ReadChannel(SINGLE_ENDED, HORIZONTAL));
</#if>

    ${DELAYFunctions.delayMs}(1000);
}
//********************************************
// EXAMPLE Get Coordinate Direction
//********************************************
static stickCoordinateDirections_t EXAMPLE_GetDirection(void)
{
    stickCoordinateDirections_t coordinateDirection = stickCentered;  

    coordinateDirection = ( (EXAMPLE_CoordinateState(ThumbStick_MCP3402ReadChannel(SINGLE_ENDED, MCP3204_CH0)) << 4) 
                         + EXAMPLE_CoordinateState(ThumbStick_MCP3402ReadChannel(SINGLE_ENDED, MCP3204_CH1)) );
    
    return coordinateDirection;
}
//********************************************
// EXAMPLE Coordinate Direction Handler
//********************************************
static uint8_t EXAMPLE_CoordinateState(uint16_t passedValue)
{
    if (passedValue < (stickCenterValue - stickThreshold) )
    {             
        return 0;           // Left Column  |   Upper Row       
    }             
    else if (passedValue > (stickCenterValue + stickThreshold) )  
    {      
        return 2;           // Right Column |   Bottom Row 
    }
    else                         
    {                                       
        return 1;           // Center Column|   Center Row
    } 
}
<#if (mccHorizontalMode == "Mirrored") || (mccVerticalMode == "Mirrored")>
//********************************************
// EXAMPLE Hex Value Mirror Function
//********************************************
static uint16_t EXAMPLE_MirrorValue (uint16_t passedValue)
{
    return (stickMaxValue - passedValue);
}
</#if>
/**
 End of File
*/
