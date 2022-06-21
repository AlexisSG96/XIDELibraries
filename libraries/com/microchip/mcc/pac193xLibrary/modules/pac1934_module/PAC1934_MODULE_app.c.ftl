<#assign moduleNameUpperCase = "PAC1934">
<#assign moduleNameLowerCase = "pac1934">
<#if (picArchitecture = "8bit")>
<#assign i2cNoInstance = cmbMSSP?replace("MSSP", "")>
<#elseif (picArchitecture = "16bit")>
<#assign i2cNoInstance = cmbMSSP?replace("I2C", "")>
</#if>
<#assign version = "2.00">
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

// PAC193x Library Version
// #define PAC193X_LIBVER "${libVersion}"

#include "${moduleNameUpperCase}.h"

static int16_t errorCode = -1;

/* I2C/SMBus configuration flag
 * WARNING: the flag is shared by all ${moduleNameUpperCase} devices in the system.
 * Consequently, all the devices, either on the same I2C bus or not must 
 * have the same BYTE_COUNT configuration: at the system initialization phase, 
 * the code must call the ${moduleNameUpperCase}_SetSmbusByteCountBit() for each PAC device.
 */
static bool ENABLE_BYTE_COUNT_FLAG = false;

void ${moduleNameUpperCase}_Device_Initialize(uint8_t i2cBusID, uint8_t i2cAddress){
    <#-- SAMPLE RATE , busID = selected I2C instance no.-->
    ${moduleNameUpperCase}_SetSampleRate(i2cBusID, i2cAddress, ${cmbSampleRate});

    <#-- SLEEP MODE -->
    <#if (ckSleepMode == "enabled")>
    ${moduleNameUpperCase}_SetSleepModeBit(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetSleepModeBit(i2cBusID, i2cAddress, 0);
    </#if>

    <#-- SINGLE SHOT MODE -->
    <#if (ckOneShot == "enabled")>
    ${moduleNameUpperCase}_SetSingleShotModeBit(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetSingleShotModeBit(i2cBusID, i2cAddress, 0);
    </#if>

    <#-- ALERT PIN -->
    <#if (ckAlertPin == "enabled")>
    ${moduleNameUpperCase}_SetAlertPin(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetAlertPin(i2cBusID, i2cAddress, 0);
    </#if>
    
    <#-- ALERT CC -->
    <#if (ckAlertCC == "enabled")>
    ${moduleNameUpperCase}_SetAlertCC(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetAlertCC(i2cBusID, i2cAddress, 0);
    </#if>

    <#-- OVERFLOW ALERT -->
    <#if (ckOverflowAlert == "enabled")>
    ${moduleNameUpperCase}_SetOverflowAlert(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetOverflowAlert(i2cBusID, i2cAddress, 0);
    </#if>

    //${moduleNameUpperCase}_SetCtrlRegister(i2cBusID, i2cAddress, ${ctrlRegister});

    <#-- CHANNEL STATE -->
    <#if (ckOnCh1 == "enabled")>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 1, 0);
    <#else>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 1, 1);
    </#if>
    <#if (ckOnCh2 == "enabled")>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 2, 0);
    <#else>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 2, 1);
    </#if>
    <#if (ckOnCh3 == "enabled")>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 3, 0);
    <#else>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 3, 1);
    </#if>
    <#if (ckOnCh4 == "enabled")>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 4, 0);
    <#else>
    ${moduleNameUpperCase}_SetChannelState(i2cBusID, i2cAddress, 4, 1);
    </#if>

    <#-- SMBUS TIMEOUT -->
    <#if (ckSmbusTimeout == "enabled")>
    ${moduleNameUpperCase}_SetSmbusTimeoutBit(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetSmbusTimeoutBit(i2cBusID, i2cAddress, 0);
    </#if>

    <#-- SMBUS BYTE COUNT -->
    <#if (ckSmbusByteCount == "enabled")>
    ${moduleNameUpperCase}_SetSmbusByteCountBit(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetSmbusByteCountBit(i2cBusID, i2cAddress, 0);
    </#if>

    <#-- NO SKIP -->
    <#if (ckNoSkip == "enabled")>
    ${moduleNameUpperCase}_SetNoSkipBit(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetNoSkipBit(i2cBusID, i2cAddress, 0);
    </#if>

    //${moduleNameUpperCase}_SetChannelDisRegister(i2cBusID, i2cAddress, ${channelDisRegister});
    
    <#-- CHANNEL BID I&V -->
    <#switch cmbStateCh1>
    <#case "BiDirectional I">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 1, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 1, 0);
    <#break>
    <#case "BiDirectional IV">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 1, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 1, 1);
    <#break>
    <#case "BiDirectional V">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 1, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 1, 1);
    <#break>
    <#case "UniDirectional">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 1, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 1, 0);
    <#break>
    </#switch>
    <#switch cmbStateCh2>
    <#case "BiDirectional I">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 2, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 2, 0);
    <#break>
    <#case "BiDirectional IV">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 2, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 2, 1);
    <#break>
    <#case "BiDirectional V">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 2, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 2, 1);
    <#break>
    <#case "UniDirectional">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 2, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 2, 0);
    <#break>
    </#switch>
    <#switch cmbStateCh3>
    <#case "BiDirectional I">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 3, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 3, 0);
    <#break>
    <#case "BiDirectional IV">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 3, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 3, 1);
    errorCode = ${moduleNameUpperCase}_GetLastError();
    <#break>
    <#case "BiDirectional V">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 3, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 3, 1);
    <#break>
    <#case "UniDirectional">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 3, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 3, 0);
    <#break>
    </#switch>
    <#switch cmbStateCh4>
    <#case "BiDirectional I">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 4, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 4, 0);
    <#break>
    <#case "BiDirectional IV">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 4, 1);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 4, 1);
    <#break>
    <#case "BiDirectional V">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 4, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 4, 1);
    <#break>
    <#case "UniDirectional">
    ${moduleNameUpperCase}_SetChannelBidI(i2cBusID, i2cAddress, 4, 0);
    ${moduleNameUpperCase}_SetChannelBidV(i2cBusID, i2cAddress, 4, 0);
    <#break>
    </#switch>

    //${moduleNameUpperCase}_SetNegPwrRegister(i2cBusID, i2cAddress, ${negPwrRegister});

    <#-- RISE REFRESH -->
    <#switch cmbRisingEdge>
    <#case "NONE">
    ${moduleNameUpperCase}_SetRiseRefreshType(i2cBusID, i2cAddress, 0);
    <#break>
    <#case "REFRESH_V">
    ${moduleNameUpperCase}_SetRiseRefreshType(i2cBusID, i2cAddress, 1);
    <#break>
    <#case "REFRESH">
    ${moduleNameUpperCase}_SetRiseRefreshType(i2cBusID, i2cAddress, 2);
    <#break>
    <#case "REFRESH & REFRESH_V">
    ${moduleNameUpperCase}_SetRiseRefreshType(i2cBusID, i2cAddress, 3);
    <#break>
    </#switch>

    <#-- FALL REFRESH -->
    <#switch cmbFallingEdge>
    <#case "NONE">
    ${moduleNameUpperCase}_SetFallRefreshType(i2cBusID, i2cAddress, 0);
    <#break>
    <#case "REFRESH_V">
    ${moduleNameUpperCase}_SetFallRefreshType(i2cBusID, i2cAddress, 1);
    <#break>
    <#case "REFRESH">
    ${moduleNameUpperCase}_SetFallRefreshType(i2cBusID, i2cAddress, 2);
    <#break>
    <#case "REFRESH & REFRESH_V">
    ${moduleNameUpperCase}_SetFallRefreshType(i2cBusID, i2cAddress, 3);
    <#break>
    </#switch>

    <#-- POWER ON RESET -->
    <#if (ckPowerOnReset == "enabled")>
    ${moduleNameUpperCase}_SetPowerOnResetBit(i2cBusID, i2cAddress, 1);
    <#else>
    ${moduleNameUpperCase}_SetPowerOnResetBit(i2cBusID, i2cAddress, 0);
    </#if>

    //${moduleNameUpperCase}_SetSlowRegister(i2cBusID, i2cAddress, ${slowRegister});

    <#-- REFRESH TYPE -->
    <#switch cmbRefreshType>
    <#case "REFRESH">  
    ${moduleNameUpperCase}_Refresh(i2cBusID, i2cAddress);
    ${moduleNameUpperCase}_Refresh(i2cBusID, i2cAddress);
    <#break>
    <#case "REFRESH_G">
    ${moduleNameUpperCase}_RefreshG(i2cBusID, i2cAddress);
    ${moduleNameUpperCase}_RefreshG(i2cBusID, i2cAddress);
    <#break>
    <#case "REFRESH_V">
    ${moduleNameUpperCase}_RefreshV(i2cBusID, i2cAddress);
    ${moduleNameUpperCase}_RefreshV(i2cBusID, i2cAddress);
    <#break>
    </#switch>
}


int16_t ${moduleNameUpperCase}_GetLastError(void){
    return errorCode;
}

/* ${moduleNameUpperCase}_Write() and 
 * ${moduleNameUpperCase}_Read() implementation 
 * with "Foundation Services" I2C support API
 */
#if defined(I2C_FSERV_ENABLED)
/* WARNING 1: Foundation Services supports only one I2C host by default */
/* Consequently, i2cBusID is not used in this implementation. */

/* WARNING 2: replacing the ${moduleNameUpperCase}_Write function call with inline code in order to reduce the call-stack depth */
//void ${moduleNameUpperCase}_Write(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t *pdata, uint8_t length){
//    i2c_writeNBytes(i2cAddress, pdata, length);
//    errorCode = ${moduleNameUpperCase}_NO_ERR;
//}
#define ${moduleNameUpperCase}_Write(BUS_ID, I2C_ADDR, PDATA, LENGTH) { i2c_writeNBytes(I2C_ADDR, PDATA, LENGTH); \
                                                                   errorCode = ${moduleNameUpperCase}_NO_ERR; }


uint8_t ${moduleNameUpperCase}_Read(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t *pdata, uint8_t length){
    uint8_t byteCount;
    int i;
            
    if(ENABLE_BYTE_COUNT_FLAG == true){
        //in SMBUS block read protocol, the number of read bytes is returned 
        //before the actual data bytes
        length = (uint8_t)(length + SMBUS_BYTECNT);
    }
    
    //read the register value
    i2c_readNBytes(i2cAddress, pdata, length);

    if(ENABLE_BYTE_COUNT_FLAG == true){
        //SMBUS mode
        byteCount = pdata[0];
        //move the data to the beginning of the read buffer
        for(i=0; i<(length - SMBUS_BYTECNT); i++){
            *(pdata + i) = *(pdata + i + SMBUS_BYTECNT);
        }
    }else{
        //I2C mode
        byteCount = length;
    }
    
    errorCode = ${moduleNameUpperCase}_NO_ERR;
    return byteCount;
}
#endif // defined(I2C_FSERV_ENABLED)


/* ${moduleNameUpperCase}_Write() and 
 * ${moduleNameUpperCase}_Read() implementation 
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

void ${moduleNameUpperCase}_Write(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t *pdata, uint8_t length){
    volatile I2C_MESSAGE_STATUS(I2CPREF) status;
    
     switch(i2cBusID){
    <#switch noOfMssp>
        <#case "4">
#ifdef I2C4_CLASSIC_ENABLED
        case 4:
            I2C4_MasterWrite(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
        <#case "3">
#ifdef I2C3_CLASSIC_ENABLED
        case 3:
            I2C3_MasterWrite(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
        <#case "2">
#ifdef I2C2_CLASSIC_ENABLED
        case 2:
            I2C2_MasterWrite(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
        <#case "1">
<#if i2cNoInstance = ''>
#ifdef I2C_CLASSIC_ENABLED
        case 1: 
            I2C_MasterWrite(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
<#else>
#ifdef I2C1_CLASSIC_ENABLED
        case 1: 
            I2C1_MasterWrite(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
</#if>
    </#switch>
        default:
            /* i2cBusID is not valid */
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return;
    }
    
    //wait for the message to be sent or has changed
    while(status == I2C_MESSAGE_PENDING(I2CPREF));
    
    if(status != I2C_MESSAGE_COMPLETE(I2CPREF)){
        errorCode = ${moduleNameUpperCase}_I2C_ERRCLASS | status;
    }else{
        errorCode = ${moduleNameUpperCase}_NO_ERR;
    }
}

uint8_t ${moduleNameUpperCase}_Read(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t *pdata, uint8_t length){
    volatile I2C_MESSAGE_STATUS(I2CPREF) status;
    uint8_t byteCount;
    int i;
            
    if(ENABLE_BYTE_COUNT_FLAG == true){
        //in SMBUS block read protocol, the number of read bytes is returned 
        //before the actual data bytes
        length = (uint8_t)(length + SMBUS_BYTECNT);
    }
    
    //read the register value 
    switch(i2cBusID){
    <#switch noOfMssp>
        <#case "4">
#ifdef I2C4_CLASSIC_ENABLED
        case 4:
            I2C4_MasterRead(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
        <#case "3">
#ifdef I2C3_CLASSIC_ENABLED
        case 3:
            I2C3_MasterRead(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
        <#case "2">
#ifdef I2C2_CLASSIC_ENABLED            
        case 2:
            I2C2_MasterRead(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
        <#case "1">
<#if i2cNoInstance = ''>
#ifdef I2C_CLASSIC_ENABLED
        case 1: 
            I2C_MasterRead(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
<#else>
#ifdef I2C1_CLASSIC_ENABLED
        case 1: 
            I2C1_MasterRead(pdata, length, i2cAddress, (I2C_MESSAGE_STATUS(I2CPREF)*)&status);
            break;
#endif
</#if>
    </#switch>
        default:
            /* i2cBusID is not valid */
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;
    }

    //wait for the message to be sent or has changed
    while(status == I2C_MESSAGE_PENDING(I2CPREF));

    if(status == I2C_MESSAGE_COMPLETE(I2CPREF)){
        if(ENABLE_BYTE_COUNT_FLAG == true){
            //SMBUS mode
            byteCount = pdata[0];
            //move the data to the beginning of the read buffer
            for(i=0; i<(length - SMBUS_BYTECNT); i++){
                *(pdata + i) = *(pdata + i + SMBUS_BYTECNT);
            }
        }else{
            //I2C mode
            byteCount = length;
        }
        errorCode = ${moduleNameUpperCase}_NO_ERR;
    }else{
        byteCount = 0;
        errorCode = ${moduleNameUpperCase}_I2C_ERRCLASS | status;
    }
    return byteCount;
}
#endif // defined(I2C1_CLASSIC_ENABLED) || defined(I2C2_CLASSIC_ENABLED) || defined(I2C3_CLASSIC_ENABLED) || defined(I2C4_CLASSIC_ENABLED)



uint8_t ${moduleNameUpperCase}_GetProductID(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t readBuffer[1+SMBUS_BYTECNT];
    uint8_t registerAddr;

    //write the register address
    registerAddr = ${moduleNameUpperCase}_PRODUCT_ID_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR) 
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint8_t ${moduleNameUpperCase}_GetManufacturerID(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t readBuffer[1+SMBUS_BYTECNT];
    uint8_t registerAddr;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_MANUFACTURER_ID_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint8_t ${moduleNameUpperCase}_GetRevisionID(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t readBuffer[1+SMBUS_BYTECNT];
    uint8_t registerAddr;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_REVISION_ID_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


void ${moduleNameUpperCase}_Refresh(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t writeBuffer[1];
    
    writeBuffer[0] = ${moduleNameUpperCase}_REFRESH_CMD_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
}


void ${moduleNameUpperCase}_RefreshG(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t writeBuffer[1];
    
    writeBuffer[0] = ${moduleNameUpperCase}_REFRESH_G_CMD_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
}


void ${moduleNameUpperCase}_RefreshV(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t writeBuffer[1];
    
    writeBuffer[0] = ${moduleNameUpperCase}_REFRESH_V_CMD_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
}


uint32_t ${moduleNameUpperCase}_GetAccumulatorCount(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[3 + SMBUS_BYTECNT];
    uint32_t accumulatorCount;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_ACC_COUNT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;

    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 3);
    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    accumulatorCount = readBuffer[0];
    accumulatorCount = (accumulatorCount << 8) + readBuffer[1];
    accumulatorCount = (accumulatorCount << 8) + readBuffer[2];
    return accumulatorCount;
}


<#if (picArchitecture = "8bit")>
void ${moduleNameUpperCase}_GetPowerAccRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t* value){
    uint8_t registerAddr, readBuffer[6 + SMBUS_BYTECNT];
    int i;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VPOWER1_ACC_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VPOWER2_ACC_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VPOWER3_ACC_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VPOWER4_ACC_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return;
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return;
    
    //read 6 bytes to establish the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 6);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return;
    
    for(i = 0; i < 6; i++){
       *(value + i) = readBuffer[i];
    }
}


float ${moduleNameUpperCase}_GetPowerAccReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense){
    uint8_t bidV, bidI, VpowerAccRaw[6 + SMBUS_BYTECNT];
    float VpowerAccReal, PowerUnit, PowerFSR;
    uint32_t PowerRegScale = 0x10000000;
    uint32_t highPart, lowPart;
    
    // check if rsense!=0 
    if( rsense == 0 ){
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return 0; 
    }

    ${moduleNameUpperCase}_GetPowerAccRaw(i2cBusID, i2cAddress, channelNo, VpowerAccRaw);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    bidV = ${moduleNameUpperCase}_GetChannelBidVLat(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    bidI = ${moduleNameUpperCase}_GetChannelBidILat(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    highPart = VpowerAccRaw[0];
    highPart = (highPart << 8) + VpowerAccRaw[1];
    highPart = (highPart << 8) + VpowerAccRaw[2];
    lowPart = VpowerAccRaw[3];
    lowPart = (lowPart << 8) + VpowerAccRaw[4];
    lowPart = (lowPart << 8) + VpowerAccRaw[5];
    
    //the unit for Rsense is uOhms
    if(bidV == 1 || bidI == 1){
        if( (highPart & 0x800000) != 0 ){
            highPart = highPart | 0xFF800000; //sign extension
        }
        VpowerAccReal = (float)((int32_t)highPart);
        PowerFSR = (6.4 / rsense) * 1000000;
    }else{
        VpowerAccReal = (float)(highPart);
        PowerFSR = (3.2 / rsense) * 1000000;
    }
    PowerUnit = PowerFSR / (float)PowerRegScale;
    VpowerAccReal = VpowerAccReal * PowerUnit;
    VpowerAccReal = (VpowerAccReal * 16777216) + (((float)lowPart) * PowerUnit);
    
    return VpowerAccReal;
}
<#elseif (picArchitecture = "16bit")>
uint64_t ${moduleNameUpperCase}_GetPowerAccRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[6 + SMBUS_BYTECNT];
    uint64_t registerValue;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VPOWER1_ACC_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VPOWER2_ACC_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VPOWER3_ACC_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VPOWER4_ACC_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read 6 bytes to establish the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 6);
    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    registerValue = readBuffer[0];
    registerValue = (registerValue << 8) + readBuffer[1];
    registerValue = (registerValue << 8) + readBuffer[2];
    registerValue = (registerValue << 8) + readBuffer[3];
    registerValue = (registerValue << 8) + readBuffer[4];
    registerValue = (registerValue << 8) + readBuffer[5];
            
    return registerValue;
}

float ${moduleNameUpperCase}_GetPowerAccReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense){
    uint8_t bidV, bidI;
    uint64_t VpowerAccRaw;
    float VpowerAccReal, PowerUnit, PowerFSR;
    uint32_t PowerRegScale = 0x10000000;

    // check if rsense!=0 
    if( rsense == 0 ){
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return 0; 
    }
    
    VpowerAccRaw = ${moduleNameUpperCase}_GetPowerAccRaw(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    bidV = ${moduleNameUpperCase}_GetChannelBidVLat(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    bidI = ${moduleNameUpperCase}_GetChannelBidILat(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //the unit for Rsense is uOhms
    if(bidV == 1 || bidI == 1){
        if((VpowerAccRaw & 0x800000000000) == 0x800000000000){
            VpowerAccRaw = VpowerAccRaw | 0xFFFF800000000000;       //sign extension
        }
        VpowerAccReal = (float)((int64_t)VpowerAccRaw);
        PowerFSR = (6.4 / rsense) * 1000000;
    }else{
        VpowerAccReal = (float)VpowerAccRaw;
        PowerFSR = (3.2 / rsense) * 1000000;
    }
    PowerUnit = PowerFSR / PowerRegScale;
    VpowerAccReal = VpowerAccReal * PowerUnit;
    
    return VpowerAccReal;
}
</#if>

uint16_t ${moduleNameUpperCase}_GetVbusRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[2 + SMBUS_BYTECNT];
    uint16_t VbusRaw;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VBUS1_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VBUS2_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VBUS3_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VBUS4_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;      
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read 2 bytes to establish the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 2); 
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;

    VbusRaw = readBuffer[0];
    VbusRaw = (VbusRaw << 8) + readBuffer[1];
    return VbusRaw;
}

float ${moduleNameUpperCase}_GetVbusReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint16_t VbusRaw;
    uint8_t bidV;
    float VbusReal, VbusLsb;
    
    VbusRaw = ${moduleNameUpperCase}_GetVbusRaw(i2cBusID, i2cAddress, channelNo);
    if(errorCode == ${moduleNameUpperCase}_NO_ERR){
        bidV = ${moduleNameUpperCase}_GetChannelBidVLat(i2cBusID, i2cAddress, channelNo);
        if(errorCode == ${moduleNameUpperCase}_NO_ERR){
            if(bidV == 1){
                VbusLsb = 64000 / 65536.0;
                VbusReal = (float)((short)VbusRaw);
            }else{
                VbusLsb = 32000 / 65536.0;
                VbusReal = (float)VbusRaw;
            }
            VbusReal = VbusReal * VbusLsb;      //mV
            return VbusReal;
        }
    }
    return 0;
}

uint16_t ${moduleNameUpperCase}_GetVsenseRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[2 + SMBUS_BYTECNT];
    uint16_t VsenseRaw;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VSENSE1_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VSENSE2_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VSENSE3_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VSENSE4_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 2);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    VsenseRaw = readBuffer[0];
    VsenseRaw = (VsenseRaw << 8) + readBuffer[1];
    return VsenseRaw;
}

float ${moduleNameUpperCase}_GetVsenseReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint16_t VsenseRaw;
    uint8_t bidI;
    float VsenseReal, VsenseLsb;
    
    //read the register value
    VsenseRaw = ${moduleNameUpperCase}_GetVsenseRaw(i2cBusID, i2cAddress, channelNo);
    if(errorCode == ${moduleNameUpperCase}_NO_ERR){
        bidI = ${moduleNameUpperCase}_GetChannelBidILat(i2cBusID, i2cAddress, channelNo);
        if(errorCode == ${moduleNameUpperCase}_NO_ERR){
            if(bidI == 1){
                VsenseLsb = 200 / 65536.0;
                VsenseReal = (float)((short)VsenseRaw);
            }else{
                VsenseLsb = 100 / 65536.0;
                VsenseReal = (float)VsenseRaw;
            }
            VsenseReal = VsenseReal * VsenseLsb;        //mV
            return VsenseReal;
        }
    }
    return 0;
}

uint16_t ${moduleNameUpperCase}_GetVbusAvgRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[2 + SMBUS_BYTECNT];
    uint16_t VbusAvgRaw;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VBUS1_AVG_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VBUS2_AVG_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VBUS3_AVG_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VBUS4_AVG_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 2);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    VbusAvgRaw = readBuffer[0];
    VbusAvgRaw = (VbusAvgRaw << 8) + readBuffer[1];
    return VbusAvgRaw;
}

float ${moduleNameUpperCase}_GetVbusAvgReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint16_t VbusAvgRaw;
    uint8_t bidV;
    float VbusAvgReal, VbusLsb;
    
    VbusAvgRaw = ${moduleNameUpperCase}_GetVbusAvgRaw(i2cBusID, i2cAddress, channelNo);
    if(errorCode == ${moduleNameUpperCase}_NO_ERR){
        bidV = ${moduleNameUpperCase}_GetChannelBidVLat(i2cBusID, i2cAddress, channelNo);
        if(errorCode == ${moduleNameUpperCase}_NO_ERR){
            if(bidV == 1){
                VbusLsb = 64000 / 65536.0;
                VbusAvgReal = (float)((short)VbusAvgRaw);
            }else{
                VbusLsb = 32000 / 65536.0;
                VbusAvgReal = (float)VbusAvgRaw;
            }
            VbusAvgReal = (VbusAvgReal * VbusLsb);        //mV
            return VbusAvgReal;
        }
    }
    return 0;
}

uint16_t ${moduleNameUpperCase}_GetVsenseAvgRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[2 + SMBUS_BYTECNT];
    uint16_t VsenseAvgRaw;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VSENSE1_AVG_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VSENSE2_AVG_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VSENSE3_AVG_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VSENSE4_AVG_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 2);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    VsenseAvgRaw = readBuffer[0];
    VsenseAvgRaw = (VsenseAvgRaw << 8) + readBuffer[1];
    return VsenseAvgRaw;
}

