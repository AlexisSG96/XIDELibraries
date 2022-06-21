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

#include "mtouch.h"
#include "../mcc.h"

/* ======================================================================= *
 * Definitions
 * ======================================================================= */
<#if mtouch.scanRateControl.enabled??>
#define MTOUCH_SCAN_TIMER_TICK                  ${mtouch.scanRateControl.scanTimerTick} //unit us
#define MTOUCH_SCAN_RELOAD                      (uint16_t)(65535-((MTOUCH_SCAN_INTERVAL*1000.0)/MTOUCH_SCAN_TIMER_TICK)) 
<#if mtouch.gesture.enabled??>
#if (MTOUCH_SCAN_INTERVAL != 10) 
#error The mTouch gesture engine needs to use 10ms scan rate for gesture timer.
#endif
</#if>
</#if>
<#if mtouch.lowPower.enabled??>
#define MTOUCH_LOWPOWER_SCAN_RELOAD             (uint16_t)(65535-((MTOUCH_LOWPOWER_SCAN_INTERVAL*1000.0)/MTOUCH_SCAN_TIMER_TICK)) 
#define MTOUCH_LOWPOWER_INACTIVE_TIMEOUT_CYCLE  (uint16_t)(MTOUCH_LOWPOWER_INACTIVE_TIMEOUT/MTOUCH_SCAN_INTERVAL)
#define MTOUCH_LOWPOWER_BASELINEUPDATE_CYCLE    (uint16_t)(MTOUCH_LOWPOWER_BASELINEUPDATE_TIME/MTOUCH_LOWPOWER_SCAN_INTERVAL)
</#if>


/* ======================================================================= *
 * Local Variable
 * ======================================================================= */

static bool mtouch_time_toScan = false;
static bool mtouch_request_init = false;
<#if mtouch.scanRateControl.enabled??>
static uint16_t mTouchScanReload = MTOUCH_SCAN_RELOAD;
</#if>
<#if mtouch.lowPower.enabled??>
static bool mtouch_lowpowerEnabled = true;
static bool mtouch_lowpowerActivated = false;
static uint16_t mtouch_inactive_counter = 0;
static uint16_t mtouch_sleep_baseline_counter = 0;
const  uint8_t mtouch_sleep_sensors[] = MTOUCH_LOWPOWER_SENSOR_LIST;
</#if>

/*
 * =======================================================================
 *  Local Functions
 * =======================================================================
 */
<#if mtouch.scanRateControl.enabled??>
static void MTOUCH_ScanScheduler(void);   
</#if>
<#if mtouch.lowPower.enabled??>
static void MTOUCH_Lowpower_Initialize();
</#if>
static bool MTOUCH_needReburst(void);

<#if mtouch.scanRateControl.enabled??>
/*
 * =======================================================================
 * MTOUCH_ScanScheduler()
 * =======================================================================
 *  The interrupt handler callback for scanrate timer  
 */
static void MTOUCH_ScanScheduler(void)         
{
  
    //schedule the next timer1 interrupt
    TMR1_WriteTimer(mTouchScanReload);
    
    //schedule the scan
    mtouch_time_toScan = true;  

<#if mtouch.gesture.enabled??>
    // Update Gesture timer
    MTOUCH_Gesture_updateTimer(1u);
</#if>
}
</#if>
/*
 * =======================================================================
 * MTOUCH_Service_isInProgress()
 * =======================================================================
 *  indicate the mTouch service status
 */

bool MTOUCH_Service_isInProgress()
{
    return mtouch_time_toScan;
}

<#if mtouch.lowPower.enabled??>
/*
 * =======================================================================
 * MTOUCH_Lowpower_Initialize()
 * =======================================================================
 *  initialize the registers and settings for low power operation
 */
static void MTOUCH_Lowpower_Initialize()
{
    /* Uncomment the line below if the part have VREGCON register*/
    /* Enable low-power sleep mode for Voltage Regulator. */
    // VREGCONbits.VREGPM = 1;
}
</#if>

/*
 * =======================================================================
 * MTOUCH_Init()
 * =======================================================================
 *  Root initialization routine for all enabled mTouch library modules.
 */
