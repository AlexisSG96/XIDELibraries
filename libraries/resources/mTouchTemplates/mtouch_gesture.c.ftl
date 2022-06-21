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

/* Include files */
#include "mtouch_gesture.h"
#include "mtouch_button.h"


/* 
 * =======================================================================
 * Gesture Macros
 * =======================================================================
 */
/* returns the magnitude of two values */
#define magnitude(x, y) 	((x)>=(y))?((x)-(y)):((y)-(x))

/* returns the movement direction based on two values */
#define direction(x, y) 	((x)>=(y))?1u:0u

/* returns the absolute value */
#define abval(val)              (((val)<0) ? (-(val)) : (val))

/* 
 * =======================================================================
 * Gesture Enumerations
 * =======================================================================
 */
typedef enum
{
    NO_DIRECTION        = 0xf0u,
    RIGHT               = 0x0u,
    LEFT                = 0x2u,
    UP                  = 0x3u,
    DOWN                = 0x1u,
    UP_RIGHT            = 0x5u,
    UP_LEFT             = 0x6u,
    DOWN_RIGHT          = 0x7u,
    DOWN_LEFT           = 0x8u,
    UP_RIGHT_EXTEND     = 0x9u,
    UP_LEFT_EXTEND      = 0xau,
    DOWN_RIGHT_EXTEND   = 0xbu,
    DOWN_LEFT_EXTEND    = 0xcu
} SWIPE_DIRECTION;

typedef enum
{
    TOUCH_DOWN_EVENT                    = 0x10u,
    TOUCH_UP_EVENT                      = 0x20u,
    TAP_THRESH_EXCEEDED_EVENT           = 0x30u,
  /* SEQ_TAP_DIST_THRESH_EXCEEDED_EVENT  = 0x40u, */
    SWIPE_THRESH_EXCEEDED_EVENT         = 0x50u,
    SWIPE_HOLD_EVENT                    = 0x60u,
  /* SWIPE_HOLD_THRESH_EXCEEDED_EVENT    = 0x70u, */
    TAP_TIMEOUT_EVENT                   = 0x80u,
    TAP_HOLD_TIMEOUT_EVENT              = 0x90u,
    SWIPE_TIMEOUT_EVENT                 = 0xa0u,
    DIRECTION_CHANGE_EVENT              = 0xb0u,
    PINCH_ZOOM_EVENT                    = 0xc0u
} TOUCH_EVENT;


/* 
 * =======================================================================
 * Gesture Static Constants
 * =======================================================================
 */
/* number of gesture patterns to be checked against */
#define PATTERN_NUM                     (sizeof(GESTURE_EVENTS)/sizeof(GESTURE_EVENTS[0u]))

/* touch sensor dimensions (in coordinate resolution)) */
/* #define SENSOR_WIDTH                 (TouchSensor_GetXChannelCount()<<COORD_RESOLUTION) */
/* #define SENSOR_HEIGHT                (TouchSensor_GetYChannelCount()<<COORD_RESOLUTION) */

/* Sensor width and height settings */
#define GESTURE_SURFACE_RESOLUTION_BITS 8u
#define SENSOR_WIDTH                    (1u << GESTURE_SURFACE_RESOLUTION_BITS) /* (256u) */
#define SENSOR_HEIGHT                   (1u << GESTURE_SURFACE_RESOLUTION_BITS) /* (256u) */

/* gesture timer states */ 
#define _OFF                            -1
#define _RESET                          0

/* direction modifiers */
#define RIGHT_MODIFIER                  0x01u
#define LEFT_MODIFIER                   0x02u
#define TOP_MODIFIER                    0x04u
#define BOTTOM_MODIFIER                 0x08u
#define CENTER_MODIFIER                 0x00u
#define NO_STATE                        0xf0u

/* distance tracking status   */
#define STOP                            0x00u
#define INIT                            0x01u
#define PROGRESS                        0X02u

#define TS_NONE   0u
#define TS_DOWN   1u
#define TS_UP     2u
#define TS_STREAM 3u

<#if mtouch.surface.num_contacts == 2>
/* contacts status */
#define TWO_CONTACTS        0x03u
#define FIRST_CONTACT       0x01u
#define SECOND_CONTACT      0x02u
#define NO_CONTACT          0x00u
</#if>

/* 
 * =======================================================================
 * Gesture Variables
 * =======================================================================
 */
int16_t timer;
static uint16_t touchDown[2];
static uint16_t touchStream[2];
static uint16_t touchUp[2];
static uint8_t tapCount;
static uint8_t eventCounter;
static uint32_t eventQueue;
static bool    gestureDetected;
static uint8_t gestureID;
static uint8_t gestureValue;
static uint8_t timeoutTrack;