float ${moduleNameUpperCase}_GetVsenseAvgReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint16_t VsenseAvgRaw;
    uint8_t bidI;
    float VsenseAvgReal, VsenseLsb;
    
    VsenseAvgRaw = ${moduleNameUpperCase}_GetVsenseAvgRaw(i2cBusID, i2cAddress, channelNo);
    if(errorCode == ${moduleNameUpperCase}_NO_ERR){
        bidI = ${moduleNameUpperCase}_GetChannelBidILat(i2cBusID, i2cAddress, channelNo);
        if(errorCode == ${moduleNameUpperCase}_NO_ERR){
            if(bidI == 1){
                VsenseLsb = 200 / 65536.0;
                VsenseAvgReal = (float)((short)VsenseAvgRaw);
            }else{
                VsenseLsb = 100 / 65536.0;
                VsenseAvgReal = (float)VsenseAvgRaw;
            }
            VsenseAvgReal = VsenseAvgReal * VsenseLsb;      //mV
            return VsenseAvgReal;
        }
    }
    return 0;
}

float ${moduleNameUpperCase}_GetIsense(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense){
    float VsenseReal, current;

    // check if rsense!=0 
    if( rsense == 0 ){
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return 0; 
    }
    
    VsenseReal = ${moduleNameUpperCase}_GetVsenseReal(i2cBusID, i2cAddress, channelNo);      //mV
    if(errorCode == ${moduleNameUpperCase}_NO_ERR){
        //the Rsense unit is uOhms
        current = (VsenseReal / rsense) * 1000000;         //mA
        return current;
    }
    return 0;
}