void MTOUCH_Initialize(void)
{   
    MTOUCH_Sensor_InitializeAll();
<#if mtouch.button.enabled??>
    MTOUCH_Button_InitializeAll();
</#if>
<#if mtouch.prox.enabled??>
    MTOUCH_Proximity_InitializeAll();
</#if>
<#if mtouch.slider.enabled??>
    MTOUCH_Slider_InitializeAll();
</#if>
<#if mtouch.surface.enabled??>
    MTOUCH_Surface_InitializeAll();
</#if>
<#if mtouch.gesture.enabled??>
    MTOUCH_Gesture_Initialize();
</#if>
<#if mtouch.surfaceUtility??>
#if (MTOUCH_DEBUG_COMM_ENABLE == 1u)
    MTOUCH_Comm_Initialize();
#endif
</#if>
<#if mtouch.hostInterfaceComms??>
    MTOUCH_Memory_Initialize();
</#if>
<#if mtouch.dataStreamer??>
#if (MTOUCH_DEBUG_COMM_ENABLE == 1u)
    MTOUCH_DataStreamer_Initialize();    
#endif      
</#if>
    MTOUCH_Sensor_Sampled_ResetAll();
    MTOUCH_Sensor_Scan_Initialize();
<#if mtouch.lowPower.enabled??>
    MTOUCH_Lowpower_Initialize();
</#if>
<#if mtouch.scanRateControl.enabled??>
    TMR1_SetInterruptHandler(MTOUCH_ScanScheduler);
</#if>

}

/*
 * =======================================================================
 * MTOUCH_Service_Mainloop()
 * =======================================================================
 *  Root mainloop service routine for all enabled mTouch library modules.
 */
bool MTOUCH_Service_Mainloop(void)
{

    if(mtouch_request_init)
    {
        MTOUCH_Initialize();
        mtouch_request_init = false;
    }

    <#if mtouch.scanRateControl.enabled??>
    <#else>
    /* In free running mode, the mTouch service will be executed once MTOUCH_Service_Mainloop gets called.*/
    mtouch_time_toScan = true;
    </#if>
    
    if(mtouch_time_toScan)               
    {
        if(MTOUCH_Sensor_SampleAll() == false)     
            return false;  

        <#if mtouch.lowPower.enabled??>
        if(mtouch_lowpowerActivated && mtouch_lowpowerEnabled)
        {
            mtouch_time_toScan = false;
            MTOUCH_Sensor_Sampled_ResetAll();  

            if(MTOUCH_Sensor_isAnySensorActive())
            {
                MTOUCH_Service_exitLowpower();
                mtouch_inactive_counter = 0;
            }
            else
            {
            <#if mtouch.button.enabled?? || mtouch.prox.enabled??>
                /* Exit low power temporarily for baseline update */
                if((0u != MTOUCH_LOWPOWER_BASELINEUPDATE_CYCLE) &&
                   (++mtouch_sleep_baseline_counter == MTOUCH_LOWPOWER_BASELINEUPDATE_CYCLE)) 
                {
                    <#if mtouch.button.enabled?? >
                    MTOUCH_Button_Baseline_ForceUpdate();
                    </#if>
                    <#if mtouch.prox.enabled?? >
                    MTOUCH_Proximity_Baseline_ForceUpdate();
                    </#if>
                    MTOUCH_Service_exitLowpower();
                    mtouch_sleep_baseline_counter = 0;
                    mtouch_inactive_counter = 
                            MTOUCH_LOWPOWER_INACTIVE_TIMEOUT_CYCLE - 1;
                }
            </#if>
                SLEEP();
                NOP();
                NOP();
            }
            return true;
        }
        else
        {
        </#if>
        <#if mtouch.button.enabled??>
            MTOUCH_Button_ServiceAll();             /* Execute state machine for all buttons w/scanned sensors */
        </#if>
        <#if mtouch.prox.enabled??>
            MTOUCH_Proximity_ServiceAll();          /* Execute state machine for all proximity w/scanned sensors */
        </#if>
        <#if mtouch.slider.enabled??>
            MTOUCH_Slider_ServiceAll();             /* Execute state machine for all Slider */
        </#if>
        <#if mtouch.surface.enabled??>
            MTOUCH_Surface_ServiceAll();
        </#if>
        <#if mtouch.gesture.enabled??>              
            MTOUCH_Gesture_Service();              /* Execute the gesture module */
        </#if>
        <#if mtouch.surfaceUtility??>
        #if (MTOUCH_DEBUG_COMM_ENABLE == 1u)
            MTOUCH_Comm_Service();                 /* Execute 2D Surface Utility module */
        #endif
        </#if>
        <#if mtouch.dataStreamer??>
        #if (MTOUCH_DEBUG_COMM_ENABLE == 1u)
            MTOUCH_DataStreamer_Service();          /* Execute Data Visualizer module */  
        #endif
        </#if>
            mtouch_time_toScan = MTOUCH_needReburst();
            MTOUCH_Sensor_Sampled_ResetAll();  
            MTOUCH_Tick();
<#if mtouch.lowPower.enabled??>
            if(mtouch_lowpowerEnabled)
            {
<#if mtouch.button.enabled?? && mtouch.prox.enabled??>
                if(MTOUCH_Button_Buttonmask_Get() || MTOUCH_Proximity_Proximitymask_Get())
<#elseif mtouch.button.enabled??>
                if(MTOUCH_Button_Buttonmask_Get())
<#elseif mtouch.prox.enabled??>
                if(MTOUCH_Proximity_Proximitymask_Get())
<#else>
                if(MTOUCH_Sensor_isAnySensorActive())
</#if>
                {
                    mtouch_inactive_counter = 0;
                }
                else
                {
                    if(++mtouch_inactive_counter == 
                       MTOUCH_LOWPOWER_INACTIVE_TIMEOUT_CYCLE)
                    {
                        MTOUCH_Service_enterLowpower();
                        mtouch_sleep_baseline_counter = 0;
                        SLEEP();
                        NOP();
                        NOP();
                    }
                }
            }
</#if>
            return true;
<#if mtouch.lowPower.enabled??>
        }   
</#if> 
    }
    else                              
    {
        return false;                
    }
}