<#if mtouch.surface.num_contacts == 2>
static uint8_t distanceTrackingStatus;
static uint8_t dualFingerGesture = 0u;
uint8_t const stateTable[4][4] =
{   
    {TS_NONE,    TS_DOWN,     TS_UP,       TS_STREAM  },
    {TS_DOWN,    TS_DOWN,     TS_DOWN,     TS_DOWN    },
    {TS_UP,      TS_DOWN,     TS_UP,       TS_UP      },
    {TS_STREAM,  TS_DOWN,     TS_UP,       TS_STREAM  }
};
</#if>

/* 
 * =======================================================================
 * Gesture Structure Declarations
 * =======================================================================
 */
/* structure of required information that each gesture must
*  contain.
 * 
 *  pattern - the pattern of touch events that make up the gesture
 *  mask - used to mask off certain bits to group events together (e.g. combine center and edge touch down events)
 *  value - the gesture ID returns when the event queue matches that gesture pattern
 *  releaseRequired - flag that tells the firmware to send a release notification for this gesture when a touch is removed
 *  repeatSend - flag that tells the firmware to repeatedly send the gesture ID for this gesture
*/  
typedef struct _GestureItem{
    uint32_t pattern;
    uint32_t mask;
    uint8_t gestureID;
    uint8_t releaseRequired;
    uint8_t repeatSend;
} GestureItem;


typedef struct 
{
    /* Gesture Configuration */
    uint8_t tapReleaseTimeout;
    uint8_t tapHoldTimeout;
    uint8_t swipeTimeout;
    uint8_t xSwipeDistanceThreshold;
    uint8_t ySwipeDistanceThreshold;
    uint8_t edgeSwipeDistanceThreshold;
    uint8_t tapDistanceThreshold;
    uint8_t seqTapDistanceThreshold;
    uint8_t edgeBoundary;
    int8_t wheelPostscaler;
    int8_t wheelStartQuadrantCount;
    int8_t wheelReverseQuadrantCount;
<#if mtouch.surface.num_contacts == 2>
    uint8_t pinchZoomThreshold;
</#if>
}mtouch_gesture_t;

/* 
 * =======================================================================
 * Gesture Structure Definitions
 * =======================================================================
 */
/* ROM array that holds all the supported gesture pattern information */
const GestureItem GESTURE_EVENTS[] =
{
    {0x00002010u, 0xfffffff0u, PRE_TAP, 0u, 0u},    /* this gesture is never actually transmitted, only an intermediate step to the TAP gesture */
    {0x00802010u, 0xfffffff0u, TAP, 0u, 0u},
    {0x80202010u, 0xfffffff0u, TAP, 0u, 0u},        /* dual finger touch might have two touch up events */
    {0x90A08010u, 0xfffffff0u, HOLD_TAP, 1u, 0u},

    {0x20503012u, 0xfffffff2u, RIGHT_EDGE_SWIPE, 0u, 0u},
    {0xA0503012u, 0xfffffff2u, RIGHT_EDGE_SWIPE_HOLD, 1u, 1u},
    {0x20503010u, 0xfffffff0u, RIGHT_SWIPE, 0u, 0u},
    {0xA0503010u, 0xfffffff0u, RIGHT_SWIPE_HOLD, 1u, 1u},

    {0x20523211u, 0xfffffff1u, LEFT_EDGE_SWIPE, 0u, 0u},
    {0xA0523211u, 0xfffffff1u, LEFT_EDGE_SWIPE_HOLD, 1u, 1u},    
    {0x20523210u, 0xfffffff0u, LEFT_SWIPE, 0u, 0u},
    {0xA0523210u, 0xfffffff0u, LEFT_SWIPE_HOLD, 1u, 1u},

    {0x20533318u, 0xfffffff8u, UP_EDGE_SWIPE, 0u, 0u},
    {0xA0533318u, 0xfffffff8u, UP_EDGE_SWIPE_HOLD, 1u, 1u},
    {0x20533310u, 0xfffffff0u, UP_SWIPE, 0u, 0u},
    {0xA0533310u, 0xfffffff0u, UP_SWIPE_HOLD, 1u, 1u},

    {0x20513114u, 0xfffffff4u, DOWN_EDGE_SWIPE, 0u, 0u},
    {0xA0513114u, 0xfffffff4u, DOWN_EDGE_SWIPE_HOLD, 1u, 1u},
    {0x20513110u, 0xfffffff0u, DOWN_SWIPE, 0u, 0u},
    {0xA0513110u, 0xfffffff0u, DOWN_SWIPE_HOLD, 1u, 1u},
};

/* current Gesture Item */
static GestureItem currentGesture;

/* Gesture Initialization */
static mtouch_gesture_t mtouch_gesture = {
    /* Gesture Configuration */
    TAP_RELEASE_TIMEOUT,
    TAP_HOLD_TIMEOUT,
    SWIPE_TIMEOUT,
    HORIZONTAL_SWIPE_DISTANCE_THRESHOLD,
    VERTICAL_SWIPE_DISTANCE_THRESHOLD,
    0u,
    TAP_AREA,
    SEQ_TAP_DIST_THRESHOLD,
    EDGE_BOUNDARY,
    WHEEL_POSTSCALER,
    WHEEL_START_QUADRANT_COUNT,
    WHEEL_REVERSE_QUADRANT_COUNT,
<#if mtouch.surface.num_contacts == 2>
    PINCH_ZOOM_THRESHOLD,
</#if>
};

