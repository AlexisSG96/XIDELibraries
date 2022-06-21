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

#include <stdint.h>
#include "mtouch.h"

/*
*   This file is a quick start example of how to use touch library APIs.
*   The detailed API document can be found at:
*   http://microchipdeveloper.com/touch:mcc-api
*/



/* 
   The touch_example() below shows the usage of the most common APIs for 
   different touch modules.

   The more advanced callback APIs example can be found at:
   http://microchipdeveloper.com/touch:lowcost-mtouch-kit

*/

<#if mtouch.lowPower.enabled??>
static uint8_t myTaskIsDone,myTaskStarted;
</#if>

void touch_example(void)
{
    /*
        The following code will be placed in the while(1) loop in the main.c file
    */
    if(MTOUCH_Service_Mainloop())
    {
        <#if mtouch.button.enabled??>
        /* Button API*/
        if (MTOUCH_Button_isPressed(0))
        {
            /* process if button is pressed */
            /* LED_SetHigh();*/
            
        }
        else
        {
            /* process if button is not pressed */
            /* LED_SetLow();*/
        }
        </#if>

        <#if mtouch.prox.enabled??>
        /* Proximity API*/
        if(MTOUCH_Proximity_isActivated(0))
        {
            // process if proximity is triggered
            /* LED_SetHigh();*/
        }
        else
        {
            // process if button is not triggered
            /* LED_SetLow();*/
        }
        </#if>

        <#if mtouch.slider.enabled??>
        /* Slider/Wheel API*/
        if(MTOUCH_Slider_isPositionChanged(0))
        {
            uint8_t sliderPostion = MTOUCH_Slider_Position_Get(0);
            // process slider position
        }
        </#if>

        <#if mtouch.surface.enabled??>
        /* Surface API */
        <#if mtouch.surface.num_contacts == 2>
        if(MTOUCH_Surface_Contact_Status_Get(0) & TOUCH_ACTIVE) 
        {
            uint16_t HorizontalPosition0 = 
                MTOUCH_Surface_Position_Get(HORIZONTAL,0);
            uint16_t verticalPosition0 = 
                MTOUCH_Surface_Position_Get(VERTICAL,0);
            /* process position information from surface touch point 0 */
        }
        if(MTOUCH_Surface_Contact_Status_Get(1) & TOUCH_ACTIVE) 
        {
            uint16_t HorizontalPosition1 = 
                MTOUCH_Surface_Position_Get(HORIZONTAL,1);
            uint16_t verticalPosition1 = 
                MTOUCH_Surface_Position_Get(VERTICAL,1);
            /* process position information from surface touch point 1 */
        }
        <#else>
        if(MTOUCH_Surface_Status_Get() & TOUCH_ACTIVE) 
        {
            uint16_t HorizontalPosition = 
                MTOUCH_Surface_Position_Get(HORIZONTAL);
            uint16_t verticalPosition = 
                MTOUCH_Surface_Position_Get(VERTICAL);
            /* process position information from surface touch point */
        }
        </#if>
        </#if>

        <#if mtouch.gesture.enabled??>
        /* Surface Gesture API */
        if(MTOUCH_Gesture_isGestureDetected()) /* Is gesture detected ? */
        {
            /* Which gesture is detected ? 
               The gesture IDs can be found in mtouch_gesture.h file
            */
            uint8_t gesture_which_gesture = MTOUCH_Gesture_GestureID_Get();
            /* 
                This value is only applicable to wheel gesture and pinch/zoom
            */
            uint8_t gesture_info = MTOUCH_Gesture_GestureValue_Get();

            /* process the gesture */
        }
        </#if>
    }
    
    
    <#if mtouch.lowPower.enabled??>
    /* The low power handling logic is inside MTOUCH_Service_Mainloop(). 
       
       The library provides the following APIs to enable/disable the low power 
       mode from the mainline code.
       
       Typically, when a time critical task, like communication, is happening,
       the user will disable the low power in order for the fastest response. 
       After the task is done, the system needs to go back to low power mode.
    */
    if(myTaskIsDone)
    {
        MTOUCH_Service_enableLowpower();
        myTaskIsDone = 0;
    }
    else if(myTaskStarted)
    {
        MTOUCH_Service_disableLowpower();
        myTaskStarted = 0;
    }
    else
    {
        /* Keep the current low power state */
    }
    </#if>

}