float ${moduleNameUpperCase}_GetIsenseAvg(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense){
    float VsenseAvgReal, currentAvg;

    // check if rsense!=0 
    if( rsense == 0 ){
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return 0; 
    }
    
    VsenseAvgReal = ${moduleNameUpperCase}_GetVsenseAvgReal(i2cBusID, i2cAddress, channelNo);        //mV
    if(errorCode == ${moduleNameUpperCase}_NO_ERR){
        //the Rsense unit is uOhms
        currentAvg = (VsenseAvgReal / rsense) * 1000000;        //mA
        return currentAvg;
    }
    return 0;
}


uint32_t ${moduleNameUpperCase}_GetPowerRaw(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[4 + SMBUS_BYTECNT];
    uint32_t VpowerRaw;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            registerAddr = ${moduleNameUpperCase}_VPOWER1_ADDR;
            break;
        case 2:
            registerAddr = ${moduleNameUpperCase}_VPOWER2_ADDR;
            break;
        case 3:
            registerAddr = ${moduleNameUpperCase}_VPOWER3_ADDR;
            break;
        case 4:
            registerAddr = ${moduleNameUpperCase}_VPOWER4_ADDR;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return 0;
    }
    
    //write the register address
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 4); 
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    VpowerRaw = readBuffer[0];
    VpowerRaw = (VpowerRaw << 8) + readBuffer[1];
    VpowerRaw = (VpowerRaw << 8) + readBuffer[2];
    VpowerRaw = (VpowerRaw << 8) + readBuffer[3];
            
    return VpowerRaw;
}

