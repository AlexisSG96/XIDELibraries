<#if (picArchitecture = "8bit")>
<#assign i2cNoInstance = cboMssp?replace("MSSP", "")>
<#elseif (picArchitecture = "16bit")>
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

// MCP47FEB Library Version
// #define MCP47FEB_LIBVER "${libVersion}"

#include "MCP47FEBxx.h"

int8_t MCP47FEB_MODULE_Initialize(MCP47FEB_i2c_params i2cParams){
    int8_t errorCode = MCP47FEB_SUCCESS;
	
    //CHANNEL 0
    <#if txtCh0VolatileDac != "">
    errorCode = MCP47FEB_SetVolatileDacValue(i2cParams, 0, ${txtCh0VolatileDac});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    </#if>
	
    <#switch cboCh0VolatileGain>
    <#case "Gain_X1">
    errorCode = MCP47FEB_SetVolatileGain(i2cParams, 0, MCP47FEB_GAIN_X1);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "Gain_X2">
    errorCode = MCP47FEB_SetVolatileGain(i2cParams, 0, MCP47FEB_GAIN_X2);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    </#switch>	
	
    errorCode = MCP47FEB_SetVolatilePowerdown(i2cParams, 0, MCP47FEB_${cboCh0VolatilePowerdown});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    errorCode = MCP47FEB_SetVolatileVref(i2cParams, 0, MCP47FEB_${cboCh0VolatileVref});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    <#if txtCh0NonvolatileDac != "">
    errorCode = MCP47FEB_SetNonvolatileDacValue(i2cParams, 0, ${txtCh0NonvolatileDac});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    </#if>
	
    <#switch cboCh0NonvolatileGain>
    <#case "Gain_X1">
    errorCode = MCP47FEB_SetNonvolatileGain(i2cParams, 0, MCP47FEB_GAIN_X1);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "Gain_X2">
    errorCode = MCP47FEB_SetNonvolatileGain(i2cParams, 0, MCP47FEB_GAIN_X2);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    </#switch>
	
    errorCode = MCP47FEB_SetNonvolatilePowerdown(i2cParams, 0, MCP47FEB_${cboCh0NonvolatilePowerdown});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    errorCode = MCP47FEB_SetNonvolatileVref(i2cParams, 0, MCP47FEB_${cboCh0NonvolatileVref});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    <#if enableI2cAddrLock == "enabled" >
    errorCode = MCP47FEB_SetI2cAddressLockStatus(i2cParams, MCP47FEB_LOCK);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#else>
    errorCode = MCP47FEB_SetI2cAddressLockStatus(i2cParams, MCP47FEB_UNLOCK);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    </#if>
	
    <#switch cboCh0Locks>
    <#case "Unlock all">
    errorCode = MCP47FEB_SetLocks(i2cParams, 0, MCP47FEB_UNLOCK_ALL);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "All nonvolatile regs">
    errorCode = MCP47FEB_SetLocks(i2cParams, 0, MCP47FEB_LOCK_ALL_NONVOLATILE_REGS);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "All except volatile config">
    errorCode = MCP47FEB_SetLocks(i2cParams, 0, MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "All DAC regs">
    errorCode = MCP47FEB_SetLocks(i2cParams, 0, MCP47FEB_LOCK_ALL);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    </#switch>
	  

    <#-- 2 channels -->
    <#if noOfChannels == "2" >
    //CHANNEL 1
    <#if txtCh1VolatileDac != "">
    errorCode = MCP47FEB_SetVolatileDacValue(i2cParams, 1, ${txtCh1VolatileDac});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    </#if>
	
    <#switch cboCh1VolatileGain>
    <#case "Gain_X1">
    errorCode = MCP47FEB_SetVolatileGain(i2cParams, 1, MCP47FEB_GAIN_X1);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "Gain_X2">
    errorCode = MCP47FEB_SetVolatileGain(i2cParams, 1, MCP47FEB_GAIN_X2);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    </#switch>
	
    errorCode = MCP47FEB_SetVolatilePowerdown(i2cParams, 1, MCP47FEB_${cboCh1VolatilePowerdown});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    errorCode = MCP47FEB_SetVolatileVref(i2cParams, 1, MCP47FEB_${cboCh1VolatileVref});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    <#if txtCh1NonvolatileDac != "">
    errorCode = MCP47FEB_SetNonvolatileDacValue(i2cParams, 1, ${txtCh1NonvolatileDac});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    </#if>
	
    <#switch cboCh1NonvolatileGain>
    <#case "Gain_X1">
    errorCode = MCP47FEB_SetNonvolatileGain(i2cParams, 1, MCP47FEB_GAIN_X1);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    <#case "Gain_X2">
    errorCode = MCP47FEB_SetNonvolatileGain(i2cParams, 1, MCP47FEB_GAIN_X2);
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
    <#break>
    </#switch>
	
    errorCode = MCP47FEB_SetNonvolatilePowerdown(i2cParams, 1, MCP47FEB_${cboCh1NonvolatilePowerdown});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    errorCode = MCP47FEB_SetNonvolatileVref(i2cParams, 1, MCP47FEB_${cboCh1NonvolatileVref});
    if(errorCode != MCP47FEB_SUCCESS) goto initialize_exit;
	
    <#switch cboCh1Locks>
    <#case "Unlock all">
    errorCode = MCP47FEB_SetLocks(i2cParams, 1, MCP47FEB_UNLOCK_ALL);
    <#break>
    <#case "All nonvolatile regs">
    errorCode = MCP47FEB_SetLocks(i2cParams, 1, MCP47FEB_LOCK_ALL_NONVOLATILE_REGS);
    <#break>
    <#case "All except volatile config">
    errorCode = MCP47FEB_SetLocks(i2cParams, 1, MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG);
    <#break>
    <#case "All DAC regs">
    errorCode = MCP47FEB_SetLocks(i2cParams, 1, MCP47FEB_LOCK_ALL);
    <#break>
    </#switch>
    </#if>

initialize_exit:    
    return errorCode;
}

/* MCP47FEB_Write() and 
 * MCP47FEB_Read() implementation 
 * with "Foundation Services" I2C support API
 */
#if defined(I2C_FSERV_ENABLED)
/* WARNING: Foundation Services supports only one I2C host by default */
/* Consequently, i2cBusID is not used in this implementation. */

int8_t MCP47FEB_Write(MCP47FEB_i2c_params i2cParams, uint8_t *pdata, uint8_t length){
   int8_t errorCode = MCP47FEB_NO_ERR;
//    //validate the parameters
//    if( (pdata == NULL) ||
//        (length == 0) ){
//        return MCP47FEB_INVALID_PARAMETER;
//    }    
   i2c_writeNBytes(i2cParams.i2cAddress, pdata, length);
   return errorCode;
}

int8_t MCP47FEB_Read(MCP47FEB_i2c_params i2cParams, uint8_t *pdata, uint8_t length){
    int8_t errorCode = MCP47FEB_NO_ERR;
//    //validate the parameters
//    if( (pdata == NULL) ||
//        (length == 0) ){
//        return MCP47FEB_INVALID_PARAMETER;
//    }            
    
    //read the register value
    i2c_readNBytes(i2cParams.i2cAddress, pdata, length);
    return errorCode;
}
#endif // defined(I2C_FSERV_ENABLED)

/* MCP47FEB_Write() and 
 * MCP47FEB_Read() implementation 
 * with "classic" I2C support API
 */
<#switch noOfMssp>
    <#case "4">
#if defined(I2C1_CLASSIC_ENABLED) || defined(I2C2_CLASSIC_ENABLED) || defined(I2C3_CLASSIC_ENABLED) || defined(I2C4_CLASSIC_ENABLED)
    <#break>
    <#case "3">
#if defined(I2C1_CLASSIC_ENABLED) || defined(I2C2_CLASSIC_ENABLED) || defined(I2C3_CLASSIC_ENABLED) 
    <#break>
    <#case "2">
#if defined(I2C1_CLASSIC_ENABLED) || defined(I2C2_CLASSIC_ENABLED)
    <#break>
    <#case "1">
        <#if i2cNoInstance = ''>
#if defined(I2C_CLASSIC_ENABLED)
        <#else>
#if defined(I2C1_CLASSIC_ENABLED)
        </#if>
    <#break>
</#switch>
int8_t MCP47FEB_Write(MCP47FEB_i2c_params i2cParams, uint8_t *pdata, uint8_t length){
    volatile I2C_MESSAGE_STATUS(I2CPREF) status; //volatile

//    //validate parameters
//    if( (pdata == NULL) ||
//        (length == 0) ){
//        return MCP47FEB_INVALID_PARAMETER;
//    }
    
    switch(i2cParams.i2cBusID){
<#switch noOfMssp>
    <#case "4">
#ifdef I2C4_CLASSIC_ENABLED
        case 4:
            I2C4_MasterWrite(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
    <#case "3">
#ifdef I2C3_CLASSIC_ENABLED
        case 3:
            I2C3_MasterWrite(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
    <#case "2">
#ifdef I2C2_CLASSIC_ENABLED
        case 2:
            I2C2_MasterWrite(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
    <#case "1">
<#if i2cNoInstance = ''>
#ifdef I2C_CLASSIC_ENABLED
        case 1: 
            I2C_MasterWrite(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
<#else>
#ifdef I2C1_CLASSIC_ENABLED
        case 1: 
            I2C1_MasterWrite(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
</#if>
</#switch>
        default:
            /* i2cBusID is not valid */
            return MCP47FEB_INVALID_I2C_BUSID;
    }
     
    //wait for the message to be sent or has changed
    while(status == I2C_MESSAGE_PENDING(I2CPREF));
    
    if(status != I2C_MESSAGE_COMPLETE(I2CPREF)){
        return MCP47FEB_I2C_ERRCLASS | status;
    }else{
        return MCP47FEB_SUCCESS;
    }
}

int8_t MCP47FEB_Read(MCP47FEB_i2c_params i2cParams, uint8_t *pdata, uint8_t length){
    volatile I2C_MESSAGE_STATUS(I2CPREF) status; //volatile
    
//    //validate the parameters
//    if( (pdata == NULL) ||
//        (length == 0) ){
//        return MCP47FEB_INVALID_PARAMETER;
//    }
    
    //read the register value 
    switch(i2cParams.i2cBusID){
<#switch noOfMssp>
    <#case "4">
#ifdef I2C4_CLASSIC_ENABLED
        case 4:
            I2C4_MasterRead(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
    <#case "3">
#ifdef I2C3_CLASSIC_ENABLED
        case 3:
            I2C3_MasterRead(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
    <#case "2">
#ifdef I2C2_CLASSIC_ENABLED            
        case 2:
            I2C2_MasterRead(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
    <#case "1">
<#if i2cNoInstance = ''>
#ifdef I2C_CLASSIC_ENABLED
        case 1: 
            I2C_MasterRead(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
<#else>
#ifdef I2C1_CLASSIC_ENABLED
        case 1: 
            I2C1_MasterRead(pdata, length, i2cParams.i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
</#if>
    </#switch>
        default:
            /* i2cBusID is not valid */
            return MCP47FEB_INVALID_I2C_BUSID;
    }
     
    //wait for the message to be sent or has changed
    while(status == I2C_MESSAGE_PENDING(I2CPREF));
    
    if(status != I2C_MESSAGE_COMPLETE(I2CPREF)){
        return MCP47FEB_I2C_ERRCLASS | status;
    }else{
        return MCP47FEB_SUCCESS;
    }
}
#endif // defined(I2C1_CLASSIC_ENABLED) || defined(I2C2_CLASSIC_ENABLED) || defined(I2C3_CLASSIC_ENABLED) || defined(I2C4_CLASSIC_ENABLED)

int8_t MCP47FEB_GetVolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* dacValue) {
    uint8_t rxData[2];
    uint8_t addrCmd; 
    int8_t errorCode;

	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            addrCmd = MCP47FEB_VOLATILE_DAC0_ADDR | MCP47FEB_CMD_READ;
            break;
        case 1:
            addrCmd = MCP47FEB_VOLATILE_DAC1_ADDR | MCP47FEB_CMD_READ;
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	<#else>
    if(channelNo == 0){
        addrCmd = MCP47FEB_VOLATILE_DAC0_ADDR | MCP47FEB_CMD_READ;
    }
    else {
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	</#if>
    
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *dacValue = rxData[0];
    *dacValue = (*dacValue << 8) + rxData[1];
    return MCP47FEB_SUCCESS;
}


int8_t MCP47FEB_SetVolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t dacValue) {
    uint8_t writeBuffer[3];
    int8_t errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            writeBuffer[0] = MCP47FEB_VOLATILE_DAC0_ADDR & MCP47FEB_CMD_WRITE;
            break;
        case 1:
            writeBuffer[0] = MCP47FEB_VOLATILE_DAC1_ADDR & MCP47FEB_CMD_WRITE;
            break;
        default:
               return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
    if(channelNo == 0){
        writeBuffer[0] = MCP47FEB_VOLATILE_DAC0_ADDR & MCP47FEB_CMD_WRITE;
    } else {
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    </#if>
    
    writeBuffer[1] = (dacValue & 0xff00) >> 8;
    writeBuffer[2] = (dacValue & 0xff);
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_SetAllVolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t vrefSettings) {
    uint8_t writeBuffer[3];
    int8_t errorCode;
    
    writeBuffer[0] = MCP47FEB_VOLATILE_VREF_ADDR & MCP47FEB_CMD_WRITE;        
    writeBuffer[1] = (vrefSettings & 0xff00) >> 8;
    writeBuffer[2] = (vrefSettings & 0xff);
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetAllVolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t* vrefSettings) {
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;
    
     addrCmd = MCP47FEB_VOLATILE_VREF_ADDR | MCP47FEB_CMD_READ;

    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *vrefSettings = rxData[0];
    *vrefSettings = (*vrefSettings << 8) + rxData[1];
    return MCP47FEB_SUCCESS;
}

int8_t MCP47FEB_GetVolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* vrefSetting){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
    addrCmd = MCP47FEB_VOLATILE_VREF_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *vrefSetting = rxData[1] & MCP47FEB_CH0;
            return MCP47FEB_SUCCESS;
        case 1:
            *vrefSetting = (rxData[1] & MCP47FEB_CH1) >> 2;
            return MCP47FEB_SUCCESS;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	<#else>
	*vrefSetting = rxData[1] & MCP47FEB_CH0;
    return MCP47FEB_SUCCESS;
	</#if>	
}

int8_t MCP47FEB_SetVolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t vrefSetting){
    uint16_t readVref;
    int8_t errorCode;
    
    if (vrefSetting != MCP47FEB_VREF_VDD &&
        vrefSetting != MCP47FEB_VREF_INTERNAL &&
        vrefSetting != MCP47FEB_VREF_UNBUFFERED	&&
        vrefSetting != MCP47FEB_VREF_BUFFERED ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // first read the existing value, modify the desired channel and write back the new value.
    errorCode = MCP47FEB_GetAllVolatileVref(i2cParams, &readVref);
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    uint8_t     writeBuffer[3];
    writeBuffer[0] = MCP47FEB_VOLATILE_VREF_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[1] = (vrefSetting & 0xff00) >> 8; // msb, unimplemented
        
    <#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            // make sure the desired channel bits are set to 0
            readVref = readVref & (~MCP47FEB_CH0);
            // now update their value
            writeBuffer[2] = (uint8_t)((vrefSetting & MCP47FEB_CH0) | readVref);
            break;
        case 1:
            readVref = readVref & (~MCP47FEB_CH1);
            writeBuffer[2] = (uint8_t)(((vrefSetting << 2) & MCP47FEB_CH1) | readVref);
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
	// make sure the desired channel bits are set to 0
    readVref = readVref & (~MCP47FEB_CH0);
    // now update their value
    writeBuffer[2] = (uint8_t)((vrefSetting & MCP47FEB_CH0) | readVref);
	</#if>
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;    
}

int8_t MCP47FEB_SetAllVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t powerdownSetting){
    uint8_t     writeBuffer[3];
    int8_t errorCode;
    
    writeBuffer[0] = MCP47FEB_VOLATILE_POWERDOWN_ADDR & MCP47FEB_CMD_WRITE;        
    writeBuffer[1] = 0 ; //unimplemented
    writeBuffer[2] = (powerdownSetting & 0xff);
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;    
}

int8_t MCP47FEB_GetAllVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t* powerdownSetting){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;
    
    addrCmd = MCP47FEB_VOLATILE_POWERDOWN_ADDR | MCP47FEB_CMD_READ;

    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *powerdownSetting = rxData[0];
    *powerdownSetting = (*powerdownSetting << 8) + rxData[1];
    return MCP47FEB_SUCCESS;    
}

int8_t MCP47FEB_GetVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* powerdownSetting){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
    addrCmd = MCP47FEB_VOLATILE_POWERDOWN_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *powerdownSetting = rxData[1] & MCP47FEB_CH0;
            return MCP47FEB_SUCCESS;
        case 1:
            *powerdownSetting = (rxData[1] & MCP47FEB_CH1) >> 2;
            return MCP47FEB_SUCCESS;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	<#else>
	*powerdownSetting = rxData[1] & MCP47FEB_CH0;
    return MCP47FEB_SUCCESS;
	</#if>
}

int8_t MCP47FEB_SetVolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t powerdownSetting){
    uint16_t readVal;
    int8_t errorCode;
    
    if (powerdownSetting != MCP47FEB_PWRDN_100K&&
        powerdownSetting != MCP47FEB_PWRDN_1K &&
        powerdownSetting != MCP47FEB_PWRDN_NORMAL	&&
        powerdownSetting != MCP47FEB_PWRDN_VOUT ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // first read the existing value, modify the desired channel and write back the new value.
    errorCode = MCP47FEB_GetAllVolatilePowerdown(i2cParams, &readVal);
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    uint8_t     writeBuffer[3];
     
    writeBuffer[0] = MCP47FEB_VOLATILE_POWERDOWN_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[1] = 0; // msb, unimplemented
    
    <#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            // make sure the desired channel bits are set to 0
            readVal = readVal & (~MCP47FEB_CH0);
            // now update their value
            writeBuffer[2] = (uint8_t)((powerdownSetting & MCP47FEB_CH0) | readVal);
            break;
        case 1:
            readVal = readVal & (~MCP47FEB_CH1);
            writeBuffer[2] = (uint8_t)((((uint16_t)powerdownSetting << 2) & MCP47FEB_CH1) | readVal);
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
	// make sure the desired channel bits are set to 0
    readVal = readVal & (~MCP47FEB_CH0);
    // now update their value
    writeBuffer[2] = (uint8_t)((powerdownSetting & MCP47FEB_CH0) | readVal);
    </#if>
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetVolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* gainValue){
    uint8_t rxData[1];
    uint8_t addrCmd;
    int8_t errorCode;

     if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
     addrCmd = MCP47FEB_VOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *gainValue = rxData[0] & BIT_0_MASK; //MSB bit 0 is the ch0 gain
            return MCP47FEB_SUCCESS;
        case 1:
            *gainValue = (rxData[0] & BIT_1_MASK) >> 1;
            return MCP47FEB_SUCCESS;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	<#else>
	*gainValue = rxData[0] & BIT_0_MASK; //MSB bit 0 is the ch0 gain
    return MCP47FEB_SUCCESS;
	</#if>
}

int8_t MCP47FEB_SetVolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t gainValue){
    uint16_t readVal;
    int8_t errorCode;
    
    if (gainValue != MCP47FEB_GAIN_X1&&
        gainValue != MCP47FEB_GAIN_X2 ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // first read the existing value, modify the desired channel and write back the new value.
    uint8_t rxData[1];
    uint8_t addrCmd; 
    uint8_t writeBuffer[3];

    addrCmd = MCP47FEB_VOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    readVal = rxData[0];
     
    writeBuffer[0] = MCP47FEB_VOLATILE_GAIN_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[2] = 0; // LSB, unimplemented
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            // make sure the desired channel bits are set to 0
            readVal = readVal & (~BIT_0_MASK);
            // now update their value
            writeBuffer[1] = (uint8_t)((gainValue & BIT_0_MASK) | readVal);
            break;
        case 1:
            readVal = readVal & (~BIT_1_MASK);
            writeBuffer[1] = (uint8_t)((((uint16_t)gainValue << 1) & BIT_1_MASK) | readVal);
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
    // make sure the desired channel bits are set to 0
    readVal = readVal & (~BIT_0_MASK);
    // now update their value
    writeBuffer[1] = (uint8_t)((gainValue & BIT_0_MASK) | readVal);
    </#if>

    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;    
}

int8_t MCP47FEB_GetPorStatus (MCP47FEB_i2c_params i2cParams, uint8_t* porFlag){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

    addrCmd = MCP47FEB_VOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *porFlag = (rxData[1] & BIT_7_MASK) >> 7; //LSB bit 7 is the POR flag
    return MCP47FEB_SUCCESS;
}

int8_t MCP47FEB_GetEEWAStatus (MCP47FEB_i2c_params i2cParams, uint8_t* eewaFlag){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

    addrCmd = MCP47FEB_VOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *eewaFlag = (rxData[1] & BIT_6_MASK) >> 6; //LSB bit 6 is the EEWA flag
    return MCP47FEB_SUCCESS;    
}

int8_t MCP47FEB_GetI2cAddressLockStatus(MCP47FEB_i2c_params i2cParams, uint8_t* i2cAddrLockFlag){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

    addrCmd = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
   
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *i2cAddrLockFlag = (rxData[1] & BIT_7_MASK) >> 7 ; //LSB bit 7 is the I2C address lock flag
    return MCP47FEB_SUCCESS;      
}

int8_t MCP47FEB_SetI2cAddressLockStatus (MCP47FEB_i2c_params i2cParams, uint8_t i2cAddrLockFlag){
    int8_t errorCode;
    uint8_t writeBuffer[3];
        
    if (i2cAddrLockFlag != MCP47FEB_LOCK&&
        i2cAddrLockFlag != MCP47FEB_UNLOCK ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if(i2cAddrLockFlag == MCP47FEB_LOCK){
        writeBuffer[0] = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_DISABLE;
    } else {
        writeBuffer[0] = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_ENABLE; //enable changing the address
    }
    
    //lock/unlock the i2c address
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetI2cAddressValue (MCP47FEB_i2c_params i2cParams, uint8_t* i2cAddrVal){
    int8_t errorCode;
    uint8_t rxData[2];
    uint8_t addrCmd; 
    
     addrCmd = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
     
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *i2cAddrVal = rxData[1] & 0x7F ;//first 7 bits of LSB hold the address
    return MCP47FEB_SUCCESS;
}

int8_t MCP47FEB_SetI2cAddress(MCP47FEB_i2c_params i2cParams, uint8_t addrValue){
    uint8_t readVal[2];
    if (addrValue > 0x7F ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    // first read the existing value, modify the desired bits and write back the new value.
    uint8_t rxData[2];
    uint8_t addrCmd; 
    uint8_t writeBuffer[3];
    int8_t errorCode;

    addrCmd = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    readVal[0] = rxData[0]; 
    readVal[1] = rxData[1];
   
    writeBuffer[0] = MCP47FEB_NONVOLATILE_GAIN_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[1] = readVal[0]; // MSB, copy existing value
    // now update the value
    writeBuffer[2] = addrValue | (readVal[1] & (BIT_7_MASK));

    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetAllLocks(MCP47FEB_i2c_params i2cParams, uint16_t* lockOptions){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;
    
    addrCmd = MCP47FEB_VOLATILE_WIPERLOCK_ADDR | MCP47FEB_CMD_READ;
     
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *lockOptions = rxData[0];
    *lockOptions = (*lockOptions << 8) + rxData[1];
    return MCP47FEB_SUCCESS;     
}

int8_t MCP47FEB_GetLocks(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* lockOption){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

     if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
    addrCmd = MCP47FEB_VOLATILE_WIPERLOCK_ADDR | MCP47FEB_CMD_READ;
    
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *lockOption = rxData[1] & MCP47FEB_CH0;
            return MCP47FEB_SUCCESS;
        case 1:
            *lockOption = (rxData[1] & MCP47FEB_CH1) >> 2;
            return MCP47FEB_SUCCESS;
        default:
            return MCP47FEB_ERR_UNKNOWN_ERROR;
    }
	<#else>
    *lockOption = rxData[1] & MCP47FEB_CH0;
    return MCP47FEB_SUCCESS;
    </#if>
}

int8_t MCP47FEB_SetAllLocks(MCP47FEB_i2c_params i2cParams, uint16_t lockOption){
    int8_t errorCode;
    
    // configure channel 0
    errorCode = MCP47FEB_SetLocks(i2cParams, 0,lockOption & MCP47FEB_CH0);
    if (errorCode != MCP47FEB_NO_ERR){
        return errorCode;
    }
    
	<#if noOfChannels == "2">
    // alow time for the write to finish 
    DELAY_MS(20);

    //configure channel 1
    errorCode = MCP47FEB_SetLocks(i2cParams, 1,(lockOption & MCP47FEB_CH1) >> 2);
    if (errorCode != MCP47FEB_NO_ERR){
        return errorCode;
    } 	
	</#if>
    return MCP47FEB_NO_ERR;
}

int8_t MCP47FEB_SetLocks(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t lockOptions){
    uint8_t writeBuffer[1];
    int8_t errorCode;
    
    if (lockOptions != MCP47FEB_UNLOCK_ALL &&
        lockOptions != MCP47FEB_LOCK_ALL_NONVOLATILE_REGS &&
        lockOptions != MCP47FEB_LOCK_ALL_EXCEPT_VOLATILE_CONFIG	&&
        lockOptions != MCP47FEB_LOCK_ALL ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // extract the value for each config bit and write them all at once
    // the input value is structured as follows: bits 1:0 = DLx:CLx 
    uint8_t dlVal = (lockOptions & 0x2) >> 1;
    uint8_t clVal = (lockOptions & 0x1);
    uint8_t addrCl, addrDl;
    
	<#if noOfChannels == "2">
    switch(channelNo){
        case 0:
            addrCl = MCP47FEB_VOLATILE_DAC0_ADDR;
            addrDl = MCP47FEB_NONVOLATILE_DAC0_ADDR;
            break;
        case 1:
            addrCl = MCP47FEB_VOLATILE_DAC1_ADDR;
            addrDl = MCP47FEB_NONVOLATILE_DAC1_ADDR;
            break;
        default:
            //we should never get here
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
    addrCl = MCP47FEB_VOLATILE_DAC0_ADDR;
    addrDl = MCP47FEB_NONVOLATILE_DAC0_ADDR;
    </#if>
    
    if(clVal == MCP47FEB_LOCK){
        writeBuffer[0] = addrCl | MCP47FEB_CMD_DISABLE;
    } else {
        writeBuffer[0] = addrCl | MCP47FEB_CMD_ENABLE; 
    }
    
    // lock/unlock the CL bit
    // write one config bit at a time
    // continuously writing CL + DL will only correctly set the 
    // first bit that was transmitted in the I2C transaction
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //wait for the eeprom to finish writing 
    DELAY_MS(20);
    
    // move to the DL address
   
    if(dlVal == MCP47FEB_LOCK){
        writeBuffer[0] = addrDl | MCP47FEB_CMD_DISABLE;
    } else {
        writeBuffer[0] = addrDl | MCP47FEB_CMD_ENABLE;
    }
   
    // lock/unlock the DL bit
    // write one config bit at a time
    // continuously writing CL + DL will only correctly set the 
    // first bit that was transmitted in the I2C transaction
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}


int8_t MCP47FEB_GetNonvolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* dacValue) {
    uint8_t rxData[2];
    uint8_t addrCmd; 
    int8_t errorCode;
	
    switch (channelNo){
        case 0:
            addrCmd = MCP47FEB_NONVOLATILE_DAC0_ADDR | MCP47FEB_CMD_READ;
            break;
        <#if noOfChannels == "2">
        case 1:
            addrCmd = MCP47FEB_NONVOLATILE_DAC1_ADDR | MCP47FEB_CMD_READ;
            break;
        </#if>
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *dacValue = rxData[0];
    *dacValue = (*dacValue << 8) + rxData[1];
    return MCP47FEB_SUCCESS;    
   }


int8_t MCP47FEB_SetNonvolatileDacValue(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t dacValue) {
    uint8_t     writeBuffer[3];
    int8_t errorCode;    
	
    switch (channelNo){
        case 0:
            writeBuffer[0] = MCP47FEB_NONVOLATILE_DAC0_ADDR & MCP47FEB_CMD_WRITE;
            break;
        <#if noOfChannels == "2">
        case 1:
            writeBuffer[0] = MCP47FEB_NONVOLATILE_DAC1_ADDR & MCP47FEB_CMD_WRITE;
            break;
        </#if>
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    writeBuffer[1] = (dacValue & 0xff00) >> 8;
    writeBuffer[2] = (dacValue & 0xff);
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_SetAllNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t vrefSettings) {
    uint8_t     writeBuffer[3];
    int8_t errorCode;
    
    writeBuffer[0] = MCP47FEB_NONVOLATILE_VREF_ADDR & MCP47FEB_CMD_WRITE;        
    writeBuffer[1] = (vrefSettings & 0xff00) >> 8;
    writeBuffer[2] = (vrefSettings & 0xff);
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetAllNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint16_t* vrefSettings) {
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;
    
    addrCmd = MCP47FEB_NONVOLATILE_VREF_ADDR | MCP47FEB_CMD_READ;

    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *vrefSettings = rxData[0];
    *vrefSettings = (*vrefSettings << 8) + rxData[1];
    return MCP47FEB_SUCCESS;
}

int8_t MCP47FEB_GetNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t* vrefSetting){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

     if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
    addrCmd = MCP47FEB_NONVOLATILE_VREF_ADDR | MCP47FEB_CMD_READ;
     
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *vrefSetting = rxData[1] & MCP47FEB_CH0;
            return MCP47FEB_SUCCESS;
        case 1:
            *vrefSetting = (rxData[1] & MCP47FEB_CH1) >> 2;
            return MCP47FEB_SUCCESS;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	<#else>
    *vrefSetting = rxData[1] & MCP47FEB_CH0;
    return MCP47FEB_SUCCESS;
    </#if>
}

int8_t MCP47FEB_SetNonvolatileVref(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint16_t vrefSetting){
    uint16_t readVref;
    uint8_t  writeBuffer[3];
    int8_t   errorCode;

    if (vrefSetting != MCP47FEB_VREF_VDD &&
        vrefSetting != MCP47FEB_VREF_INTERNAL &&
        vrefSetting != MCP47FEB_VREF_UNBUFFERED	&&
        vrefSetting != MCP47FEB_VREF_BUFFERED ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // first read the existing value, modify the desired channel and write back the new value.
    errorCode = MCP47FEB_GetAllNonvolatileVref(i2cParams, &readVref);
    if (errorCode != MCP47FEB_SUCCESS){
        return errorCode;
    }
    
    writeBuffer[0] = MCP47FEB_NONVOLATILE_VREF_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[1] = (vrefSetting & 0xff00) >> 8; // msb, unimplemented
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            // make sure the desired channel bits are set to 0
            readVref = readVref & (~MCP47FEB_CH0);
            // now update their value
            writeBuffer[2] = (uint8_t)((vrefSetting & MCP47FEB_CH0) | readVref);
            break;
        case 1:
            readVref = readVref & (~MCP47FEB_CH1);
            writeBuffer[2] = (uint8_t)(((vrefSetting << 2) & MCP47FEB_CH1) | readVref);
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
    // make sure the desired channel bits are set to 0
    readVref = readVref & (~MCP47FEB_CH0);
    // now update their value
    writeBuffer[2] = (uint8_t)((vrefSetting & MCP47FEB_CH0) | readVref);
    </#if>
    
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_SetAllNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t powerdownSetting){
    uint8_t     writeBuffer[3];
    int8_t errorCode;
    
    writeBuffer[0] = MCP47FEB_NONVOLATILE_POWERDOWN_ADDR & MCP47FEB_CMD_WRITE;        
    writeBuffer[1] = 0 ; //unimplemented
    writeBuffer[2] = (powerdownSetting & 0xff);
    
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetAllNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint16_t* powerdownSetting){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;
    
    addrCmd = MCP47FEB_NONVOLATILE_POWERDOWN_ADDR | MCP47FEB_CMD_READ;
    
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    *powerdownSetting = rxData[0];
    *powerdownSetting = (*powerdownSetting << 8) + rxData[1];
    return MCP47FEB_SUCCESS;    
}

int8_t MCP47FEB_GetNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* powerdownSetting){
    uint8_t rxData[2];
    uint8_t addrCmd;
    int8_t errorCode;

    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
    addrCmd = MCP47FEB_NONVOLATILE_POWERDOWN_ADDR | MCP47FEB_CMD_READ;
    
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *powerdownSetting = rxData[1] & MCP47FEB_CH0;
            return MCP47FEB_SUCCESS;
        case 1:
            *powerdownSetting = (rxData[1] & MCP47FEB_CH1) >> 2;
            return MCP47FEB_SUCCESS;
        default:
            break;
    }
	<#else>
    *powerdownSetting = rxData[1] & MCP47FEB_CH0;
    return MCP47FEB_SUCCESS;
    </#if>
    return MCP47FEB_ERR_INVALID_CHANNEL;    
}

int8_t MCP47FEB_SetNonvolatilePowerdown(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t powerdownSetting){
    uint16_t readVal;
    uint8_t     writeBuffer[3];
    int8_t errorCode;
    
    if (powerdownSetting != MCP47FEB_PWRDN_100K&&
        powerdownSetting != MCP47FEB_PWRDN_1K &&
        powerdownSetting != MCP47FEB_PWRDN_NORMAL	&&
        powerdownSetting != MCP47FEB_PWRDN_VOUT ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // first read the existing value, modify the desired channel and write back the new value.
    int8_t res = MCP47FEB_GetAllNonvolatilePowerdown(i2cParams, &readVal);
    if (res != MCP47FEB_NO_ERR){
        return res;
    }
    
    writeBuffer[0] = MCP47FEB_NONVOLATILE_POWERDOWN_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[1] = 0; // msb, unimplemented
	
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            // make sure the desired channel bits are set to 0
            readVal = readVal & (~MCP47FEB_CH0);
            // now update their value
            writeBuffer[2] = (uint8_t)((powerdownSetting & MCP47FEB_CH0) | readVal);
            break;
        case 1:
            readVal = readVal & (~MCP47FEB_CH1);
            writeBuffer[2] = (uint8_t)((((uint16_t)powerdownSetting << 2) & MCP47FEB_CH1) | readVal);
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
    // make sure the desired channel bits are set to 0
    readVal = readVal & (~MCP47FEB_CH0);
    // now update their value
    writeBuffer[2] = (uint8_t)((powerdownSetting & MCP47FEB_CH0) | readVal);
    </#if>    
   
    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}

int8_t MCP47FEB_GetNonvolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t* gainValue){
    uint8_t rxData[1];
    uint8_t addrCmd;
    int8_t errorCode;

    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
     
    addrCmd = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
     
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            *gainValue = rxData[0] & BIT_0_MASK; //MSB bit 0 is the ch0 gain
            return MCP47FEB_SUCCESS;
        case 1:
            *gainValue = (rxData[0] & BIT_1_MASK) >> 1;
            return MCP47FEB_SUCCESS;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
	<#else>
    *gainValue = rxData[0] & BIT_0_MASK; //MSB bit 0 is the ch0 gain
    return MCP47FEB_SUCCESS;
    </#if>
}


int8_t MCP47FEB_SetNonvolatileGain(MCP47FEB_i2c_params i2cParams, uint8_t channelNo, uint8_t gainValue){
    uint16_t readVal;
    uint8_t rxData[2];
    uint8_t addrCmd; 
    uint8_t writeBuffer[3];
    int8_t errorCode;
    
    if (gainValue != MCP47FEB_GAIN_X1&&
        gainValue != MCP47FEB_GAIN_X2 ){
        return MCP47FEB_ERR_INVALID_VALUE;
    }
    
    if (channelNo > NO_OF_CHANNELS - 1){
        return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    
    // first read the existing value, modify the desired channel and write back the new value.
    addrCmd = MCP47FEB_NONVOLATILE_GAIN_ADDR | MCP47FEB_CMD_READ;
     
    //set the device register pointer
    errorCode = MCP47FEB_Write(i2cParams, &addrCmd, sizeof(addrCmd));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    //read the register value
    errorCode = MCP47FEB_Read(i2cParams, rxData, sizeof(rxData));
    if(errorCode != MCP47FEB_SUCCESS) return errorCode;
    
    readVal = rxData[0];
    
    writeBuffer[0] = MCP47FEB_NONVOLATILE_GAIN_ADDR & MCP47FEB_CMD_WRITE;
    writeBuffer[2] = rxData[1]; // i2c address
	
	<#if noOfChannels == "2">
    switch (channelNo){
        case 0:
            // make sure the desired channel bits are set to 0
            readVal = readVal & (~BIT_0_MASK);
            // now update their value
            writeBuffer[1] = (uint8_t)((gainValue & BIT_0_MASK) | readVal);
            break;
        case 1:
            readVal = readVal & (~BIT_1_MASK);
            writeBuffer[1] = (uint8_t)((((uint16_t)gainValue << 1) & BIT_1_MASK) | readVal);
            break;
        default:
            return MCP47FEB_ERR_INVALID_CHANNEL;
    }
    <#else>
    // make sure the desired channel bits are set to 0
    readVal = readVal & (~BIT_0_MASK);
    // now update their value
    writeBuffer[1] = (uint8_t)((gainValue & BIT_0_MASK) | readVal);
    </#if>

    errorCode = MCP47FEB_Write(i2cParams, writeBuffer, sizeof(writeBuffer));
    return errorCode;
}








