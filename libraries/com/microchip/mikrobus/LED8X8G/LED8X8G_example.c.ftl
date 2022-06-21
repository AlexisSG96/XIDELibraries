/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "LED8X8G.h"
#include "MAX7219.h"
#include "${DELAYFunctions.delayHeader}"

static int ballPosX = 1;
static int ballPosY = 1;
static int ballDirX = 1;
static int ballDirY = 1;

// Screen goes from 0 to 7 in x and y (0 indexed)
#define MAX_POSITION 7
#define MIN_POSITION 0

static uint8_t leftPaddleY = 4;
static uint8_t rightPaddleY = 4;


// Set up the display

static void Pong_Display_Initialize() 
{
    LED8X8G_Initialize();
    MAX7219_Write(MAX7219_INTENSITY, 0xA); // Turn up LED intensity
}

// Displays a paddle on row 'row' centered at position 'position'

static void Pong_Display_Paddle(uint8_t row, uint8_t position) 
{

    // Prevent the paddle going off the screen
    if (position < MIN_POSITION + 1) 
    {
        position = MIN_POSITION + 1;
    } 
    else if (position > MAX_POSITION - 1) 
    {
        position = MAX_POSITION - 1;
    }

    // Drawing of the paddle
    uint8_t paddle = 0b111;
    // Shift the paddle to be centered at position 'position'
    paddle = paddle << (position - 1);

    LED8X8G_Row(row, paddle);
}


void Pong_Demo(void) 
{
    Pong_Display_Initialize();
    while (1) 
    {
        // Clear the previous ball
        LED8X8G_Row(ballPosX, 0);

        // Move the ball
        ballPosX += ballDirX;
        ballPosY += ballDirY;

        // If the ball hits anything, have it bounce
        if (ballPosY > MAX_POSITION) 
        {
            ballPosY = MAX_POSITION - 1;
            ballDirY = -1;
        } 
        else if (ballPosY < MIN_POSITION) 
        {
            ballPosY = MIN_POSITION + 1;
            ballDirY = 1;
        }

        if (ballPosX > MAX_POSITION - 1) 
        {
            ballDirX = -1;
            ballPosX = MAX_POSITION - 2;
        } 
        else if (ballPosX < MIN_POSITION + 1) 
        {
            ballPosX = MIN_POSITION + 2;
            ballDirX = 1;
        }

        // Move the paddle the ball is heading towards to intercept it
        if (ballDirX == -1) // Heading to the left
        { 
            if (leftPaddleY < ballPosY) 
            {
                leftPaddleY++;
            } 
            else if (leftPaddleY > ballPosY) 
            {
                leftPaddleY--;
            }
        }
        else if (ballDirX == 1) // Heading to the right
        { 
            if (rightPaddleY < ballPosY) 
            {
                rightPaddleY++;
            } 
            else if (rightPaddleY > ballPosY) 
            {
                rightPaddleY--;
            }
        }
        // Update the screen
        LED8X8G_Row(ballPosX, 1 << ballPosY);
        Pong_Display_Paddle(MIN_POSITION, leftPaddleY);
        Pong_Display_Paddle(MAX_POSITION, rightPaddleY);

        // Speed of animation
        ${DELAYFunctions.delayMs}(125);
    }
}