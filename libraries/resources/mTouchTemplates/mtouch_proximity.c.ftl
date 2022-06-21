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
#include <string.h>

#include "mtouch.h"
#include "mtouch_proximity.h"

#if (MTOUCH_PROXIMITY_ENABLE == 1u)

enum mtouch_prox_state
{
<#if mtouch.prox.debounce_enabled == true>
    MTOUCH_PROXIMITY_STATE_initializing = 0,
    MTOUCH_PROXIMITY_STATE_notActivated,
    MTOUCH_PROXIMITY_STATE_activatedDebounce,
    MTOUCH_PROXIMITY_STATE_activated,
    MTOUCH_PROXIMITY_STATE_notActivatedDebounce<#if mtouch.prox.suspend_mode_enabled == true>,
    MTOUCH_PROXIMITY_STATE_suspended,
    MTOUCH_PROXIMITY_STATE_disabled
</#if>
<#else>
    MTOUCH_PROXIMITY_STATE_initializing = 0,
    MTOUCH_PROXIMITY_STATE_notActivated,
    MTOUCH_PROXIMITY_STATE_activated<#if mtouch.prox.suspend_mode_enabled == true>,
    MTOUCH_PROXIMITY_STATE_suspended,
    MTOUCH_PROXIMITY_STATE_disabled
</#if>
</#if>    

};
<#if mtouch.prox.aks_group_enabled == true>
enum mtouch_prox_aks_group
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

 enum mtouch_proximity_hysteresis_thresholds
    {
        HYST_50_PERCENT     = 1,
        HYST_25_PERCENT     = 2,
        HYST_12_5_PERCENT   = 3,
        HYST_6_25_PERCENT   = 4,
        HYST_MAX            = 5
    };

    
   
