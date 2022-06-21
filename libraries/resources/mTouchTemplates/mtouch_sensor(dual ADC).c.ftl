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
#include <stdlib.h>
#include "../mcc.h"
<#if mtouch.sensor.AFA??>
<#else>
#include "mtouch_random.h"
</#if>
#include "mtouch_sensor.h"

#define Sensor_calculate_cal_thrs(oversampling)        ((mtouch_sensor_packetsample_t)(oversampling)<<1)      
#define Sensor_calculate_balance_point(oversampling)   ((mtouch_sensor_packetsample_t)(oversampling)<<9)

typedef ${mtouch.sensor.adc_sample.type} mtouch_sensor_adcsample_t;
#define MTOUCH_SENSOR_ADCSAMPLE_MIN                    ((mtouch_sensor_adcsample_t)${mtouch.sensor.adc_sample.min})
#define MTOUCH_SENSOR_ADCSAMPLE_MAX                    ((mtouch_sensor_adcsample_t)${mtouch.sensor.adc_sample.max})

typedef ${mtouch.sensor.packet.counter.type} mtouch_sensor_packetcounter_t;
#define MTOUCH_SENSOR_PACKETCOUNTER_MIN                ((mtouch_sensor_packetcounter_t)${mtouch.sensor.packet.counter.min})
#define MTOUCH_SENSOR_PACKETCOUNTER_MAX                ((mtouch_sensor_packetcounter_t)${mtouch.sensor.packet.counter.max})

typedef ${mtouch.sensor.packet.sample.type} mtouch_sensor_packetsample_t;
#define MTOUCH_SENSOR_PACKETSAMPLE_MIN                 ((mtouch_sensor_packetsample_t)${mtouch.sensor.packet.sample.min})
#define MTOUCH_SENSOR_PACKETSAMPLE_MAX                 ((mtouch_sensor_packetsample_t)${mtouch.sensor.packet.sample.max})

typedef uint8_t mtouch_sensor_addcap_t;
#define ADD_CAP_LIMIT                                  (uint8_t)0x0F

typedef uint8_t mtouch_sensor_time_t;
#define MIN_ACQ_TIME                                   (mtouch_sensor_time_t)1
#define MAX_ACQ_TIME                                   (mtouch_sensor_time_t)32
#define MIN_ACQ_TIME                                   (mtouch_sensor_time_t)1
#define MAX_PRECHARGE_TIME                             (mtouch_sensor_time_t)32
#define PACKET_PROCESS_TIME                            (mtouch_sensor_time_t)110  

<#if mtouch.sensor.AFA??>
typedef ${mtouch.sensor.packet.noise.type} mtouch_sensor_packetnoise_t;
#define MTOUCH_SENSOR_PACKETNOISE_MIN                  ((mtouch_sensor_packetnoise_t)${mtouch.sensor.packet.noise.min})
#define MTOUCH_SENSOR_PACKETNOISE_MAX                  ((mtouch_sensor_packetnoise_t)${mtouch.sensor.packet.noise.max})

typedef ${mtouch.sensor.AFA.sampleperiod.type} mtouch_sensor_sampleperiod_t;
#define MTOUCH_SENSOR_SAMPLEPERIOD_MIN                 ((mtouch_sensor_sampleperiod_t)MAX_ACQ_TIME+MAX_PRECHARGE_TIME+PACKET_PROCESS_TIME)
#define MTOUCH_SENSOR_SAMPLEPERIOD_MAX                 ((mtouch_sensor_sampleperiod_t)${mtouch.sensor.AFA.sampleperiod.max})      
<#else>
typedef ${mtouch.sensor.packet.sampledelay.type} mtouch_sensor_sampledelay_t;
</#if>

#define SCAN_RETRY                                      (uint8_t)5

typedef struct
{
    unsigned done:1;
    unsigned check:1;
    unsigned error:1;
    unsigned interrupted:1;
} mtouch_sensor_globalflags_t;

typedef struct
{
 const  enum mtouch_sensor_names        sensor;
 const  uint8_t                         adcon0;     
<#if mtouch.sensor.adxchImplemented??>
 const  uint8_t                         adxch;
<#elseif mtouch.sensor.adxch0Implemented??>
const  uint8_t                          adxch0;
const  uint8_t                          adxch1;
</#if>
        mtouch_sensor_time_t            precharge_time;
        mtouch_sensor_time_t            acquisition_time;
        mtouch_sensor_packetcounter_t   oversampling;
        mtouch_sensor_addcap_t          addcap;
        mtouch_sensor_sample_t          rawSample;
        unsigned                        sampled:1;
        unsigned                        active:1;
        unsigned                        calibrated:1;
        unsigned                        enabled:1;
        unsigned                        acqTime_cal:1;
} mtouch_sensor_t;

typedef struct
{
    mtouch_sensor_t* sensor_adc1;
    mtouch_sensor_t* sensor_adc2;
}mtouch_scan_group_t;

