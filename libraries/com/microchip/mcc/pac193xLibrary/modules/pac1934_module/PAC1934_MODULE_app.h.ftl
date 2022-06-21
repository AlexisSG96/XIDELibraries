<#assign moduleNameUpperCase = "PAC1934">
<#assign moduleNameLowerCase = "pac1934">
<#if (picArchitecture = "16bit")>
<#assign i2cNoInstance = cmbMSSP?replace("I2C", "")>
</#if>
<#assign libVersion = pacLibVersion>
/* 
   © 2017 Microchip Technology Inc. and its subsidiaries.  
 
   Subject to your compliance with these terms, you may use Microchip software
   and any derivatives exclusively with Microchip products. It is your 
   responsibility to comply with third party license terms applicable to your
   use of third party software (including open source software) that may 
   accompany Microchip software. 
  
   THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER 
   EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING 
   ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS
   FOR A PARTICULAR PURPOSE.  
  
   IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
   INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND 
   WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP
   HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. 
   TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL
   CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF
   FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE. 
*/

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

// PAC193x Library Version
#define PAC193X_LIBVER "${libVersion}"

/**
    Section: Included Files
*/

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <math.h>

<#if (i2cLibType = "FoundationServices")>
#define I2C_FSERV_ENABLED
<#elseif (i2cLibType = "MCU16")>
<#-- let the switch cases fall through so all the defines are generated-->
    <#switch noOfMssp>
        <#case "4">
<-- check if this I2C module is selected-->
<#if i2cNoInstance = '4'>
#define I2C4_CLASSIC_ENABLED
#define I2CPREF I2C4    
<#else>
//#define I2C4_CLASSIC_ENABLED
</#if>
        <#case "3">
<#if i2cNoInstance = '3'>
#define I2C3_CLASSIC_ENABLED
#define I2CPREF I2C3    
<#else>
//#define I2C3_CLASSIC_ENABLED
</#if>
        <#case "2">
<#if i2cNoInstance = '2'>
#define I2C2_CLASSIC_ENABLED
#define I2CPREF I2C2    
<#else>
//#define I2C2_CLASSIC_ENABLED
</#if>
        <#case "1">
<#if i2cNoInstance = '1'>
#define I2C1_CLASSIC_ENABLED
#define I2CPREF I2C1    
<#elseif (i2cNoInstance = '')>
#define I2C_CLASSIC_ENABLED
#define I2CPREF I2C
<#else>
//#define I2C1_CLASSIC_ENABLED
</#if>
    </#switch>
</#if> 

<#if (i2cLibType = "FoundationServices")>
#ifdef I2C_FSERV_ENABLED
#include "../drivers/i2c_simple_master.h"
#endif
<#elseif (i2cLibType = "MCU16")>
    <#switch noOfMssp>
        <#case "4">
#ifdef I2C4_CLASSIC_ENABLED
#include "../i2c4.h"
#endif
        <#case "3">
#ifdef I2C3_CLASSIC_ENABLED
#include "../i2c3.h"
#endif
        <#case "2">
#ifdef I2C2_CLASSIC_ENABLED
#include "../i2c2.h"
#endif
        <#case "1">
<#if i2cNoInstance = ''>
#ifdef I2C_CLASSIC_ENABLED
#include "../i2c.h"
#endif
<#else>
#ifdef I2C1_CLASSIC_ENABLED
#include "../i2c1.h"
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


/*
 * ${moduleNameUpperCase} register address
 */

#define ${moduleNameUpperCase}_REFRESH_CMD_ADDR            0x00
#define ${moduleNameUpperCase}_CTRL_ADDR                   0x01
#define ${moduleNameUpperCase}_ACC_COUNT_ADDR              0x02
#define ${moduleNameUpperCase}_VPOWER1_ACC_ADDR            0x03
#define ${moduleNameUpperCase}_VPOWER2_ACC_ADDR            0x04
#define ${moduleNameUpperCase}_VPOWER3_ACC_ADDR            0X05
#define ${moduleNameUpperCase}_VPOWER4_ACC_ADDR            0X06
#define ${moduleNameUpperCase}_VBUS1_ADDR                  0x07
#define ${moduleNameUpperCase}_VBUS2_ADDR                  0x08
#define ${moduleNameUpperCase}_VBUS3_ADDR                  0x09
#define ${moduleNameUpperCase}_VBUS4_ADDR                  0x0A
#define ${moduleNameUpperCase}_VSENSE1_ADDR                0x0B
#define ${moduleNameUpperCase}_VSENSE2_ADDR                0x0C
#define ${moduleNameUpperCase}_VSENSE3_ADDR                0X0D
#define ${moduleNameUpperCase}_VSENSE4_ADDR                0X0E
#define ${moduleNameUpperCase}_VBUS1_AVG_ADDR              0X0F
#define ${moduleNameUpperCase}_VBUS2_AVG_ADDR              0X10
#define ${moduleNameUpperCase}_VBUS3_AVG_ADDR              0X11
#define ${moduleNameUpperCase}_VBUS4_AVG_ADDR              0X12
#define ${moduleNameUpperCase}_VSENSE1_AVG_ADDR            0X13
#define ${moduleNameUpperCase}_VSENSE2_AVG_ADDR            0X14
#define ${moduleNameUpperCase}_VSENSE3_AVG_ADDR            0X15
#define ${moduleNameUpperCase}_VSENSE4_AVG_ADDR            0X16
#define ${moduleNameUpperCase}_VPOWER1_ADDR                0X17
#define ${moduleNameUpperCase}_VPOWER2_ADDR                0X18
#define ${moduleNameUpperCase}_VPOWER3_ADDR                0X19
#define ${moduleNameUpperCase}_VPOWER4_ADDR                0X1A
#define ${moduleNameUpperCase}_CHANNEL_DIS_ADDR            0X1C
#define ${moduleNameUpperCase}_NEG_PWR_ADDR                0X1D
#define ${moduleNameUpperCase}_REFRESH_G_CMD_ADDR          0x1E
#define ${moduleNameUpperCase}_REFRESH_V_CMD_ADDR          0x1F
#define ${moduleNameUpperCase}_SLOW_ADDR                   0X20
#define ${moduleNameUpperCase}_CTRL_ACT_ADDR               0X21
#define ${moduleNameUpperCase}_CHANNEL_DIS_ACT_ADDR        0X22
#define ${moduleNameUpperCase}_NEG_PWR_ACT_ADDR            0X23
#define ${moduleNameUpperCase}_CTRL_LAT_ADDR               0X24
#define ${moduleNameUpperCase}_CHANNEL_DIS_LAT_ADDR        0X25
#define ${moduleNameUpperCase}_NEG_PWR_LAT_ADDR            0x26

#define ${moduleNameUpperCase}_PRODUCT_ID_ADDR             0xFD
#define ${moduleNameUpperCase}_MANUFACTURER_ID_ADDR        0xFE
#define ${moduleNameUpperCase}_REVISION_ID_ADDR            0xFF

/*
 * ${moduleNameUpperCase} library error codes
 */
