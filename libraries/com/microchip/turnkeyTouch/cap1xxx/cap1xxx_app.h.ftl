/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdint.h>
#include <stdbool.h>    
#include <xc.h>
#include "../mcc.h"
<#if deviceFamily =="CAP12" >
#include "cap12xx.h"
<#else>
#include "cap11xx.h"
</#if>

#define CAPxxxx_ADDRESS     ${I2CAddress}  //7-bit I2C Address **Note: the i2c libraries will add automatically add the read or write bit  
#define CAPxxxx_ID          ${deviceID}       
#define NUMBER_OF_SENSORS   ${numberOfSensor}  

#define CAP_error_None                  0
#define CAP_error_DeviceIDMismatch      0xFF
       
//================================================================
// CAP Driver API
//================================================================

<#if resetPinSettings??>
inline  void    CAP_holdInReset     (void);
inline  void    CAP_resetRelease    (void);

</#if>
inline  uint8_t CAP_readRegister    (uint8_t addr);
inline  void    CAP_writeRegister   (uint8_t addr,uint8_t data);

uint8_t CAP_init    (uint8_t CAP_Configuration[][2],uint8_t numberOfConfigRegister);

int8_t  CAP_getSensorDelta          (uint8_t sensor);
uint8_t CAP_getGeneralStatus        (void);
uint8_t CAP_getSensorStatus         (void);
void    CAP_resetSensorStatus       (void);
uint8_t CAP_getMainControl          (void);
uint8_t CAP_getConfiguration2       (void);
void    CAP_enterStandby            (void);
void    CAP_exitStandby             (void);
void    CAP_enterDeepSleep          (void);
void    CAP_exitDeepSleep           (void);
bool    CAP_isCalibrated            (void);
void    CAP_setGain                 (uint8_t gain);
void    CAP_setInputThresholds      (uint8_t sensorChannel, uint8_t sensorThreshold);
void    CAP_setDeltaSensitivity     (uint8_t sensitivityCode);
void    CAP_setSamplingConfig       (uint8_t config);
uint8_t CAP_getNoiseFlag            (void);
void    CAP_disableRFNoise          (void);
<#if hasLED=="true">

/*=============================================================================
 * LED Drive API
 * =============================================================================
 */
void    CAP_LED_Output_Type_Set         (uint8_t value);
void    CAP_LED_Sensor_Linking_Set      (uint8_t value);
void    CAP_LED_Polarity_Set            (uint8_t value);
void    CAP_LED_Output_Control_Set      (uint8_t value);
void    CAP_LED_Linked_Transition_Set   (uint8_t value);
void    CAP_LED_Mirror_Set              (uint8_t value);
void    CAP_LED_Behavior_Set            (uint8_t ledChannel, uint8_t behavior);
</#if>