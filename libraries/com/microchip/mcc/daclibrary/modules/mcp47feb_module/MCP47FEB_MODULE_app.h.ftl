<#if (picArchitecture = "16bit")>
<#assign i2cNoInstance = cboMssp?replace("I2C", "")>
</#if>
<#assign libVersion = dacLibVersion>

/*
  © 2021 Microchip Technology Inc. and its subsidiaries

  Subject to your compliance with these terms, you may use Microchip software
  and any derivatives exclusively with Microchip products. You're responsible
  for complying with 3rd party license terms applicable to your use of 3rd party
  software (including open source software) that may accompany Microchip software.
  SOFTWARE IS "AS IS." NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY,
  APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT,
  MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT WILL MICROCHIP
  BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, INCIDENTAL OR CONSEQUENTIAL LOSS,
  DAMAGE, COST OR EXPENSE OF ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER
  CAUSED, EVEN IF MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE
  FORESEEABLE. TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY
  ON ALL CLAIMS RELATED TO THE SOFTWARE WILL NOT EXCEED AMOUNT OF FEES, IF ANY,
  YOU PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*/

#ifndef MCP47FEB_H
#define MCP47FEB_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

// MCP47FEB Library Version
#define MCP47FEB_LIBVER "${libVersion}"

/*
 * Delay function support
 */
// Make sure that a matching platform is enabled (here or in project settings):
<#if (deviceFamily = "Atmel")>
#define AVR8_PLATFORM
<#elseif (deviceFamily = "Pic")>
    <#if (picArchitecture = "8bit")>
#define PIC8_PLATFORM
    <#elseif (picArchitecture = "16bit")>
#define PIC16_PLATFORM
    </#if>
</#if>

#if !defined(PIC16_PLATFORM) &&  !defined(PIC8_PLATFORM) && !defined(AVR8_PLATFORM)
#error "No platform has been selected!"
#endif
#ifdef PIC16_PLATFORM
#define FCY 16000000UL    // Instruction clock frequency must reflect the MCU configuration 
#include <libpic30.h>
#define DELAY_MS(T) __delay_ms(T)
#endif
#ifdef PIC8_PLATFORM
#include "../mcc.h"
#define DELAY_MS(T) __delay_ms(T)
#endif
#ifdef AVR8_PLATFORM
#include "../config/clock_config.h"
#include <util/delay.h>
#define DELAY_MS(T) _delay_ms(T)
#endif

/*
 * I2C driver support
 */
// Make sure that at least one I2C module is enabled (here or in project settings):

<#if (i2cLibType = "FoundationServices")>
#define I2C_FSERV_ENABLED
<#elseif (i2cLibType = "MCU16")>
<#-- let the switch cases fall through so all the defines are generated-->
    <#switch noOfMssp>
        <#case "4">
<-- check if this I2C module is selected-->
<#if i2cNoInstance = '4'>
#define I2C4_CLASSIC_ENABLED
<#else>
//#define I2C4_CLASSIC_ENABLED
</#if>
        <#case "3">
<#if i2cNoInstance = '3'>
#define I2C3_CLASSIC_ENABLED
<#else>
//#define I2C3_CLASSIC_ENABLED
</#if>
        <#case "2">
<#if i2cNoInstance = '2'>
#define I2C2_CLASSIC_ENABLED
<#else>
//#define I2C2_CLASSIC_ENABLED
</#if>
        <#case "1">
<#if i2cNoInstance = '1'>
#define I2C1_CLASSIC_ENABLED
<#elseif (i2cNoInstance = '')>
#define I2C_CLASSIC_ENABLED
<#else>
//#define I2C1_CLASSIC_ENABLED
</#if>
    </#switch>
</#if> 

<#if (i2cLibType = "FoundationServices")>
#ifdef I2C_FSERV_ENABLED
#include "../drivers/i2c_simple_master.h"
#define MCP47FEB_BUS_ID 0
#endif
<#elseif (i2cLibType = "MCU16")>
    <#switch noOfMssp>
        <#case "4">
#ifdef I2C4_CLASSIC_ENABLED
#include "../i2c4.h"
#define I2CPREF I2C4
#define MCP47FEB_BUS_ID 4
#endif
        <#case "3">
#ifdef I2C3_CLASSIC_ENABLED
#include "../i2c3.h"
#define I2CPREF I2C3
#define MCP47FEB_BUS_ID 3
#endif
        <#case "2">