#define ${moduleNameUpperCase}_I2C_ERRCLASS                     0x1000
#define ${moduleNameUpperCase}_INVALID_INPUT_VALUE              -1000
#define ${moduleNameUpperCase}_ERR_NO_SINGLE_SHOT_MODE          -1001
#define ${moduleNameUpperCase}_INVALID_BIT                      0x02
#define ${moduleNameUpperCase}_INVALID_SLOW_TRANSITION          0x04
#define ${moduleNameUpperCase}_INVALID_REFRESH_TYPE             0x05
#define ${moduleNameUpperCase}_NO_ERR                           0x00


/*
 * ${moduleNameUpperCase} library constants
 */
#define BIT_0       0x01
#define BIT_1       0x02
#define BIT_2       0x04
#define BIT_3       0x08
#define BIT_4       0X10
#define BIT_5       0x20
#define BIT_6       0x40
#define BIT_7       0x80
#define BIT_8       0x100
#define BIT_9       0x200
#define BIT_10      0x400
#define BIT_11      0x800
#define BIT_12      0x1000
#define BIT_13      0x2000
#define BIT_14      0x4000
#define BIT_15      0x8000

#define SMBUS_BYTECNT   1   //the extra byte for SMBUS block read protocol


<#if txtRsenseCh1??>
<#if txtRsenseCh1 != "">
#define R_SENSE_1 ${txtRsenseCh1}
</#if>
</#if>
<#if txtRsenseCh2??>
<#if txtRsenseCh2 != "">
#define R_SENSE_2  ${txtRsenseCh2}
</#if>
</#if>
<#if txtRsenseCh3??>
<#if txtRsenseCh3 != "">
#define R_SENSE_3  ${txtRsenseCh3}
</#if>
</#if>
<#if txtRsenseCh4??>
<#if txtRsenseCh4 != "">
#define R_SENSE_4  ${txtRsenseCh4}
</#if>
</#if>
<#if txtEnergyTimestamp??>
<#if txtEnergyTimestamp != "">
uint32_t timestampSingleShot = ${txtEnergyTimestamp};
</#if>
</#if>

#define PAC1934_I2C_ADDR  ${cmbI2cAddr}

/* 
 * ${moduleNameUpperCase} library interface
 */

/**
    @Summary
        Initializes the ${moduleNameUpperCase} instance:
    @Description
        This routine initializes the ${moduleNameUpperCase} device based on user configuration
        in the MCC gui.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        None
    @Example
        <code>
            ${moduleNameUpperCase}_MODULE_Initialize(1, 0x10);	
        </code>
*/
void ${moduleNameUpperCase}_Device_Initialize(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the last error code value.
    @Description
        This function returns the current error code returned by the last called method.
    @Preconditions
        None
    @Param
        None
    @Returns
        The value for the last error code.
    @Example
        <code>
            ${moduleNameUpperCase}_GetLastError();
        <code>
*/
int16_t ${moduleNameUpperCase}_GetLastError(void);


/**
    @Summary
        Returns the Product ID value for the ${moduleNameUpperCase}.
    @Description
        This method returns the Product ID value for the ${moduleNameUpperCase}. 
        This register is read-only.
    @Preconditions
        None 
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The Product ID register value. This value is 0x5B.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_GetProductID(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetProductID(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the Manufacturer ID for the ${moduleNameUpperCase}.
    @Description
        This method returns the Manufacturer ID that identifies Microchip as 
        the manufacturer of the ${moduleNameUpperCase}. 
        This register is read-only.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The Manufacturer ID register value. This value is 0x5D.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution 
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_GetManufacturerID(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetManufacturerID(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the Revision ID value for the ${moduleNameUpperCase}.
    @Description
        This method returns the die revision value. This register is read-only.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The Revision ID register value. This value is 0x03 or higher.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_GetRevisionID(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetRevisionID(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Executes a 'REFRESH' command.
    @Description
        This method executes a 'REFRESH' command. In this case, the accumulator data, 
        accumulator count, Vbus, Vsense measurements are all refreshed 
        and the accumulators are reset. 
        The updated data is stable and can be read after 1ms.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_Refresh(1, 0x10);
        <code>
*/
void ${moduleNameUpperCase}_Refresh(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Executes a 'REFRESH_G' command.
    @Description
        This method executes a 'REFRESH' command, but it is intended for use 
        with the General Call command. In this case, the accumulator data, 
        accumulator count, Vbus, Vsense measurements are
        all refreshed and the accumulators are reset. 
        The updated data is stable and can be read after 1ms.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_RefreshG(1, 0x10);
        <code>
*/
void ${moduleNameUpperCase}_RefreshG(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Executes a 'REFRESH_V' command.
    @Description
        This method executes a 'REFRESH_V' command. In this case, the readable 
        accumulator data, readable accumulator count, Vbus, Vsense measurements 
        are all refreshed without affecting the internal accumulators values 
        or accumulator count. 
        The updated data is stable and can be read after 1ms.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_RefreshV(1, 0x10);
        <code>
*/
void ${moduleNameUpperCase}_RefreshV(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the current accumulator count.
    @Description
        This method returns the count for each time a power result has been summed 
        in the accumulator. 
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The accumulator count register value.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint32_t count = ${moduleNameUpperCase}_GetAccumulatorCount(1, 0x10);
        <code>
*/
uint32_t ${moduleNameUpperCase}_GetAccumulatorCount(uint8_t i2cBusID, uint8_t i2cAddress);


<#if (picArchitecture = "8bit")>
/**
    @Summary
        Returns the current register accumulated power.
    @Description
        This method returns the register value of the accumulator sum of Vpower samples.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        *value - the user buffer that receives the accumulator register value.
                 The buffer size must be 6 bytes.
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution 
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t accPowerRawCh1[6];
            ${moduleNameUpperCase}_GetPowerAccRaw(1, 0x10, 1, accPowerRawCh1);
        <code>
*/
void ${moduleNameUpperCase}_GetPowerAccRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t* value);
<#elseif (picArchitecture = "16bit")>
/**
    @Summary
        Returns the current register accumulated power.
    @Description
        This method returns the register value of the accumulator sum of Vpower samples.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The power accumulator register value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution 
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
         uint64_t accPowerRawCh1 = ${moduleNameUpperCase}_GetPowerAccRaw(1, 0x10, 1);
*/
uint64_t ${moduleNameUpperCase}_GetPowerAccRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);
</#if>


/**
    @Summary
        Returns the current real accumulated power.
    @Description
        This method returns the calculated real value of the accumulated sum of Vpower samples.
        The value unit is Watt.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        rsense - the external sense resistor value that is used (in micro Ohms).
                 The value must be non-zero, otherwise the function returns 0 and
                 sets the execution error code to ${moduleNameUpperCase}_INVALID_INPUT_VALUE.
    @Returns
        The power accumulated value of the selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution 
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float powerAccRealCh1 = ${moduleNameUpperCase}_GetPowerAccReal(1, 0x10, 1, 1000000);
        <code>
*/
float ${moduleNameUpperCase}_GetPowerAccReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense);


/**
    @Summary
        Returns the current Vbus register value.
    @Description
        This method returns the most recent register value of a bus voltage sample.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The bus voltage register value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint16_t vbusRawCh1 = ${moduleNameUpperCase}_GetVbusRaw(1, 0x10, 1);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetVbusRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current real Vbus value.
    @Description
        This method returns the most recent calculated value of a bus voltage sample.
        The value unit is milli-Volt.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4 
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The bus voltage value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float vbusRealCh1 = ${moduleNameUpperCase}_GetVbusReal(1, 0x10, 1);
        <code>
*/
float ${moduleNameUpperCase}_GetVbusReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current Vsense register value.
    @Description
        This method returns the most recent register value of the sense voltage samples.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The register value of current sense voltage for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint16_t vsenseRawCh1 = ${moduleNameUpperCase}_GetVsenseRaw(1, 0x10, 1);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetVsenseRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current real Vsense value.
    @Description
        This method returns the most recent real value of the sense voltage samples.
        The value unit is milli-Volt.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The sense voltage value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float vsenseRealCh1 = ${moduleNameUpperCase}_GetVsenseReal(1, 0x10, 1);
        <code>
*/
float ${moduleNameUpperCase}_GetVsenseReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current Vbus average register value.
    @Description
        This method returns the register value of a rolling average of 
        the 8 most recent bus voltage measurements.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The register value of the bus voltage average for the selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint16_t vbusAvgRawCh1 = ${moduleNameUpperCase}_GetVbusAvgRaw(1, 0x10, 1);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetVbusAvgRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current real Vbus average value.
    @Description
        This method returns the real value of a rolling average 
        of the 8 most bus voltage measurements.
        The unit value is milli-Volt.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The value of the bus voltage average for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float vbusAvgRealCh1 = ${moduleNameUpperCase}_GetVbusAvgReal(1, 0x10, 1);
        <code>
*/
float ${moduleNameUpperCase}_GetVbusAvgReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current Vsense average register value.
    @Description
        This method returns the register value of a rolling average of 
        the 8 most recent sense voltage measurements.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The register value of the sense voltage average for the selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
           uint16_t vsenseAvgRawCh1 = ${moduleNameUpperCase}_GetVsenseAvgRaw(1, 0x10, 1);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetVsenseAvgRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current real Vsense average value.
    @Description
        This method returns the real value of a rolling average of 
        the 8 most sense voltage measurements.
        The value unit is milli-Volt.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The value of the sense voltage average for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float vsenseAvgRealCh1 = ${moduleNameUpperCase}_GetVsenseAvgReal(1, 0x10, 1);
        <code>
*/
float ${moduleNameUpperCase}_GetVsenseAvgReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current Isense value.
    @Description
        This method returns the most recent calculated value of the sense current samples.
        The value unit is milli-Amp.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed  
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        rsense - the external sense resistor value that is used (in micro Ohms).
                 The value must be non-zero, otherwise the function returns 0 and
                 sets the execution error code to ${moduleNameUpperCase}_INVALID_INPUT_VALUE.
    @Returns
        The current value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float currentSenseCh1 = ${moduleNameUpperCase}_GetIsense(1, 0x10, 1, 1000000);
        <code>
*/
float ${moduleNameUpperCase}_GetIsense(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense);


/**
    @Summary
        Returns the current average IsenseAvg value.
    @Description
        This method returns the value of a rolling average of the 8 most recent
        sense current measurements.
        The value unit is milli-Amp.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        rsense - the external sense resistor value that is used (in micro Ohms).
                 The value must be non-zero, otherwise the function returns 0 and
                 sets the execution error code to ${moduleNameUpperCase}_INVALID_INPUT_VALUE.
    @Returns
        The current average value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float currentSenseAvgCh1 = ${moduleNameUpperCase}_GetIsenseAvg(1, 0x10, 1, 1000000);
        <code>
*/
float ${moduleNameUpperCase}_GetIsenseAvg(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense);


/**
    @Summary
        Returns the current Vpower register value.
    @Description
        This method returns the register value of the proportional power for each channel.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Returns
        The register value of power for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint32_t powerRawCh1 = ${moduleNameUpperCase}_GetPowerRaw(1, 0x10, 1);
        <code>
*/
uint32_t ${moduleNameUpperCase}_GetPowerRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the current real Vpower value.
    @Description
        This method returns the real value of the proportional power for each channel.
        The value unit is Watt.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        rsense - the external sense resistor value that is used (in micro Ohms).
                 The value must be non-zero, otherwise the function returns 0 and
                 sets the execution error code to ${moduleNameUpperCase}_INVALID_INPUT_VALUE.
    @Returns
        The power value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float powerRealCh1 = ${moduleNameUpperCase}_GetPowerReal(1, 0x10, 1, 1000000);
        <code>
*/
float ${moduleNameUpperCase}_GetPowerReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense);