float ${moduleNameUpperCase}_GetPowerReal(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense){
    uint32_t VpowerRaw;
    float VpowerReal, PowerUnit, PowerFSR;
    uint32_t PowerRegScale = 0x10000000;
    uint8_t bidV, bidI;

    // check if rsense!=0 
    if( rsense == 0 ){
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return 0; 
    }
    
    VpowerRaw = ${moduleNameUpperCase}_GetPowerRaw(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    bidV = ${moduleNameUpperCase}_GetChannelBidVLat(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    bidI = ${moduleNameUpperCase}_GetChannelBidILat(i2cBusID, i2cAddress, channelNo);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //the unit for Rsense is uOhms
    if(bidV == 1 || bidI == 1){
        VpowerReal = (float)((int32_t)VpowerRaw);
        PowerFSR = (6.4 / rsense) * 1000000;
    }else{
        VpowerReal = (float)VpowerRaw;
        PowerFSR = (3.2 / rsense) * 1000000;
    }
    PowerUnit = PowerFSR / PowerRegScale;
    VpowerReal = (VpowerReal * PowerUnit) / 16;
    
    return VpowerReal;
}


float ${moduleNameUpperCase}_GetEnergy(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense){
    float powerAccReal, energyVal;
    uint16_t sampleRate;
    float EnergyUnit = 1 / 3.6;
    
    powerAccReal = ${moduleNameUpperCase}_GetPowerAccReal(i2cBusID, i2cAddress, channelNo, rsense);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    sampleRate = ${moduleNameUpperCase}_GetSampleRateLat(i2cBusID, i2cAddress);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    energyVal = (powerAccReal / sampleRate) * EnergyUnit;
    return energyVal;
}


float ${moduleNameUpperCase}_GetSingleShotEnergy(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint32_t rsense, uint32_t timestamp){
    //the timestamp unit is us
    float powerAccReal, energyVal;
    float EnergyUnit = 1 / 3.6;
    uint8_t singleShotBit;

    singleShotBit = ${moduleNameUpperCase}_GetSingleShotModeBitLat(i2cBusID, i2cAddress);
    if(singleShotBit != 1){
        errorCode = ${moduleNameUpperCase}_ERR_NO_SINGLE_SHOT_MODE;
        return 0;
    }
       
    powerAccReal = ${moduleNameUpperCase}_GetPowerAccReal(i2cBusID, i2cAddress, channelNo, rsense);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    energyVal = powerAccReal * (timestamp / 1000000.0) * EnergyUnit;
    return energyVal;
}


uint8_t ${moduleNameUpperCase}_GetCtrlRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], registerAddr;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


void ${moduleNameUpperCase}_SetCtrlRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t writeBuffer[2];
    
    writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;     //register address
    writeBuffer[1] = value;
    
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
}