/* 
 * =======================================================================
 * Gesture Static Prototypes
 * =======================================================================
 */
static uint8_t  appendEvent(TOUCH_EVENT event);
static SWIPE_DIRECTION getSwipeDirection(void);
static void     wheelDetect(TOUCH_EVENT event);
<#if mtouch.surface.num_contacts == 2>
static uint8_t  compare_contact_status(uint8_t contact_status, uint8_t contactIndex);
static void     pinchZoomDetection(uint16_t magX, uint16_t magY);
<#else>
static uint8_t  compare_contact_status(uint8_t contact_status);
</#if>
/* 
 * =======================================================================
 * Gesture Function Definitions
 * =======================================================================
 */

/*
 *========================================================================
 * Check if contact has been touched, released or moved
 * Input  : 0 = Not in detect / 1 = In detect, index of the contacts 0/1
 *========================================================================
 */
<#if mtouch.surface.num_contacts == 2>
static uint8_t compare_contact_status(uint8_t contact_status,uint8_t contactIndex)
{
    static uint8_t last_contact_status[2] = {0u,0u};
    uint8_t return_status = 0u;
	
	if(last_contact_status[contactIndex] == contact_status)
	{
            /* No change -> STREAM or NONE */
            if(0u == contact_status)
            {
                /* No Contact */
                return_status = TS_NONE;
            }
            else
            {
                /* Moved contact */
                return_status = TS_STREAM;	
            }		
	}
	else
	{
            /* Changed */
            if(0u == contact_status)
            {
                /* Released */
                return_status = TS_UP;
            }
            else
            {
                return_status = TS_DOWN;
            }
	}
	last_contact_status[contactIndex] = contact_status;
	return return_status;
}
<#else>
static uint8_t compare_contact_status(uint8_t contact_status)
{
    static uint8_t last_contact_status = 0u;
    uint8_t return_status = 0u;
	
	if(last_contact_status == contact_status)
	{
            /* No change -> STREAM or NONE */
            if(0u == contact_status)
            {
                /* No Contact */
                return_status = TS_NONE;
            }
            else
            {
                /* Moved contact */
                return_status = TS_STREAM;	
            }		
	}
	else
	{
            /* Changed */
            if(0u == contact_status)
            {
                    /* Released */
                    return_status = TS_UP;
            }
            else
            {
                    return_status = TS_DOWN;
            }
	}
	last_contact_status = contact_status;
	return return_status;
}
</#if>


<#if mtouch.surface.num_contacts == 2>
/*
 * =======================================================================
 * Detect the pinch and zoom gesture
 * Input : distance of X and Y axises
 * =======================================================================
 */
static void pinchZoomDetection(uint16_t magX, uint16_t magY)
{
    static uint16_t previousFingerDistance;
    static int8_t  increment;
    uint16_t currentFingerDistance;
    int8_t inc = 0;


    if((distanceTrackingStatus == INIT) || (distanceTrackingStatus ==STOP))
    {
        increment = 0;
        /* previousFingerDistance = isqrt(((uint32_t)magX)*((uint32_t)magX)+((uint32_t)magY)*((uint32_t)magY)); */
        previousFingerDistance = magX+magY;
	    distanceTrackingStatus = PROGRESS;
    }
    else if(distanceTrackingStatus == PROGRESS)
    {
        /* currentFingerDistance = isqrt(((uint32_t)magX)*((uint32_t)magX)+((uint32_t)magY)*((uint32_t)magY)); */
        currentFingerDistance = magX+magY;
        if(currentFingerDistance  > (previousFingerDistance + mtouch_gesture.pinchZoomThreshold)) 
        {
            inc = 1;
        } 
        else if((currentFingerDistance + mtouch_gesture.pinchZoomThreshold) < previousFingerDistance ) 
        { 
            inc = -1;
        }
        else
        {
            /* Do Nothing */
        }

        if(inc)
        {
            increment +=inc;
            previousFingerDistance = currentFingerDistance;
            
            if((int8_t)inc > 0)
            {
                gestureID = ZOOM;
            }
            else
            {
                gestureID = PINCH;
            }
            
            gestureValue = (uint8_t)increment;
        }

    }
    else
    {
      /* Do Nothing */
    }
	
	
}
</#if>
/*
 * =======================================================================
 * Gesture engine processes updated touch info
 * Input : surface
 * =======================================================================
 */
