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
#ifndef MTOUCH_BUTTON_H
#define MTOUCH_BUTTON_H
<#if mtouch.button.enabled??>
    
    #include <stdint.h>
    #include <stdbool.h>
    #include "mtouch_config.h"
    #include "mtouch.h"
    
/*
 * =======================================================================
 * Application / Configuration Settings
 * =======================================================================
 */
 
    enum mtouch_button_names
    {
    <#list 0..mtouch.button.items?size-1 as i>
        ${mtouch.button.items[i].name} = ${i}<#if i != mtouch.button.items?size-1>,</#if>
    </#list>
    };
    
/*
 * =======================================================================
 * Typedefs / Data Types
 * =======================================================================
 */
    typedef ${mtouch.button.buttonmask.type} mtouch_buttonmask_t;
    
    typedef ${mtouch.button.stateCounter.type} mtouch_button_statecounter_t;
    #define MTOUCH_BUTTON_STATECOUNTER_MIN (${mtouch.button.stateCounter.min})
    #define MTOUCH_BUTTON_STATECOUNTER_MAX (${mtouch.button.stateCounter.max})

    typedef ${mtouch.button.baselineCounter.type} mtouch_button_baselinecounter_t;
    #define MTOUCH_BUTTON_BASECOUNTER_MIN (${mtouch.button.baselineCounter.min})
    #define MTOUCH_BUTTON_BASECOUNTER_MAX (${mtouch.button.baselineCounter.max})
    
    typedef ${mtouch.button.reading.type} mtouch_button_reading_t;
    #define MTOUCH_BUTTON_READING_MIN (${mtouch.button.reading.min})
    #define MTOUCH_BUTTON_READING_MAX (${mtouch.button.reading.max})
    
    
    typedef ${mtouch.button.baseline.type} mtouch_button_baseline_t;
    #define MTOUCH_BUTTON_BASELINE_MIN (${mtouch.button.baseline.min})
    #define MTOUCH_BUTTON_BASELINE_MAX (${mtouch.button.baseline.max})

    
    typedef ${mtouch.button.deviation.type} mtouch_button_deviation_t;
    #define MTOUCH_BUTTON_DEVIATION_MIN (${mtouch.button.deviation.min})
    #define MTOUCH_BUTTON_DEVIATION_MAX (${mtouch.button.deviation.max})

    typedef ${mtouch.button.threshold.type} mtouch_button_threshold_t;
    #define MTOUCH_BUTTON_THRESHOLD_MIN ((mtouch_button_threshold_t)(${mtouch.button.threshold.min}))
    #define MTOUCH_BUTTON_THRESHOLD_MAX ((mtouch_button_threshold_t)(${mtouch.button.threshold.max}))

    typedef ${mtouch.button.scaling.type} mtouch_button_scaling_t;
    #define MTOUCH_BUTTON_SCALING_MIN ((mtouch_button_scaling_t)(${mtouch.button.scaling.min}))
    #define MTOUCH_BUTTON_SCALING_MAX ((mtouch_button_scaling_t)(${mtouch.button.scaling.max}))

    


/*
 * =======================================================================
 * Global Functions
 * =======================================================================
 */
    <#if mtouch.button.interfaceMethod == "0">
    void MTOUCH_Button_SetPressedCallback   (void (*callback)(enum mtouch_button_names button));
    void MTOUCH_Button_SetNotPressedCallback(void (*callback)(enum mtouch_button_names button));
    </#if>
    
    void                        MTOUCH_Button_Initialize    (enum mtouch_button_names button);
    void                        MTOUCH_Button_InitializeAll (void);
    void                        MTOUCH_Button_ServiceAll    (void);
    <#if mtouch.button.pressTimeout != "0">
    void                        MTOUCH_Button_Tick          (void);
    </#if>
    <#if mtouch.lowPower.enabled??>
    void                        MTOUCH_Button_Baseline_ForceUpdate(void);
    </#if>
    mtouch_button_deviation_t   MTOUCH_Button_Deviation_Get (enum mtouch_button_names button);
    mtouch_button_reading_t     MTOUCH_Button_Reading_Get   (enum mtouch_button_names button);
    mtouch_button_reading_t     MTOUCH_Button_Baseline_Get  (enum mtouch_button_names button);
    mtouch_button_scaling_t     MTOUCH_Button_Scaling_Get   (enum mtouch_button_names button);
    void                        MTOUCH_Button_Scaling_Set   (enum mtouch_button_names button,mtouch_button_scaling_t scaling);
    mtouch_button_threshold_t   MTOUCH_Button_Threshold_Get (enum mtouch_button_names button);
    void                        MTOUCH_Button_Threshold_Set (enum mtouch_button_names button,mtouch_button_threshold_t threshold);
    uint8_t                     MTOUCH_Button_Oversampling_Get(enum mtouch_button_names button);
    void                        MTOUCH_Button_Oversampling_Set(enum mtouch_button_names button,uint8_t oversampling);
    
    bool                        MTOUCH_Button_isPressed     (enum mtouch_button_names button);
    bool                        MTOUCH_Button_isInitialized (enum mtouch_button_names button);
    mtouch_buttonmask_t         MTOUCH_Button_Buttonmask_Get(void);
    uint8_t                     MTOUCH_Button_State_Get     (enum mtouch_button_names button);
<#if mtouch.button.suspend_mode_enabled == true>
    void                        MTOUCH_Button_Disable       (enum mtouch_button_names button);
    void                        MTOUCH_Button_Suspend       (enum mtouch_button_names button);
    void                        MTOUCH_Button_Resume        (enum mtouch_button_names button);
</#if>
<#if mtouch.button.reburst_mode != "Disabled">
    void                        MTOUCH_Button_Reburst_Request(enum mtouch_button_names button);
    bool                        MTOUCH_Button_Reburst_Service(void);
</#if>
</#if>
#endif // MTOUCH_BUTTON_H