uint16_t ${moduleNameUpperCase}_GetSampleRate(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], sampleRateBits;
    uint16_t sampleRateVal = 0;     ////0 is invalid value. If returned by function, something went wrong...
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    sampleRateBits = (uint8_t)((readBuffer[0] & 0xC0) >> 6);
    switch(sampleRateBits){
        case 0:
            sampleRateVal = 1024;
            break;
        case 1:
            sampleRateVal = 256;
            break;
        case 2:
            sampleRateVal = 64;
            break;
        case 3:
            sampleRateVal = 8;
            break;
    }
    return sampleRateVal;
}

void ${moduleNameUpperCase}_SetSampleRate(uint8_t i2cBusID, uint8_t i2cAddress, uint16_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //write the register address
    writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return;
    
    //read the current value of the register
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return;
    
    //write the new value of the sample rate
    switch(value){
        case 1024:
            writeBuffer[1] = 0;
            break;
        case 256:
            writeBuffer[1] = 1;
            break;
        case 64:
            writeBuffer[1] = 2;
            break;
        case 8:
            writeBuffer[1] = 3;
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return;
    }
    
    writeBuffer[1] = (uint8_t)((writeBuffer[1] << 6) + (readBuffer[0] & 0x3F));
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
}


uint8_t ${moduleNameUpperCase}_GetSleepModeBit(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], sleepMode;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the current register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR){
        return ${moduleNameUpperCase}_INVALID_BIT;
    }
    sleepMode = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
    return sleepMode;
}