#ifdef I2C2_CLASSIC_ENABLED
#include "../i2c2.h"
#define I2CPREF I2C2
#define MCP47FEB_BUS_ID 2
#endif
        <#case "1">
<#if i2cNoInstance = ''>
#ifdef I2C_CLASSIC_ENABLED
#include "../i2c.h"
#define I2CPREF I2C
#define MCP47FEB_BUS_ID 1
#endif
<#else>
#ifdef I2C1_CLASSIC_ENABLED
#include "../i2c1.h"
#define I2CPREF I2C1
#define MCP47FEB_BUS_ID 1
#endif
</#if>
    </#switch>
</#if>

#define CONCAT(X, Y)    X ## Y

#if defined(I2C_CLASSIC_ENABLED) || defined(I2C1_CLASSIC_ENABLED) || defined(I2C2_CLASSIC_ENABLED) || defined(I2C3_CLASSIC_ENABLED) || defined(I2C4_CLASSIC_ENABLED)
#define I2C_MESSAGE_STATUS(PREF)          CONCAT(PREF, _MESSAGE_STATUS)
#define I2C_MESSAGE_COMPLETE(PREF)        CONCAT(PREF,_MESSAGE_COMPLETE)
#define I2C_MESSAGE_FAIL(PREF)            CONCAT(PREF,_MESSAGE_FAIL)
#define I2C_MESSAGE_PENDING(PREF)         CONCAT(PREF,_MESSAGE_PENDING)
#define I2C_STUCK_START(PREF)             CONCAT(PREF,_STUCK_START)
#define I2C_MESSAGE_ADDRESS_NO_ACK(PREF)  CONCAT(PREF,_MESSAGE_ADDRESS_NO_ACK)
#define I2C_DATA_NO_ACK(PREF)             CONCAT(PREF,_DATA_NO_ACK)
#define I2C_LOST_STATE(PREF)              CONCAT(PREF,_LOST_STATE)
#elif !defined(I2C_FSERV_ENABLED)
#error "No I2C bus has been enabled in the platform!"
#endif

/**
 Section: Constants
*/

#define MCP47FEB_ADDRESS ${txtI2cAddress}

#define DAC_RESOLUTION ${dacResolution}
#define NO_OF_CHANNELS ${noOfChannels}

//commands 
#define MCP47FEB_CMD_READ                           0x6 // bitwise OR with the register address below 
#define MCP47FEB_CMD_WRITE                          0xF8 // bitwise AND with register address

#define MCP47FEB_CMD_ENABLE                         0x2 // b'01' << 1 
#define MCP47FEB_CMD_DISABLE                        0x4 // b'10' << 1

#define MCP47FEB_VOLATILE_DAC0_ADDR                 0x0 // for read/write the address is placed on the top 5 MSB; this represents the shifted address
<#if noOfChannels == "2">
#define MCP47FEB_VOLATILE_DAC1_ADDR                 0x8  // 0x1 << 3 
</#if>
#define MCP47FEB_VOLATILE_VREF_ADDR                 0x40 // 0x8 << 3
#define MCP47FEB_VOLATILE_POWERDOWN_ADDR            0x48 // 0x9 << 3
#define MCP47FEB_VOLATILE_GAIN_ADDR                 0x50 // 0xA << 3
#define MCP47FEB_VOLATILE_WIPERLOCK_ADDR            0x58 // 0xB << 3
#define MCP47FEB_NONVOLATILE_DAC0_ADDR              0x80 // 0x10 << 3
<#if noOfChannels == "2">
#define MCP47FEB_NONVOLATILE_DAC1_ADDR              0x88 // 0x11 << 3
</#if>
#define MCP47FEB_NONVOLATILE_VREF_ADDR              0xC0 // 0x18 << 3
#define MCP47FEB_NONVOLATILE_POWERDOWN_ADDR         0xC8 // 0x19 << 3
#define MCP47FEB_NONVOLATILE_GAIN_ADDR              0xD0 // 0x1A << 3

#define MCP47FEB_VREF_VDD                           0x0
#define MCP47FEB_VREF_INTERNAL                      0x1		
#define MCP47FEB_VREF_UNBUFFERED                    0x2
#define MCP47FEB_VREF_BUFFERED                      0x3

#define MCP47FEB_PWRDN_NORMAL                       0x0
#define MCP47FEB_PWRDN_1K                           0x1
#define MCP47FEB_PWRDN_100K                         0x2
#define MCP47FEB_PWRDN_VOUT                         0x3