/**
    @Summary
        Returns the current energy value.
    @Description
        This method returns the calculated energy value that corresponds 
        with the accumulated power.
        The value unit is milli-Watt-hour.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        rsense - the external sense resistor value that is used (in micro Ohms).
                 The value must be non-zero, otherwise the function returns 0 and
                 sets the execution error code to ${moduleNameUpperCase}_INVALID_INPUT_VALUE.
    @Returns
        The energy value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            float energyCh1 = ${moduleNameUpperCase}_GetEnergy(1, 0x10, 1, 1000000);
        <code>
*/
float ${moduleNameUpperCase}_GetEnergy(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense);


/**
    @Summary
        Returns the energy value if ${moduleNameUpperCase} is configured in Single-Shot mode.
    @Description
        This method returns the calculated energy value that corresponds 
        with the accumulated power, if Single-Shot mode is active.
        The value unit is milli-Watt-hour.
    @Preconditions
        ${moduleNameUpperCase} must be configured in Single-Shot mode.
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param 
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param 
        rsense - the external sense resistor value that is used (in micro Ohms)
                 The value must be non-zero, otherwise the function returns 0 and
                 sets the execution error code to ${moduleNameUpperCase}_INVALID_INPUT_VALUE.
    @Param 
        timestamp - the accumulation time to provide the energy measurement in Single-shot mode
    @Returns
        The energy value for selected channel.
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            //set Single-Shot mode
            ${moduleNameUpperCase}_SetSingleShotModeBit(1, 0x10, 1);
            //get the energy value in 1s
            float energyCh1 = ${moduleNameUpperCase}_GetSingleShotEnergy(1, 0x10, 1, 1000000, 1000000);
        <code>
*/
float ${moduleNameUpperCase}_GetSingleShotEnergy(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense, uint32_t timestamp);


