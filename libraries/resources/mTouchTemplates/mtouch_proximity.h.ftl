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
#ifndef MTOUCH_PROXIMITY_H
#define MTOUCH_PROXIMITY_H
<#if mtouch.prox.enabled??>
    
    #include <stdint.h>
    #include <stdbool.h>
    #include "mtouch.h"
    #include "mtouch_config.h"

/*
 * =======================================================================
 * Application / Configuration Settings
 * =======================================================================
 */
    
    enum mtouch_proximity_names
    {
    <#list 0..mtouch.prox.items?size-1 as i>
        ${mtouch.prox.items[i].name} = ${i}<#if i != mtouch.prox.items?size-1>,</#if>
    </#list>
    };

   
/*
 * =======================================================================
 * Typedefs / Data Types
 * =======================================================================
 */
    typedef ${mtouch.prox.proxmask.type} mtouch_proxmask_t;
 
    typedef ${mtouch.prox.stateCounter.type} mtouch_prox_statecounter_t;
    #define MTOUCH_PROXIMITY_STATECOUNTER_MIN (${mtouch.prox.stateCounter.min})
    #define MTOUCH_PROXIMITY_STATECOUNTER_MAX (${mtouch.prox.stateCounter.max})
    
    
    typedef ${mtouch.prox.baselineCounter.type} mtouch_prox_baselinecounter_t;
    #define MTOUCH_PROXIMITY_BASECOUNTER_MIN (${mtouch.prox.baselineCounter.min})
    #define MTOUCH_PROXIMITY_BASECOUNTER_MAX (${mtouch.prox.baselineCounter.max})
    
    typedef ${mtouch.prox.reading.type} mtouch_prox_reading_t;
    #define MTOUCH_PROXIMITY_READING_MIN ((mtouch_prox_reading_t)${mtouch.prox.reading.min})
    #define MTOUCH_PROXIMITY_READING_MAX ((mtouch_prox_reading_t)${mtouch.prox.reading.max})
    
    typedef ${mtouch.prox.baseline.type} mtouch_prox_baseline_t;
    #define MTOUCH_PROXIMITY_BASELINE_MIN (${mtouch.prox.baseline.min})
    #define MTOUCH_PROXIMITY_BASELINE_MAX (${mtouch.prox.baseline.max})
    
    typedef ${mtouch.prox.deviation.type} mtouch_prox_deviation_t;
    #define MTOUCH_PROXIMITY_DEVIATION_MIN (${mtouch.prox.deviation.min})
    #define MTOUCH_PROXIMITY_DEVIATION_MAX (${mtouch.prox.deviation.max})

    typedef ${mtouch.prox.threshold.type} mtouch_prox_threshold_t;
    #define MTOUCH_PROXIMITY_THRESHOLD_MIN ((mtouch_prox_threshold_t)(${mtouch.prox.threshold.min}))
    #define MTOUCH_PROXIMITY_THRESHOLD_MAX ((mtouch_prox_threshold_t)(${mtouch.prox.threshold.max}))

    typedef ${mtouch.prox.scaling.type} mtouch_prox_scaling_t;
    #define MTOUCH_PROXIMITY_SCALING_MIN ((mtouch_prox_scaling_t)(${mtouch.prox.scaling.min}))
    #define MTOUCH_PROXIMITY_SCALING_MAX ((mtouch_prox_scaling_t)(${mtouch.prox.scaling.max}))


/*
 * =======================================================================
 * Global Functions
 * =======================================================================
 */
    <#if mtouch.prox.interfaceMethod == "0">
    void MTOUCH_Proximity_SetActivatedCallback   (void (*callback)(enum mtouch_proximity_names prox));
    void MTOUCH_Proximity_SetNotActivatedCallback(void (*callback)(enum mtouch_proximity_names prox));
    </#if>
    void                        MTOUCH_Proximity_Initialize     (enum mtouch_proximity_names prox);
    void                        MTOUCH_Proximity_InitializeAll  (void);
    void                        MTOUCH_Proximity_ServiceAll     (void);
    <#if mtouch.prox.activityTimeout != "0">
    void                        MTOUCH_Proximity_Tick           (void);
    </#if>
    void                        MTOUCH_Proximity_Recalibrate    (void);
    <#if mtouch.lowPower.enabled??>
    void                        MTOUCH_Proximity_Baseline_ForceUpdate(void);
    </#if>

    mtouch_prox_deviation_t     MTOUCH_Proximity_Deviation_Get  (enum mtouch_proximity_names prox);
    mtouch_prox_reading_t       MTOUCH_Proximity_Reading_Get    (enum mtouch_proximity_names prox);
    mtouch_prox_reading_t       MTOUCH_Proximity_Baseline_Get   (enum mtouch_proximity_names prox);
    mtouch_prox_scaling_t       MTOUCH_Proximity_Scaling_Get    (enum mtouch_proximity_names prox);
    void                        MTOUCH_Proximity_Scaling_Set    (enum mtouch_proximity_names prox,mtouch_prox_scaling_t scaling);
    void                        MTOUCH_Proximity_Threshold_Set  (enum mtouch_proximity_names prox,mtouch_prox_threshold_t threshold);
    mtouch_prox_threshold_t     MTOUCH_Proximity_Threshold_Get  (enum mtouch_proximity_names prox);
    
    bool                        MTOUCH_Proximity_isActivated    (enum mtouch_proximity_names prox);
    bool                        MTOUCH_Proximity_isInitialized  (enum mtouch_proximity_names prox);
    uint8_t                     MTOUCH_Proximity_State_Get      (enum mtouch_proximity_names prox);
    mtouch_proxmask_t           MTOUCH_Proximity_Proximitymask_Get(void);
<#if mtouch.prox.suspend_mode_enabled == true>
    void                        MTOUCH_Proximity_Disable       (enum mtouch_proximity_names prox);
    void                        MTOUCH_Proximity_Suspend       (enum mtouch_proximity_names prox);
    void                        MTOUCH_Proximity_Resume        (enum mtouch_proximity_names prox);
</#if>
<#if mtouch.prox.reburst_mode != "Disabled">
    void                        MTOUCH_Proximity_Reburst_Request(enum mtouch_proximity_names prox);
    bool                        MTOUCH_Proximity_Reburst_Service(void);
</#if>
</#if>
#endif // MTOUCH_PROXIMITY_H