#define MCP47FEB_GAIN_X1                            0x0
#define MCP47FEB_GAIN_X2                            0x1

#define MCP47FEB_CH0                                0x3u
<#if noOfChannels == "2">
#define MCP47FEB_CH1                                0xCu
</#if>

#define MCP47FEB_LOCK                               0x1   //config enable
#define MCP47FEB_UNLOCK                             0x0  //config disable

//use for the SetLocks method
#define MCP47FEB_UNLOCK_ALL                         0x0
#define MCP47FEB_LOCK_ALL_NONVOLATILE_REGS          0x1
#define MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG    0x2
#define MCP47FEB_LOCK_ALL                           0x3

#define BIT_0_MASK   0x1u
#define BIT_1_MASK   0x2u
#define BIT_2_MASK   0x4u
#define BIT_3_MASK   0x8u
#define BIT_4_MASK   0x10u
#define BIT_5_MASK   0x20u
#define BIT_6_MASK   0x40u
#define BIT_7_MASK   0x80u

#define MCP47FEB_EEPROM_BUSY                        0x01    // EEPEOM write cycle in progress

// Library functions return codes
#define MCP47FEB_SUCCESS                            0x00
#define MCP47FEB_NO_ERR                             0x00 //   0
#define MCP47FEB_ERR_INVALID_SIZE                   0x01 //  -1
#define MCP47FEB_ERR_INVALID_VALUE                  0x02 //  -2
#define MCP47FEB_ERR_INVALID_CHANNEL                0x03 //  -3
#define MCP47FEB_INVALID_I2C_BUSID                  0x04
#define MCP47FEB_INVALID_PARAMETER                  0x05
#define MCP47FEB_ERR_UNKNOWN_ERROR                  0x10 //  -4
#define MCP47FEB_I2C_ERRCLASS                       0x80 // Prefix added to the error codes 
                                                         // returned by i2c library functions 

typedef struct _MCP47FEB_i2c_params {
    uint8_t i2cAddress; // device's 7-bit I2C address
    uint8_t i2cBusID;   // I2C bus index - used only by "i2c classic lib"
} MCP47FEB_i2c_params;