/**
    @Summary
        Returns CTRL register value.
    @Description
        This method returns the currently set control register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The control register value:
                        Bits 7-6:   Sample Rate
                        Bit 5:      Sleep Mode
                        Bit 4:      Single Shot Mode
                        Bit 3:      Alert Pin
                        Bit 2:      Alert CC
                        Bit 1:      Overflow Alert
                        Bit 0:      Overflow
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t ctrlReg = ${moduleNameUpperCase}_GetCtrlRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetCtrlRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the CTRL register value.
    @Description
        This method sets the current control register value. Followed by the REFRESH 
        or REFRESH_V command, the new value of register will be activated.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the control register value to be set (8bit value):
                                Bits 7-6:   Sample Rate
                                Bit 5:      Sleep Mode
                                Bit 4:      Single Shot Mode
                                Bit 3:      Alert Pin
                                Bit 2:      Alert CC
                                Bit 1:      Overflow Alert
                                Bit 0:      Overflow
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetCtrlRegister(1, 0x10, 0);
        <code>
*/
void ${moduleNameUpperCase}_SetCtrlRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the sample rate value.
    @Description
        This method returns the sample rate value in normal mode, 
        if SLOW pin is not asserted.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param  
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The sample rate value.Possible values are:
                                1024 samples/s
                                 256 samples/s
                                  64 samples/s
                                   8 samples/s
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint16_t sampleRate = ${moduleNameUpperCase}_GetSampleRate(1, 0x10);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetSampleRate(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the sample rate value.
    @Description
        This method sets the current value of the sample rate. Followed by the 
        REFRESH or REFRESH_V command, the new value of sample rate will be activated.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the sample rate value to be set. Accepted values are: 
                                                        1024 samples/s
                                                         256 samples/s
                                                          64 samples/s
                                                           8 samples/s
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetSampleRate(1, 0x10, 256);
        <code>
*/
void ${moduleNameUpperCase}_SetSampleRate(uint8_t i2cBusID, uint8_t i2cAddress, uint16_t value);


/**
    @Summary
        Returns Sleep bit value.
    @Description
        This method returns the 'SLEEP' bit value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The 'SLEEP' bit value. Possible values are:
                                    0 - Active Mode
                                    1 - Sleep Mode
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t sleepBit = ${moduleNameUpperCase}_GetSleepModeBit(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSleepModeBit(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the SLEEP bit value.
    @Description
        This method sets the 'SLEEP' bit value. Followed by the 
        REFRESH or REFRESH_V command, the new mode will be activated.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the sleep bit value to be set. Accepted values are:
                                                  0 - Active Mode
                                                  1 - Sleep Mode
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetSleepModeBit(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetSleepModeBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the Single Shot bit value.
    @Description
        This method returns the Single Shot bit value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The Single Shot bit value. Possible values are:
                                                0 - Sequential scan mode
                                                1 - Single Shot mode
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t singleShotBit = ${moduleNameUpperCase}_GetSingleShotModeBit(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSingleShotModeBit(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the Single Shot bit value.
    @Description
        This method sets the 'Single Shot' bit value. If this bit is set to 1, 
        and sending a REFRESH command, the device resets accumulator 
        and performs one conversion cycle for any and all active channels, 
        then returns to sleep mode.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the Single Shot bit value to be set. Accepted values are:
                                                        0 - Sequential scan mode
                                                        1 - Single Shot mode
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetSingleShotModeBit(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetSingleShotModeBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the 'Alert Pin' bit value.
    @Description
        This method returns the 'Alert Pin' bit value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The 'Alert Pin' bit value. Possible values are:
                                        0 - disabled alert pin function
                                        1 - enabled alert pin function
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t alertPin = ${moduleNameUpperCase}_GetAlertPin(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetAlertPin(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'Alert Pin' bit value.
    @Description
        This method sets the 'Alert Pin' bit value. Followed by the REFRESH or REFRESH_V command, 
            the new bit value will be activated.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param  
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the alert pin bit value to be set. Accepted values are:
                                        0 - disable the alert pin function
                                        1 - SLOW pin function as an ALERT pin
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetAlertPin(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetAlertPin(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the 'ALERT_CC' bit value.
    @Description
        This method returns the 'ALERT_CC' bit value. If this bit is 1, 
        'Alert Pin' is asserted for 5us at the end of each conversion cycle.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The 'ALERT_CC' bit value. Possible values:
                0 - No Alert Conversion Cycle Complete
                1 - ALERT function asserted for 5us on each completion of the conversion cycle
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
        If this bit and the 'Overflow ALert' bit are set, 'Overflow Alert' dominates.
    @Example
        <code>
            uint8_t alertCC = ${moduleNameUpperCase}_GetAlertCC(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetAlertCC(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'ALERT_CC' bit value.
    @Description
        This method sets the 'ALERT_CC' bit value. If this bit is set to 1, 
        'Alert Pin' is asserted for 5us at the end of each conversion cycle.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the 'ALERT_CC' bit value to be set. Accepted values are:
                  0 - No Alert on Conversion Cycle Complete
                  1 - ALERT function asserted for 5us on each completion of the conversion cycle
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
        If this bit and the 'Overflow ALert' bit are set, ' Overflow Alert ' dominates.
    @Example
        <code>
            ${moduleNameUpperCase}_SetAlertCC(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetAlertCC(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the 'Overflow Alert' bit value.
    @Description
        This method returns the ' Overflow Alert ' bit value. If this bit is set 
        and any of the accumulators or the accumulator counter overflow, 
        the ALERT function will be triggered. In this case, this bit will be 0 
        and 'ALERT' pin will be 1.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The ' Overflow Alert ' bit value. Possible values are:
            0 - no ALERT if accumulator or accumulator counter overflow has occurred
            1 - ALERT pin triggered if accumulators or accumulator counter have overflowed
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT
    @Note   
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
        If this bit and the ' Overflow Alert ' bit are set, ' Overflow Alert ' dominates.
    @Example
        <code>
            uint8_t overflowAlert = ${moduleNameUpperCase}_GetOverflowAlert(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetOverflowAlert(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'Overflow Alert' bit value.
    @Description
        This method sets the current ' Overflow Alert ' bit value. If this bit is set 
        and any of the accumulators or the accumulator counter overflow, 
        the ALERT function will be triggered. In this case, this bit will be 0 
        and 'ALERT' pin will be 1.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the ' Overflow Alert ' bit value to be set. Accepted values are:
                    0 - no ALERT if accumulator or accumulator counter overflow has occurred
                    1 - ALERT pin triggered if accumulators or accumulator counter have overflowed
    @Returns
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
            If this bit and the ' Overflow Alert ' bit are set, ' Overflow Alert ' dominates.
    @Example
        <code>
            ${moduleNameUpperCase}_SetOverflowAlert(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetOverflowAlert(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the 'Overflow' bit value.
    @Description
        This method returns the overflow indication status bit. 
        This bit will be 1 if any of the accumulators or the accumulator counter overflows.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The 'Overflow' bit value.
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t overflowBit = ${moduleNameUpperCase}_GetOverflow(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetOverflow(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'CHANNEL_DIS and SMBus' register value.
    @Description
        This method returns the currently set ' Channel DIS and SMBus ' register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Returns
        The register value.
                Bit 7: CH1_OFF
                Bit 6: CH2_OFF
                Bit 5: CH3_OFF
                Bit 4: CH4_OFF
                Bit 3: SMBus Timeout
                Bit 2: SMBus Byte Count
                Bit 1: No Skip
                Bit 0: Unimplemented
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelDisReg = ${moduleNameUpperCase}_GetChannelDisRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelDisRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'CHANNEL_DIS and SMBus' register value.
    @Description
        This method sets the current ' Channel DIS and SMBus ' register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the ' Channel DIS and SMBus ' register value to be set:
                                Bit 7: CH1_OFF
                                Bit 6: CH2_OFF
                                Bit 5: CH3_OFF
                                Bit 4: CH4_OFF
                                Bit 3: SMBus Timeout
                                Bit 2: SMBus Byte Count
                                Bit 1: No Skip
                                Bit 0: Unimplemented
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetChannelDisRegister(1, 0x10, 0);
        <code>
*/
void ${moduleNameUpperCase}_SetChannelDisRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the channel state value.
    @Description
        This method returns the state of a channel during conversion cycle, active or inactive.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Return
        The state for selected channel. Possible values are:
                0 - channel active during conversion cycle
                1 - channel inactive during conversion cycle
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelStateCh1 = ${moduleNameUpperCase}_GetChannelState(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelState(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
    @Description
        This method sets the state of a channel, active or inactive, during conversion cycle.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param 
        i2cAddress - the i2c 7bit client address to be accessed
    @Param 
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param 
        value - the state value to be set for selected channel. Accepted values are:
                        0 - Channel active during conversion cycle
                        1 - Channel inactive during conversion cycle
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            //set off CH1
            ${moduleNameUpperCase}_SetChannelState(1, 0x10, 1, 1);
        <code>
 */
void ${moduleNameUpperCase}_SetChannelState(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t value);


/**
    @Summary
        Returns the 'Timeout Enable' bit value.
    @Description
        This method returns the value of the ' Timeout enable ' bit.
        The SMBus timeout is disabled by default, and is enabled by setting this bit.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed  
    @Return
        The ' Timeout enable ' bit value.
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t timeoutBit = ${moduleNameUpperCase}_GetSmbusTimeoutBit(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSmbusTimeoutBit(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'Timeout Enable' bit value.
    @Description
        This method sets the ' Timeout enable ' bit value. 
        The SMBus timeout is disabled by default, and is enabled by settings this bit.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the ' SMBus Timeout ' bit value to be set. Accepted values are 0 or 1.
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetSmbusTimeoutBit(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetSmbusTimeoutBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the 'Byte Count' bit value.
    @Description
        This method returns the value of ' Byte Count ' bit.
        This bit causes Byte Count data to be included in the response to the 
        SMBus Block Read command for each register read. 
        This functionality is disabled by default, and Block Read corresponds 
        to I2C Protocol.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The ' Byte Count ' bit value. Possible values are:
                            0 - No Byte Count in response to a Block Read command
                            1 - Data in response to a Block Read command includes the Byte Count data
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t byteCountBit = ${moduleNameUpperCase}_GetSmbusByteCountBit(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSmbusByteCountBit(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'Byte Count' bit value.
    @Description
        This method sets the value of ' Byte Count ' bit. 
        This bit causes Byte Count data to be included in the response to the 
        SMBus Block Read command for each register read. This functionality is
        disabled by default, and Block Read corresponds to I2C protocol.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        bitValue - the ' Byte Count ' bit value to be set. Accepted values are:
                        0 - No Byte Count in response to a Block Read command
                        1 - Data in response to a Block Read command includes Byte Count data
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetSmbusByteCountBit(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetSmbusByteCountBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t bitValue);


/**
    @Summary
        Returns the 'NO SKIP' bit value.
    @Description
        This method returns the ' NO SKIP ' bit value. This bit controls 
        the auto-incrementing of the address pointer for channels that are inactive.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed  
    @Return
        The ' NO SKIP ' bit value. Possible values are:
            0 - The auto-incrementing pointer will skip over address pointer for channels that are inactive
            1 - The auto-incrementing pointer will not skip over addresses used by/for channels that are inactive
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t noSkipBit = ${moduleNameUpperCase}_GetNoSkipBit(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetNoSkipBit(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'NO SKIP' bit value.
    @Description
        This method sets the ' NO SKIP ' bit value. This bit controls the 
        auto-incrementing of the address pointer for channels that are inactive.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        bitValue - the ' NO SKIP ' bit value to be set. Accepted values are:
            0 - The auto-incrementing pointer will skip over address pointer for channels that are inactive
            1 - The auto-incrementing pointer will not skip over addresses used by/for channels that are inactive
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetNoSkipBit(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetNoSkipBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t bitValue);


/**
    @Summary
        Returns the 'NEG_PWR' register value.
    @Description
        This method returns the currently set 'NEG_PWR' register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'NEG_PWR' register value:
                        Bit 7: CH1 Bidirectional current measurement
                        Bit 6: CH2 Bidirectional current measurement
                        Bit 5: CH3 Bidirectional current measurement
                        Bit 4: CH4 Bidirectional current measurement
                        Bit 3: CH1 Bidirectional voltage measurement
                        Bit 2: CH2 Bidirectional voltage measurement
                        Bit 1: CH3 Bidirectional voltage measurement
                        Bit 0: CH4 Bidirectional voltage measurement
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t negPwrRegister = ${moduleNameUpperCase}_GetNegPwrRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetNegPwrRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'NEG_PWR' register value.
    @Description
        This method sets the current 'NEG_PWR' register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the 'NEG_PWR' register value to be set:
                    Bit 7: CH1 Bidirectional current measurement
                    Bit 6: CH2 Bidirectional current measurement
                    Bit 5: CH3 Bidirectional current measurement
                    Bit 4: CH4 Bidirectional current measurement
                    Bit 3: CH1 Bidirectional voltage measurement
                    Bit 2: CH2 Bidirectional voltage measurement
                    Bit 1: CH3 Bidirectional voltage measurement
                    Bit 0: CH4 Bidirectional voltage measurement
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetNegPwrRegister(1, 0x10, 0);
        <code>
*/
void ${moduleNameUpperCase}_SetNegPwrRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the channel bidirectional current state value.
    @Description
        This method returns if current measurements are bidirectional, for selected channel. 
        In bidirectional mode, the Vsense voltage measurement data format is in 
        16-bit two's complement (signed) format and the full scale range for 
        Vsense is -100mV to +100mV.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are: 1, 2, 3 or 4.
    @Return
        The bit value for selected channel. Possible values are:
                            0 - scale range for Vsense is 0 to +100mV 
                            1 - scale range for Vsense is -100mV to +100mV
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelBidICh1 = ${moduleNameUpperCase}_GetChannelBidI(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelBidI(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Sets the channel bidirectional current state value.
    @Description
        This method sets if current measurements are bidirectional, for selected channel. 
        In bidirectional mode, the Vsense voltage measurement data format is in 
        16-bit two's complement (signed) format and the full scale range for 
        Vsense is -100mV to +100mV.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are: 1, 2, 3 or 4.
    @Param
        value - the bit value to be set for selected channel. Accepted values are:
                        0 - scale range for Vsense is 0 to +100mV
                        1 - scale range for Vsense is -100mV to +100mV
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetChannelBidI(1, 0x10, 1, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetChannelBidI(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t value);


/**
    @Summary
        Returns the channel bidirectional voltage state value.
    @Description
        This method returns if voltage measurements are bidirectional, for selected channel. 
        In bidirectional mode, the Vbus voltage measurement data format is 16bit two's complement. 
        If the channel is enabled for negative voltage measurements, 
        the full scale range for Vbus is -32V to 32V.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are: 1, 2, 3 or 4.
    @Return
        The bit value for selected channel. Possible values are:
                        0 - scale range for Vbus is 0 to +32V
                        1 - scale range for Vbus is -32V to +32V
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelBidVCh1 = ${moduleNameUpperCase}_GetChannelBidV(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelBidV(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Sets the channel bidirectional voltage state value.
    @Description
        This method sets if voltage measurements are bidirectional, for selected channel. 
        In this mode, the Vbus voltage measurement data format is 16-bit two's complement. 
        If the channel is enabled for negative voltage measurements, 
        the full scale for Vbus is -32V to +32V.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Param
        value - the bit value to be set for selected channel. Accepted values are:
                            0 - scale range for Vbus is 0 to +32V
                            1 - scale range for Vbus is -32V to +32V
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetChannelBidV(1, 0x10, 1, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetChannelBidV(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t value);


/**
    @Summary
        Returns the 'SLOW' register value.
    @Description
        This method returns the currently set 'SLOW' register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'SLOW' register value:
                    Bit 7: Slow Pin
                    Bit 6: Low to High transition
                    Bit 5: High to Low transition
                    Bit 4: REFRESH Rising Edge
                    Bit 3: REFRESH_V Rising Edge
                    Bit 2: REFRESH Falling Edge
                    Bit 1: REFRESH_V Falling Edge
                    Bit 0: Power On Reset bit
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t slowRegister = ${moduleNameUpperCase}_GetSlowRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSlowRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets the 'SLOW' register value.
    @Description
        This method sets the current 'SLOW' register value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - 'SLOW' register value to be set
                            Bit 7: Slow Pin (just readable)
                            Bit 6: Low to High transition (just readable)
                            Bit 5: High to Low transition (just readable)
                            Bit 4: REFRESH Rising Edge
                            Bit 3: REFRESH_V Rising Edge
                            Bit 2: REFRESH Falling Edge
                            Bit 1: REFRESH_V Falling Edge
                            Bit 0: Power On Reset bit
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetSlowRegister(1, 0x10, 0x15);
        <code>
*/
void ${moduleNameUpperCase}_SetSlowRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns the 'Slow Pin' bit value.
    @Description
        This method returns the currently slow pin value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The ' Slow Pin ' bit value.
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t slowPin = ${moduleNameUpperCase}_GetSlowPin(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSlowPin(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns slow transition value.
    @Description
        This method returns the currently type of slow transition.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The slow transition value. Possible values are:
            0 - the Slow pin has not transitioned (Low to High or High to Low) since the last REFRESH command
            1 - the Slow pin has transitioned High to Low since the last REFRESH command
            2 - the Slow pin has transitioned Low to High since the last REFRESH command
            3 - the Slow pin has transitioned High to Low and Low to High since the last REFRESH command
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_SLOW_TRANSITION.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t slowTransition = ${moduleNameUpperCase}_GetSlowTransition(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSlowTransition(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns rise refresh type value.
    @Description
        This method returns which type of refresh (REFRESH or REFRESH_V) is enabled 
        to take place on the rising edge of the SLOW pin.
        This bit is not reset automatically, it must be written to be changed.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The value associated with the refresh type:
                0 - disables a limited REFRESH and REFRESH_V functions to take place 
                        on the rising edge of the SLOW pin
                1 - enables a limited REFRESH_V function to take place on the rising
                        edge of the SLOW pin
                2 - enables a limited REFRESH function to take place on the rising
                        edge of the SLOW pin
                3 - enables a limited REFRESH and REFRESH_V functions to take place
                        on the rising edge of the SLOW pin
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_REFRESH_TYPE.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
           uint8_t riseRefreshType = ${moduleNameUpperCase}_GetRiseRefreshType(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetRiseRefreshType(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets rise refresh type value.
    @Description
        This method sets which type of refresh (REFRESH or REFRESH_V) is enabled 
        to take place on the rising edge of the SLOW pin. 
        This bit is not reset automatically, it must be written to be changed.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the associated value to refresh type to be set. Accepted values are:
                    0 - disables a limited REFRESH and REFRESH_V functions to take place 
                            on the rising edge of the SLOW pin
                    1 - enables a limited REFRESH_V function to take place on the rising
                            edge of the SLOW pin
                    2 - enables a limited REFRESH function to take place on the rising
                            edge of the SLOW pin
                    3 - enabled a limited REFRESH and REFRESH_V functions to take place  
                            on the rising edge of the SLOW pin
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetRiseRefreshType(1, 0x10, 2);
        <code>
*/
void ${moduleNameUpperCase}_SetRiseRefreshType(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns fall refresh type value.
    @Description
        This method returns which type of refresh (REFRESH or REFRESH_V) is enabled 
        to take place on the falling edge of the SLOW pin. This bit is not reset
        automatically, it must be written to be changed.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The value associated with the refresh type:
                    0 - disables a limited REFRESH and REFRESH_V functions to take place
                            on the falling edge of the SLOW pin
                    1 - enables a limited REFRESH_V function to take place on the
                            falling edge of the SLOW pin
                    2 - enables a limited REFRESH function to take place on the 
                            falling edge of the SLOW pin
                    3 - enables a limited REFRESH and REFRESH_V functions to take place
                            on the falling edge of the SLOW pin
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_REFRESH_TYPE.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t fallRefreshType = ${moduleNameUpperCase}_GetFallRefreshType(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetFallRefreshType(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets fall refresh type value.
    @Description
        This method sets which type of refresh (REFRESH or REFRESH_V) is enabled 
        to take place on the falling edge of the SLOW pin. 
        This bit is not reset automatically, it must be written to be changed.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the associated value to refresh type, to be set:
                    0 - disables a limited REFRESH and REFRESH_V functions to take place
                            on the falling edge of the SLOW pin
                    1 - enables a limited REFRESH_V function to take place on the
                            falling edge of the SLOW pin
                    2 - enables a limited REFRESH function to take place on the 
                            falling edge of the SLOW pin
                    3 - enables a limited REFRESH and REFRESH_V functions to take place
                            on the falling edge of the SLOW pin
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            ${moduleNameUpperCase}_SetFallRefreshType(1, 0x10, 2);
        <code>
*/
void ${moduleNameUpperCase}_SetFallRefreshType(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns 'POR' bit value.
    @Description
        This method returns the currently ' Power On Reset ' status flag value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The POR status bit value. Possible values are:
                0 - this bit has been cleared over I2C since the last POR occurred
                1 - this bit has the POR default value of 1, and has not been cleared
                    since the last recent occurred
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t porBit = ${moduleNameUpperCase}_GetPowerOnResetBit(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetPowerOnResetBit(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Sets 'POR' bit value.
    @Description
        This method sets the current ' Power On Reset ' status flag value.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        value - the POR status bit to be set. Accepted values are:
                    0 - this bit has been cleared over I2C since the last POR occurred
                    1 - this bit has the POR default value of 1, and has not been
                            cleared since the last recent occurred
    @Return
        None
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            ${moduleNameUpperCase}_SetPowerOnResetBit(1, 0x10, 1);
        <code>
*/
void ${moduleNameUpperCase}_SetPowerOnResetBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value);


/**
    @Summary
        Returns 'CTRL_ACT' register value.
    @Description
        This method returns an image of the Control register. 
        Its value reflects the current active value, whereas the value of the 
        Control register (0x01 address) may have been programmed but
        not activated by one of the REFRESH commands.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The current active value of control register.
                        Bits 7-6:   Sample Rate
                        Bit 5:      Sleep 
                        Bit 4:      Single-shot mode
                        Bit 3:      Alert Pin
                        Bit 2:      Alert CC
                        Bit 1:      Overflow Alert
                        Bit 0:      Overflow
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t ctrlActRegister = ${moduleNameUpperCase}_GetCtrlActRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetCtrlActRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'SAMPLE_RATE_ACT' value.
    @Description
        This method returns the sample rate value that is currently active 
        since the most recent REFRESH function was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The current active sample rate value. Possible values are:
                            1024 samples/s
                             256 samples/s
                              64 samples/s
                               8 samples/s
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint16_t sampleRateAct = ${moduleNameUpperCase}_GetSampleRateAct(1, 0x10);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetSampleRateAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'SLEEP_MODE_ACT' bit value.
    @Description
        This method returns the 'Sleep' bit value that is currently active since 
        the most recent REFRESH function was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The current active 'Sleep' bit value. Possible values are:
                        0 - Active mode
                        1 - Sleep mode, no data conversion
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t sleepModeAct = ${moduleNameUpperCase}_GetSleepModeBitAct(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSleepModeBitAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'SINGLE_SHOT_ACT' bit value.
    @Description
        This method returns the ' Single Shot ' bit value that is currently 
        active since the most recent REFRESH command was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The current active ' Single Shot ' bit value. Possible values are:
                0 - Sequential scan mode
                1 - Single-shot mode
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t singleShotAct = ${moduleNameUpperCase}_GetSingleShotModeBitAct(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSingleShotModeBitAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'ALERT_PIN_ACT' bit value.
    @Description
        This method returns the 'ALERT_PIN' bit value that is currently active 
        since the most recent REFRESH function was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The current active 'ALERT_PIN' bit value. Possible values are:
                0 - Disabled ALERT pin function
                1 - Enabled ALERT pin function
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t alertPinAct = ${moduleNameUpperCase}_GetAlertPinAct(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetAlertPinAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'ALERT_CC_ACT' bit value.
    @Description
        This method returns the 'ALERT_CC' bit value that is currently active 
        since the most recent REFRESH function was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed     
    @Return
        The current 'ALERT_CC' bit value. Possible values are:
                0 - No ALERT on Conversion Cycle Complete
                1 - ALERT function asserted for 5us on each completion of the Conversion Cycle
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t alertCCAct = ${moduleNameUpperCase}_GetAlertCCAct(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetAlertCCAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'OVERFLOW_ALERT_ACT' bit value.
    @Description
        This method returns the ' Overflow Alert ' bit value that is currently 
        active since the most recent REFRESH function was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed   
    @Return
        The current active ' Overflow Alert ' bit value. Possible values are:
            0 - No ALERT if accumulator or accumulator counter overflow has occurred
            1 - ALERT pin triggered if accumulator or accumulator counter has overflowed
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t overflowAlertAct = ${moduleNameUpperCase}_GetOverflowAlertAct(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetOverflowAlertAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'OVERFLOW_ACT' bit value.
    @Description
        This method returns the 'Overflow' bit value that is currently active 
        since the most recent REFRESH function was received.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed  
    @Return
        The current active 'Overflow' bit value. Possible values are:
            0 - No accumulator or accumulator counter overflow has occurred
            1 - Accumulator or accumulator counter has overflowed
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t overflowAct = ${moduleNameUpperCase}_GetOverflowAlert(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetOverflowAct(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns 'CHANNEL_DIS_ACT' register value.
    @Description
        This method returns an image of the Channel Disable bits in 'CHANNEL_DIS' register (0x1C).
        The bits reflect the value that was activated by the most recent REFRESH function,
        and is currently active.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'CHANNEL_DIS' current active register value:
                Bit 7:    CH1_OFF
                Bit 6:    CH2_OFF
                Bit 5:    CH3_OFF
                Bit 4:    CH4_OFF
                Bits 3-0: Unimplemented
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelDisActRegister = ${moduleNameUpperCase}_GetChannelDisActRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelDisActRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns actual channel state value.
    @Description
        This method returns an image of a channel state which reflects the value 
        that was activated by the most recent REFRESH function, and is currently active.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Return
        The current active state for selected channel. Possible values are:
                0 - channel ON
                1 - channel OFF
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelStateActCh1 = ${moduleNameUpperCase}_GetChannelStateAct(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelStateAct(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns 'NEG_PWR_ACT' register value.
    @Description
        This method returns an image of the NEG_PWR register (0x1D). 
        The bits reflect the value that was activated by the most recent REFRESH function, 
        and is currently active.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'NEG_PWR' current active register value:
                Bit 7: CH1 Bidirectional current measurement
                Bit 6: CH2 Bidirectional current measurement
                Bit 5: CH3 Bidirectional current measurement
                Bit 4: CH4 Bidirectional current measurement
                Bit 3: CH1 Bidirectional voltage measurement
                Bit 2: CH2 Bidirectional voltage measurement
                Bit 1: CH3 Bidirectional voltage measurement
                Bit 0: CH4 Bidirectional voltage measurement
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t negPwrActRegister = ${moduleNameUpperCase}_GetNegPwrActRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetNegPwrActRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the actual channel bidirectional current measurement state value.
    @Description
        This method returns the current measurements are currently activated 
        to be bidirectional, for selected channel. This bit reflects the value 
        for selected channel that was activated by the most recent REFRESH
            function, and is currently active.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Return
        The current active bit value for selected channel. Possible values are:
                        0 - scale range for Vsense is 0 to +100mV
                        1 - scale range for Vsense is -100mV to +100mV
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t channelBidIActCh1 = ${moduleNameUpperCase}_GetChannelBidIAct(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelBidIAct(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the actual bidirectional voltage measurement state value.
    @Description
        This method returns if voltage measurements are currently activated to be 
        directional, for selected channel. This bit reflects the value for 
        selected channel that was activated by the most recent
        REFRESH function, and is currently active.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Return
        The current active bit value for selected channel. Possible values are:
                        0 - scale range for Vbus is 0 to +32V
                        1 - scale range for Vbus is -32V to +32V
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelBidVActCh1 = ${moduleNameUpperCase}_GetChannelBidVAct(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelBidVAct(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the 'CTRL_LAT' register value.
    @Description
        This method returns an image of the 'CTRL_ACT' register (0x21). 
        This register reflects the value that was active before the most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The control register value that was active before the most recent REFRESH command.
                                Bits 7-6: Sample Rate
                                Bit 5:    Sleep
                                Bit 4:    Single-shot mode
                                Bit 3:    Alert Pin
                                Bit 2:    Alert CC
                                Bit 1:    Overflow Alert
                                Bit 0:    Overflow
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t ctrlLatRegister = ${moduleNameUpperCase}_GetCtrlLatRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetCtrlLatRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'SAMPLE_RATE_LAT' value.
    @Description
        This method returns the sample rate value that was active before the 
        most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The sample rate value that was active before the most recent REFRESH command. 
            Possible values are:
                1024 samples/s
                 256 samples/s
                  64 samples/s
                   8 samples/s
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint16_t sampleRateLat = ${moduleNameUpperCase}_GetSampleRateLat(1, 0x10);
        <code>
*/
uint16_t ${moduleNameUpperCase}_GetSampleRateLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'SLEEP_LAT' bit value.
    @Description
        This method returns the 'SLEEP' bit value that was active before the most 
        recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'SLEEP' bit value that was active before the most recent REFRESH command. 
            Possible values are:
                            0 - Active mode
                            1 - Sleep mode
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t sleepModeBitLat = ${moduleNameUpperCase}_GetSleepModeBitLat(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSleepModeBitLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
       Returns the 'SINGLE_SHOT_LAT' bit value. 
    @Description
        This method returns the ' Single-Shot ' bit value that was active before 
        the most recent REFRESH function.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The ' Single-Shot ' bit value that was active before the most recent REFRESH command. 
            Possible values are:
                            0 - Sequential scan mode
                            1 - Single-shot mode
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t singleShotBitLat = ${moduleNameUpperCase}_GetSingleShotModeBitLat(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetSingleShotModeBitLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'ALERT_PIN_LAT' bit value.
    @Description
        This method returns the 'ALERT_PIN' bit value that was active before the 
        most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'ALERT_PIN' bit value that was active before the most recent REFRESH command. 
            Possible values are:
                    0 - Disabled ALERT pin function
                    1 - Enabled ALERT pin function
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t alertPinLat = ${moduleNameUpperCase}_GetAlertPinLat(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetAlertPinLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'ALERT_CC_LAT' bit value.
    @Description
        This method returns the 'ALERT_CC' bit value that was active before the 
        most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'ALERT_CC' bit value that was active before the most recent REFRESH command. 
            Possible values are:
                0 - No ALERT on Conversion Cycle Complete
                1 - ALERT function asserted for 5us on each completion of the Conversion cycle
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t alertCCLat = ${moduleNameUpperCase}_GetAlertCCLat(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetAlertCCLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'OVERFLOW_ALERT_LAT' bit value.
    @Description
        This method returns the ' Overflow Alert ' bit value that was active before 
        the most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The ' Overflow Alert ' bit value that was active before the most recent REFRESH command. 
            Possible values are:
                0 - No ALERT if accumulator or accumulator counter overflow has occurred
                1 - ALERT pin triggered if accumulator or accumulator counter has overflowed
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t overflowAlertLat = ${moduleNameUpperCase}_GetOverflowAlertLat(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetOverflowAlertLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'OVERFLOW_LAT' bit value.
    @Description
        This method returns the 'Overflow' bit value that was active before the 
        most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'Overflow' bit value that was active before the most recent REFRESH command. 
            Possible values are:
                    0 - No accumulator or accumulator counter overflow has occurred
                    1 - Accumulator or accumulator counter has overflowed
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t overflowLat = ${moduleNameUpperCase}_GetOverflowLat(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetOverflowLat(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the 'CHANNEL_DIS_LAT' register value.
    @Description
        This method returns an image of the Channel Disable bits in 'CHANNEL_DIS_ACT' register (0x22).
        The bits reflect the value that was active before the most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'CHANNEL_DIS' register value that was active before the most recent REFRESH command:
                            Bit 7:    CH1_OFF
                            Bit 6:    CH2_OFF
                            Bit 5:    CH3_OFF
                            Bit 4:    CH4_OFF
                            Bits 3-0: Unimplemented
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t channelDisLatRegister = ${moduleNameUpperCase}_GetChannelDisLatRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelDisLatRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns latched channel state value.
    @Description
        This method returns an image of the actual channel state which reflects 
        the value that was active before the most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are: 1, 2, 3 or 4.
    @Return
        The state for selected channel that was active before the most recent REFRESH command.
            Possible values are:
                            0 - channel ON
                            1 - channel OFF
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t channelStateLatCh1 = ${moduleNameUpperCase}_GetChannelStateLat(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelStateLat(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the 'NEG_PWR_LAT' register value.
    @Description
        This method Returns an image of the NEG_PWR_ACT register (0x23). 
        The bits reflect the value that was active before the most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Return
        The 'NEG_PWR' register value that was active before the most recent REFRESH command.
                            Bit 7: CH1 Bidirectional current measurement
                            Bit 6: CH2 Bidirectional current measurement
                            Bit 5: CH3 Bidirectional current measurement
                            Bit 4: CH4 Bidirectional current measurement
                            Bit 3: CH1 Bidirectional voltage measurement
                            Bit 2: CH2 Bidirectional voltage measurement
                            Bit 1: CH3 Bidirectional voltage measurement
                            Bit 0: CH4 Bidirectional voltage measurement
        In case of execution error, the returned value is 0.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution).
    @Example
        <code>
            uint8_t negPwrLatRegister = ${moduleNameUpperCase}_GetNegPwrLatRegister(1, 0x10);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetNegPwrLatRegister(uint8_t i2cBusID, uint8_t i2cAddress);


/**
    @Summary
        Returns the latched bidirectional current measurement state value.
    @Description
        This method returns if current measurements were activated to be bidirectional 
        before the most recent REFRESH command, for selected channel. This bit 
        reflects the value for selected channel that was active before 
        the most recent REFRESH function.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Return
        The bit value that was active before the most recent REFRESH command, for selected channel.
            Possible values are:
                    0 - scale range for Vsense is 0 to +100mV
                    1 - scale range for Vsense is -100mV to +100mV
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t channelBidILatCh1 = ${moduleNameUpperCase}_GetChannelBidILat(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelBidILat(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


/**
    @Summary
        Returns the latched bidirectional voltage measurement state value
    @Description
        This method returns if voltage measurements are activated to be bidirectional 
        before the most recent REFRESH command, for selected channel. 
        This bit reflects the value for selected channel that was active before 
        the most recent REFRESH command.
    @Preconditions
        None
    @Param
        i2cBusID - the i2c bus ID: 1 for i2c1, 2 for i2c2, 3 for i2c3, 4 for i2c4
    @Param
        i2cAddress - the i2c 7bit client address to be accessed
    @Param
        channelNo - the channel index. Accepted values are 1, 2, 3 or 4.
    @Return
        The bit value that was active before the most recent REFRESH command, for selected channel.
            Possible values are:
                    0 - scale range for Vbus is 0 to +32V
                    1 - scale range for Vbus is -32V to +32V
        In case of execution error, the returned value is ${moduleNameUpperCase}_INVALID_BIT.
    @Note
        The following ${moduleNameUpperCase}_GetLastError() call returns this method execution
        resulted error code (e.g. ${moduleNameUpperCase}_NO_ERR for successful execution). 
    @Example
        <code>
            uint8_t channelBidVLatCh1 = ${moduleNameUpperCase}_GetChannelBidVLat(1, 0x10, 1);
        <code>
*/
uint8_t ${moduleNameUpperCase}_GetChannelBidVLat(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo);


#ifdef	__cplusplus
}
#endif /* __cplusplus */

#endif	/* XC_HEADER_TEMPLATE_H */