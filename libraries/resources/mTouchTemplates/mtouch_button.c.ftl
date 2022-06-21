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
#include <xc.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "mtouch.h"
#include "mtouch_button.h"
<#if mtouch.hostInterfaceComms??>
<#if mtouch.hostInterfaceComms.hostInterruptMode??>
<#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
#include "mtouch_memory.h"
</#if>
</#if>
</#if>

#if (MTOUCH_BUTTONS_ENABLE == 1u)
enum mtouch_button_state
{
<#if mtouch.button.debounce_enabled == true>
    MTOUCH_BUTTON_STATE_initializing = 0,
    MTOUCH_BUTTON_STATE_notPressed,
    MTOUCH_BUTTON_STATE_pressDebounce,
    MTOUCH_BUTTON_STATE_pressed,    
    MTOUCH_BUTTON_STATE_releaseDebounce<#if mtouch.button.suspend_mode_enabled == true>,
    MTOUCH_BUTTON_STATE_suspended,
    MTOUCH_BUTTON_STATE_disabled,
</#if>
<#else>
    MTOUCH_BUTTON_STATE_initializing = 0,
    MTOUCH_BUTTON_STATE_notPressed,
    MTOUCH_BUTTON_STATE_pressed<#if mtouch.button.suspend_mode_enabled == true>,
    MTOUCH_BUTTON_STATE_suspended,
    MTOUCH_BUTTON_STATE_disabled
</#if>
</#if>

};

<#if mtouch.button.aks_group_enabled == true>
    enum mtouch_button_aks_group
    {
        No_AKS_Group    = 0,
        AKS_Group_1     = 1,
        AKS_Group_2     = 2,
        AKS_Group_3     = 3,
        AKS_Group_4     = 4,
        AKS_Group_5     = 5,
        AKS_Group_6     = 6,
        AKS_Group_7     = 7,
        Max_AKS_Group   = 8
    };
</#if>

    enum mtouch_button_hysteresis_thresholds
    {
        HYST_50_PERCENT     = 1,
        HYST_25_PERCENT     = 2,
        HYST_12_5_PERCENT   = 3,
        HYST_6_25_PERCENT   = 4,
        HYST_MAX            = 5
    };