/**
 * Initializes the MCP47FEBxx device with all the selections from the 
 * graphical user interface 
 * @preconditions
 *      I2C is initialized (and interrupts are enabled if I2C driver uses interrupts).
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_MODULE_Initialize(MCP47FEB_i2c_params i2cParams);

/**
 * Returns the currently set volatile DAC value for the specified channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip
 * @param 
 *      *dacValue (out) - pointer to variable that will store the DAC value. 
 *                        Depending on the selected chip this will be an 8/10/12 bit value
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetVolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* dacValue) ;

/**
 * Sets the volatile DAC value for the specified channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip
 * @param 
 *      dacValue (in)  - the DAC value to be set (8/10/12 bit value depending on the chip). 
 *                       No input validation is performed for this values. 
 *                       If the value exceeds the chip's resolution it will be written as is, 
 *                       but the actual value in the register will be truncated.
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetVolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t dacValue) ;

/**
 * Sets the entire Vref register value
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure. 
 * @param 
 *      vrefSettings (in) - variable that contain the register value to be set. 
 *                          Depending on the device the register will have the following contents:
                            Bits 15-4: Unimplemented
                            Bits 3-2: Channel 1 Vref (if available)
                            Bits 1-0: Channel 0 Vref
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetAllVolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t vrefSettings) ;
 
/**
 * Returns the currently set Vref register value
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *vrefSettings (out) - pointer to variable that contain the register value. 
 *                            Depending on the device the register will have the following contents:
                              Bits 15-4: Unimplemented
                              Bits 3-2: Channel 1 Vref (if available)
                              Bits 1-0: Channel 0 Vref
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetAllVolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t* vrefSettings) ;

/**
 * Returns the currently set Vref option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *vrefSetting (out) - pointer to variable that will store the Vref option. Valid options are:
                             VREF_VDD
                             VREF_INTERNAL
                             VREF_UNBUFFERED
                             VREF_BUFFERED
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetVolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* vrefSetting); 

/**
 * Sets the volatile Vref option value for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      vrefSetting (in) - Vref option. Valid options are:
                           MCP47FEB_VREF_VDD
                           MCP47FEB_VREF_INTERNAL
                           MCP47FEB_VREF_UNBUFFERED
                           MCP47FEB_VREF_BUFFERED
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetVolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t vrefSetting); 



/**
 * Sets the entire Powerdown register value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure. 
 * @param 
 *      powerdownSetting (in) - variable that contain the register value to be set. 
 *                              Depending on the device the register will have the following contents:
                                Bits 15-4: Unimplemented
                                Bits 3-2: Channel 1 Powerdown (if available)
                                Bits 1-0: Channel 0 Powerdown
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetAllVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t powerdownSetting);

/**
 * Returns the currently set Powerdown register value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *powerdownSetting (out) - pointer to variable that will store the Powerdown register value. 
 *                                Depending on the device the register will have the following contents:
                                  Bits 15-4: Unimplemented
                                  Bits 3-2: Channel 1 Powerdown (if available)
                                  Bits 1-0: Channel 0 Powerdown
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetAllVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t* powerdownSetting);

/**
 * Returns the currently set Powerdown option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *powerdownSetting (out) - pointer to variable that will store the Powerdown option. Valid options are:
                                  MCP47FEB_PWRDN_NORMAL 	
                                  MCP47FEB_PWRDN_1K	 
                                  MCP47FEB_PWRDN_100K		
                                  MCP47FEB_PWRDN_VOUT
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* powerdownSetting);

/**
 * Sets the volatile value for the Powerdown option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      powerdownSetting (in) - the Powerdown option. Valid options are:
                                MCP47FEB_PWRDN_NORMAL 	
                                MCP47FEB_PWRDN_1K		 
                                MCP47FEB_PWRDN_100K		
                                MCP47FEB_PWRDN_VOUT
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t powerdownSetting);

/**
 * Returns the currently set gain value for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *gainValue (out) - pointer to variable that will store the Gain value. Valid options are:
                           GAIN_X1
                           GAIN_X2
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetVolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* gainValue);

/**
 * Sets the volatile value for the Gain option for the selected channel.
 * @param
 *      i2cParams (in)- device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      gainValue (in) - the Gain value to set. Valid options are:
                         MCP47FEB_GAIN_X1
                         MCP47FEB_GAIN_X2
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetVolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t gainValue);

/**
 * Returns the POR flag value. Reading the flag value will also clear it.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *porFlag (out) - pointer to variable that will store the read POR flag value
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetPorStatus (MCP47FEB_i2c_params i2cParams, uint8_t* porFlag);

/**
 * Returns the EEWA (EEPROM write active) flag value.
 * !NOTE: Reading EEWA flag value will also clear the POR flag value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *eewaFlag (out) - pointer to variable that will store the read EEWA flag value
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetEEWAStatus (MCP47FEB_i2c_params i2cParams, uint8_t* eewaFlag);

/**
 * Returns the I2C address lock status.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *i2cAddrLockFlag (out) - pointer to variable that will store the read I2C address lock value: 
 *                               1 = Locked (MCP47FEB_LOCK) 
 *                               0 = Unlocked (MCP47FEB_UNLOCK)
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetI2cAddressLockStatus(MCP47FEB_i2c_params i2cParams, uint8_t* i2cAddrLockFlag); 

/**
 * Locks/unlocks the I2C address setting.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      i2cAddrLockFlag (in) - desired I2C address lock value: 
 *                             MCP47FEB_LOCK (1) = lock the I2C address
 *                             MCP47FEB_UNLOCK (0) = unlock the I2C address
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 * !!! NOTE: the lock can be changed only via a HV command and high voltage is required on the HVC pin. Please see the device datasheet for more details.
 */
int8_t MCP47FEB_SetI2cAddressLockStatus (MCP47FEB_i2c_params i2cParams, uint8_t i2cAddrLockFlag);

/**
 * Returns the currently set I2C address (7 bit value).
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *i2cAddrVal (out) - pointer to variable that will store the read I2C address value (7-bit address).
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetI2cAddressValue (MCP47FEB_i2c_params i2cParams, uint8_t* i2cAddrVal);

/**
 * Sets the I2C address (7bit value) if the address is unlocked.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      addrValue (in) - the I2C address to be set (7-bit address).
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 *
 * !!! NOTE: the I2C address can be changed only if the address isn't locked. 
 * The MCP47FEB_GetI2cAddresLockStatus method can be used to determine the lock status. 
 * A HV command is needed to unlock the address and high voltage is required on the HVC pin. 
 * Please see the device datasheet for more details.
 */
int8_t MCP47FEB_SetI2cAddress(MCP47FEB_i2c_params i2cParams, uint8_t addrValue);

