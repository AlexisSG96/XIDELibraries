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

#ifndef __MTOUCH_GESTURE_H__
#define __MTOUCH_GESTURE_H__

/*----------------------------------------------------------------------------
  include files
----------------------------------------------------------------------------*/
#include "../mcc.h"
#include <stdint.h>
#include <string.h>
#include <__null.h>

/* 
 * =======================================================================
 * Gesture Constants
 * =======================================================================
 */
/* Timebase */
#define DEF_GESTURE_TIME_BASE_MS        10u

/* gesture IDs */
#define NO_GESTURE                      0x00u
#define RIGHT_SWIPE                     0x10u
#define RIGHT_SWIPE_HOLD                0x12u
#define RIGHT_EDGE_SWIPE                0x11u
#define RIGHT_EDGE_SWIPE_HOLD           0x13u
#define RIGHT_SWIPE_DUAL                0x14u
#define RIGHT_SWIPE_HOLD_DUAL           0x16u
#define RIGHT_EDGE_SWIPE_DUAL           0x15u
#define RIGHT_EDGE_SWIPE_HOLD_DUAL      0x17u

#define LEFT_SWIPE                      0x20u
#define LEFT_SWIPE_HOLD                 0x22u
#define LEFT_EDGE_SWIPE                 0x21u
#define LEFT_EDGE_SWIPE_HOLD            0x23u
#define LEFT_SWIPE_DUAL                 0x24u
#define LEFT_SWIPE_HOLD_DUAL            0x26u
#define LEFT_EDGE_SWIPE_DUAL            0x25u
#define LEFT_EDGE_SWIPE_HOLD_DUAL       0x27u

#define UP_SWIPE                        0x30u
#define UP_SWIPE_HOLD                   0x32u
#define UP_EDGE_SWIPE                   0x31u
#define UP_EDGE_SWIPE_HOLD              0x33u
#define UP_SWIPE_DUAL                   0x34u
#define UP_SWIPE_HOLD_DUAL              0x36u
#define UP_EDGE_SWIPE_DUAL              0x35u
#define UP_EDGE_SWIPE_HOLD_DUAL         0x37u

#define DOWN_SWIPE                      0x40u
#define DOWN_SWIPE_HOLD                 0x42u
#define DOWN_EDGE_SWIPE                 0x41u
#define DOWN_EDGE_SWIPE_HOLD            0x43u
#define DOWN_SWIPE_DUAL                 0x44u
#define DOWN_SWIPE_HOLD_DUAL            0x46u
#define DOWN_EDGE_SWIPE_DUAL            0x45u
#define DOWN_EDGE_SWIPE_HOLD_DUAL       0x47u

#define HOLD_TAP                        0xd0u
#define HOLD_TAP_DUAL                   0xd4u
#define PRE_TAP                         0x8fu
#define TAP                             0x90u
#define DOUBLE_TAP                      0x92u
#define TAP_DUAL                        0xa0u
#define PALM                            0xb0u

#define PINCH                           0xc0u
#define ZOOM                            0xc1u

#define GESTURE_RELEASED                0xA8u

#define CW_WHEEL                        0xf0u
#define CCW_WHEEL                       0xf1u
#define CW_WHEEL_DUAL                   0xf4u
#define CCW_WHEEL_DUAL                  0xf5u


/* 
 * =======================================================================
 * Gesture Global Prototypes
 * =======================================================================
 */
void        MTOUCH_Gesture_updateTimer(uint16_t time_elapsed_since_update);
void        MTOUCH_Gesture_clearGesture  (void);
bool        MTOUCH_Gesture_isGestureDetected(void);
uint8_t     MTOUCH_Gesture_GestureID_Get(void);
uint8_t     MTOUCH_Gesture_GestureValue_Get(void);
uint8_t*    MTOUCH_Gesture_GestureConfigAddress_Get(void);
void        MTOUCH_Gesture_Initialize (void);
void        MTOUCH_Gesture_Service    (void);

#endif