void MTOUCH_Gesture_Service()
{
    static uint8_t lastEvent;               /* most recent gesture event */
    static uint8_t swipeCounter;            /* number of identical swipes in a row that have occurred */
    static uint8_t tapThreshExceeded;       /* has the current touch location exceeded the tap distance threshold from the touch down location? */
    static uint16_t x_position, y_position;
    uint16_t magX, magY;                    /* magnitude of x and y movement */
    uint8_t evt;
<#if mtouch.surface.num_contacts == 2>
    uint8_t touch_current_state[2];
    uint8_t contacts_state;
<#else>
    uint8_t touch_current_state;
</#if>
    SWIPE_DIRECTION dir;

    /* get contacts status */
<#if mtouch.surface.num_contacts == 2>
    touch_current_state[0] = MTOUCH_Surface_Contact_Status_Get(0u);
    touch_current_state[1] = MTOUCH_Surface_Contact_Status_Get(1u);
    touch_current_state[0] &= (uint8_t)0x01u;
    touch_current_state[1] &= (uint8_t)0x01u;
    contacts_state = (uint8_t)(touch_current_state[0] | (uint8_t)(touch_current_state[1]<<1u));

    touch_current_state[0] = compare_contact_status(touch_current_state[0],0u);

    touch_current_state[1] = compare_contact_status(touch_current_state[1],1u);
    
    /* using the state matrix to determine the combined state of the two contacts */
    touch_current_state[0] = stateTable[touch_current_state[0]][touch_current_state[1]];


    /* Once both contacts are active, the gesture engine treat all gesture as dual finger gesture, 
       the flag will only be cleared once the dual gesture is recognized
       or there is no gesture processing at this moment. 
    */
    if(contacts_state == TWO_CONTACTS)
    {
       if(dualFingerGesture == 0u)
       {
          dualFingerGesture = 1u;
          distanceTrackingStatus = INIT;
       }
    } 
    else
    {
        distanceTrackingStatus = STOP;
        if(timer ==_OFF)
        {
            dualFingerGesture = 0u;
        }
    }

    if(dualFingerGesture)
    {
        /* if the gesture engine is processing dual finger gesture, 
            then use the center of mass for gesture processing. 
        */
        x_position = (uint16_t)(MTOUCH_Surface_Position_Get(HORIZONTAL, 0u)>>1u) \
        + (uint16_t)(MTOUCH_Surface_Position_Get(HORIZONTAL, 1u)>>1u);

        y_position = (uint16_t)(MTOUCH_Surface_Position_Get(VERTICAL, 0u)>>1u) \
        + (uint16_t)(MTOUCH_Surface_Position_Get(VERTICAL, 1u)>>1u);

    }
    else if (contacts_state == FIRST_CONTACT)
    {
        x_position = MTOUCH_Surface_Position_Get(HORIZONTAL, 0u);
        y_position = MTOUCH_Surface_Position_Get(VERTICAL, 0u);
    }
    else if (contacts_state == SECOND_CONTACT)
    {
        x_position = MTOUCH_Surface_Position_Get(HORIZONTAL, 1u);
        y_position = MTOUCH_Surface_Position_Get(VERTICAL, 1u);
    }
    else
    {

    }

<#else>

    touch_current_state = MTOUCH_Surface_Status_Get();
    touch_current_state &= (uint8_t)0x01u;
    touch_current_state = compare_contact_status(touch_current_state);

    x_position = MTOUCH_Surface_Position_Get(HORIZONTAL);
    y_position = MTOUCH_Surface_Position_Get(VERTICAL);

</#if>

    /* look at the current touch state to determine which touch events to look for
    several touch events can only occur within certain touch states */
<#if mtouch.surface.num_contacts == 2>
    switch(touch_current_state[0])
<#else>
    switch(touch_current_state)
</#if>
    {
        /* new touch on the sensor */
        case TS_DOWN:
            /* reset registers to start new touch event queue */
            eventCounter = 0u;
            eventQueue = 0u;
            lastEvent = 0u;
            swipeCounter = 0u;                                  
            memset((void*)&currentGesture, 0, sizeof(currentGesture));
            tapThreshExceeded = 0u;

            /* clear the old gesture values reported to the host */
            gestureID = 0u;
            gestureValue = 0u;

            /* save current touch coordinate as a "touch down" */
            touchDown[0u] = x_position;
            touchDown[1u] = y_position;

            evt = TOUCH_DOWN_EVENT;

            /* determine the area of the initial touch (edge vs. center) and append the touch event to the queue */
            if (touchDown[0u] < mtouch_gesture.edgeBoundary) 
            {
                evt |= LEFT_MODIFIER;
            } 

            if (touchDown[0u] > (SENSOR_WIDTH-mtouch_gesture.edgeBoundary)) 
            {
                evt |= RIGHT_MODIFIER;               
            } 

            if (touchDown[1u] < mtouch_gesture.edgeBoundary) 
            {
                evt |= BOTTOM_MODIFIER;          
            } 

            if (touchDown[1u] > (SENSOR_HEIGHT-mtouch_gesture.edgeBoundary)) 
            {              
                evt |= TOP_MODIFIER;                
            } 
            /*
            else 
            {

                evt |= CENTER_MODIFIER;
                lastEvent = appendEvent(TOUCH_DOWN_EVENT|CENTER_MODIFIER);
            }
            */

            lastEvent = appendEvent((TOUCH_EVENT)evt);

         /* check if new touch exceeds the distance threshold from the previous touch up
            this means it is not a sequential tap (e.g. double-tap, triple-tap, etc.) */
            if(tapCount > 0u) 
            {
                magX = magnitude(touchDown[0u], touchUp[0u]);
                magY = magnitude(touchDown[1u], touchUp[1u]);

                if((magX > mtouch_gesture.seqTapDistanceThreshold) || (magY > mtouch_gesture.seqTapDistanceThreshold)) 
                {
                    tapCount = 0u;
                }
            }

            timer = _RESET;            
            break;

       /* touch was just removed from the sensor */
       case TS_UP:
            /* save current coordinate as a "touch up" */
            touchUp[0u] = x_position;
            touchUp[1u] = y_position;

            timeoutTrack = 0u;

         /* send a RELEASED_GESTURE ID if it is required by the gesture
            this is often required by gesture that can be held indefinitely (e.g. TAP HOLD, SWIPE HOLD, etc.) */
            if(currentGesture.releaseRequired){
                gestureID = GESTURE_RELEASED;
            } else {            
                lastEvent = appendEvent(TOUCH_UP_EVENT);
            }

            /* reset current gesture data */
            memset((void*)&currentGesture, 0, sizeof(currentGesture));

            timer = _RESET;
            break;            

        /* active touch on the sensor */
        case TS_STREAM:
<#if mtouch.surface.num_contacts == 2>
            /* pinch and zoom gesture has high priority than the others */
            if(dualFingerGesture)
            {
                pinchZoomDetection
                (
                    magnitude(MTOUCH_Surface_Position_Get(HORIZONTAL, 0) 
                              ,MTOUCH_Surface_Position_Get(HORIZONTAL, 1)),
                    magnitude(MTOUCH_Surface_Position_Get(VERTICAL, 0)  
                              ,MTOUCH_Surface_Position_Get(VERTICAL, 1))
                );

                if(gestureID)
                {
                    lastEvent = appendEvent(PINCH_ZOOM_EVENT);
                }
            }
</#if>

         /* check for and append timeout events
            these events only depend on how long the touch has been applied to the sensor, */
            if((timer >= (int16_t)mtouch_gesture.tapReleaseTimeout) && (!tapThreshExceeded) && ((timeoutTrack & 0x01u) != 0x01u)) 
            {
                lastEvent = appendEvent(TAP_TIMEOUT_EVENT);
                timeoutTrack |= 0x01u;
            } 
            else if((timer >= (int16_t)mtouch_gesture.swipeTimeout) && ((timeoutTrack & 0x02u) != 0x02u)) 
            {
                lastEvent = appendEvent(SWIPE_TIMEOUT_EVENT);
                timeoutTrack |= 0x02u;                                                                  
            } 
            else if((timer >= (int16_t)mtouch_gesture.tapHoldTimeout) && (!tapThreshExceeded) && (timeoutTrack == 0x03u))
            {
                lastEvent = appendEvent(TAP_HOLD_TIMEOUT_EVENT);
                timeoutTrack = 0x00u;    
                timer = _OFF;
            }
            else
            {
              /* Do Nothing */
            }


            /* save current coordinate as "touch stream" */
            touchStream[0u] = x_position;
            touchStream[1u] = y_position;

            /* find absolute distance from the "touch down" coordinates */
            magX = magnitude(touchStream[0u], touchDown[0u]);
            magY = magnitude(touchStream[1u], touchDown[1u]);

            /* check if this distance exceeds the tap threshold and append the event if so */
            if(((magX > mtouch_gesture.tapDistanceThreshold) || (magY > mtouch_gesture.tapDistanceThreshold)) && (!tapThreshExceeded))
            {
             /* get the direction the touch is moving
                NOTE** swipe direction and tap direction are calculated the same so we can reuse the swipe function */
                dir = getSwipeDirection();

                lastEvent = appendEvent((TOUCH_EVENT)(TAP_THRESH_EXCEEDED_EVENT|dir));
                tapThreshExceeded = 1u;
            }

            /* check if this distance exceeded the swipe threshold and append the event if so */
            if(tapThreshExceeded && (timer < (int16_t)mtouch_gesture.swipeTimeout)) {
                if((magX > mtouch_gesture.xSwipeDistanceThreshold) || (magY > mtouch_gesture.ySwipeDistanceThreshold)) {
                    /* get the direction the touch is moving */
                    dir = getSwipeDirection();

                 /* Some long swipes can exceed the swipe threshold several times over and
                    we don't want to append the same event to the queue every time.
                    To account for this, sequential swipe events that are identical are combined into
                    a single event. */                   
                    if (dir != NO_DIRECTION) {                    
                        /* move the queue index back one if the current and previous swipes are the same */
                        if((swipeCounter > 0u) && (lastEvent == (SWIPE_THRESH_EXCEEDED_EVENT|dir))) {
                            eventCounter--;
                            swipeCounter--;
                        }

                        /* append the latest swipe event */
                        lastEvent = appendEvent((TOUCH_EVENT)(SWIPE_THRESH_EXCEEDED_EVENT|dir));
                        swipeCounter++;
                    }

                 /* after a swipe is confirmed, reset the current location as
                    the touch down location. This combined with the above routine that combines
                    identical swipe events allows for variable swipe lengths. */
                    if(timer != _OFF) {
                        timer = _RESET;
                    }

                    touchDown[0u] = x_position;
                    touchDown[1u] = y_position;
                }
            }
            break;

        /* no touch on the sensor */
        case TS_NONE:
            /* check if too much time elapses after a touch up for a sequential tap to occur
            note that the timer will only be running if there was a touch on the sensor so
            this conditional isn't always true; */
            if(timer > (int16_t)mtouch_gesture.tapReleaseTimeout) {
                lastEvent = appendEvent(TAP_TIMEOUT_EVENT);

                tapCount = 0u;
                timer = _OFF;
            }
            break;

        default:
            break;

    }

    /* if the current gesture is required to repeatedly send its value, then do so.
    this is often required by gesture that can be held indefinitely (e.g. TAP HOLD, SWIPE HOLD, etc.) */
    if (currentGesture.repeatSend == 1u) 
    {
        gestureID = currentGesture.gestureID;
    }   

    /* set the status if:
      a.) a gesture was decoded
      b.) a wheel gesture was decoded AND bit zero of the gestureValue register (dirty bit) is set */
    if((gestureID&0xfeu) == 0xf0u) 
    {
        if ((gestureValue&0x01u) == 0x01u ) 
        {
            gestureDetected = true;
        }
    } 
    else if (gestureID) 
    {
        gestureDetected = true;
    }
    else
    {
        /* Do Nothing */
    }
<#if mtouch.surface.num_contacts == 2>
    /* check if the gesture is dual finger gesture */
    if(dualFingerGesture && gestureDetected)
    {   
        if((gestureID != NO_GESTURE) && (gestureID <DOWN_SWIPE_DUAL))
        {   
            gestureID +=0x04u;
        }
        else if((gestureID&0xf0u) == TAP)
        {
            gestureID +=0x10u;
        }
        else if(gestureID == HOLD_TAP)
        {
            gestureID += 0x04u;
        }
        else
        {
          /* Do Nothing */
        }


        if((gestureID&PINCH) !=PINCH)
        {
            dualFingerGesture = 0u;
        }
    }   
</#if>
		
}