/*
 * =======================================================================
 * MTOUCH_Tick
 * =======================================================================
 */
void MTOUCH_Tick(void)
{
    <#if mtouch.button.enabled??>
    <#if mtouch.button.pressTimeout != "0">
    MTOUCH_Button_Tick();
    </#if>
    </#if>
    <#if mtouch.prox.enabled??>
    <#if mtouch.prox.activityTimeout != "0">
    MTOUCH_Proximity_Tick();
    </#if>
    </#if>
}

/*
 * =======================================================================
 * MTOUCH_Reburst
 * =======================================================================
 */
 static bool MTOUCH_needReburst(void)
 {
    bool needReburst = false;
    <#if mtouch.button.reburst_mode ??>
    <#if mtouch.button.reburst_mode != "Disabled">
    <#if mtouch.slider.enabled??>
    needReburst |= MTOUCH_Slider_Reburst_Service();
    </#if>
    needReburst |= MTOUCH_Button_Reburst_Service();
    </#if>
    </#if>
    
    <#if mtouch.prox.reburst_mode ??>
    <#if mtouch.prox.reburst_mode != "Disabled">
    needReburst |= MTOUCH_Proximity_Reburst_Service();
    </#if>
    </#if>
    return needReburst;
 }

<#if mtouch.lowPower.enabled??>
/*
 * =======================================================================
 * MTOUCH_Service_enterLowpower
 * =======================================================================
 */
void MTOUCH_Service_enterLowpower(void)
{
    uint8_t i;
    mtouch_lowpowerActivated = true;
    
    for(i=0;i<MTOUCH_SENSORS;i++)
    {
        MTOUCH_Sensor_Disable (i);
    }
    
    for(i=0;i < sizeof(mtouch_sleep_sensors);i++)
    {
        MTOUCH_Sensor_Enable(mtouch_sleep_sensors[i]);
    }

    mTouchScanReload = MTOUCH_LOWPOWER_SCAN_RELOAD;
    MTOUCH_Sensor_startLowpower();
}

/*
 * =======================================================================
 * MTOUCH_Service_exitLowpower
 * =======================================================================
 */
void MTOUCH_Service_exitLowpower(void)
{
    uint8_t i;
    
    mtouch_lowpowerActivated = false;
    mTouchScanReload = MTOUCH_SCAN_RELOAD;
    
    for(i=0;i<MTOUCH_SENSORS;i++)
    {
        MTOUCH_Sensor_Enable (i);
    }
    MTOUCH_Sensor_exitLowpower ();
}

/*
 * =======================================================================
 * MTOUCH_Service_LowpowerState_Get
 * =======================================================================
 */
bool MTOUCH_Service_LowpowerState_Get(void)
{
    return mtouch_lowpowerActivated;
}

/*
 * =======================================================================
 * MTOUCH_Service_disableLowpower
 * =======================================================================
 */
void MTOUCH_Service_disableLowpower(void)
{
     mtouch_lowpowerEnabled = false;
}
 
/*
 * =======================================================================
 * MTOUCH_Service_enableLowpower
 * =======================================================================
 */
void MTOUCH_Service_enableLowpower(void)
{
    mtouch_lowpowerEnabled = true;
}
</#if>

/*
 * =======================================================================
 * Request the initialization of mTouch library
 * note: this is designed to use in the Interrupt context so that the compiler
 *  does not duplicate the MTOUCH_Initialize() and causing possible hardware 
 *  stack overflow.
 * =======================================================================
 */
 void MTOUCH_requestInitSet(void)
 {
     mtouch_request_init = true;
 }

 bool MTOUCH_requestInitGet(void)
 {
     return mtouch_request_init;
 }