/**
 * Returns the current wiperlock register value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *lockOptions (out) - pointer to variable that will store the read lock value.
 *                           bits[3:2] = Wiperlock setting for Channel 1 (if available)
 *                           bits[1:0] = Wiperlock setting for Channel 0
 * 
 * Available values are:
 * -----------------------------------------------------------------------------------------------------
 * | Lock  |   DAC configuration   |      DAC wiper         |            Define name                   |
 * | Value |-------------------------------------------------------------------------------------------|
 * |       |Volatile | Nonvolatile | Volatile | Nonvolatile |                                          |
 * |-------|---------|-------------|------------------------|------------------------------------------|
 * | 0     |Unlocked |Unlocked     |Unlocked  |Unlocked     | MCP47FEB_UNLOCK_ALL                      |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 1     |Unlocked |Locked       |Unlocked  |Locked       | MCP47FEB_LOCK_ALL_NONVOLATILE_REGS       |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 2     |Unlocked |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 3     |Locked   |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL                        |
 * |--------------------------------------------------------|------------------------------------------|
 *
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetAllLocks(MCP47FEB_i2c_params i2cParams, uint16_t* lockOptions);

/**
 * Returns the current wiperlock register value for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *lockOptions (out) - pointer to variable that will store the read lock value for the desired channel
 * 
 * Available values are:
 * -----------------------------------------------------------------------------------------------------
 * | Lock  |   DAC configuration   |      DAC wiper         |            Define name                   |
 * | Value |-------------------------------------------------------------------------------------------|
 * |       |Volatile | Nonvolatile | Volatile | Nonvolatile |                                          |
 * |-------|---------|-------------|------------------------|------------------------------------------|
 * | 0     |Unlocked |Unlocked     |Unlocked  |Unlocked     | MCP47FEB_UNLOCK_ALL                      |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 1     |Unlocked |Locked       |Unlocked  |Locked       | MCP47FEB_LOCK_ALL_NONVOLATILE_REGS       |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 2     |Unlocked |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 3     |Locked   |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL                        |
 * |--------------------------------------------------------|------------------------------------------|
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetLocks(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* lockOptions); 

/**
 * Sets the current wiperlock register value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      lockOptions (in) - The lock value to be set.
 *                         bits[3:2] = Wiperlock setting for Channel 1 (if available)
 *                         bits[1:0] = Wiperlock setting for Channel 0
 * 
 * Available values are:
 * -----------------------------------------------------------------------------------------------------
 * | Lock  |   DAC configuration   |      DAC wiper         |            Define name                   |
 * | Value |-------------------------------------------------------------------------------------------|
 * |       |Volatile | Nonvolatile | Volatile | Nonvolatile |                                          |
 * |-------|---------|-------------|------------------------|------------------------------------------|
 * | 0     |Unlocked |Unlocked     |Unlocked  |Unlocked     | MCP47FEB_UNLOCK_ALL                      |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 1     |Unlocked |Locked       |Unlocked  |Locked       | MCP47FEB_LOCK_ALL_NONVOLATILE_REGS       |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 2     |Unlocked |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 3     |Locked   |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL                        |
 * |--------------------------------------------------------|------------------------------------------|
 *
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)   
*/
int8_t MCP47FEB_SetAllLocks(MCP47FEB_i2c_params i2cParams, uint16_t lockOption);