/***********************************************************
* Function: 
*   static SWIPE_DIRECTION getSwipeDirection(void)
* 
* Overview: 
*   Calculates the direction of the swipe and reports it
*   as a value from 0 to 3.
* 
*   0 - Right
*   1 - Down
*   2 - Left 
*   3 - Up
***********************************************************/
static SWIPE_DIRECTION getSwipeDirection(void)
{
    int16_t x_dist = (int16_t)touchDown[0] - (int16_t)touchStream[0];
    int16_t y_dist = (int16_t)touchDown[1] - (int16_t)touchStream[1];
    SWIPE_DIRECTION dir = NO_DIRECTION;
    
    if (abval(x_dist) >= abval(y_dist)) {
        if (x_dist > 0) 
		{
            dir = LEFT;
        } 
		else 
		{
            dir = RIGHT;
        }
    } 
	else 
	{
        if (y_dist > 0)
		{
            dir = DOWN;
        }
		else 
		{
            dir = UP;
        }
    }
      
    return dir;
}

/**************************************************************
* Function: 
*   static uint8_t appendEvent(TOUCH_EVENT event)
* 
* Overview: 
*   appends the given event to the queue. 
* 
*   The entire queue is then checked against all gesture
*   patterns in the GESTURE_EVENTS array looking for a match.
* 
*   If there is a match, the gesture ID will be stored in a
*   RAM location the host can read from.
* 
*   After each event is appended, this function also looks for
*   a wheel gesture pattern. The wheel gesture is more complex
*   than other gesture so the the decoding for it is done 
*   separately. 
****************************************************************/
static uint8_t appendEvent(TOUCH_EVENT event)
{
    uint8_t x;
    uint8_t gesture;
    uint32_t temp = event;
    uint8_t *gesture_events;

    /* roll the values like a circular buffer if we hit the size limit of the
    event queue */
    if(eventCounter >= sizeof(uint32_t)) 
	{
        eventCounter--;
        eventQueue >>= 8u;
    }

    /* append the current event */
    eventQueue |= (uint32_t)(temp << (uint8_t)(eventCounter<<3u));

    if(gestureID != 0xf0u)
	{
        /* check if the current event queue matches any patterns in the GESTURE_EVENTS array */
        for(x=0u;x < PATTERN_NUM;x++)
        {
            if((eventQueue&GESTURE_EVENTS[x].mask) == (GESTURE_EVENTS[x].pattern&GESTURE_EVENTS[x].mask)) 
            {
                gesture = GESTURE_EVENTS[x].gestureID;                        

                /* copy the current event pattern (used for checking the repeadSend and releaseRequired bits) */
                gesture_events = (uint8_t*)&GESTURE_EVENTS[x];                
                memcpy((void*)&currentGesture, gesture_events, sizeof(currentGesture));

                /* if the event was a tap then increment the tap counter */
                if(gesture == TAP) 
		{
                    if (tapCount != 0u) 
                    {
                        gestureID = (uint8_t)(gesture | tapCount);
                    }
                } 
		else if (gesture == PRE_TAP) 
		{
                    tapCount++;                    
                } 
		else 
		{
                    /* store the gesture ID */
                    gestureID = gesture;                    
                }                

                break;
            }
        }
    }
<#if mtouch.surface.num_contacts == 2>
    if(!(dualFingerGesture))
    {
        /* check if the events match the wheel pattern */
        wheelDetect(event);
    }
<#else>
    /* check if the events match the wheel pattern */
    wheelDetect(event);   
</#if>
    eventCounter++;
    return event;
}