/* 
 * =======================================================================
 * Proximity Type Structure
 * =======================================================================
 */
    typedef struct
    {
        const uint8_t                   name;
        const enum mtouch_sensor_names  sensor;
        enum mtouch_prox_state          state;
        <#if mtouch.prox.aks_group_enabled == true>
        enum mtouch_prox_aks_group      aks_group;
        </#if>
        mtouch_prox_reading_t           reading;
        mtouch_prox_baseline_t          baseline;
        mtouch_prox_deviation_t         integratedDeviation;
        mtouch_prox_statecounter_t      counter;
        mtouch_prox_baselinecounter_t   baseline_count;
        mtouch_prox_deviation_t         threshold;
        mtouch_prox_scaling_t           scaling;
        <#if mtouch.prox.individual_hysteresis_enabled ==true>
        enum mtouch_proximity_hysteresis_thresholds   hysteresis;
        </#if>
    } mtouch_proximity_t;
 
    const mtouch_proximity_t mtouch_proximity_init[MTOUCH_PROXIMITY] =
    {
    <#list 0..mtouch.prox.items?size-1 as i>    /* ${mtouch.prox.items[i].name} */
        {   ${mtouch.prox.items[i].name}, 
            ${mtouch.prox.items[i].sensor},
            MTOUCH_PROXIMITY_STATE_initializing,
            <#if mtouch.prox.aks_group_enabled == true>
            ${mtouch.prox.items[i].aks_group},
            </#if>            
            0,0,0,0,0, /* non-const variables */
            (mtouch_prox_deviation_t)MTOUCH_PROXIMITY_THRESHOLD_${mtouch.prox.items[i].name}, /* threshold */           
            (uint8_t)MTOUCH_PROXIMITY_SCALING_${mtouch.prox.items[i].name}<#if mtouch.prox.individual_hysteresis_enabled == true>, /* scaling */
            MTOUCH_PROXIMITY_HYSTERESIS_${mtouch.prox.items[i].name}
        <#else> /* scaling */
        </#if>
        }<#if i != mtouch.prox.items?size-1>,</#if>
    </#list>};
    
    static mtouch_proximity_t mtouch_proximity[MTOUCH_PROXIMITY];
    
    <#if mtouch.prox.reburst_mode == "Reburst Unresolved">
    static mtouch_proxmask_t proximity_reburst_request;
    <#elseif mtouch.prox.reburst_mode == "Reburst All">
    static bool proximity_reburst_request;
    </#if>

/*
 * =======================================================================
 *  Local Functions
 * =======================================================================
 */
static void                     Proximity_Service               (enum mtouch_proximity_names name);
static void                     Proximity_Deviation_Update      (enum mtouch_proximity_names prox);
static void                     Proximity_Reading_Update        (mtouch_proximity_t* prox);
<#if mtouch.prox.medianfilterEnabled != "true" >
static void                     Proximity_Reading_Update_Helper (mtouch_proximity_t* prox);
</#if>
static void                     Proximity_Baseline_Initialize   (mtouch_proximity_t* prox);
static void                     Proximity_Baseline_Update       (mtouch_proximity_t* prox);
static mtouch_prox_reading_t    Proximity_Baseline_Get_helper   (enum mtouch_proximity_names prox);
<#if mtouch.prox.aks_group_enabled == true>
static bool                     Proximity_Check_AKS_Block       (mtouch_proximity_t* prox);
</#if>
<#if mtouch.prox.activityTimeout != "0">
static void                     Proximity_Tick_helper           (mtouch_proximity_t* prox);
</#if>
<#if mtouch.prox.interfaceMethod == "0">
static void                     Proximity_DefaultCallback       (enum mtouch_proximity_names prox);
</#if>
static void                     Proximity_State_Initializing    (mtouch_proximity_t* prox);
static void                     Proximity_State_NotActivated    (mtouch_proximity_t* prox);
static void                     Proximity_State_Activated       (mtouch_proximity_t* prox);
<#if mtouch.prox.debounce_enabled == true>
static void                     Proximity_State_NotActivatedDebounce    (mtouch_proximity_t* prox);
static void                     Proximity_State_ActivatedDebounce       (mtouch_proximity_t* prox);
</#if>
<#if mtouch.prox.medianfilterEnabled == "true" >
static mtouch_prox_reading_t median_filter(enum mtouch_proximity_names prox,mtouch_prox_reading_t new_data);
</#if>
<#if mtouch.prox.suspend_mode_enabled == true>
static void                     Proximity_State_Disabled       (mtouch_proximity_t* prox);
static void                     Proximity_State_Suspended      (mtouch_proximity_t* prox);
</#if>
<#if mtouch.prox.reburst_mode != "Disabled">
static inline void              Proximity_Reburst_Request(mtouch_proximity_t* prox);
static inline void              Proximity_Reburst_Clear(void);
</#if>

<#if mtouch.prox.interfaceMethod == "0">
/*
 * =======================================================================
 *  Callback Function Pointers
 * =======================================================================
 */
static void (*callback_activated)   (enum mtouch_proximity_names) = Proximity_DefaultCallback;
static void (*callback_notActivated)(enum mtouch_proximity_names) = Proximity_DefaultCallback;
</#if>

<#if mtouch.prox.medianfilterEnabled == "true" >
/*
 * =======================================================================
 *  Meidan Filter
 * =======================================================================
 */
#define MTOUCH_MEDIAN_FILTER_TAP        ${mtouch.prox.MedianFiltersWindow}
 
static uint8_t                  tap_index[MTOUCH_PROXIMITY][MTOUCH_MEDIAN_FILTER_TAP];
static mtouch_prox_reading_t    filter_data[MTOUCH_PROXIMITY][MTOUCH_MEDIAN_FILTER_TAP];
</#if>

/*
 * =======================================================================
 * Proximity Statemachine
 * =======================================================================
 */
typedef void (*proximity_statemachine_state_t)(mtouch_proximity_t*);
proximity_statemachine_state_t Proximity_StateMachine[] = 
{
<#if mtouch.prox.debounce_enabled == true>
    Proximity_State_Initializing,
    Proximity_State_NotActivated,
    Proximity_State_ActivatedDebounce,    
    Proximity_State_Activated,
    Proximity_State_NotActivatedDebounce<#if mtouch.prox.suspend_mode_enabled == true>,
    Proximity_State_Suspended,
    Proximity_State_Disabled
</#if>
<#else>
    Proximity_State_Initializing,
    Proximity_State_NotActivated,
    Proximity_State_Activated<#if mtouch.prox.suspend_mode_enabled == true>,
    Proximity_State_Suspended,
    Proximity_State_Disabled
</#if>
</#if>

};
#define PROXIMITY_STATEMACHINE_COUNT (uint8_t)(sizeof(Proximity_StateMachine)/sizeof(proximity_statemachine_state_t))

/*
 * =======================================================================
 *  MTOUCH_Proximity_Initialize
 * =======================================================================
 */
void MTOUCH_Proximity_Initialize(enum mtouch_proximity_names name)
{
    mtouch_proximity_t* prox = &mtouch_proximity[name];
    
    prox->state           = MTOUCH_PROXIMITY_STATE_initializing;
    prox->baseline        = (mtouch_prox_baseline_t)0;
    prox->counter         = (mtouch_prox_statecounter_t)0;
    prox->baseline_count  = (mtouch_prox_baselinecounter_t)0;
    prox->integratedDeviation = (mtouch_prox_deviation_t)0;
    <#if mtouch.prox.medianfilterEnabled == "true">
    /*Initialize Median filter*/
    for (uint8_t i=0;i < MTOUCH_MEDIAN_FILTER_TAP;i++)
    {
        tap_index[name][i]=i;
        filter_data[name][i] = 0;
    }
    </#if>
}

void MTOUCH_Proximity_Recalibrate(void)
{
    uint8_t i;
    for (i = 0; i < MTOUCH_PROXIMITY; i++)
    {
        MTOUCH_Proximity_Initialize(i);
    }
}

void MTOUCH_Proximity_InitializeAll(void)
{
    memcpy(mtouch_proximity,mtouch_proximity_init,sizeof(mtouch_proximity_init));
    
    <#if mtouch.prox.items?size == 1>
    MTOUCH_Proximity_Initialize(${mtouch.prox.items[0].name});
    <#else>
    enum mtouch_proximity_names proximity;
    memcpy(mtouch_proximity,mtouch_proximity_init,sizeof(mtouch_proximity_init));    
    for (proximity = 0; proximity < MTOUCH_PROXIMITY; proximity++)
    {  
        MTOUCH_Proximity_Initialize(proximity);
    }
    </#if>
}

void MTOUCH_Proximity_ServiceAll(void)
{
    <#if mtouch.prox.reburst_mode == "Reburst All">
    Proximity_Reburst_Clear();    
    </#if>

    <#if mtouch.prox.items?size == 1>
    Proximity_Service(${mtouch.prox.items[0].name});
    <#else>
    enum mtouch_proximity_names proximity;
    for (proximity = 0; proximity < MTOUCH_PROXIMITY; proximity++)
    {  
        Proximity_Service(proximity);
    }
    </#if>
}

/*
 * =======================================================================
 * Proximity Service
 * =======================================================================
 */
static void Proximity_Service(enum mtouch_proximity_names name)
{
    mtouch_proximity_t* prox = &mtouch_proximity[name];
        
    if (MTOUCH_Sensor_wasSampled(prox->sensor) && MTOUCH_Sensor_isCalibrated(prox->sensor))
    {
        Proximity_Reading_Update(prox);
        Proximity_Deviation_Update(name);

        if (prox->state >= PROXIMITY_STATEMACHINE_COUNT)
        {
            MTOUCH_Proximity_Initialize(prox->name);
        }
        Proximity_StateMachine[prox->state](prox);
    }
}
static void Proximity_State_Initializing(mtouch_proximity_t* prox)
{
    /* Initialize the baseline. */
    if ((prox->counter) <= (mtouch_prox_statecounter_t)MTOUCH_PROXIMITY_BASELINE_INIT/2)
    { 
        Proximity_Baseline_Initialize(prox); /* Rough resolution */
    } else { 
        Proximity_Baseline_Update(prox); /* Fine resolution */
    }
    
    /* Exit after a fixed number of baseline updates */
    (prox->counter)++;
    if ((prox->counter) >= (mtouch_prox_statecounter_t)MTOUCH_PROXIMITY_BASELINE_INIT)
    {
        prox->state   = MTOUCH_PROXIMITY_STATE_notActivated;
        prox->counter = (mtouch_prox_statecounter_t)0;
    }
    
    <#if mtouch.prox.reburst_mode != "Disabled">
    Proximity_Reburst_Request(prox);
    </#if>
} 
static void Proximity_State_NotActivated(mtouch_proximity_t* prox)
{
    <#if mtouch.prox.negativeDeviation != "0">
    /* Negative Capacitance check */
    int32_t deviation = (int32_t)((uint32_t)(MTOUCH_Proximity_Reading_Get(prox->name)) - (uint32_t)(MTOUCH_Proximity_Baseline_Get(prox->name)));
    if (deviation < (int32_t)(-prox->threshold))
    {
        (prox->counter)++;
        if ((prox->counter) > (mtouch_prox_statecounter_t)MTOUCH_PROXIMITY_NEGATIVEDEVIATION)
        {
            prox->counter = (mtouch_prox_statecounter_t)0;
            MTOUCH_Proximity_Initialize(prox->name);
            <#if mtouch.prox.reburst_mode != "Disabled">
            Proximity_Reburst_Request(prox);
            </#if>
        }
    }
    /* Threshold check */
    else if ((prox->integratedDeviation) > (prox->threshold))
    <#else>
    /* Threshold check */
    if ((prox->integratedDeviation) > (prox->threshold))
    </#if>
    {
        <#if mtouch.prox.aks_group_enabled == true>
        if(prox->aks_group != No_AKS_Group)
        {
            if(Proximity_Check_AKS_Block(prox))
                return;
        }
        </#if>
        <#if mtouch.prox.debounce_enabled == true>
        prox->state   = MTOUCH_PROXIMITY_STATE_activatedDebounce;
        prox->counter = (mtouch_prox_statecounter_t)0;
        <#if mtouch.prox.reburst_mode != "Disabled">
        Proximity_Reburst_Request(prox);
        </#if>
        <#else>
        prox->state   = MTOUCH_PROXIMITY_STATE_activated;
        prox->counter = (mtouch_prox_statecounter_t)0; 
        <#if mtouch.prox.interfaceMethod == "0">
        callback_activated(prox->name);
        </#if>
        </#if>        
    }
    else
    {
        /* Delta is positive, but not past the threshold. */
        prox->counter = (mtouch_prox_statecounter_t)0;
    }
    
    /* Baseline Update check */
    
    <#if mtouch.prox.aks_group_enabled == true>
        if(prox->aks_group != No_AKS_Group)
        {
            if(Proximity_Check_AKS_Block(prox))
            {
                prox->baseline_count = (mtouch_prox_baselinecounter_t)
                (MTOUCH_PROXIMITY_BASECOUNTER_MAX-MTOUCH_PROXIMITY_BASELINE_HOLD);
                
                return;
            }
        }
    </#if>
    (prox->baseline_count)++;
    if ((prox->baseline_count) == MTOUCH_PROXIMITY_BASELINE_RATE)
    {
        prox->baseline_count = (mtouch_prox_baselinecounter_t)0;
        Proximity_Baseline_Update(prox);
    }
}

static void Proximity_State_Activated(mtouch_proximity_t* prox)
{
    <#if mtouch.prox.activityTimeout != "0">
    /* Timeout check */
    if ((prox->counter) >= MTOUCH_PROXIMITY_ACTIVITYTIMEOUT)
    {
        MTOUCH_Proximity_Initialize(prox->name);
        <#if mtouch.prox.interfaceMethod == "0">
        callback_notActivated(prox->name);
        </#if>
    }

    </#if>    
    /* Threshold check */
    <#if mtouch.prox.activityTimeout != "0">
    <#if mtouch.prox.individual_hysteresis_enabled == true>
    else if ((prox->integratedDeviation) < (prox->threshold-((prox->threshold) >> prox->hysteresis)))
    <#else>
    else if ((prox->integratedDeviation) < (prox->threshold-((prox->threshold) >> MTOUCH_PROXIMITY_COMMON_HYSTERESIS)))
    </#if>
    <#else>
    <#if mtouch.prox.individual_hysteresis_enabled == true>
    if ((prox->integratedDeviation) < (prox->threshold -((prox->threshold) >> prox->hysteresis)))
    <#else>
    if ((prox->integratedDeviation) < (prox->threshold -((prox->threshold) >> MTOUCH_PROXIMITY_COMMON_HYSTERESIS)))
    </#if>
    </#if>
    {
        <#if mtouch.prox.debounce_enabled == true>
        prox->state   = MTOUCH_PROXIMITY_STATE_notActivatedDebounce;
        prox->counter = (mtouch_prox_statecounter_t)0;
        <#if mtouch.prox.reburst_mode != "Disabled">
        Proximity_Reburst_Request(prox);
        </#if>
        <#else>
        prox->state   = MTOUCH_PROXIMITY_STATE_notActivated;
        prox->counter = (mtouch_prox_statecounter_t)0;
        prox->baseline_count = (mtouch_prox_baselinecounter_t)MTOUCH_PROXIMITY_BASECOUNTER_MAX-MTOUCH_PROXIMITY_BASELINE_HOLD;
        <#if mtouch.prox.interfaceMethod == "0">
        callback_notActivated(prox->name);
        </#if>
        </#if>
    }
}
<#if mtouch.prox.debounce_enabled == true>
static void Proximity_State_ActivatedDebounce(mtouch_proximity_t* prox)
{
    <#if mtouch.prox.aks_group_enabled == true>
    if(prox->aks_group != No_AKS_Group)
    {
        if(Proximity_Check_AKS_Block(prox))
        {
            prox->state   = MTOUCH_PROXIMITY_STATE_notActivated;
            prox->counter = (mtouch_prox_statecounter_t)0;
            return;
        }
           
    }
    
    </#if>
    if((prox->integratedDeviation) > (prox->threshold))
    {
        (prox->counter)++;
        if ((prox->counter) >= MTOUCH_PROXIMITY_DEBOUNCE_COUNT)
        {
            prox->state   = MTOUCH_PROXIMITY_STATE_activated;
            prox->counter = (mtouch_prox_statecounter_t)0;
            <#if mtouch.prox.interfaceMethod == "0">
            callback_activated(prox->name);
            </#if>
        }
        <#if mtouch.prox.reburst_mode != "Disabled">
        Proximity_Reburst_Request(prox);
        </#if>
    }
    else
    {
        prox->state   = MTOUCH_PROXIMITY_STATE_notActivated;
        prox->counter = (mtouch_prox_statecounter_t)0;
    }
}

static void Proximity_State_NotActivatedDebounce(mtouch_proximity_t* prox)
{
    <#if mtouch.prox.individual_hysteresis_enabled == true>
    if ((prox->integratedDeviation) < (prox->threshold -((prox->threshold) >> prox->hysteresis)))
    <#else>
    if ((prox->integratedDeviation) < (prox->threshold -((prox->threshold) >> MTOUCH_PROXIMITY_COMMON_HYSTERESIS)))
    </#if>
    {
        (prox->counter)++;
        if ((prox->counter) >= MTOUCH_PROXIMITY_DEBOUNCE_COUNT)
        {
            prox->state   = MTOUCH_PROXIMITY_STATE_notActivated;
            prox->counter = (mtouch_prox_statecounter_t)0;
            prox->baseline_count = (mtouch_prox_baselinecounter_t)MTOUCH_PROXIMITY_BASECOUNTER_MAX-MTOUCH_PROXIMITY_BASELINE_HOLD;
            <#if mtouch.prox.interfaceMethod == "0">
            callback_notActivated(prox->name);
            </#if>
        }
        <#if mtouch.prox.reburst_mode != "Disabled">
        Proximity_Reburst_Request(prox);
        </#if>
    }
    else
    {
        prox->state   = MTOUCH_PROXIMITY_STATE_activated;
        prox->counter = (mtouch_prox_statecounter_t)0;
    }
}
</#if>

<#if mtouch.prox.suspend_mode_enabled == true>
static void Proximity_State_Suspended(mtouch_proximity_t* prox)
{
    /* Update baseline during Suspend state*/
    Proximity_Baseline_Initialize(prox);
    
    /* Disable sensor until next baseline update */
    MTOUCH_Sensor_Disable(prox->sensor);
}
static void Proximity_State_Disabled(mtouch_proximity_t* prox)
{}
</#if>

<#if mtouch.prox.activityTimeout != "0">
/*
 * =======================================================================
 *  MTOUCH_Proximity_Tick
 * =======================================================================
 */
void MTOUCH_Proximity_Tick(void)
{
    <#if mtouch.prox.items?size == 1>
    Proximity_Tick_helper(&mtouch_proximity[0]);
    <#else>
    uint8_t i;
    for (i = 0; i < MTOUCH_PROXIMITY; i++)
    {
        Proximity_Tick_helper(&mtouch_proximity[i]);
    }
    </#if>
}
static void Proximity_Tick_helper(mtouch_proximity_t* prox)
{
    /* Only pressed state counter is based on real time */
    if ((prox->state) == MTOUCH_PROXIMITY_STATE_activated)
    {
        (prox->counter)++;
        if (prox->counter == (mtouch_prox_statecounter_t)0)
        {
            prox->counter = (mtouch_prox_statecounter_t)0xFFFF;
        }
    }
    <#if mtouch.prox.suspend_mode_enabled == true>
    /* Enable sensor to update baseline in suspend state */
    else if((prox->state) == MTOUCH_PROXIMITY_STATE_suspended)
    {
        (prox->counter)++;
        if(prox->counter >= MTOUCH_PROXIMITY_BASELINE_RATE)
        {
            prox->counter = (mtouch_prox_statecounter_t)0;
            MTOUCH_Sensor_Enable(prox->sensor);
        }
    }
    </#if>
}
</#if>


/*
 * =======================================================================
 * Proximity State and Deviation
 * =======================================================================
 */

mtouch_prox_threshold_t MTOUCH_Proximity_Threshold_Get(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
        return mtouch_proximity[name].threshold;
    else
        return (mtouch_prox_deviation_t)0;
}

void MTOUCH_Proximity_Threshold_Set(enum mtouch_proximity_names name,mtouch_prox_threshold_t threshold)
{
    if(name < MTOUCH_PROXIMITY)
        if(threshold >= MTOUCH_PROXIMITY_THRESHOLD_MIN && threshold <= MTOUCH_PROXIMITY_THRESHOLD_MAX)
            mtouch_proximity[name].threshold = threshold;
}

mtouch_prox_scaling_t MTOUCH_Proximity_Scaling_Get(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
        return mtouch_proximity[name].scaling;
    else
        return (mtouch_prox_scaling_t)0;
}

void MTOUCH_Proximity_Scaling_Set(enum mtouch_proximity_names name,mtouch_prox_scaling_t scaling)
{
    if(name < MTOUCH_PROXIMITY)
        if(scaling <= MTOUCH_PROXIMITY_SCALING_MAX)
            mtouch_proximity[name].scaling = scaling;
}

bool MTOUCH_Proximity_isActivated(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
    <#if mtouch.prox.debounce_enabled == true>
        return (mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_activated || mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_notActivatedDebounce) ? true : false;
    <#else>
        return (mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_activated) ? true : false; 
</#if>
    else
        return false;
}

bool MTOUCH_Proximity_isInitialized(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
        return (mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_initializing) ? false : true;
    else
        return false;
}

mtouch_prox_deviation_t MTOUCH_Proximity_Deviation_Get(enum mtouch_proximity_names name) /* Global */
{
    if(name < MTOUCH_PROXIMITY)
        return mtouch_proximity[name].integratedDeviation;
    else
        return (mtouch_prox_deviation_t)0;
}

static void Proximity_Deviation_Update(enum mtouch_proximity_names name)
{
    int32_t deviation;
    deviation = (int32_t)((uint32_t)(MTOUCH_Proximity_Reading_Get(name)) - (uint32_t)(MTOUCH_Proximity_Baseline_Get(name)));
    /* Delta scaling */
    deviation = deviation >> (mtouch_proximity[name].scaling); /* XC8 compiler will extend sign bit of signed values */

    /* Bounds checking */
    if (deviation > MTOUCH_PROXIMITY_DEVIATION_MAX)
    {
        deviation = MTOUCH_PROXIMITY_DEVIATION_MAX;
    }
    if (deviation < MTOUCH_PROXIMITY_DEVIATION_MIN)
    {
        deviation = MTOUCH_PROXIMITY_DEVIATION_MIN;
    }

    if(deviation < 0)
    {
        mtouch_proximity[name].integratedDeviation = 0;
    }
    else if((mtouch_prox_deviation_t)deviation < (mtouch_prox_deviation_t)(mtouch_proximity[name].threshold >> 3)) 
    {
        /* decrement the accumulation of deviation when the deviation is less than 12.5% of the threshold */
        if(mtouch_proximity[name].integratedDeviation >0 )
            mtouch_proximity[name].integratedDeviation--;
    }
    else
    {
        mtouch_proximity[name].integratedDeviation -= mtouch_proximity[name].integratedDeviation >> MTOUCH_PROXIMITY_DEVIATION_GAIN;
        if(MTOUCH_PROXIMITY_DEVIATION_MAX - mtouch_proximity[name].integratedDeviation > deviation)
            mtouch_proximity[name].integratedDeviation += deviation;
        else
            mtouch_proximity[name].integratedDeviation = MTOUCH_PROXIMITY_DEVIATION_MAX;
    }
}
 
<#if mtouch.prox.suspend_mode_enabled == true>/*
 * =======================================================================
 *  MTOUCH_Proximity_ (Suspend / Disable / Resume)
 * =======================================================================
 */
void MTOUCH_Proximity_Suspend(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
    {
        <#if mtouch.prox.interfaceMethod == "0">
        if(mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_activated)
            callback_notActivated(name);
        </#if>

        mtouch_proximity[name].state = MTOUCH_PROXIMITY_STATE_suspended;
        MTOUCH_Sensor_Disable(mtouch_proximity[name].sensor);
    }
}

void MTOUCH_Proximity_Disable(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
    {
        <#if mtouch.prox.interfaceMethod == "0">    
        if(mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_activated)
            callback_notActivated(name);
        </#if>

        mtouch_proximity[name].state = MTOUCH_PROXIMITY_STATE_disabled;
        MTOUCH_Sensor_Disable(mtouch_proximity[name].sensor);
    }
}

void MTOUCH_Proximity_Resume(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
    {
        if(mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_suspended)
        {
            mtouch_proximity[name].state = MTOUCH_PROXIMITY_STATE_notActivated;
        }
        else if(mtouch_proximity[name].state == MTOUCH_PROXIMITY_STATE_disabled) 
        {
            MTOUCH_Proximity_Initialize(name);
        }
        else 
        { }
        MTOUCH_Sensor_Enable(mtouch_proximity[name].sensor);
    }
}
</#if>

/*
 * =======================================================================
 * Proximity Reading and Baseline
 * =======================================================================
 */
mtouch_prox_reading_t MTOUCH_Proximity_Reading_Get(enum mtouch_proximity_names name) /* Global */
{
    if (name < MTOUCH_PROXIMITY)
        return mtouch_proximity[name].reading;
    else
        return (mtouch_prox_reading_t)0;
}

static void Proximity_Reading_Update(mtouch_proximity_t* prox)
{
    <#if mtouch.prox.medianfilterEnabled == "true" >

    static mtouch_prox_reading_t reading[MTOUCH_PROXIMITY] = {0};
    if(prox->state == MTOUCH_PROXIMITY_STATE_initializing)
    {
        reading[prox->name] = MTOUCH_Sensor_RawSample_Get(prox->sensor) << MTOUCH_PROXIMITY_READING_GAIN;
    }
    else
    {
        reading[prox->name] -= reading[prox->name] >> MTOUCH_PROXIMITY_READING_GAIN;
        reading[prox->name] += MTOUCH_Sensor_RawSample_Get(prox->sensor);
    }
    
    if (GIE == (uint8_t)1)
    {
        GIE = (uint8_t)0;
        prox->reading = median_filter(prox->name,reading[prox->name]);
        GIE = (uint8_t)1;
    }
    else
    {
        prox->reading = median_filter(prox->name,reading[prox->name]);
    }
    <#else>
    if (GIE == (uint8_t)1)
    {
        GIE = (uint8_t)0;
        Proximity_Reading_Update_Helper(prox);
        GIE = (uint8_t)1;
    }
    else
    {
        Proximity_Reading_Update_Helper(prox);
    }
    </#if>
}
<#if mtouch.prox.medianfilterEnabled != "true" >
static void Proximity_Reading_Update_Helper (mtouch_proximity_t* prox)
{
    if(prox->state != MTOUCH_PROXIMITY_STATE_initializing)
    {
        prox->reading -= prox->reading>>MTOUCH_PROXIMITY_READING_GAIN;
        prox->reading += MTOUCH_Sensor_RawSample_Get(prox->sensor);
    }
    else
    {
        prox->reading = MTOUCH_Sensor_RawSample_Get(prox->sensor) << MTOUCH_PROXIMITY_READING_GAIN;
    }
}
</#if>

static void Proximity_Baseline_Initialize(mtouch_proximity_t* prox)
{
    prox->baseline   = MTOUCH_Sensor_RawSample_Get(prox->sensor);
    prox->baseline <<= (MTOUCH_PROXIMITY_BASELINE_GAIN + MTOUCH_PROXIMITY_READING_GAIN);
}

static void Proximity_Baseline_Update(mtouch_proximity_t* prox)
{
    if (GIE == (uint8_t)1)
    {
        GIE = (uint8_t)0;
        prox->baseline -= (prox->baseline) >> MTOUCH_PROXIMITY_BASELINE_GAIN;
        prox->baseline += prox->reading;
        GIE = (uint8_t)1;
    }
    else
    {
        prox->baseline -= (prox->baseline) >> MTOUCH_PROXIMITY_BASELINE_GAIN;
        prox->baseline += prox->reading;
    }
}

mtouch_prox_reading_t MTOUCH_Proximity_Baseline_Get(enum mtouch_proximity_names name) /* Global */
{
    if (name < MTOUCH_PROXIMITY)
        return Proximity_Baseline_Get_helper(name);
    else
        return (mtouch_prox_reading_t)0;

}

static mtouch_prox_reading_t Proximity_Baseline_Get_helper(enum mtouch_proximity_names name)
{
    return (mtouch_prox_reading_t)(mtouch_proximity[name].baseline >> MTOUCH_PROXIMITY_BASELINE_GAIN);
}

<#if mtouch.prox.aks_group_enabled == true>
static mtouch_prox_reading_t Proximity_Unscaled_Deviation_Get(mtouch_proximity_t* prox)
{
    return (mtouch_prox_reading_t)(prox->reading - (mtouch_prox_reading_t)((prox->baseline)>>MTOUCH_PROXIMITY_BASELINE_GAIN));
}

/*
 * =======================================================================
 * Proximity Adjacent Key Suppression
 * =======================================================================
 */
static bool Proximity_Check_AKS_Block(mtouch_proximity_t* prox)
{
    enum mtouch_prox_aks_group currentAKSGroup = prox->aks_group;
    int16_t surplus_deviation_this_prox,surplus_deviation_check_prox;
    mtouch_proximity_t* check_prox;
    
    surplus_deviation_this_prox = (int16_t)(Proximity_Unscaled_Deviation_Get(prox) - (mtouch_prox_reading_t)prox->threshold);
    
    for(check_prox = &prox[0];check_prox <= &prox[MTOUCH_PROXIMITY-1];check_prox++)
    {
        if(check_prox->name == prox->name)
        {
            /* Don't check again itself*/
        }
        else
        {
            if(check_prox->aks_group == currentAKSGroup)
            {
            <#if mtouch.prox.debounce_enabled == true>
                if(check_prox->state == MTOUCH_PROXIMITY_STATE_activated || check_prox->state == MTOUCH_PROXIMITY_STATE_activatedDebounce)  /* block if other prox in the same AKS group is activated */
                    return true;
            <#else>
                if(check_prox->state == MTOUCH_PROXIMITY_STATE_activated)  /* block if other prox in the same AKS group is pressed */
                    return true;
            </#if>
                else                                                    /* check other sensors surplus deviation */
                {
                    surplus_deviation_check_prox = (int16_t)(Proximity_Unscaled_Deviation_Get(check_prox) - (mtouch_prox_reading_t)check_prox->threshold);
                    if(surplus_deviation_check_prox > 0 && surplus_deviation_check_prox > surplus_deviation_this_prox)
                        return true;
                }
            }            
        }
    }
    
    return false;
}
</#if>

<#if mtouch.prox.reburst_mode != "Disabled">
/*
 * =======================================================================
 * Proximity Reburst
 * =======================================================================
 */

static inline void Proximity_Reburst_Request(mtouch_proximity_t* prox)
{
    <#if mtouch.prox.reburst_mode != "Reburst All">
    proximity_reburst_request |= (mtouch_proxmask_t)1 << prox->name;
    <#else>
    proximity_reburst_request = true;
    </#if>
}

static inline void Proximity_Reburst_Clear(void)
{
    <#if mtouch.prox.reburst_mode != "Reburst All">
    proximity_reburst_request = (mtouch_proxmask_t)0;
    <#else>
    proximity_reburst_request = false;
    </#if>
}

void MTOUCH_Proximity_Reburst_Request(enum mtouch_proximity_names prox)
{
    Proximity_Reburst_Request(&mtouch_proximity[prox]);
}

bool MTOUCH_Proximity_Reburst_Service(void)
{
    <#if mtouch.prox.reburst_mode == "Reburst Unresolved">
    static  bool                      reburst_resolved = true;
    enum mtouch_proximity_names       prox;
    <#if mtouch.prox.aks_group_enabled == true>
    uint8_t                           aks_group_reburst = 0;
    </#if>
    
    
    if(proximity_reburst_request)
    {    
        /* Disable non-reburst sensor*/
        for(prox = MTOUCH_PROXIMITY-1; prox!=0xFF;prox--)
        {
            if((proximity_reburst_request&(mtouch_proxmask_t)1<<prox)==0)
            {  
                MTOUCH_Sensor_Disable(mtouch_proximity[prox].sensor);
            }
            <#if mtouch.prox.aks_group_enabled == true>
            else
            {   
                if(mtouch_proximity[prox].aks_group!=No_AKS_Group)
                {
                    aks_group_reburst |= (uint8_t)1<< (mtouch_proximity[prox].aks_group-1);
                }
            }
            </#if>
        }
        <#if mtouch.prox.aks_group_enabled == true>
        /* Enable the sensors in the AKS group that requires reburst */
        if(aks_group_reburst)
        {
            for(prox = MTOUCH_PROXIMITY-1; prox!=0xFF;prox--)
            {
                if(mtouch_proximity[prox].aks_group!=No_AKS_Group)
                {
                    if((aks_group_reburst&(uint8_t)1<<(mtouch_proximity[prox].aks_group-1))!=0)
                    {  
                        MTOUCH_Sensor_Enable(mtouch_proximity[prox].sensor);
                    }
                }
            }
        
        }
        </#if>
        reburst_resolved = false;
        Proximity_Reburst_Clear();
    }
    else if(reburst_resolved == false)
    {
        for(prox = MTOUCH_PROXIMITY-1; prox!=0xFF;prox--)
        {
            <#if mtouch.prox.suspend_mode_enabled == true>
            if(mtouch_proximity[prox].state!=MTOUCH_PROXIMITY_STATE_disabled || mtouch_proximity[prox].state!=MTOUCH_PROXIMITY_STATE_suspended)
            {
                MTOUCH_Sensor_Enable(mtouch_proximity[prox].sensor);
            }
            <#else>
                MTOUCH_Sensor_Enable(mtouch_proximity[prox].sensor);
            </#if>
        }
        reburst_resolved = true;
    }
    else
    {
        /* Do nothing if there is no reburst request and the previous reburst request has been resolved */
    }
    
    return !reburst_resolved;
    <#elseif mtouch.prox.reburst_mode == "Reburst All">
    return proximity_reburst_request;
    </#if>
}

</#if>
<#if mtouch.lowPower.enabled??>
void MTOUCH_Proximity_Baseline_ForceUpdate(void)
{
    enum mtouch_proximity_names prox;
    
    for(prox = 0;prox<MTOUCH_PROXIMITY;prox++)
    {
        mtouch_proximity[prox].baseline_count = MTOUCH_PROXIMITY_BASELINE_RATE - 1;
    }

}
</#if>
<#if mtouch.prox.interfaceMethod == "0">
/*
 * =======================================================================
 * Proximity Press/Release Callback Setter Functions
 * =======================================================================
 */
static void Proximity_DefaultCallback(enum mtouch_proximity_names name) { }
void MTOUCH_Proximity_SetActivatedCallback(void (*callback)(enum mtouch_proximity_names))
{
    callback_activated = callback;
}
void MTOUCH_Proximity_SetNotActivatedCallback(void (*callback)(enum mtouch_proximity_names))
{
    callback_notActivated = callback;
}
</#if>

<#if mtouch.prox.medianfilterEnabled == "true">
static mtouch_prox_reading_t median_filter(enum mtouch_proximity_names prox,mtouch_prox_reading_t new_data)
{
    uint8_t i = (uint8_t)0;
    static uint8_t deleted;
    mtouch_prox_reading_t temp_data;
    uint8_t new_index,temp_index;

    new_index=deleted;
    while (tap_index[prox][i]!=deleted)
    {
        if (filter_data[prox][i]>new_data)
        {
            temp_data=filter_data[prox][i];
            temp_index=tap_index[prox][i];
            filter_data[prox][i]=new_data;
            tap_index[prox][i]=new_index;
            new_data=temp_data;
            new_index=temp_index;
        }
        i++;
    }
    filter_data[prox][i]=new_data;
    tap_index[prox][i]=new_index;
    for (;i < MTOUCH_MEDIAN_FILTER_TAP-1;i++)
    {
        if(new_data>filter_data[prox][i+1])
        {
            filter_data[prox][i]=filter_data[prox][i+1];
            tap_index[prox][i]=tap_index[prox][i+1];
            filter_data[prox][i+1]=new_data;
            tap_index[prox][i+1]=new_index;
        }
        else
            break;
    }
    if (++deleted>=MTOUCH_MEDIAN_FILTER_TAP)
        deleted = (uint8_t)0;

    return filter_data[prox][MTOUCH_MEDIAN_FILTER_TAP/2];
}
</#if>
uint8_t MTOUCH_Proximity_State_Get(enum mtouch_proximity_names name)
{
    if(name < MTOUCH_PROXIMITY)
        return (uint8_t)mtouch_proximity[name].state;
    else
        return 0;
}

mtouch_proxmask_t MTOUCH_Proximity_Proximitymask_Get(void)
{
    mtouch_proxmask_t output = 0;

    for (uint8_t i = 0; i < MTOUCH_PROXIMITY; i++)
    {
        if (MTOUCH_Proximity_isActivated(i) == true)
        {
            output |= (mtouch_proxmask_t)0x01 << i;
        }
    }
    return output;
}
#endif