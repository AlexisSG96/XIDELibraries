/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "RGB4x4.h"
#include "${DELAYFunctions.delayHeader}"

typedef struct 
{
    RGB4x4_t color;
    uint8_t x;
    uint8_t y;
} RGB4x4_single_t;

static void RGB4x4_SetColor(RGB4x4_single_t *LED, const RGB4x4_t *color);
static void RGB4x4_SetCoordinates(RGB4x4_single_t *LED, uint8_t x, uint8_t y);

static uint8_t RGB4x4_ToInd(uint8_t x, uint8_t y);

static RGB4x4_t LEDS[16];
static RGB4x4_single_t myLED, yourLED;
static const RGB4x4_t BLUE = {0, 0, 50}, RED = {0, 50, 0};

void RGB4x4_Example_Moving(void) 
{
    RGB4x4_SetBuffer(LEDS, 16);
    RGB4x4_SetColor(&myLED, &RED);
    RGB4x4_SetColor(&yourLED, &BLUE);
    
    RGB4x4_SetCoordinates(&myLED, 0, 3);
    RGB4x4_SetCoordinates(&yourLED, 3, 0);
    ${DELAYFunctions.delayMs}(100);
	
    RGB4x4_SetCoordinates(&myLED, 1, 3);
    RGB4x4_SetCoordinates(&yourLED, 3, 1);
    ${DELAYFunctions.delayMs}(100);
	
    RGB4x4_SetCoordinates(&myLED, 1, 2);
    RGB4x4_SetCoordinates(&yourLED, 2, 1);
    ${DELAYFunctions.delayMs}(100);
	
    RGB4x4_SetCoordinates(&myLED, 0, 2);
    RGB4x4_SetCoordinates(&yourLED, 2, 0);
    ${DELAYFunctions.delayMs}(100);
}

static void RGB4x4_SetColor(RGB4x4_single_t *LED, const RGB4x4_t *color) 
{
    LED->color = *color;
    LEDS[RGB4x4_ToInd(LED->x, LED->y)] = LED->color;
    RGB4x4_Update();
}

static void RGB4x4_SetCoordinates(RGB4x4_single_t *LED, uint8_t x, uint8_t y) 
{
    RGB4x4_t color_null = {0, 0, 0};
    
    // Turn off previous LED location
    LEDS[RGB4x4_ToInd(LED->x, LED->y)] = color_null;
    
    // Update new position
    LED->x = x;
    LED->y = y;
    LEDS[RGB4x4_ToInd(LED->x, LED->y)] = LED->color;
    RGB4x4_Update();
}

static uint8_t RGB4x4_ToInd(uint8_t x, uint8_t y) 
{
    // Origin at bottom left, x increases to the right, y increases up
    return x + y * 4U;
}