/**********************************************************
* Function: 
*   static void wheelDetect(TOUCH_EVENT event)
* 
* Overview: 
*   The wheel gesture detection is different from other 
*   gesture in that it doesn't have a single, unique pattern
*   to compare against. Instead it looks for sequential swipe
*   gesture where the swipe direction follows a repeating pattern.
* 
*   Since several swipe events can occur in a single movement we are
*   able to monitor the direction of this movement in real-time. A 
*   clockwise wheel motion will have swipes with directions
*   that follow the repeating pattern of [up, right, down, left, up, right, ...]
*   Counter-clockwise wheels follow this pattern in reverse. So a wheel is
*   decoded by monitoring that the swipe directions follow this pattern.
* 
*   To avoid accidentally mistaking a swipe gesture for wheel
*   movement, the wheel detection requires a certain number of 
*   swipe directions matching the wheel pattern to occur before 
*   it starts outputting the wheel gesture. Once it begins 
*   outputting the wheel gesture, all other gesture detection is
*   suppressed until the touch is removed.
* 
*   There is also a postscaler on the wheel gesture output that
*   allows the user to adjust how frequently the wheel counter
*   will update (e.g. every direction change, every 2 changes, etc.)
* 
**********************************************************/
static void wheelDetect(TOUCH_EVENT event)
{
    static int8_t quadrant_count;
    
    static uint8_t lastEventDir = (uint8_t)NO_STATE;
    static int8_t wheelStart = 0;
    static int8_t wheelDir = 0;
    static int8_t wheelCount = 0;
    static uint8_t wheelOutputCounter = 0u;
    static uint8_t first_time = 1u;
    uint8_t currentEventDir;
    uint8_t comp_val;

    /* confirm that this is a SWIPE event */
    if((event&0xf0u) == SWIPE_THRESH_EXCEEDED_EVENT)
    {
        /* get only the swipe direction */
        currentEventDir = (event&0x03u);     

        if (first_time && (wheelDir == 0) )
		{
            quadrant_count = mtouch_gesture.wheelStartQuadrantCount;
            first_time = 0u;
        }
        
     /* not in wheel mode - watch events to confirm the direction (cw/ccw) and
        count the number of direction changes that occur */
        if(wheelDir == 0) 
		{
            if(currentEventDir == ((lastEventDir+1u)&0x03u)) 
			{ /* direction matches the next element in the clockwise pattern */
                wheelStart++;
                wheelCount = 0;
            } 
			else if(currentEventDir == ((lastEventDir-1u)&0x03u)) 
			{ /* direction matches the next element in the counter-clockwise pattern */
                wheelStart--;
                wheelCount = 0;
            } 
			else if(currentEventDir != lastEventDir) 
			{ /* direction does not match any pattern, reset the counter */
                wheelStart = 0;
            }
            else
            { 
                /* Do Nothing */
             }

            /* enter a wheel mode based on the direction of the events
              the threshold determines the number of direction changes that must be done
              before entering a wheel mode */
                if(wheelStart == quadrant_count) 
				{
                    wheelDir = 1; /* direction is clockwise */
                } 
				else if(wheelStart == -quadrant_count) 
				{
                    wheelDir = -1; /* direction is counter-clockwise */
                }
                                else
                                {
                                  /* Do Nothing */
                 }
        }
        /* in wheel mode - monitor swipe directions to increment the wheel counter */
        if((wheelDir == 1) || (wheelDir == -1)) 
		{
            timer = _OFF;
            /* current event should either :
                a.) match the last event
                b.) be the next event in the cw/ccw pattern
                otherwise it's not a match for the wheel pattern */
            if((currentEventDir == lastEventDir) || (currentEventDir == (((uint8_t)((uint8_t)lastEventDir + (uint8_t)wheelDir))&0x03u))) 
			{
                /* adjust the wheel counter based on the direction of the wheel */
                if(wheelDir == 1) 
				{
                    if(wheelCount < mtouch_gesture.wheelPostscaler) 
					{
                        wheelCount++;
                    }
                } 
				else 
				{
                    if(wheelCount > -mtouch_gesture.wheelPostscaler) 
					{
                        wheelCount--;
                    }
                }
            } 
            else
            {
                wheelDir = 0;
                wheelStart = 0;
                quadrant_count = mtouch_gesture.wheelReverseQuadrantCount;
                timer = _RESET;
            }

            /* output the wheel action if we trip the postscaler */       
            if(wheelCount == mtouch_gesture.wheelPostscaler) 
			{
                gestureID = CW_WHEEL;
                wheelOutputCounter = (wheelOutputCounter+1u) & 0x0fu;
                gestureValue = (uint8_t)(wheelOutputCounter<<4u);
                gestureValue |= (uint8_t)(lastEventDir<<2u);
                comp_val = (wheelDir > 0 ) ? 1u : 0u;
                gestureValue |= (uint8_t)(comp_val<<1u);  
                gestureValue |= 0x01u;
                wheelCount = 0;
            } 
			else if(wheelCount == -mtouch_gesture.wheelPostscaler) 
			{
                gestureID = CCW_WHEEL;
                wheelOutputCounter = (wheelOutputCounter-1u) & 0x0fu;
                gestureValue = (uint8_t)(wheelOutputCounter<<4u);
                gestureValue |= (uint8_t)(lastEventDir<<2u);
                comp_val = (wheelDir > 0 ) ? 1u : 0u;
                gestureValue |= (uint8_t)(comp_val<<1u);
                gestureValue |= 0x01u;
                wheelCount = 0;            
            } 
            else
            {
                /* Do Nothing */
             }
        }
        /* update the previous swipe direction to be the current swipe direction */
        lastEventDir = currentEventDir;
    } 
    else if((event == TOUCH_UP_EVENT) || (event == SWIPE_TIMEOUT_EVENT)) 
    { 
        /* reset if the touch was removed */
        wheelDir = 0;
        wheelStart = 0;
        wheelCount = 0;
        if ((gestureID &0xfeu) == 0xf0u) 
	{
            gestureID = 0u;
        }        
        lastEventDir = NO_STATE;
        wheelOutputCounter = 0u;
    }
    else if ((TOUCH_EVENT)(event &0xf0u) == TOUCH_DOWN_EVENT) 
    {
        first_time = 1u;
    }
    else
    {
        /* Do Nothing */
    }
    
}

