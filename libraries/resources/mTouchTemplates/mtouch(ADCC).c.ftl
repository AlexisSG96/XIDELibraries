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
#define MTOUCH_SCAN_TIMER_TICK                  ${mtouch.scanRateControl.scanTimerTick?c} //unit us
<#if mtouch.scanRateControl.timer == "TMR2"> 
#define MTOUCH_MAX_TIMER_PERIOD                 ${mtouch.scanRateControl.maxTimerInterval} //unit ms
#define MTOUCH_SCAN_PERIOD                      (uint16_t)MTOUCH_SCAN_INTERVAL
#define MTOUCH_TMR2_POST_SCALER                 (uint8_t)(MTOUCH_SCAN_PERIOD / MTOUCH_MAX_TIMER_PERIOD)
#define MTOUCH_TMR2_PERIOD                      (uint8_t)((MTOUCH_SCAN_PERIOD*1000.0)/(MTOUCH_SCAN_TIMER_TICK*(MTOUCH_TMR2_POST_SCALER+1))-1u)
<#else>
#define MTOUCH_SCAN_RELOAD                      (uint16_t)(65535-((MTOUCH_SCAN_INTERVAL*1000.0)/MTOUCH_SCAN_TIMER_TICK)) 
</#if>
<#if mtouch.gesture.enabled??>
#if (MTOUCH_SCAN_INTERVAL != 10) 
#error The mTouch gesture engine needs to use 10ms scan rate for gesture timer.
#endif
</#if>
</#if>
<#if mtouch.lowPower.enabled??>
<#if mtouch.scanRateControl.timer == "TMR2"> 
#define MTOUCH_LOWPOWER_SCAN_PERIOD             (uint16_t)MTOUCH_LOWPOWER_SCAN_INTERVAL
#define MTOUCH_TMR2_PERIOD_LOWPOWER             (uint8_t)((MTOUCH_LOWPOWER_SCAN_PERIOD*1000.0)/(MTOUCH_SCAN_TIMER_TICK*(MTOUCH_TMR2_POST_SCALER_LOWPOWER+1))-1u)
#define MTOUCH_TMR2_POST_SCALER_LOWPOWER        (uint8_t)(MTOUCH_LOWPOWER_SCAN_PERIOD / MTOUCH_MAX_TIMER_PERIOD)
<#else>
#define MTOUCH_LOWPOWER_SCAN_RELOAD             (uint16_t)(65535-((MTOUCH_LOWPOWER_SCAN_INTERVAL*1000.0)/MTOUCH_SCAN_TIMER_TICK)) 
</#if>
#define MTOUCH_LOWPOWER_INACTIVE_TIMEOUT_CYCLE  (uint16_t)(MTOUCH_LOWPOWER_INACTIVE_TIMEOUT/MTOUCH_SCAN_INTERVAL)
#define MTOUCH_LOWPOWER_BASELINEUPDATE_CYCLE    (uint16_t)(MTOUCH_LOWPOWER_BASELINEUPDATE_TIME/MTOUCH_LOWPOWER_SCAN_INTERVAL)
</#if>


/* ======================================================================= *
 * Local Variable
 * ======================================================================= */

static bool mtouch_time_toScan = false;
static bool mtouch_request_init = false;
<#if mtouch.scanRateControl.enabled??>
<#if mtouch.scanRateControl.timer == "TMR1"> 
static uint16_t mTouchScanReload = MTOUCH_SCAN_RELOAD;
</#if>
</#if>
<#if mtouch.lowPower.enabled??>
static bool mtouch_lowpowerEnabled = true;
static bool mtouch_lowpowerActivated = false;
static uint16_t mtouch_inactive_counter = 0;
static uint16_t mtouch_sleep_baseline_counter = 0;
const  uint8_t mtouch_sleep_sensors[MTOUCH_LOWPOWER_SENSORS] = MTOUCH_LOWPOWER_SENSOR_LIST;
</#if>