/*
 * =======================================================================
 * LOCAL FUNCTIONS
 * =======================================================================
 */
static enum mtouch_sensor_error Sensor_Service              (uint8_t scanGroup);
static enum mtouch_sensor_error Sensor_Acquisition          (mtouch_sensor_t* sensor_adc1,mtouch_sensor_t* sensor_adc2);
static enum mtouch_sensor_error Sensor_Acq_ExecutePacket    (mtouch_sensor_t* sensor_adc1,mtouch_sensor_t* sensor_adc2);
static void                     Sensor_postAcquisitionProcess(mtouch_sensor_t* sensor);
 
static void                     Sensor_loadADCSettings      (mtouch_sensor_t* sensor, uint8_t adc_index);
static uint8_t                  Sensor_getScanGroupIndex    (mtouch_sensor_t* sensor);
static inline void              Sensor_setSampled           (mtouch_sensor_t* sensor);
static inline void              Sensor_Sampled_Reset        (mtouch_sensor_t* sensor);
static inline void              Sensor_setActive            (mtouch_sensor_t* sensor);
static inline void              Sensor_setInactive          (mtouch_sensor_t* sensor);
static inline bool              Sensor_isActive             (mtouch_sensor_t* sensor);

static        bool              Sensor_isEnabled            (mtouch_sensor_t* sensor);

static inline bool              Sensor_isCalibrated         (mtouch_sensor_t* sensor);
static inline void              Sensor_setCalibrated        (mtouch_sensor_t* sensor);
static inline void              Sensor_setCalibratAcqTime   (mtouch_sensor_t* sensor);
static inline bool              Sensor_isCalibratingAcqTime (mtouch_sensor_t* sensor);
static void                     Sensor_autoCalibration      (mtouch_sensor_t* sensor);


static void                     Sensor_RawSample_Update     (mtouch_sensor_t* sensor);

static void                     Sensor_DefaultCallback      (enum mtouch_sensor_names sensor);

<#if mtouch.sensor.AFA??>
static enum mtouch_sensor_error Sensor_Scanfrequency_Evaluation(mtouch_sensor_t* sensor_adc1,mtouch_sensor_t* sensor_adc2);
<#else>
static void                     MTOUCH_Delay                (void);
</#if>

/*
 * =======================================================================
 *  Callback Function Pointers
 * =======================================================================
 */
static void (*callback_sampled)(enum mtouch_sensor_names sensor) = Sensor_DefaultCallback;

/*
 * =======================================================================
 *  Local Variables
 * =======================================================================
 */
static mtouch_sensor_packetsample_t     packet_sample[2];
 <#if mtouch.sensor.AFA??>
static mtouch_sensor_packetsample_t     packet_noise;
<#else>
static uint8_t                          mtouch_sample_delay;
</#if>
static bool                             lowpowerActivated = false;
static volatile mtouch_sensor_globalflags_t      sensor_globalFlags;
<#if mtouch.sensor.AFA??>
/*
 * =======================================================================
 *  Sensor runtime data
 * =======================================================================
 */
static mtouch_sensor_sampleperiod_t     sample_period = MTOUCH_SENSOR_SAMPLEPERIOD_MIN;    
</#if>

/*
 * =======================================================================
 *  Sensor Configurations
 * =======================================================================
 */
static mtouch_sensor_t mtouch_sensor[MTOUCH_SENSORS] = {
<#list 0..mtouch.sensor.items?size-1 as i>
    {   ${mtouch.sensor.items[i].name},
        MTOUCH_SENSOR_ADCON0_${mtouch.sensor.items[i].name},
        <#if mtouch.sensor.adxchImplemented??>
        MTOUCH_SENSOR_ADXCH_${mtouch.sensor.items[i].name},
        <#elseif mtouch.sensor.adxch0Implemented??>
        MTOUCH_SENSOR_ADXCH0_${mtouch.sensor.items[i].name},
        MTOUCH_SENSOR_ADXCH1_${mtouch.sensor.items[i].name},
        </#if>
        MTOUCH_SENSOR_PRECHARGE_${mtouch.sensor.items[i].name},
        MTOUCH_SENSOR_ACQUISITION_${mtouch.sensor.items[i].name},
        MTOUCH_SENSOR_OVERSAMPLING_${mtouch.sensor.items[i].name},
        MTOUCH_SENSOR_ADDITIONALCAP_${mtouch.sensor.items[i].name},
        0,0,0,0,0,0
    },
</#list>
};

/*
 * =======================================================================
 *  Sensor Group Configurations
 * =======================================================================
 */