/**********************************************************
* Function: 
*   bool MTOUCH_Gesture_isGestureDetected(void)
* 
* Overview: 
*   returns if a gesture is detected or not.
**********************************************************/
bool MTOUCH_Gesture_isGestureDetected(void)
{	
    return gestureDetected;
}

/**********************************************************
* Function: 
*   uint8_t MTOUCH_Gesture_GestureID_Get(void)
* 
* Overview: 
*   returns the current, decoded gesture
**********************************************************/
uint8_t MTOUCH_Gesture_GestureID_Get(void)
{
    return gestureID;
}

/**********************************************************
* Function: 
*   uint8_t MTOUCH_Gesture_GestureValue_Get(void)
* 
* Overview: 
*   returns additional gesture information. Currently this
*   is only used for the counter data wheel performing a 
*   wheel gesture.
**********************************************************/
uint8_t MTOUCH_Gesture_GestureValue_Get(void)
{
    return gestureValue;
}

/**********************************************************
* Function: 
*   void MTOUCH_Gesture_clearGesture()
* 
* Overview: 
*   clears all existing gesture information, and prepare for
*   the next gesture detection.
**********************************************************/
void MTOUCH_Gesture_clearGesture(void)
{
    gestureDetected = false;
    gestureID = 0u;  	
}

/************************************************************************
* Function: 
*   void MTOUCH_Gesture_updateTimer(uint16_t time_elapsed_since_update)
* 
* Overview: 
*   Updates local variable with time period
* Input:
* 	Number of ms since last update
**************************************************************************/
void MTOUCH_Gesture_updateTimer(uint16_t time_elapsed_since_update)
{
    /* Count timer in 10s of ms */
    if(timer >= 0) 
    {
        timer += (int16_t)time_elapsed_since_update;
    }
}

/*****************************************************************
* Function: 
*   void MTOUCH_Gesture_Initialize()
* 
* Overview: 
*   Initialize the Gesture tracking variables
******************************************************************/
void MTOUCH_Gesture_Initialize()
{
    /* Initialize the gesture module */
    tapCount = 0u;
    eventCounter = 0u;
    eventQueue = 0u;
    timer = _OFF;
    timeoutTrack = 0u;
}

/*****************************************************************
* Function: 
*   uint8_t*    MTOUCH_Gesture_GestureConfigAddress_Get(void);
* 
* Overview: 
*   Return the address of the gesture struct vairable.
******************************************************************/
uint8_t* MTOUCH_Gesture_GestureConfigAddress_Get(void)
{
    return (uint8_t*) &mtouch_gesture;
}