/*
 * =======================================================================
 *  Local Functions
 * =======================================================================
 */
<#if mtouch.scanRateControl.enabled??>
static void MTOUCH_ScanScheduler(void); 
<#if mtouch.scanRateControl.timer == "TMR2">
static void MTOUCH_SetTimer2Period(uint16_t scanPeriod); 
</#if>  
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
<#if mtouch.scanRateControl.timer == "TMR1">   
    //schedule the next timer1 interrupt
    TMR1_WriteTimer(mTouchScanReload);
</#if>
    
    //schedule the scan
    mtouch_time_toScan = true;  

<#if mtouch.gesture.enabled??>
    // Update Gesture timer
    MTOUCH_Gesture_updateTimer(1u);
</#if>
}

<#if mtouch.scanRateControl.timer == "TMR2">  
/*
 * =======================================================================
 * MTOUCH_SetTimer2Config
 * =======================================================================
 *  set Timer2 period register and the postscaler   
 */
static void MTOUCH_SetTimer2Config(void) 
{
<#if mtouch.lowPower.enabled??>
    if(mtouch_lowpowerActivated)
    {
        /* Set timer period and control register */
        T2CON = 0x00;                        /* Timer OFF */
        TMR2_LoadPeriodRegister(MTOUCH_TMR2_PERIOD_LOWPOWER);     /* set period */
        T2CON = 0xD0 + (MTOUCH_TMR2_POST_SCALER_LOWPOWER & 0x0F);  /* set post-scaler, Timer ON */
    }
    else
    {
        T2CON = 0x00; 
        TMR2_LoadPeriodRegister(MTOUCH_TMR2_PERIOD);     
        T2CON = 0xD0 + (MTOUCH_TMR2_POST_SCALER & 0x0F);  
    }
<#else>
    /* Set timer period and control register */
    T2CON = 0x00;  /* Timer OFF */
    TMR2_LoadPeriodRegister(MTOUCH_TMR2_PERIOD);     /* set period */
    T2CON = 0xD0 + (MTOUCH_TMR2_POST_SCALER & 0x0F);  /* set post-scaler, Timer ON */
</#if> 
} 
</#if>
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
<#if pic.isLF == "false" >
    /* Enable low-power sleep mode for Voltage Regulator. */
<#if pic.isK40 == "true" >
    VREGCONbits.VREGPM1 = 1;
<#else>
    VREGCONbits.VREGPM = 1;
</#if>
</#if>
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
#if (MTOUCH_BUTTONS_ENABLE == 1u)
    MTOUCH_Button_InitializeAll();
#endif
</#if>
<#if mtouch.prox.enabled??>
#if (MTOUCH_PROXIMITY_ENABLE == 1u)
    MTOUCH_Proximity_InitializeAll();
#endif
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
<#if mtouch.scanRateControl.timer == "TMR2"> 
    MTOUCH_SetTimer2Config();