/**
 * Sets the current wiperlock register value for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      lockOptions (in) - the lock value to be set for the selected channel.
  * 
 * Available values are:
 * -----------------------------------------------------------------------------------------------------
 * | Lock  |   DAC configuration   |      DAC wiper         |            Define name                   |
 * | Value |-------------------------------------------------------------------------------------------|
 * |       |Volatile | Nonvolatile | Volatile | Nonvolatile |                                          |
 * |-------|---------|-------------|------------------------|------------------------------------------|
 * | 0     |Unlocked |Unlocked     |Unlocked  |Unlocked     | MCP47FEB_UNLOCK_ALL                      |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 1     |Unlocked |Locked       |Unlocked  |Locked       | MCP47FEB_LOCK_ALL_NONVOLATILE_REGS       |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 2     |Unlocked |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG |
 * |-------|---------|-------------|----------|-------------|------------------------------------------|
 * | 3     |Locked   |Locked       |Locked    |Locked       | MCP47FEB_LOCK_ALL                        |
 * |--------------------------------------------------------|------------------------------------------|
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetLocks(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t lockOptions);

/**
 * Returns the currently set nonvolatile DAC value for the specified channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip
 * @param 
 *      *dacValue (out) - pointer to variable that will store the DAC value. 
 *                        Depending on the selected chip this will be an 8/10/12 bit value
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetNonvolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* dacValue) ;

/**
 * Sets the nonvolatile DAC value for the specified channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - channelNo - the channel number. Accepted values are 0 or 1, depending on the selected chip
 * @param 
 *      dacValue (in) - the DAC value to be set (8/10/12 bit value depending on the chip)
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetNonvolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t dacValue) ;

/**
 * Sets the entire Vref register value
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure. 
 * @param 
 *      vrefSettings (in) - variable that contain the register value to be set. 
 *                          Depending on the device the register will have the following contents:
                            Bits 15-4: Unimplemented
                            Bits 3-2: Channel 1 Vref (if available)
                            Bits 1-0: Channel 0 Vref
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetAllNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t vrefSettings) ;
 
/**
 * Returns the currently set Vref register value
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param
 *      *vrefSettings (out) - pointer to variable that will contain the register value. 
 *                            Depending on the device the register will have the following contents:
                              Bits 15-4: Unimplemented
                              Bits 3-2: Channel 1 Vref (if available)
                              Bits 1-0: Channel 0 Vref
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetAllNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t* vrefSettings) ;

/**
 * Returns the currently set Vref option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *vrefSetting (out)- pointer to variable that will store the Vref option. Valid options are:
                            MCP47FEB_VREF_VDD 		
                            MCP47FEB_VREF_INTERNAL		
                            MCP47FEB_VREF_UNBUFFERED	
                            MCP47FEB_VREF_BUFFERED

 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* vrefSetting); 

/**
 * Sets the nonvolatile Vref option value for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      vrefSetting (in) - Vref option. Valid options are:
                           MCP47FEB_VREF_VDD 		
                           MCP47FEB_VREF_INTERNAL	
                           MCP47FEB_VREF_UNBUFFERED	
                           MCP47FEB_VREF_BUFFERED

 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t vrefSetting); 

/**
 * Sets the entire Powerdown register value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure. 
 * @param 
 *      powerdownSetting (in) - variable that contain the register value to be set. 
 *                              Depending on the device the register will have the following contents:
                                Bits 15-4: Unimplemented
                                Bits 3-2: Channel 1 Powerdown (if available)
                                Bits 1-0: Channel 0 Powerdown
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetAllNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t powerdownSetting);

/**
 * Returns the currently set Powerdown register value.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      *powerdownSetting (out) - variable that will store the Powerdown register value. 
 *                                Depending on the device the register will have the following contents:
                                  Bits 15-4: Unimplemented
                                  Bits 3-2: Channel 1 Powerdown (if available)
                                  Bits 1-0: Channel 0 Powerdown
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetAllNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t* powerdownSetting);

/**
 * Returns the currently set Powerdown option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *powerdownSetting (out) - variable that will store the Powerdown option. Valid options are:
                                  MCP47FEB_PWRDN_NORMAL
                                  MCP47FEB_PWRDN_1K
                                  MCP47FEB_PWRDN_100K
                                  MCP47FEB_PWRDN_VOUT
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* powerdownSetting);

/**
 * Sets the nonvolatile value for the Powerdown option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      powerdownSetting (in) - the Powerdown option. Valid options are:
                                MCP47FEB_PWRDN_NORMAL
                                MCP47FEB_PWRDN_1K
                                MCP47FEB_PWRDN_100K
                                MCP47FEB_PWRDN_VOUT
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_SetNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t powerdownSetting);

/**
 * Returns the currently set gain value for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      *gainValue (out) - pointer to variable that will store the Gain value. Valid options are:
                           MCP47FEB_GAIN_X1
                           MCP47FEB_GAIN_X2
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call)
 */
int8_t MCP47FEB_GetNonvolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* gainValue);

/**
 * Sets the nonvolatile value for the Gain option for the selected channel.
 * @param
 *      i2cParams (in) - device's I2C address and bus index - see MCP47FEB_i2c_params structure.
 * @param 
 *      channelNo (in) - the channel number. Accepted values are 0 or 1, depending on the selected chip.
 * @param 
 *      gainValue (in) - the Gain value to set. Valid options are:
                         MCP47FEB_GAIN_X1
                         MCP47FEB_GAIN_X2
 * @return
 *      function call return code - see "Library functions return codes" section
 *      (e.g MCP47FEB_SUCCESS for successful call) 
 */
int8_t MCP47FEB_SetNonvolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t gainValue);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* MCP47FEB_H */