static  mtouch_scan_group_t const  sensor_scan_group[MTOUCH_SCAN_GROUPS] = {
    <#list 0..mtouch.scangroup.items?size-1 as i>
    {<#if mtouch.scangroup.items[i].adc1_index != "DUMMY_SENSOR"> &(mtouch_sensor[${mtouch.scangroup.items[i].adc1_index}])<#else> NULL </#if>,<#if mtouch.scangroup.items[i].adc2_index != "DUMMY_SENSOR">&(mtouch_sensor[${mtouch.scangroup.items[i].adc2_index}])<#else> NULL </#if>},
    </#list>
};

/*
 * =======================================================================
 * MTOUCH_Sensor_Init()
 * =======================================================================
 */
enum mtouch_sensor_error MTOUCH_Sensor_Initialize(enum mtouch_sensor_names sensor)
{
   
    MTOUCH_Sensor_Enable(sensor);
    MTOUCH_Sensor_Calibrate(sensor);
    Sensor_Sampled_Reset(&mtouch_sensor[sensor]);
    
    return MTOUCH_SENSOR_ERROR_none;
}

/*
 * =======================================================================
 * MTOUCH_Sensor_InitializeAll()
 * =======================================================================
 */
void MTOUCH_Sensor_InitializeAll(void)
{
    enum mtouch_sensor_names sensor; 
    
    for (sensor = 0; sensor < MTOUCH_SENSORS; sensor++)
    {
        MTOUCH_Sensor_Initialize(sensor);
    }
}

/*
 * =======================================================================
 * MTOUCH_SensorScan_Initialize
 * =======================================================================
 *  initialization for ADC and Timer module
 */
void MTOUCH_Sensor_Scan_Initialize(void)
{
    <#if mtouch.sensor.AFA??>
    T${mtouch.sensor.AFA.timer}CONbits.T${mtouch.sensor.AFA.timer}CKPS = ${mtouch.sensor.AFA.timerPrescaler};
    </#if>

    AD1CON0     = (uint8_t)0;                            /* overwrite the ADC configuration for mTouch scan */
    AD2CON0     = (uint8_t)0;  
    ADCOMCON    = (uint8_t)${pic.adc.adcomcon_value};
    AD1CON3     = (uint8_t)0b01000000;
    AD2CON3     = (uint8_t)0b01000000;
    
    <#if mtouch.sensor.txReg?? >
    ADCTX   = (uint8_t)0x${mtouch.sensor.txReg.ADCTX};
    AD1TX0  = (uint8_t)0x${mtouch.sensor.txReg.AD1TX0};
    AD1TX1  = (uint8_t)0x${mtouch.sensor.txReg.AD1TX1};
    AD2TX0  = (uint8_t)0x${mtouch.sensor.txReg.AD2TX0};
    AD2TX1  = (uint8_t)0x${mtouch.sensor.txReg.AD2TX1};
    </#if>
}

/*
 * =======================================================================
 * MTOUCH_Sensor_SampleAll()
 * =======================================================================
 *  
 */

bool MTOUCH_Sensor_SampleAll(void)
{
    uint8_t group;   
    for (group = 0; group < MTOUCH_SCAN_GROUPS; group++)
    {
        if(Sensor_Service(group)!= MTOUCH_SENSOR_ERROR_none)
            return false;
    }
    return true;
}

void MTOUCH_Sensor_startLowpower(void)
{
    lowpowerActivated = true;
}

void MTOUCH_Sensor_exitLowpower(void)
{
    lowpowerActivated = false;
}

/*
 * =======================================================================
 * MTOUCH_Sensor_isAnySensorActive()
 * =======================================================================
 *  
 */
bool MTOUCH_Sensor_isAnySensorActive(void)
{
    enum mtouch_sensor_names sensor;   
    
    for (sensor = 0; sensor < MTOUCH_SENSORS; sensor++)
    {
        if(mtouch_sensor[sensor].active)
            return true;
    }
    
    return false;
}

/*
 * =======================================================================
 * Sensor_Service()
 * =======================================================================
 */
static enum mtouch_sensor_error Sensor_Service(uint8_t scanGroup)
{
    mtouch_sensor_t*       sensor_adc1;
    mtouch_sensor_t*       sensor_adc2;   
    
    sensor_adc1 = (mtouch_sensor_t*)sensor_scan_group[scanGroup].sensor_adc1;
    sensor_adc2 = (mtouch_sensor_t*)sensor_scan_group[scanGroup].sensor_adc2;
    
    enum mtouch_sensor_error error = Sensor_Acquisition(sensor_adc1,sensor_adc2);

    /* Validate sensor output. Handle errors. */
    switch(error)
    {
        case MTOUCH_SENSOR_ERROR_none:
        {
            if(Sensor_isEnabled(sensor_adc1))
            {
                /* Stop update the sensor Raw reading in low power mode, so that  
                   the current sensor reading will compare with the last sensor 
                   reading in normal power mode.
                */ 
                if(!lowpowerActivated)
                {
                    Sensor_RawSample_Update(sensor_adc1);
                }
                Sensor_setSampled(sensor_adc1);
                callback_sampled(sensor_adc1->sensor);
            }
            if(Sensor_isEnabled(sensor_adc2))
            {
                if(!lowpowerActivated)
                {
                    Sensor_RawSample_Update(sensor_adc2);
                }
                Sensor_setSampled(sensor_adc2);
                callback_sampled(sensor_adc2->sensor);
            }
        }
        break;

        case MTOUCH_SENSOR_ERROR_invalid_index:          break;
        case MTOUCH_SENSOR_ERROR_interrupt_notEnabled:   break;
        case MTOUCH_SENSOR_ERROR_invalid_calibrate:      break;
        case MTOUCH_SENSOR_ERROR_tooManyRetries:         break;
        case MTOUCH_SENSOR_ERROR_scanOverrun:            break;
        default: break;
    }

    return error;
}

static uint8_t Sensor_getScanGroupIndex(mtouch_sensor_t* sensor)
{
    uint8_t sensorGroup;
    for(sensorGroup = 0; sensorGroup < MTOUCH_SCAN_GROUPS; sensorGroup++)
    {
        if(sensor_scan_group[sensorGroup].sensor_adc1 == sensor)
            return 0;
        if(sensor_scan_group[sensorGroup].sensor_adc2 == sensor)
            return 1;
    }
    return 0;
}

/*
 * =======================================================================
 * Sensor_Acquisition()
 * =======================================================================
 */
static enum mtouch_sensor_error Sensor_Acquisition(mtouch_sensor_t* sensor_adc1,mtouch_sensor_t* sensor_adc2)
{
    uint8_t retry = SCAN_RETRY;
    
    /* Input validation */
    if (sensor_adc1 == NULL && sensor_adc2 == NULL)
    {
        return MTOUCH_SENSOR_ERROR_invalid_index;
    }

    /*
     * =======================================================================
     * Production Scan
     * =======================================================================
     */
    while(Sensor_Acq_ExecutePacket(sensor_adc1,sensor_adc2))
    {
        retry--;
        if(retry == 0)
        {
            return MTOUCH_SENSOR_ERROR_tooManyRetries;
        }
    }
    
    if(sensor_adc1 != NULL)
    {
        Sensor_postAcquisitionProcess(sensor_adc1);
    }
    
    if(sensor_adc2 !=NULL)
    {
        Sensor_postAcquisitionProcess(sensor_adc2);
    }
    
    <#if mtouch.sensor.AFA??>
    if((Sensor_isActive(sensor_adc1) && Sensor_isCalibrated(sensor_adc1))
     ||(Sensor_isActive(sensor_adc2) && Sensor_isCalibrated(sensor_adc2)))
    {
        return Sensor_Scanfrequency_Evaluation(sensor_adc1,sensor_adc2);
    }
    </#if>
    
    return MTOUCH_SENSOR_ERROR_none;
}

static void Sensor_postAcquisitionProcess(mtouch_sensor_t* sensor)
{
    mtouch_sensor_sample_t deviation;
    uint8_t adcIndex = Sensor_getScanGroupIndex(sensor);           
    
    if(Sensor_isEnabled(sensor))
        deviation = (mtouch_sensor_sample_t)abs(packet_sample[adcIndex] - sensor->rawSample);
    else
        deviation = 0;
    
    if(deviation > MTOUCH_SENSOR_ACTIVE_THRESHOLD)
        Sensor_setActive(sensor);
    else
        Sensor_setInactive(sensor);
}

void MTOUCH_Sensor_NotifyInterruptOccurred(void)
{   
    sensor_globalFlags.interrupted = 1;
}


static void Sensor_loadADCSettings(mtouch_sensor_t* sensor, uint8_t adc_index)
{
    if (sensor == NULL)
        return;

    uint8_t addressOffset = (adc_index) ? 0x80 : 0x00;

    *(&AD1CON0 + addressOffset) = (uint8_t) sensor->adcon0;
    *(&AAD1CAP + addressOffset) = (uint8_t) sensor->addcap;
    <#if pic.adc.trigsel??>
    *(&AAD1CON2 + addressOffset) = (uint8_t)(${pic.adc.trigsel}<<4);
    </#if>
    *(&AAD1GRD + addressOffset) &= (uint8_t) 0b11111110;
    <#if mtouch.sensor.adxchImplemented??>
    *(&AAD1CH + addressOffset)  = (uint8_t) sensor->adxch;
    <#elseif mtouch.sensor.adxch0Implemented??>
    *(&AAD1CH0 + addressOffset)  = (uint8_t) sensor->adxch0;
    *(&AAD1CH1 + addressOffset)  = (uint8_t) sensor->adxch1;
    </#if>

    if (Sensor_isCalibrated(sensor))
    {
        *(&AD1PRECON + addressOffset) = (uint8_t) sensor->precharge_time;
        *(&AD1ACQCON + addressOffset) = (uint8_t) sensor->acquisition_time;
    }
    else
    {
        *(&AD1PRECON + addressOffset) = MAX_PRECHARGE_TIME;
        if (Sensor_isCalibratingAcqTime(sensor))
            *(&AD1ACQCON + addressOffset) = (uint8_t) sensor->acquisition_time;
        else
            *(&AD1ACQCON + addressOffset) = MAX_ACQ_TIME;
    }

    packet_sample[adc_index] = Sensor_calculate_balance_point(sensor->oversampling);
}

/*
 * =======================================================================
 * Sensor_Acq_ExecutePacket()
 * =======================================================================
 */
static enum mtouch_sensor_error Sensor_Acq_ExecutePacket(mtouch_sensor_t* sensor_adc1,mtouch_sensor_t* sensor_adc2)
{
    uint8_t ADxIF_flag = 0;
    mtouch_sensor_packetcounter_t   packet_counter;
    
    <#if mtouch.sensor.AFA??>
    mtouch_sensor_adcsample_t       last_a = 0;
    mtouch_sensor_adcsample_t       last_b = 0;
    uint8_t                         activeSensor = 0;
    </#if>
    
    <#if mtouch.shareADC??>
    uint8_t                         ADCOMCON_temp;
    uint8_t                         AD1CON2_temp,AD2CON2_temp;
    </#if>
    
     /* If only one sensor in the scan group is disabled, the sensor will be forced on during scan.
     * otherwise, the other sensor result might have an offset due to the coupling change between these two sensors
     * in the same scan group.
     */
    uint8_t sensor1ForceEnabled = 0, sensor2ForceEnabled = 0;
    if(sensor_adc1 != NULL && sensor_adc2 != NULL)
    {
        if (sensor_adc1->enabled == false && sensor_adc2->enabled == true)
        {
            sensor_adc1->enabled = 1;
            sensor1ForceEnabled = 1;
        }
        else if (sensor_adc2->enabled == false && sensor_adc1->enabled == true)
        {
            sensor_adc2->enabled = 1;
            sensor2ForceEnabled = 1;
        }
        else if(sensor_adc1->enabled == false && sensor_adc2->enabled == false)
        {
            return MTOUCH_SENSOR_ERROR_none;
        }
        else {
            /* Do Nothing */
        }   
    }
    else if(sensor_adc1 == NULL && sensor_adc2 != NULL)
    {
        if(sensor_adc2->enabled == false)
        {
            return MTOUCH_SENSOR_ERROR_none;
        }
        else {
            /* Do Nothing */
        }  
    }
    else if(sensor_adc1 != NULL && sensor_adc2 == NULL)
    {   
        if(sensor_adc1->enabled == false)
        {
            return MTOUCH_SENSOR_ERROR_none;
        }
        else {
            /* Do Nothing */
        }  
    }
    else
    {
        /* Do Nothing */
    }
    <#if mtouch.sensor.AFA??>
    if(Sensor_isActive(sensor_adc2))
        activeSensor = 1;
    else
    {
        //activeSensor default to 0
    }
    </#if>
    
    <#if mtouch.shareADC??>
    ADCOMCON_temp = ADCOMCON;       /* store the current ADC configuration */
    AD1CON2_temp  = AD1CON2;
    AD2CON2_temp  = AD2CON2;
    MTOUCH_Sensor_Scan_Initialize();
    </#if>

    
    
    if(sensor_adc1!=NULL)
    {
        packet_counter  = (mtouch_sensor_packetcounter_t)(sensor_adc1->oversampling-(mtouch_sensor_packetcounter_t)1);
        ADxIF_flag = 0;
        <#if mtouch.sensor.guard_dualadc.grdasel_adc1 ??>
        AAD1GRD = 0b01000000;
        AAD2GRD = 0b00000000;
        APFCONbits.GRDASEL = ${mtouch.sensor.guard_dualadc.grdasel_adc1};
        </#if>
    }
    else
    {
        packet_counter  = (mtouch_sensor_packetcounter_t)(sensor_adc2->oversampling-(mtouch_sensor_packetcounter_t)1);
        ADxIF_flag = 1;
        <#if mtouch.sensor.guard_dualadc.grdasel_adc2 ??>
        AAD1GRD = 0b00000000;
        AAD2GRD = 0b01000000;
        APFCONbits.GRDASEL = ${mtouch.sensor.guard_dualadc.grdasel_adc2};
        </#if>
    }
        
    Sensor_loadADCSettings(sensor_adc1,0);
    Sensor_loadADCSettings(sensor_adc2,1);
    
    sensor_globalFlags.done = 0;
    sensor_globalFlags.error = 0;
    sensor_globalFlags.interrupted = 0;
    
    <#if mtouch.sensor.AFA??>
    TMR${mtouch.sensor.AFA.timer}_LoadPeriodRegister(sample_period);            /* Use timer${mtouch.sensor.AFA.timer} to schedule the scan */
    TMR${mtouch.sensor.AFA.timer}_StartTimer();
    packet_noise     = 0;
    <#else>
    mtouch_sample_delay = MTOUCH_Random();    /* Pick a random scan delay */
    ADCOMCONbits.GO_ALL = 1;
    </#if>
    /* Perform packet samples */
    do
    {
        if(ADxIF_flag == 0)
        {
            if      (PIR1bits.AD1IF == 0)   { sensor_globalFlags.check = 0; }
            while   (PIR1bits.AD1IF == 0)   { }
            PIR1bits.AD1IF  = 0;
        }
        else
        {
            if      (PIR2bits.AD2IF == 0)   { sensor_globalFlags.check = 0; }
            while   (PIR2bits.AD2IF == 0)   { }
            PIR2bits.AD2IF  = 0;
        }
        
        AAD1GRD  ^= 0b00100001;     /* Toggle guard/TX polarity     */
        AAD2GRD  ^= 0b00100001;     /* Toggle guard/TX polarity     */
        AAD1CON3 ^= 0b11000000;     /* Toggle precharge polarities  */
        AAD2CON3 ^= 0b11000000;
  
        if ((packet_counter & 0x01) == 0)
        {   /* Process a 'B' result */
            packet_sample[0] += AAD1RES0;
            packet_sample[1] += AAD2RES0;
            <#if mtouch.sensor.AFA??>
            if(activeSensor ==0)
            {
                packet_noise += (mtouch_sensor_packetsample_t)abs(last_b-AAD1RES0);
                last_b = AAD1RES0;
            }
            else                
            {
                packet_noise += (mtouch_sensor_packetsample_t)abs(last_b-AAD2RES0);
                last_b = AAD2RES0;
            }
            </#if>
        }
        else
        {   /* Process an 'A' result */
            packet_sample[0] -= AAD1RES0;
            packet_sample[1] -= AAD2RES0;
            <#if mtouch.sensor.AFA??>
            if(activeSensor ==0)
            {
                packet_noise +=(mtouch_sensor_packetsample_t)abs(last_a-AAD1RES0); 
                last_a = AAD1RES0;
            }
            else                
            {
                packet_noise +=(mtouch_sensor_packetsample_t)abs(last_a-AAD2RES0); 
                last_a = AAD1RES0;
            }
            </#if>
        }
        
        <#if mtouch.sensor.AFA??>
        <#else>
        MTOUCH_Delay();
        ADCOMCONbits.GO_ALL = 1;
        </#if>

        if (packet_counter == 0)
        {
            /* Complete packet. Perform final storage steps. */
            sensor_globalFlags.done   = (uint8_t)1;
        }
        packet_counter--;

        if (sensor_globalFlags.check != 0)
        {
            sensor_globalFlags.error = 1;
            sensor_globalFlags.done  = 1;
        }
        sensor_globalFlags.check = 1;
    } while(sensor_globalFlags.done == 0);

    <#if mtouch.sensor.AFA??>
    TMR${mtouch.sensor.AFA.timer}_StopTimer();
    </#if>
    <#if mtouch.shareADC??>
    ADCOMCON = ADCOMCON_temp;       /* restore the previous ADC configuration */
    AD1CON2  = AD1CON2_temp;
    AD2CON2  = AD2CON2_temp;
    </#if>
    
    if(sensor_globalFlags.error)
    {
        return MTOUCH_SENSOR_ERROR_scanOverrun;
    }
    
    if(sensor_globalFlags.interrupted)
    {
        return MTOUCH_SENSOR_ERROR_interruptedScan;
    }

    /* Disable the sensor if it was forced on during scan */
    if (sensor1ForceEnabled)
        sensor_adc1->enabled = 0;

    if (sensor2ForceEnabled)
        sensor_adc2->enabled = 0;
    
    /* if any sensor in the scan group is calibrating */
    if(Sensor_isEnabled(sensor_adc1) && !Sensor_isCalibrated(sensor_adc1))
    <#if  mtouch.sensor.autoCalibrationEnable == "True">    
        Sensor_autoCalibration(sensor_adc1);
    <#else>
        Sensor_setCalibrated(sensor_adc1);                                       /* Skip sensor autocalibration based on MCC configuration */                               
    </#if>
    
    if(Sensor_isEnabled(sensor_adc2) && !Sensor_isCalibrated(sensor_adc2))
    <#if  mtouch.sensor.autoCalibrationEnable == "True">    
        Sensor_autoCalibration(sensor_adc2);
    <#else>
        Sensor_setCalibrated(sensor_adc2);                                       /* Skip sensor autocalibration based on MCC configuration */                               
    </#if>
    
    AD1PRECON = 0;
    AD2PRECON = 0;
    AD1ACQCON = 0;
    AD2ACQCON = 0;
    AD1CON0bits.ADON = 0;
    AD2CON0bits.ADON = 0;
    
    return MTOUCH_SENSOR_ERROR_none;
}

<#if mtouch.sensor.AFA??>
<#else>
static void MTOUCH_Delay(void)
{
    for(uint8_t i = mtouch_sample_delay;i>0;i--)
    { }
}
</#if>

/*
 * 
 *=======================================================================
 * Automatic Sensor Calibration for internal capacitor and acquisition time
 *=======================================================================
 *
 */
static void Sensor_autoCalibration(mtouch_sensor_t* sensor)
{
    uint8_t adcIndex  = Sensor_getScanGroupIndex(sensor);

    if(!Sensor_isCalibratingAcqTime(sensor))                   /* Calibrating internal capacitor */
    {
        if(packet_sample[adcIndex] > Sensor_calculate_balance_point(sensor->oversampling))
        {
            if(++(sensor->addcap) >= ADD_CAP_LIMIT)
                Sensor_setCalibratAcqTime(sensor);
        }
        else
        {
             Sensor_setCalibratAcqTime(sensor);
        }
    }
    else                                                            /* Calibrating acquisition time */
    {
        if((mtouch_sensor_packetsample_t)abs(packet_sample[adcIndex] - sensor->rawSample) < Sensor_calculate_cal_thrs(sensor->oversampling))
        {
            sensor->precharge_time = MAX_PRECHARGE_TIME;
            Sensor_setCalibrated(sensor);
        }
        else
        {   
            /* Using Increment of 2 to ensure enough margin when
               finger is touching the sensor 
            */
            sensor->acquisition_time += (uint8_t)2;
            if((sensor->acquisition_time)>=MAX_ACQ_TIME)
            {
                sensor->precharge_time = MAX_PRECHARGE_TIME;
                Sensor_setCalibrated(sensor);
            }
        }     
    }
}

<#if mtouch.sensor.AFA??>
/*
 * 
 *=======================================================================
 * Automatic Frequency Adaptation
 *=======================================================================
 *
 */
static enum mtouch_sensor_error Sensor_Scanfrequency_Evaluation(mtouch_sensor_t* sensor_adc1,mtouch_sensor_t* sensor_adc2)
{
    uint8_t i;
    const mtouch_sensor_sampleperiod_t  frequency_hop[5] = {0,13,28,30,23};
    mtouch_sensor_packetnoise_t         packet_noise_Max;
    mtouch_sensor_sampleperiod_t        best_sample_period;
    mtouch_sensor_packetsample_t        best_packet_sample[2];   
    uint8_t                             retry;
    
    packet_noise_Max      = packet_noise + (packet_noise>>2); /* put stickiness to the current scan frequency */
    best_sample_period    = sample_period;
    best_packet_sample[0] = packet_sample[0];
    best_packet_sample[1] = packet_sample[1];
    
    for(i=(uint8_t)0;i<(uint8_t)5;i++)
    {   
        sample_period += frequency_hop[i];
        if(sample_period > MTOUCH_SENSOR_SAMPLEPERIOD_MAX)
        {
            sample_period-=MTOUCH_SENSOR_SAMPLEPERIOD_MAX;
            sample_period+=MTOUCH_SENSOR_SAMPLEPERIOD_MIN;
        }
        else if(sample_period < MTOUCH_SENSOR_SAMPLEPERIOD_MIN)
        {
            sample_period += MTOUCH_SENSOR_SAMPLEPERIOD_MIN;
        }
        
        retry = SCAN_RETRY;
        
        while(Sensor_Acq_ExecutePacket(sensor_adc1,sensor_adc2))
        {
            retry--;
            if(retry == 0)
            {
                return MTOUCH_SENSOR_ERROR_tooManyRetries;
            }
        }
         
        if(packet_noise_Max < packet_noise)
        {
            packet_noise_Max = packet_noise;
            best_sample_period = sample_period;
            best_packet_sample[0] = packet_sample[0];
            best_packet_sample[1] = packet_sample[1];
        }       
    }
    
    sample_period = best_sample_period;
    packet_sample[0] = best_packet_sample[0];
    packet_sample[1] = best_packet_sample[1];
    
    return MTOUCH_SENSOR_ERROR_none;
}
</#if>

/*
 * =======================================================================
 * Sensor Raw Sample
 * =======================================================================
 */ 
mtouch_sensor_sample_t MTOUCH_Sensor_RawSample_Get(enum mtouch_sensor_names name) /* Global */
{
    if (name < MTOUCH_SENSORS)
    {
        return mtouch_sensor[name].rawSample;
    }
    else
        return (mtouch_sensor_sample_t)0;
}

static void Sensor_RawSample_Update(mtouch_sensor_t* sensor) /* Local */
{
    uint8_t adcIndex = Sensor_getScanGroupIndex(sensor);
    
    if (INTCONbits.GIE == (uint8_t)1)
    {
        INTCONbits.GIE = (uint8_t)0;
        sensor->rawSample = packet_sample[adcIndex];
        INTCONbits.GIE = (uint8_t)1;
    }
    else
    {
        sensor->rawSample = packet_sample[adcIndex];
    }
}

/*
 * =======================================================================
 * Sensor Sampled Callback
 * =======================================================================
 */ 
static void Sensor_DefaultCallback(enum mtouch_sensor_names sensor) { }
void MTOUCH_Sensor_SetSampledCallback(void (*callback)(enum mtouch_sensor_names sensor))
{
    callback_sampled = callback;
}

/*
 * =======================================================================
 *  Enable/Disable Sensor
 * =======================================================================
 * 
 */
void MTOUCH_Sensor_Disable(enum mtouch_sensor_names sensor)
{
    if(sensor < MTOUCH_SENSORS)   
        mtouch_sensor[sensor].enabled = 0;
}

void MTOUCH_Sensor_Enable(enum mtouch_sensor_names sensor)
{
    if(sensor < MTOUCH_SENSORS)   
        mtouch_sensor[sensor].enabled = 1;
}

bool MTOUCH_Sensor_isEnabled(enum mtouch_sensor_names sensor)
{
    if(sensor < MTOUCH_SENSORS)   
        return (bool)mtouch_sensor[sensor].enabled;
    else
        return false;
}

static bool Sensor_isEnabled(mtouch_sensor_t* sensor)
{
    if(sensor!=NULL)
        return (bool)sensor->enabled;
    else
        return false;
}



/*
 * =======================================================================
 *  Sensor active status
 * =======================================================================
 * 
 */

static inline void Sensor_setActive(mtouch_sensor_t* sensor)
{
    sensor->active = 1;
}

static inline void Sensor_setInactive(mtouch_sensor_t* sensor)
{
    sensor->active = 0;
}

static inline bool Sensor_isActive(mtouch_sensor_t* sensor)
{
    if(sensor == NULL)
        return false;
        
    return (bool)sensor->active;
}

bool MTOUCH_Sensor_isActive(enum mtouch_sensor_names sensor)
{
    if(sensor<=MTOUCH_SENSORS)
        return (bool)mtouch_sensor[sensor].active;
    return false;
}

/*
 * =======================================================================
 *  Sensor calibrate status
 * =======================================================================
 * 
 */

void MTOUCH_Sensor_Calibrate(enum mtouch_sensor_names sensor)
{
    if(sensor < MTOUCH_SENSORS)
    {
        mtouch_sensor[sensor].calibrated = 0;
    }
}

bool MTOUCH_Sensor_isCalibrated(enum mtouch_sensor_names sensor)
{
    if(sensor < MTOUCH_SENSORS)
        return (bool)mtouch_sensor[sensor].calibrated;
    else
        return false;
}

static inline bool Sensor_isCalibrated(mtouch_sensor_t* sensor)
{
    return (bool)sensor->calibrated;
}

static inline void Sensor_setCalibrated(mtouch_sensor_t* sensor)
{
    sensor->calibrated = 1;
    sensor->acqTime_cal = 0;
}

static inline void Sensor_setCalibratAcqTime(mtouch_sensor_t* sensor)
{
    sensor->acqTime_cal = 1;
    sensor->acquisition_time = MIN_ACQ_TIME;
}

static inline bool Sensor_isCalibratingAcqTime(mtouch_sensor_t* sensor)
{
    return (bool)sensor->acqTime_cal;

}

/*
 * =======================================================================
 *  Sensor sample status
 * =======================================================================
 * 
 */

void MTOUCH_Sensor_Sampled_ResetAll(void)
{
    mtouch_sensor_t* sensor;
    for(sensor = &mtouch_sensor[0];sensor<= &mtouch_sensor[MTOUCH_SENSORS-1];sensor++)
    {      
        Sensor_Sampled_Reset(sensor);
    }
}

bool MTOUCH_Sensor_wasSampled(enum mtouch_sensor_names sensor) 
{
    return (bool)mtouch_sensor[sensor].sampled;
}

static inline void Sensor_Sampled_Reset(mtouch_sensor_t* sensor) 
{
    sensor->sampled = 0;
}

static inline void Sensor_setSampled(mtouch_sensor_t* sensor) 
{
    sensor->sampled = 1;
}


/*
 * =======================================================================
 *  Sensor calibration values
 * =======================================================================
 * 
 */
uint8_t MTOUCH_Sensor_AdditionalCap_Get(enum mtouch_sensor_names name) 
{
     if(name < MTOUCH_SENSORS)
        return (uint8_t)(mtouch_sensor[name].addcap<<1);  /* because the this ADC has a resolution of 2pF */     
     else
        return 0;
}

uint8_t MTOUCH_Sensor_AcquisitionTime_Get(enum mtouch_sensor_names name) 
{
     if(name < MTOUCH_SENSORS)
        return mtouch_sensor[name].acquisition_time;
     else
        return 0;
}

uint8_t MTOUCH_Sensor_PreChargeTime_Get(enum mtouch_sensor_names name) 
{
     if(name < MTOUCH_SENSORS)
        return mtouch_sensor[name].precharge_time;
     else
        return 0;
}

uint8_t MTOUCH_Sensor_Oversampling_Get(enum mtouch_sensor_names name) 
{
    if(name < MTOUCH_SENSORS)
       return (uint8_t)(mtouch_sensor[name].oversampling);
    else
       return 0;
}

void MTOUCH_Sensor_Oversampling_Set(enum mtouch_sensor_names name, uint8_t value ) 
{
    if(name < MTOUCH_SENSORS)
    {
       mtouch_sensor[name].oversampling =  (mtouch_sensor_packetcounter_t)(value);
    }
}