void ${moduleNameUpperCase}_SetSleepModeBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new bit value is valid
    if(value == 0 || value == 1){
        //write the register address
        writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //read current register value
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value
        writeBuffer[1] = (uint8_t)((value << 5) + (readBuffer[0] & 0xDF));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetSingleShotModeBit(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], singleShotBit;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    singleShotBit = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
    return singleShotBit;
}


void ${moduleNameUpperCase}_SetSingleShotModeBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new bit value is valid
    if(value == 0 || value == 1){
        //write the register address
        writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //read current register value
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1); 
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value
        writeBuffer[1] = (uint8_t)((value << 4) + (readBuffer[0] & 0xEF));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetAlertPin(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], alertPin;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    alertPin = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
    return alertPin;
}


void ${moduleNameUpperCase}_SetAlertPin(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new alert pin value is valid
    if(value == 0 || value == 1){
        //write the register address
        writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //read the current register value
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xF7) + (value << 3));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetAlertCC(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], alertCC;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    alertCC = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
    return alertCC;
}


void ${moduleNameUpperCase}_SetAlertCC(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new value is valid
    if(value == 0 || value == 1){
        //write register address and read current register value
        writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //read the current register value
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        writeBuffer[1] = (uint8_t)((value << 2) + (readBuffer[0] & 0xFB));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetOverflowAlert(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], overflowAlert;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    overflowAlert = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
    return overflowAlert;
}


void ${moduleNameUpperCase}_SetOverflowAlert(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new value is valid
    if(value == 0 || value == 1){
        //write register address and read current register value
        writeBuffer[0] = ${moduleNameUpperCase}_CTRL_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //read the current register value
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);   
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value
        writeBuffer[1] = (uint8_t)((value << 1) + (readBuffer[0] & 0xFD));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetOverflow(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], registerAddr, overflow;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);  
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    overflow = (uint8_t)(readBuffer[0] & BIT_0);
    return overflow;
}


uint8_t ${moduleNameUpperCase}_GetChannelDisRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;

    return readBuffer[0];
}

void ${moduleNameUpperCase}_SetChannelDisRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t writeBuffer[2];
    
    writeBuffer[0] = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
    writeBuffer[1] = value;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
}

uint8_t ${moduleNameUpperCase}_GetChannelState(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //check which channel is selected
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_6) >> 6);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
            break;
        case 4:
            channelState = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
        }
        return channelState;
}


void ${moduleNameUpperCase}_SetChannelState(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;      //register address
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new state value for selected channel
        switch(channelNo){
            case 1:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0x7F) + (value << 7));
                break;
            case 2:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xBF) + (value << 6));
                break;
            case 3:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xDF) + (value << 5));
                break;
            case 4:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xEF) + (value << 4));
                break;
            default:
                errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
                return;
        }

        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2); 
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}

uint8_t ${moduleNameUpperCase}_GetSmbusTimeoutBit(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], smbusTimeout;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);   
    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    smbusTimeout = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
    return smbusTimeout;
}

void ${moduleNameUpperCase}_SetSmbusTimeoutBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new bit value is valid
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new bit value for Smbus Timeout - bit 3
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xF7) + (value << 3));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}

uint8_t ${moduleNameUpperCase}_GetSmbusByteCountBit(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], byteCount;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    byteCount = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
    return byteCount;
}


void ${moduleNameUpperCase}_SetSmbusByteCountBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new bit value is valid
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value for Byte Count - bit 2
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xFB) + (value << 2));

        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        if(value == 1){
            ENABLE_BYTE_COUNT_FLAG = true;
        }else{
            ENABLE_BYTE_COUNT_FLAG = false;
        }
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetNoSkipBit(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], noSkipBit;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    noSkipBit = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
    return noSkipBit;
}