/* 
 * =======================================================================
 * Button Type Structure
 * =======================================================================
 */
    typedef struct
    {
        const enum mtouch_button_names      name;
        const enum mtouch_sensor_names      sensor;
        enum mtouch_button_state            state;
        <#if mtouch.button.aks_group_enabled == true>
        enum mtouch_button_aks_group    aks_group;
        </#if>
        mtouch_button_reading_t         reading;
        mtouch_button_baseline_t        baseline;
        mtouch_button_deviation_t       deviation;
        mtouch_button_statecounter_t    counter;
        mtouch_button_baselinecounter_t baseline_count;
        mtouch_button_threshold_t       threshold;
        mtouch_button_scaling_t         scaling;
        <#if mtouch.button.individual_hysteresis_enabled ==true>
        enum mtouch_button_hysteresis_thresholds   hysteresis;
        </#if>
    } mtouch_button_t;

    const mtouch_button_t mtouch_button_init[MTOUCH_BUTTONS] =
    {
    <#list 0..mtouch.button.items?size-1 as i>    /* ${mtouch.button.items[i].name} */
        {   ${mtouch.button.items[i].name}, 
            MTOUCH_BUTTON_SENSOR_${mtouch.button.items[i].name},
            MTOUCH_BUTTON_STATE_initializing,
            <#if mtouch.button.aks_group_enabled == true>
            ${mtouch.button.items[i].aks_group},
            </#if>
            0,0,0,0,0, /* non-const variables */
            (mtouch_button_deviation_t)MTOUCH_BUTTON_THRESHOLD_${mtouch.button.items[i].name}, /* threshold */
            (mtouch_button_scaling_t)MTOUCH_BUTTON_SCALING_${mtouch.button.items[i].name}<#if mtouch.button.individual_hysteresis_enabled == true>, /* scaling */             
            MTOUCH_BUTTON_HYSTERESIS_${mtouch.button.items[i].name}

        <#else> /* scaling */
        </#if>
        }<#if i != mtouch.button.items?size-1>,</#if>
    </#list>};
    
static mtouch_button_t mtouch_button[MTOUCH_BUTTONS];

<#if mtouch.button.reburst_mode == "Reburst Unresolved">
static mtouch_buttonmask_t button_reburst_request;
<#elseif mtouch.button.reburst_mode == "Reburst All">
static bool button_reburst_request;
</#if>
/*
 * =======================================================================
 *  Local Functions
 * =======================================================================
 */
static void                     Button_Service              (enum mtouch_button_names name);  
static void                     Button_Deviation_Update     (mtouch_button_t* button);
static void                     Button_Reading_Update       (mtouch_button_t* button);
static void                     Button_Reading_Update_Helper(mtouch_button_t* button);
static void                     Button_Baseline_Initialize  (mtouch_button_t* button);
static void                     Button_Baseline_Update      (mtouch_button_t* button);
static mtouch_button_reading_t  Button_Baseline_Get_helper  (enum mtouch_button_names button);
<#if mtouch.button.pressTimeout != "0">
static void                     Button_Tick_helper          (mtouch_button_t* button);
</#if>
<#if mtouch.button.interfaceMethod == "0">
static void                     Button_DefaultCallback      (enum mtouch_button_names button);
</#if>

static void                     Button_State_Initializing   (mtouch_button_t* button);
static void                     Button_State_NotPressed     (mtouch_button_t* button);
static void                     Button_State_Pressed        (mtouch_button_t* button);
<#if mtouch.button.debounce_enabled == true>
static void                     Button_State_PressDebounce  (mtouch_button_t* button);
static void                     Button_State_ReleaseDebounce(mtouch_button_t* button);
</#if>
<#if mtouch.button.suspend_mode_enabled == true>
static void                     Button_State_Disabled       (mtouch_button_t* button);
static void                     Button_State_Suspended      (mtouch_button_t* button);
</#if>
<#if mtouch.button.aks_group_enabled == true>
static bool                     Button_Check_AKS_Block      (mtouch_button_t* button);
</#if>

<#if mtouch.button.reburst_mode != "Disabled">
static inline void              Button_Reburst_Request(mtouch_button_t* button);
static inline void              Button_Reburst_Clear(void);
</#if>

<#if mtouch.button.interfaceMethod == "0">
/*
 * =======================================================================
 *  Callback Function Pointers
 * =======================================================================
 */
static void (*callback_pressed)   (enum mtouch_button_names) = Button_DefaultCallback;
static void (*callback_notPressed)(enum mtouch_button_names) = Button_DefaultCallback;
</#if>

/*
 * =======================================================================
 * Button State machine
 * =======================================================================
 */
typedef void (*button_statemachine_state_t)(mtouch_button_t*);
button_statemachine_state_t Button_StateMachine[] = 
{
<#if mtouch.button.debounce_enabled == true>
    Button_State_Initializing,
    Button_State_NotPressed,
    Button_State_PressDebounce,
    Button_State_Pressed,    
    Button_State_ReleaseDebounce<#if mtouch.button.suspend_mode_enabled == true>,
    Button_State_Suspended,
    Button_State_Disabled
</#if>
<#else>
    Button_State_Initializing,
    Button_State_NotPressed,
    Button_State_Pressed<#if mtouch.button.suspend_mode_enabled == true>,
    Button_State_Suspended,
    Button_State_Disabled
</#if>
</#if>

};
#define BUTTON_STATEMACHINE_COUNT (uint8_t)(sizeof(Button_StateMachine)/sizeof(button_statemachine_state_t))

/*
 * =======================================================================
 *  MTOUCH_Button_Initialize
 * =======================================================================
 */
void MTOUCH_Button_Initialize(enum mtouch_button_names name)
{
    mtouch_button_t* button = &mtouch_button[name];

    button->state           = MTOUCH_BUTTON_STATE_initializing;
    button->baseline        = (mtouch_button_baseline_t)0;
    button->counter         = (mtouch_button_statecounter_t)0;
    button->baseline_count  = (mtouch_button_baselinecounter_t)0;
    
    MTOUCH_Sensor_Calibrate(button->sensor);
}

void MTOUCH_Button_InitializeAll(void)
{
    enum mtouch_button_names button;    
    
    memcpy(mtouch_button,mtouch_button_init,sizeof(mtouch_button_init));

    for (button = 0; button < MTOUCH_BUTTONS; button++)
    {
        MTOUCH_Button_Initialize(button);
    }
}

/*
 * =======================================================================
 * Button Service
 * =======================================================================
 */

 void MTOUCH_Button_ServiceAll(void)
{
    enum mtouch_button_names button; 
    
    <#if mtouch.button.reburst_mode == "Reburst All">
    Button_Reburst_Clear();    
    </#if>
    
    for (button = 0; button < MTOUCH_BUTTONS; button++)
    {  
        Button_Service(button);
    }
}
 
static void Button_Service(enum mtouch_button_names name)
{
    mtouch_button_t* button = &mtouch_button[name];
    
    if (MTOUCH_Sensor_wasSampled(button->sensor) && MTOUCH_Sensor_isCalibrated(button->sensor))
    {
        Button_Reading_Update(button);
        Button_Deviation_Update(button);

        if (button->state >= BUTTON_STATEMACHINE_COUNT)
        {
            MTOUCH_Button_Initialize(button->name);
        }
        Button_StateMachine[(uint8_t)button->state](button);
    }
}

static void Button_State_Initializing(mtouch_button_t* button) 
{
    /* Initialize the baseline. */
    if ((button->counter) <= (mtouch_button_statecounter_t)MTOUCH_BUTTON_BASELINE_INIT/2)
    { 
        Button_Baseline_Initialize(button); /* Rough resolution */
    } else { 
        Button_Baseline_Update(button); /* Fine resolution */
    }
    
    /* Exit after a fixed number of baseline updates */
    (button->counter)++;
    if ((button->counter) >= (mtouch_button_statecounter_t)MTOUCH_BUTTON_BASELINE_INIT)
    {
        button->reading = (mtouch_button_reading_t)((button->baseline)>>MTOUCH_BUTTON_BASELINE_GAIN);
        button->state   = MTOUCH_BUTTON_STATE_notPressed;
        button->counter = (mtouch_button_statecounter_t)0;
    }
    
    <#if mtouch.button.reburst_mode != "Disabled">
    Button_Reburst_Request(button);
    </#if>
}
static void Button_State_NotPressed(mtouch_button_t* button)
{
    <#if mtouch.button.negativeDeviation!= "0">
    /* Negative Capacitance check */
    if ((button->deviation) < (mtouch_button_deviation_t)(-button->threshold))
    {
        (button->counter)++;
        if ((button->counter) > (mtouch_button_statecounter_t)MTOUCH_BUTTON_NEGATIVEDEVIATION)
        {
            button->counter = (mtouch_button_statecounter_t)0;
            MTOUCH_Button_Initialize(button->name);
            <#if mtouch.button.reburst_mode != "Disabled">
            Button_Reburst_Request(button);
            </#if>
        }
    }
    </#if>
    /* Threshold check */
    <#if mtouch.button.negativeDeviation!= "0">
    else if ((button->deviation) > (button->threshold))
    <#else>
    if ((button->deviation) > (button->threshold))
    </#if>
    {
        <#if mtouch.button.aks_group_enabled == true>
        if(button->aks_group != No_AKS_Group)
        {
            if(Button_Check_AKS_Block(button))
                return;
        }
        </#if>

        <#if mtouch.button.debounce_enabled == true>
        button->state   = MTOUCH_BUTTON_STATE_pressDebounce;
        button->counter = (mtouch_button_statecounter_t)0;
        <#if mtouch.button.reburst_mode != "Disabled">
        Button_Reburst_Request(button);
        </#if>
        <#else>
        button->state   = MTOUCH_BUTTON_STATE_pressed;
        button->counter = (mtouch_button_statecounter_t)0;
        <#if mtouch.hostInterfaceComms??>
        <#if mtouch.hostInterfaceComms.hostInterruptMode??>
        <#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
        Notify_INT_Host(); // Notify host that button state Changed.
        </#if>
        </#if>
        </#if>
        <#if mtouch.button.interfaceMethod == "0">
        callback_pressed(button->name);
        </#if>
        </#if>    
    }
    else
    {
        /* Delta is positive, but not past the threshold. */
        button->counter = (mtouch_button_statecounter_t)0;
    }
    
    
    /* Baseline Update check */
    <#if mtouch.button.aks_group_enabled == true>
    if(button->aks_group != No_AKS_Group)
    {
        if(Button_Check_AKS_Block(button))
        {
            button->baseline_count = (mtouch_button_baselinecounter_t)
            (MTOUCH_BUTTON_BASECOUNTER_MAX - MTOUCH_BUTTON_BASELINE_HOLD);
            
            return;
        }
    }
    </#if>
    (button->baseline_count)++; 
    if ((button->baseline_count) == MTOUCH_BUTTON_BASELINE_RATE)
    {
        button->baseline_count = (mtouch_button_baselinecounter_t)0;
        Button_Baseline_Update(button);
    }
}

static void Button_State_Pressed(mtouch_button_t* button)
{
    <#if mtouch.button.pressTimeout != "0">
    /* Timeout check */
    if ((button->counter) >= MTOUCH_BUTTON_PRESSTIMEOUT)
    {
        MTOUCH_Button_Initialize(button->name);
        <#if mtouch.button.interfaceMethod == "0">
        callback_notPressed(button->name);
        </#if>
    }
    </#if>
    
    /* Threshold check */
    <#if mtouch.button.pressTimeout != "0">
    <#if mtouch.button.individual_hysteresis_enabled == true>
    else if ((button->deviation) < (mtouch_button_deviation_t)((button->threshold)-((button->threshold) >> button->hysteresis)))
    <#else>
    else if ((button->deviation) < (mtouch_button_deviation_t)((button->threshold)- ((button->threshold) >> MTOUCH_BUTTON_COMMON_HYSTERESIS)))
    </#if>
    <#else>
    <#if mtouch.button.individual_hysteresis_enabled == true>
    if ((button->deviation) < (mtouch_button_deviation_t)((button->threshold)-((button->threshold) >> button->hysteresis)))
    <#else>
    if ((button->deviation) < (mtouch_button_deviation_t)((button->threshold)-((button->threshold) >> MTOUCH_BUTTON_COMMON_HYSTERESIS)))
    </#if>
    </#if>
    {
        <#if mtouch.button.debounce_enabled == true>
        button->state   = MTOUCH_BUTTON_STATE_releaseDebounce;
        button->counter = (mtouch_button_statecounter_t)0;
        <#if mtouch.button.reburst_mode != "Disabled">
        Button_Reburst_Request(button);
        </#if>
        <#else>
        button->state   = MTOUCH_BUTTON_STATE_notPressed;
        button->counter = (mtouch_button_statecounter_t)0;
        button->baseline_count = (mtouch_button_baselinecounter_t)MTOUCH_BUTTON_BASECOUNTER_MAX-MTOUCH_BUTTON_BASELINE_HOLD;
        <#if mtouch.button.interfaceMethod == "0">
        callback_notPressed(button->name);
        </#if>
        </#if>    
    }
}

<#if mtouch.button.debounce_enabled == true>
static void Button_State_PressDebounce  (mtouch_button_t* button)
{
    <#if mtouch.button.aks_group_enabled == true>
    if(button->aks_group != No_AKS_Group)
    {
        if(Button_Check_AKS_Block(button))
        {
            button->state   = MTOUCH_BUTTON_STATE_notPressed;
            button->counter = (mtouch_button_statecounter_t)0;
            return;
        }
    }
    
    </#if>
    
    if((button->deviation) > (button->threshold))
    {
        (button->counter)++;
        if ((button->counter) >= MTOUCH_BUTTON_DEBOUNCE_COUNT)
        {
            button->state   = MTOUCH_BUTTON_STATE_pressed;
            button->counter = (mtouch_button_statecounter_t)0;
            <#if mtouch.button.interfaceMethod == "0">
            <#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
            Notify_INT_Host // Notify host that button state Changed.
            </#if>
            callback_pressed(button->name);
            </#if>
        }
        <#if mtouch.button.reburst_mode != "Disabled">
        Button_Reburst_Request(button);
        </#if>
    }
    else
    {
        button->state   = MTOUCH_BUTTON_STATE_notPressed;
        button->counter = (mtouch_button_statecounter_t)0;
    }
}

static void Button_State_ReleaseDebounce(mtouch_button_t* button)
{
    <#if mtouch.button.individual_hysteresis_enabled == true>
    if ((button->deviation) < (mtouch_button_deviation_t)((button->threshold)-((button->threshold) >> button->hysteresis)))
    <#else>
    if ((button->deviation) < (mtouch_button_deviation_t)((button->threshold)-((button->threshold) >> MTOUCH_BUTTON_COMMON_HYSTERESIS)))
    </#if>
    {
        (button->counter)++;
        if ((button->counter) >= MTOUCH_BUTTON_DEBOUNCE_COUNT)
        {
            button->state   = MTOUCH_BUTTON_STATE_notPressed;
            button->counter = 0;
            button->baseline_count = (mtouch_button_baselinecounter_t)MTOUCH_BUTTON_BASECOUNTER_MAX-MTOUCH_BUTTON_BASELINE_HOLD;
            <#if mtouch.button.interfaceMethod == "0">
            callback_notPressed(button->name);
            </#if>
        }
        <#if mtouch.button.reburst_mode != "Disabled">
        Button_Reburst_Request(button);
        </#if>
    }
    else
    {
        button->state   = MTOUCH_BUTTON_STATE_pressed;
        button->counter = (mtouch_button_statecounter_t)0;
        <#if mtouch.hostInterfaceComms.hostInterruptMode == "Interrupt">
        Notify_INT_Host // Notify host that button state Changed.
        </#if>
    }
}
</#if>
<#if mtouch.button.suspend_mode_enabled == true>
static void Button_State_Suspended(mtouch_button_t* button)
{
    /* Update baseline during Suspend state*/
    Button_Baseline_Update(button);
    button->counter = (mtouch_button_statecounter_t)0;
    
    /* Disable sensor until next baseline update */
    MTOUCH_Sensor_Disable(button->sensor);
}
static void Button_State_Disabled(mtouch_button_t* button)
{}
</#if>
<#if mtouch.button.pressTimeout != "0">
/*
 * =======================================================================
 *  MTOUCH_Button_Tick
 * =======================================================================
 */
void MTOUCH_Button_Tick(void)
{
    <#if mtouch.button.items?size == 1>
    Button_Tick_helper(&mtouch_button[0]);
    <#else>
    uint8_t i;
    for (i = 0; i < MTOUCH_BUTTONS; i++)
    {
        Button_Tick_helper(&mtouch_button[i]);
    }
    </#if>
}
static void Button_Tick_helper(mtouch_button_t* button)
{
    /* Only pressed state counter is based on real time */
    if ((button->state) == MTOUCH_BUTTON_STATE_pressed)
    {
        (button->counter)++;
        if (button->counter == (mtouch_button_statecounter_t)0)
        {
            button->counter = (mtouch_button_statecounter_t)0xFFFF;
        }
    }
    <#if mtouch.button.suspend_mode_enabled == true>
    /* Enable sensor to update baseline in suspend state */
    else if((button->state) == MTOUCH_BUTTON_STATE_suspended)
    {
        (button->counter)++;
        if(button->counter >= MTOUCH_BUTTON_BASELINE_RATE)
        {
            button->counter = (mtouch_button_statecounter_t)0;
            MTOUCH_Sensor_Enable(button->sensor);
        }
    }
    </#if>
}
</#if>

/*
 * =======================================================================
 * Button State and Deviation
 * =======================================================================
 */

mtouch_button_threshold_t MTOUCH_Button_Threshold_Get(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
        return mtouch_button[name].threshold;
    else
        return (mtouch_button_threshold_t)0;
}

void MTOUCH_Button_Threshold_Set(enum mtouch_button_names name,mtouch_button_threshold_t threshold)
{
    if(name < MTOUCH_BUTTONS)
    {
        if(threshold >= MTOUCH_BUTTON_THRESHOLD_MIN && threshold <= MTOUCH_BUTTON_THRESHOLD_MAX)
           mtouch_button[name].threshold = threshold;
    }
}

mtouch_button_scaling_t MTOUCH_Button_Scaling_Get(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
        return mtouch_button[name].scaling;
    else
        return (mtouch_button_scaling_t)0;
}

void MTOUCH_Button_Scaling_Set(enum mtouch_button_names name,mtouch_button_scaling_t scaling)
{
    if(name < MTOUCH_BUTTONS)
    {
        if(scaling <= MTOUCH_BUTTON_SCALING_MAX)
            mtouch_button[name].scaling = scaling;
    }
}

uint8_t MTOUCH_Button_Oversampling_Get(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
        return (uint8_t)MTOUCH_Sensor_Oversampling_Get(mtouch_button[name].sensor);
    else
        return (uint8_t)0;
}

void MTOUCH_Button_Oversampling_Set(enum mtouch_button_names name,uint8_t oversampling)
{
    if(name < MTOUCH_BUTTONS)
    {
        MTOUCH_Sensor_Oversampling_Set(mtouch_button[name].sensor, oversampling);
    }
}

bool MTOUCH_Button_isPressed(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
    <#if mtouch.button.debounce_enabled == true>
        return (bool)((mtouch_button[name].state == MTOUCH_BUTTON_STATE_pressed || mtouch_button[name].state == MTOUCH_BUTTON_STATE_releaseDebounce) ? true : false);
    <#else>
        return (bool)((mtouch_button[name].state == MTOUCH_BUTTON_STATE_pressed) ? true : false);
    </#if>        
    else
        return false;
}

bool MTOUCH_Button_isInitialized(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
        return (bool)((mtouch_button[name].state == MTOUCH_BUTTON_STATE_initializing) ? false : true);
    else
        return false;
}

<#if mtouch.button.suspend_mode_enabled == true>
/*
 * =======================================================================
 *  MTOUCH_Button_ (Suspend / Disable / Resume)
 * =======================================================================
 */
void MTOUCH_Button_Suspend(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
    {
        <#if mtouch.button.interfaceMethod == "0">
        if(mtouch_button[name].state == MTOUCH_BUTTON_STATE_pressed)            
            callback_notPressed(name);
        </#if>

        mtouch_button[name].counter = (mtouch_button_statecounter_t)0;
        mtouch_button[name].state = MTOUCH_BUTTON_STATE_suspended;
        MTOUCH_Sensor_Disable(mtouch_button[name].sensor);
    }
}

void MTOUCH_Button_Disable(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
    {
        <#if mtouch.button.interfaceMethod == "0">
        if(mtouch_button[name].state == MTOUCH_BUTTON_STATE_pressed)
            callback_notPressed(name);
        </#if>

        mtouch_button[name].counter = (mtouch_button_statecounter_t)0;
        mtouch_button[name].state = MTOUCH_BUTTON_STATE_disabled;
        MTOUCH_Sensor_Disable(mtouch_button[name].sensor);
    }
}

void MTOUCH_Button_Resume(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
    {
        if(mtouch_button[name].state == MTOUCH_BUTTON_STATE_suspended)
        {
            mtouch_button[name].state = MTOUCH_BUTTON_STATE_notPressed;
        }
        else if(mtouch_button[name].state == MTOUCH_BUTTON_STATE_disabled) 
        {
            MTOUCH_Button_Initialize(name);
        }
        else
        { }
        MTOUCH_Sensor_Enable(mtouch_button[name].sensor);
    }
}
</#if>

mtouch_button_deviation_t MTOUCH_Button_Deviation_Get(enum mtouch_button_names name) /* Global */
{
    if(name < MTOUCH_BUTTONS)
        return mtouch_button[name].deviation;
    else
        return (mtouch_button_deviation_t)0;
}

static void Button_Deviation_Update(mtouch_button_t* button)
{
    int32_t deviation;
    
    deviation = (int32_t)((int32_t)(button->reading) - (int32_t)((button->baseline)>>MTOUCH_BUTTON_BASELINE_GAIN));

    /* Delta scaling */
    deviation = deviation >> (button->scaling); /* XC8 compiler will extend sign bit of signed values */

    /* Bounds checking */
    if (deviation > MTOUCH_BUTTON_DEVIATION_MAX)
    {
        deviation = MTOUCH_BUTTON_DEVIATION_MAX;
    }
    if (deviation < MTOUCH_BUTTON_DEVIATION_MIN)
    {
        deviation = MTOUCH_BUTTON_DEVIATION_MIN;
    }

    button->deviation = (mtouch_button_deviation_t)deviation;
}

<#if mtouch.button.aks_group_enabled == true>
static mtouch_button_reading_t Button_Unscaled_Deviation_Get(mtouch_button_t* button)
{
    return (mtouch_button_reading_t)(button->reading - (mtouch_button_reading_t)((button->baseline)>>MTOUCH_BUTTON_BASELINE_GAIN));
}
</#if>
mtouch_buttonmask_t MTOUCH_Button_Buttonmask_Get(void)
{
    mtouch_buttonmask_t output = 0;

    for (uint8_t i = 0; i < MTOUCH_BUTTONS; i++)
    {
        if (MTOUCH_Button_isPressed(i) == true)
        {
            output |= (mtouch_buttonmask_t)0x01 << i;
        }
    }
    return output;
}
 
/*
 * =======================================================================
 * Button Reading and Baseline
 * =======================================================================
 */
mtouch_button_reading_t MTOUCH_Button_Reading_Get(enum mtouch_button_names name) /* Global */
{
    if(name < MTOUCH_BUTTONS)
        return mtouch_button[name].reading;
    else
        return (mtouch_button_reading_t)0;
}

static void Button_Reading_Update(mtouch_button_t* button)
{
    if (GIE == (uint8_t) 1)
    {
        GIE = (uint8_t) 0;
        Button_Reading_Update_Helper(button);
        GIE = (uint8_t) 1;
    }
    else
    {
        Button_Reading_Update_Helper(button);
    }
}

static void Button_Reading_Update_Helper(mtouch_button_t* button)
{    
    if (button->state != MTOUCH_BUTTON_STATE_initializing)
    {
        button->reading -= button->reading>>MTOUCH_BUTTON_READING_GAIN;
        button->reading += MTOUCH_Sensor_RawSample_Get(button->sensor) >> MTOUCH_BUTTON_READING_GAIN;
    }
    else
    {
        button->reading = MTOUCH_Sensor_RawSample_Get(button->sensor);
    }
}

static void Button_Baseline_Initialize(mtouch_button_t* button)
{
    button->baseline   = MTOUCH_Sensor_RawSample_Get(button->sensor);
    button->baseline <<= MTOUCH_BUTTON_BASELINE_GAIN;
}

static void Button_Baseline_Update(mtouch_button_t* button)
{
    if (GIE == (uint8_t)1)
    {
        GIE = (uint8_t)0;
        button->baseline -= (button->baseline) >> MTOUCH_BUTTON_BASELINE_GAIN;
        button->baseline += button->reading;
        GIE = (uint8_t)1;
    }
    else
    {
        button->baseline -= (button->baseline) >> MTOUCH_BUTTON_BASELINE_GAIN;
        button->baseline += button->reading;
    }
}

mtouch_button_reading_t MTOUCH_Button_Baseline_Get(enum mtouch_button_names name) /* Global */
{
    if(name < MTOUCH_BUTTONS)
        return Button_Baseline_Get_helper(name);
    else
        return (mtouch_button_reading_t)0;
}

static mtouch_button_reading_t Button_Baseline_Get_helper(enum mtouch_button_names name)
{
    return (mtouch_button_reading_t)((mtouch_button[name].baseline) >> MTOUCH_BUTTON_BASELINE_GAIN);
}

uint8_t MTOUCH_Button_State_Get(enum mtouch_button_names name)
{
    if(name < MTOUCH_BUTTONS)
        return (uint8_t)mtouch_button[name].state;
    else
        return 0;
}

<#if mtouch.lowPower.enabled??>
void MTOUCH_Button_Baseline_ForceUpdate(void)
{
    enum mtouch_button_names button;
    
    for(button = 0;button<MTOUCH_BUTTONS;button++)
    {
        mtouch_button[button].baseline_count = MTOUCH_BUTTON_BASELINE_RATE - 1;
    }

}
</#if>

<#if mtouch.button.aks_group_enabled == true>
/*
 * =======================================================================
 * Button Adjacent Key Suppression
 * =======================================================================
 */
static bool Button_Check_AKS_Block(mtouch_button_t* button)
{
    enum mtouch_button_aks_group currentAKSGroup = button->aks_group;
    int16_t surplus_deviation_this_button,surplus_deviation_check_button;
    mtouch_button_t* check_button;
    
    surplus_deviation_this_button = (int16_t)(Button_Unscaled_Deviation_Get(button) - (mtouch_button_reading_t)button->threshold);
    
    for(check_button = &mtouch_button[0];check_button <= &mtouch_button[MTOUCH_BUTTONS-1];check_button++)
    {
        if(check_button->name == button->name)
        {
            /* Don't check again itself*/
        }
        else
        {
            if(check_button->aks_group == currentAKSGroup)
            {
                if(MTOUCH_Sensor_isEnabled(check_button->name))
                {
                    <#if mtouch.button.debounce_enabled == true>
                        if(check_button->state == MTOUCH_BUTTON_STATE_pressed || check_button->state == MTOUCH_BUTTON_STATE_pressDebounce)  /* block if other button in the same AKS group is pressed */
                            return true;
                    <#else>
                        if(check_button->state == MTOUCH_BUTTON_STATE_pressed)  /* block if other button in the same AKS group is pressed */
                            return true;
                    </#if>
                         else                                                    /* check other sensors surplus deviation */
                            {
                                surplus_deviation_check_button = (int16_t)(Button_Unscaled_Deviation_Get(check_button) - (mtouch_button_reading_t)check_button->threshold);
                                if(surplus_deviation_check_button > 0 && surplus_deviation_check_button > surplus_deviation_this_button)
                                    return true;
                            }
                }
            }
            
        }
    }    
    return false;
}
</#if>

<#if mtouch.button.reburst_mode != "Disabled">
/*
 * =======================================================================
 * Button Reburst
 * =======================================================================
 */

static inline void Button_Reburst_Request(mtouch_button_t* button)
{
    <#if mtouch.button.reburst_mode != "Reburst All">
    button_reburst_request |= (mtouch_buttonmask_t)1 << button->name;
    <#else>
    button_reburst_request = true;
    </#if>
}

static inline void Button_Reburst_Clear(void)
{
    <#if mtouch.button.reburst_mode != "Reburst All">
    button_reburst_request = (mtouch_buttonmask_t)0;
    <#else>
    button_reburst_request = false;
    </#if>
}

void MTOUCH_Button_Reburst_Request(enum mtouch_button_names button)
{
    Button_Reburst_Request(&mtouch_button[button]);
}

bool MTOUCH_Button_Reburst_Service(void)
{
    <#if mtouch.button.reburst_mode == "Reburst Unresolved">
    static  bool                      reburst_resolved = true;
    enum mtouch_button_names          button;
    <#if mtouch.button.aks_group_enabled == true>
    uint8_t                           aks_group_reburst = 0;
    </#if>
    
    
    if(button_reburst_request)
    {    
        /* Disable non-reburst sensor*/
        for(button = MTOUCH_BUTTONS-1; button!=0xFF;button--)
        {
            if((button_reburst_request&(mtouch_buttonmask_t)1<<button)==0)
            {  
                MTOUCH_Sensor_Disable(mtouch_button[button].sensor);
            }
            <#if mtouch.button.aks_group_enabled == true>
            else
            {
                if(mtouch_button[button].aks_group!=No_AKS_Group)
                {
                    aks_group_reburst |= (uint8_t)1<< (mtouch_button[button].aks_group-1);
                }
            }
            </#if>
        }
        <#if mtouch.button.aks_group_enabled == true>
        /* Enable the sensors in the AKS group that requires reburst */
        if(aks_group_reburst)
        {
            for(button = MTOUCH_BUTTONS-1; button!=0xFF;button--)
            {
                if(mtouch_button[button].aks_group!=No_AKS_Group)
                {
                    if((aks_group_reburst&(uint8_t)1<<(mtouch_button[button].aks_group-1))!=0)
                    {  
                        MTOUCH_Sensor_Enable(mtouch_button[button].sensor);
                    }
                }
            }
        
        }
        </#if>
        reburst_resolved = false;
        Button_Reburst_Clear();
    }
    else if(reburst_resolved == false)
    {
        for(button = MTOUCH_BUTTONS-1; button!=0xFF;button--)
        {
            <#if mtouch.button.suspend_mode_enabled == true>
            if(mtouch_button[button].state!=MTOUCH_BUTTON_STATE_disabled || mtouch_button[button].state!=MTOUCH_BUTTON_STATE_suspended)
            {
                MTOUCH_Sensor_Enable(mtouch_button[button].sensor);
            }
            <#else>
                MTOUCH_Sensor_Enable(mtouch_button[button].sensor);
            </#if>
        }
        reburst_resolved = true;
    }
    else
    {
        /* Do nothing if there is no reburst request and the previous reburst request has been resolved */
    }
    
    return !reburst_resolved;
    <#elseif mtouch.button.reburst_mode == "Reburst All">
    return button_reburst_request;
    </#if>
}

</#if>


<#if mtouch.button.interfaceMethod == "0">
/*
 * =======================================================================
 * Button Press/Release Callback Setter Functions
 * =======================================================================
 */
static void Button_DefaultCallback(enum mtouch_button_names button){}

void MTOUCH_Button_SetPressedCallback(void (*callback)(enum mtouch_button_names))
{
    callback_pressed = callback;
}
void MTOUCH_Button_SetNotPressedCallback(void (*callback)(enum mtouch_button_names))
{
    callback_notPressed = callback;
}
</#if>

#endif