</#if>
    ${mtouch.scanRateControl.timer}_SetInterruptHandler(MTOUCH_ScanScheduler);
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
    uint8_t mask = 0u;
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
<#if mtouch.lowPower.enabled??>
        if(mtouch_lowpowerActivated && mtouch_lowpowerEnabled)
        {
            if(MTOUCH_Lowpower_Sensor_isSamplingComplete() == false)
            {
                /* Enable idle sleep mode for ADC */
                CPUDOZEbits.IDLEN = 1u;
                NOP();
                SLEEP();
                CPUDOZEbits.IDLEN = 0u;
                NOP();
            }    
            else    
            {
                mtouch_time_toScan = false;
                MTOUCH_Sensor_Sampled_ResetAll();  
                
                if(MTOUCH_Lowpower_Sensor_isAnySensorActive())
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
                #if (MTOUCH_BUTTONS_ENABLE == 1u)
                        MTOUCH_Button_Baseline_ForceUpdate();
                #endif
                        </#if>
                        <#if mtouch.prox.enabled?? >
                #if (MTOUCH_PROXIMITY_ENABLE == 1u)
                        MTOUCH_Proximity_Baseline_ForceUpdate();
                #endif
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
                
                
            }
            return false;
        }
        else
        {
</#if>
            if(MTOUCH_Sensor_SampleAll() == false)
            {
                <#if mtouch.lowPower.enabled??>
                if(mtouch_lowpowerEnabled)
                {
                    /* Enable idle sleep mode for ADC */
                    CPUDOZEbits.IDLEN = 1u;
                    NOP();
                    SLEEP();
                    CPUDOZEbits.IDLEN = 0u;
                    NOP();
                }     
                </#if>
                return false;
            }
        <#if mtouch.button.enabled??>
        #if (MTOUCH_BUTTONS_ENABLE == 1u)
            MTOUCH_Button_ServiceAll();             /* Execute state machine for all buttons w/scanned sensors */
        #endif
        </#if>
        <#if mtouch.prox.enabled??>
        #if (MTOUCH_PROXIMITY_ENABLE == 1u)
            MTOUCH_Proximity_ServiceAll();          /* Execute state machine for all proximity w/scanned sensors */
        #endif
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
            #if (MTOUCH_BUTTONS_ENABLE == 1u)
                mask = mask  |  MTOUCH_Button_Buttonmask_Get();
            #endif
            #if (MTOUCH_PROXIMITY_ENABLE == 1u)
                mask = mask  |  MTOUCH_Proximity_Proximitymask_Get();
            #endif
                if(mask != 0u )
<#elseif mtouch.button.enabled??>
            #if (MTOUCH_BUTTONS_ENABLE == 1u)
                if(MTOUCH_Button_Buttonmask_Get())
                if(mask != 0u )
            #endif
<#elseif mtouch.prox.enabled??>
            #if (MTOUCH_PROXIMITY_ENABLE == 1u)
                if(MTOUCH_Proximity_Proximitymask_Get())
                if(mask != 0u )
            #endif
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
#if (MTOUCH_BUTTONS_ENABLE == 1u)
    MTOUCH_Button_Tick();
#endif
    </#if>
    </#if>
    <#if mtouch.prox.enabled??>
    <#if mtouch.prox.activityTimeout != "0">
#if (MTOUCH_PROXIMITY_ENABLE == 1u)
    MTOUCH_Proximity_Tick();
#endif
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
    <#if pic.isLF == "false" >
    /* Enable ULP Regulator. */
    <#if pic.isK40 == "true" >
    VREGCONbits.VREGPM1 = 2;
    <#elseif  pic.is16F == "true">
    VREGCONbits.VREGPM = 1;
    <#else>
    VREGCONbits.VREGPM = 2;
    </#if>
    </#if>
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

<#if mtouch.scanRateControl.timer == "TMR2">  
    MTOUCH_SetTimer2Config();  
<#else>
    mTouchScanReload = MTOUCH_LOWPOWER_SCAN_RELOAD;
</#if>
    
    MTOUCH_Sensor_startLowpower();
}

/*
 * =======================================================================
 * MTOUCH_Service_exitLowpower
 * =======================================================================
 */
void MTOUCH_Service_exitLowpower(void)
{
    <#if pic.isLF == "false" >
    /* Enable MAIN Regulator in LP mode. */
    <#if pic.isK40 == "true" >
    VREGCONbits.VREGPM1 = 1;
    <#else>
    VREGCONbits.VREGPM = 1;
    </#if>
    </#if>
    uint8_t i;
    
    mtouch_lowpowerActivated = false;

<#if mtouch.scanRateControl.timer == "TMR2">
    MTOUCH_SetTimer2Config(); 
<#else>
    mTouchScanReload = MTOUCH_SCAN_RELOAD;
</#if>
    
    for(i=0;i < MTOUCH_SENSORS;i++)
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
