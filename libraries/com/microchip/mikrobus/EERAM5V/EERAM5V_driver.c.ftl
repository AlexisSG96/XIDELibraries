/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "mcc.h"
#include "EERAM5V_driver.h"
#include "drivers/${I2CFunctions["masterheader"]}"
#include "drivers/I2C_functions.h"
<#if (isAVR == "true")>
#include "${pinHeader}
#include "config/clock_config.h"
#include <util/delay.h>
</#if>


/**
 * Mandatory pins to be interfaced with MCU:
 * Pin SDA,SCL: Communication with 47L16(I2C MASTER MCU)
 * Pin HS: Hardware Store Pin(Output from MCU)
 */
void EERAM5V_Initialize()
{
    ${hwStorePinSettings["setOutputLevelLow"]}
    EERAM5V_PowerDownStore();
}
 
/**
 * @brief  This function used to write data to SRAM location
 * @param  regAddress [In]: Register address of SRAM Location
 * @param  wrDataBlk  [In]: Data to be written
 * @param  length     [In]: Length of data to be written
 * @return None
 */
void EERAM5V_WriteSram(EERAM5V_ADDRESS_t regAddress, uint8_t* wrDataBlk, uint8_t length)
{
    int writeCounter = PAGESIZE;

    do
    {
        writeCounter = MIN(writeCounter,length);
        writePage(regAddress,wrDataBlk,writeCounter);
        if(eeram5v_lastError)
            break;
        regAddress = regAddress + writeCounter;
        wrDataBlk  = wrDataBlk + writeCounter;
        length = length - writeCounter;
        writeCounter = PAGESIZE;
    } while(length);

}

/**
 * @brief  This function used to read data from SRAM location
 * @param  regAddress [In]: Register address of SRAM Location
 * @param  rdDataBlk  [In]: Data to be read
 * @param  length     [In]: Length of data to be read
 * @return None
 */
void EERAM5V_ReadSram(EERAM5V_ADDRESS_t regAddress, uint8_t* rdDataBlk, uint8_t length)
{
    pageWriteSize_t pgData = {0};
    pgData.data = rdDataBlk;
    pgData.dataSize = &length;
    // Send the MSB First
    regAddress = (regAddress << 8) | (regAddress >> 8);
    while(!${I2CFunctions["open"]}(EERAM5V_7BITS_SRAM_ADDRESS));
    ${I2CFunctions["setDataCompleteCallback"]}(rdBlockCompleteHandler,&pgData);
    ${I2CFunctions["setBuffer"]}(&regAddress,2);
    ${I2CFunctions["setAddressNACKCallback"]}(i2c_restart_write,NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished.
}

/**
 * @brief  This function used to write data to Control register
 * @param  regAddress [In]: Register address of SRAM Location
 * @param  data       [In]: Data to be wtitten
 * @return None
 */
void EERAM5V_WriteCtlReg(EERAM5V_CMD_MODE_ADDRESS_t regAddress, uint8_t data)
{ 
    uint8_t dataTemp = data;
    while(!${I2CFunctions["open"]}(EERAM5V_7BITS_CNTL_REG_ADDRESS)); // sit here until we get the bus..
     
    ${I2CFunctions["setDataCompleteCallback"]}(wr1ByteCompleteHandler,&dataTemp);
    ${I2CFunctions["setBuffer"]}(&regAddress,1);
    ${I2CFunctions["setAddressNACKCallback"]}(i2c_restart_write,NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}());  // sit here until finished.    
}

/**
 * @brief  This function used to read data from Control register
 * @param  regAddress    [In]:  Register address
 * @return value         [Out]: Read data
 */
uint8_t EERAM5V_ReadCtlReg(EERAM5V_CMD_MODE_ADDRESS_t regAddress)
{
    uint8_t data;

    while(!${I2CFunctions["open"]}(EERAM5V_7BITS_CNTL_REG_ADDRESS)); // sit here until we get the bus..

    ${I2CFunctions["setDataCompleteCallback"]}(rd1ByteCompleteHandler,&data);
    ${I2CFunctions["setBuffer"]}(&regAddress,1);
    ${I2CFunctions["setAddressNACKCallback"]}(i2c_restart_write,NULL); //NACK polling?
    ${I2CFunctions["masterWrite"]}();
    while(${I2CFunctions["BUSY"]} == ${I2CFunctions["close"]}()); // sit here until finished
    return data;
}

/**
 * @brief  This function used to Store SRAM data to EEPROM using Hardware Pin
 * @param  None
 * @return None
 */
void EERAM5V_HwStore(void)
{
    uint8_t statusRegData = 0x00;
    // Read Status register AM bit
    statusRegData = EERAM5V_ReadCtlReg(EERAM5V_CNTL_STATUS_REG_ADDRESS);
    statusRegData = statusRegData >> 7;
    if(statusRegData)
    {
        // Trigger the HS pin
        ${hwStorePinSettings["setOutputLevelHigh"]}
<#if (isAVR == "true")>
        _delay_ms(10);
<#else>
        __delay_ms(10);
</#if>
        ${hwStorePinSettings["setOutputLevelLow"]}
    }   
}

/**
 * @brief  This function used to Auto Store SRAM data to EEPROM using Software Command
 *         during power loss/off condition
 * @param  None
 * @return None
 */
void EERAM5V_PowerDownStore(void)
{
    uint8_t statusRegData = 0x00;
    statusRegData = EERAM5V_ReadCtlReg(EERAM5V_CNTL_STATUS_REG_ADDRESS);
    //Clear all protected Array
    statusRegData = statusRegData & 0xE3; 
    statusRegData = (statusRegData | 0x02);
    EERAM5V_WriteCtlReg(EERAM5V_CNTL_STATUS_REG_ADDRESS,statusRegData);
    // This delay required for EERAM internal operation after command write
<#if (isAVR == "true")>
    _delay_ms(50);
<#else>
    __delay_ms(50);
</#if>
}

/**
 * @brief  This function used to Store SRAM data to EEPROM using Command
 * @param  None
 * @return None
 */
void EERAM5V_CmdStore(void)
{
    uint8_t statusRegData = 0x00;
    // Read Status register AM bit
    statusRegData = EERAM5V_ReadCtlReg(EERAM5V_CNTL_STATUS_REG_ADDRESS);
    statusRegData = statusRegData >> 7;
    if(statusRegData)
    {
        EERAM5V_WriteCtlReg(EERAM5V_CNTL_CMD_REG_ADDRESS,EERAM5V_CNTL_CMD_SOFT_STORE);
        // This delay required for EERAM internal operation after command write
<#if (isAVR == "true")>
        _delay_ms(50);
<#else>
        __delay_ms(50);
</#if>
    }  
}

/**
 * @brief  This function used to Dump EEPROM content to RAM using Command
 * @param  None
 * @return None
 */
void EERAM5V_CmdRecall(void)
{
    uint8_t statusRegData = 0x00;
    // Read Status register AM bit
    statusRegData = EERAM5V_ReadCtlReg(EERAM5V_CNTL_STATUS_REG_ADDRESS);
    statusRegData = statusRegData >> 7;
    if(statusRegData)
    {
        EERAM5V_WriteCtlReg(EERAM5V_CNTL_CMD_REG_ADDRESS,EERAM5V_CNTL_CMD_SOFT_RECALL);
        // This delay required for EERAM internal operation after command write
<#if (isAVR == "true")>
        _delay_ms(50);
<#else>
        __delay_ms(50);
</#if>
    }
}