void ${moduleNameUpperCase}_SetNoSkipBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new bit value is valid
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_CHANNEL_DIS_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new bit value - bit 1
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xFD) + (value << 1));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetNegPwrRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    else
        return readBuffer[0];
}


void ${moduleNameUpperCase}_SetNegPwrRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t writeBuffer[2];
    
    writeBuffer[0] = ${moduleNameUpperCase}_NEG_PWR_ADDR;      //register address
    writeBuffer[1] = value;
    
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
}


uint8_t ${moduleNameUpperCase}_GetChannelBidI(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    //check which channel is selected
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_6) >> 6);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
            break;
        case 4:
            channelState = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
            break;   
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
}


void ${moduleNameUpperCase}_SetChannelBidI(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_NEG_PWR_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
            
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);       
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
            
        //check which channel is selected
        switch(channelNo){
            case 1:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0x7F) + (value << 7));
                break;
            case 2:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xBF) + (value << 6));
                break;
            case 3:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xDF) + (value << 5));
                break;
            case 4:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xEF) + (value << 4));
                break;
            default:
                errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
                return;
        }
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetChannelBidV(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    //check which channel is selected
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
            break;
        case 4:
            channelState = (uint8_t)(readBuffer[0] & BIT_0);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
} 


void ${moduleNameUpperCase}_SetChannelBidV(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_NEG_PWR_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
            
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
            
        //check which channel is selected
        switch(channelNo){
            case 1:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xF7) + (value << 3));
                break;
            case 2:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xFB) + (value << 2));
                break;
            case 3:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xFD) + (value << 1));
                break;
            case 4:
                writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xFE) + value);
                break;
            default:
                errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
                return;
        }
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetSlowRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_SLOW_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    else
        return readBuffer[0];
}


void ${moduleNameUpperCase}_SetSlowRegister(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t writeBuffer[2];
    
    writeBuffer[0] = ${moduleNameUpperCase}_SLOW_ADDR;     //register address
    writeBuffer[1] = value;
    
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
}


uint8_t ${moduleNameUpperCase}_GetSlowPin(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], slowPin;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_SLOW_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1); 
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    slowPin = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
    return slowPin;
}


uint8_t ${moduleNameUpperCase}_GetSlowTransition(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], slowTransition;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_SLOW_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_SLOW_TRANSITION;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_SLOW_TRANSITION;
    
    /*
     * slowTransition = 0 -> SLOW_HL = 0; SLOW_LH = 0
     * slowTransition = 1 -> SLOW_HL = 1; SLOW_LH = 0
     * slowTransition = 2 -> SLOW_HL = 0; SLOW_LH = 1
     * slowTransition = 3 -> SLOW_HL = 1; SLOW_LH = 1
    */
    slowTransition = (uint8_t)((readBuffer[0] & 0x60) >> 5);
    return slowTransition;
}


uint8_t ${moduleNameUpperCase}_GetRiseRefreshType(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], refreshType;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_SLOW_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_REFRESH_TYPE;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_REFRESH_TYPE;
    
    /*
     * refreshType = 0 -> R_RISE = 0; R_V_RISE = 0
     * refreshType = 1 -> R_RISE = 0; R_V_RISE = 1
     * refreshType = 2 -> R_RISE = 1; R_V_RISE = 0
     * refreshType = 3 -> R_RISE = 1; R_V_RISE = 1
    */
    refreshType = (uint8_t)((readBuffer[0] & 0x18) >> 3);
    return refreshType;
}


void ${moduleNameUpperCase}_SetRiseRefreshType(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new value is valid (0/1/2/3)
    if(value == 0 || value == 1 || value == 2 || value == 3){
        /*
        * value = 0 -> R_RISE = 0; R_V_RISE = 0
        * value = 1 -> R_RISE = 0; R_V_RISE = 1
        * value = 2 -> R_RISE = 1; R_V_RISE = 0
        * value = 3 -> R_RISE = 1; R_V_RISE = 1
        */
        
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_SLOW_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);        
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xE7) + (value << 3));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetFallRefreshType(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], refreshType;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_SLOW_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_REFRESH_TYPE;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_REFRESH_TYPE;
    
    /*
     * refreshType = 0 -> R_FALL = 0; R_V_FALL = 0
     * refreshType = 1 -> R_FALL = 0; R_V_FALL = 1
     * refreshType = 2 -> R_FALL = 1; R_V_FALL = 0
     * refreshType = 3 -> R_FALL = 1; R_V_FALL = 1
    */
            
    refreshType = (uint8_t)((readBuffer[0] & 0x06) >> 1);
    return refreshType;
}


void ${moduleNameUpperCase}_SetFallRefreshType(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new value is valid (0/1/2/3)
    if(value == 0 || value == 1 || value == 2 || value == 3){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_SLOW_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        /*
         * refreshType = 0 -> R_FALL = 0; R_V_FALL = 0
         * refreshType = 1 -> R_FALL = 0; R_V_FALL = 1
         * refreshType = 2 -> R_FALL = 1; R_V_FALL = 0
         * refreshType = 3 -> R_FALL = 1; R_V_FALL = 1
        */
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xF9) + (value << 1));
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetPowerOnResetBit(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], porBit;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_SLOW_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    porBit = (uint8_t)(readBuffer[0] & BIT_0);
    return porBit;
}


void ${moduleNameUpperCase}_SetPowerOnResetBit(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t value){
    uint8_t readBuffer[1 + SMBUS_BYTECNT], writeBuffer[2];
    
    //check if the new value is valid (0/1)
    if(value == 0 || value == 1){
        //read the current register value
        writeBuffer[0] = ${moduleNameUpperCase}_SLOW_ADDR;
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 1);
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1); 
        if(errorCode != ${moduleNameUpperCase}_NO_ERR)
            return;
        
        //write the new value for POR bit 
        writeBuffer[1] = (uint8_t)((readBuffer[0] & 0xFE) + value);
        ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, writeBuffer, 2);
    }else{
        errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
        return;
    }
}


