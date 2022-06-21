/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdint.h>
#include <xc.h>
#include "../mcc.h"
<#if deviceName == "CAP1114">
#include "../cap1x14Drivers/cap1114.h"
</#if>
<#if deviceName == "CAP1214">
#include "../cap1x14Drivers/cap1214.h"
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
inline  void    CAP_holdInReset         (void);
inline  void    CAP_resetRelease        (void);

</#if>
inline  uint8_t CAP_readRegister        (uint8_t addr);
inline  void    CAP_writeRegister       (uint8_t addr,uint8_t data);

uint8_t     CAP_init    (uint8_t CAP_Configuration[][2],uint8_t numberOfConfigRegister);

int8_t      CAP_getSensorDelta          (uint8_t sensor);
uint8_t     CAP_getMainStatusControl    (void);
uint8_t     CAP_getGroupStatus          (void);
uint16_t    CAP_getSensorStatus         (void);
void        CAP_resetSensorStatus       (void);
uint8_t     CAP_getSliderPosition       (void);
uint8_t     CAP_getConfiguration2       (void);
void        CAP_enterSleep              (void);
void        CAP_exitSleep               (void);
void        CAP_enterDeepSleep          (void);
void        CAP_exitDeepSleep           (void);
bool        CAP_isCalibrated            (void);
void        CAP_setSamplingConfig       (uint8_t config);
uint16_t    CAP_getNoiseFlag            (void);
void        CAP_disableRFNoise          (void);
<#if hasLED=="true">

/*=============================================================================
 * LED Drive API
 * =============================================================================
 */
void        CAP_LED_Output_Type_Set         (uint8_t value);
void        CAP_LED_Sensor_Linking_Set      (uint8_t value);
void        CAP_LED_Polarity_1_Set          (uint8_t value);
void        CAP_LED_Polarity_2_Set          (uint8_t value);
void        CAP_LED_Output_Control_1_Set    (uint8_t value);
void        CAP_LED_Output_Control_2_Set    (uint8_t value);
void        CAP_LED_Linked_Transition_1_Set (uint8_t value);
void        CAP_LED_Linked_Transition_2_Set (uint8_t value);
void        CAP_LED_Mirror_1_Set            (uint8_t value);
void        CAP_LED_Mirror_2_Set            (uint8_t value);
void        CAP_LED_Behavior_Set            (uint8_t ledChannel, uint8_t behavior);
</#if>