uint8_t ${moduleNameUpperCase}_GetCtrlActRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);        
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint16_t ${moduleNameUpperCase}_GetSampleRateAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], sampleRateBits;
    uint16_t sampleRateVal = 0;     //0 is invalid value. If returned by function, something went wrong...
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    sampleRateBits = (uint8_t)((readBuffer[0] & 0xC0) >> 6);
    switch(sampleRateBits){
        case 0:
            sampleRateVal = 1024;
            break;
        case 1:
            sampleRateVal = 256;
            break;
        case 2:
            sampleRateVal = 64;
            break;
        case 3:
            sampleRateVal = 8;
            break;
    }
    return sampleRateVal;
}


uint8_t ${moduleNameUpperCase}_GetSleepModeBitAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], sleepMode;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    sleepMode = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
    return sleepMode;
}


uint8_t ${moduleNameUpperCase}_GetSingleShotModeBitAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], singleShotBit;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    singleShotBit = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
    return singleShotBit;
}


uint8_t ${moduleNameUpperCase}_GetAlertPinAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], alertPin;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    alertPin = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
    return alertPin;
}


uint8_t ${moduleNameUpperCase}_GetAlertCCAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], alertCC;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    alertCC = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
    return alertCC;
}


uint8_t ${moduleNameUpperCase}_GetOverflowAlertAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], overflowAlert;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    overflowAlert = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
    return overflowAlert;
}


uint8_t ${moduleNameUpperCase}_GetOverflowAct(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], overflow;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    overflow = (uint8_t)(readBuffer[0] & BIT_0);
    return overflow;
}


uint8_t ${moduleNameUpperCase}_GetChannelDisActRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint8_t ${moduleNameUpperCase}_GetChannelStateAct(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_6) >> 6);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
            break;
        case 4:
            channelState = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
}


uint8_t ${moduleNameUpperCase}_GetNegPwrActRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint8_t ${moduleNameUpperCase}_GetChannelBidIAct(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_6) >> 6);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
            break;
        case 4:
            channelState = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;                   
    }
    return channelState;
}


uint8_t ${moduleNameUpperCase}_GetChannelBidVAct(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_ACT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
            break;
        case 4:
            channelState = (uint8_t)(readBuffer[0] & BIT_0);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
}


uint8_t ${moduleNameUpperCase}_GetCtrlLatRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value - 1 byte
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint16_t ${moduleNameUpperCase}_GetSampleRateLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], sampleRateBits;
    uint16_t sampleRateVal = 0;     //0 is invalid value. If returned by function, something went wrong...
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR){
        return 0;
    }
    
    sampleRateBits = (uint8_t)((readBuffer[0] & 0xC0) >> 6);
    switch(sampleRateBits){
        case 0:
            sampleRateVal = 1024;
            break;
        case 1:
            sampleRateVal = 256;
            break;
        case 2:
            sampleRateVal = 64;
            break;
        case 3:
            sampleRateVal = 8;
            break;
    }
    return sampleRateVal;
}


uint8_t ${moduleNameUpperCase}_GetSleepModeBitLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], sleepMode;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    sleepMode = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
    return sleepMode;
}


uint8_t ${moduleNameUpperCase}_GetSingleShotModeBitLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], singleShotBit;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    singleShotBit = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
    return singleShotBit;
}


uint8_t ${moduleNameUpperCase}_GetAlertPinLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], alertPin;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    alertPin = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
    return alertPin;
}


uint8_t ${moduleNameUpperCase}_GetAlertCCLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], alertCC;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    alertCC = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
    return alertCC;
}


uint8_t ${moduleNameUpperCase}_GetOverflowAlertLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], overflowAlert;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    overflowAlert = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
    return overflowAlert;
}


uint8_t ${moduleNameUpperCase}_GetOverflowLat(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], overflow;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CTRL_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    overflow = (uint8_t)(readBuffer[0] & BIT_0);
    return overflow;
}


uint8_t ${moduleNameUpperCase}_GetChannelDisLatRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint8_t ${moduleNameUpperCase}_GetChannelStateLat(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_CHANNEL_DIS_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_6) >> 6);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
            break;
        case 4:
            channelState = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
}


uint8_t ${moduleNameUpperCase}_GetNegPwrLatRegister(uint8_t i2cBusID, uint8_t i2cAddress){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT];
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);    
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return 0;
    
    return readBuffer[0];
}


uint8_t ${moduleNameUpperCase}_GetChannelBidILat(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
    
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);        
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    //check which channel is selected
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_7) >> 7);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_6) >> 6);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_5) >> 5);
            break;
        case 4:
            channelState = (uint8_t)((readBuffer[0] & BIT_4) >> 4);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
}


uint8_t ${moduleNameUpperCase}_GetChannelBidVLat(uint8_t i2cBusID, uint8_t i2cAddress, uint8_t channelNo){
    uint8_t registerAddr, readBuffer[1 + SMBUS_BYTECNT], channelState;
    
    //write the register address
    registerAddr = ${moduleNameUpperCase}_NEG_PWR_LAT_ADDR;
    ${moduleNameUpperCase}_Write(i2cBusID, i2cAddress, &registerAddr, 1);
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    //read the register value
    ${moduleNameUpperCase}_Read(i2cBusID, i2cAddress, readBuffer, 1);        
    if(errorCode != ${moduleNameUpperCase}_NO_ERR)
        return ${moduleNameUpperCase}_INVALID_BIT;
        
    //check which channel is selected
    switch(channelNo){
        case 1:
            channelState = (uint8_t)((readBuffer[0] & BIT_3) >> 3);
            break;
        case 2:
            channelState = (uint8_t)((readBuffer[0] & BIT_2) >> 2);
            break;
        case 3:
            channelState = (uint8_t)((readBuffer[0] & BIT_1) >> 1);
            break;
        case 4:
            channelState = (uint8_t)(readBuffer[0] & BIT_0);
            break;
        default:
            errorCode = ${moduleNameUpperCase}_INVALID_INPUT_VALUE;
            return ${moduleNameUpperCase}_INVALID_BIT;
    }
    return channelState;
}