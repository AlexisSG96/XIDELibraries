/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include "RFID_driver.h"
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "${DELAYFunctions.delayHeader}"

//*********************************************************
//          CR95HF Driver Functions
//*********************************************************
<#if (RFid_SSI1PinKey != "") || (RFid_SSI0PinKey != "") || (RFid_INTIPinKey != "")>
void RFID_SpiStartUpSequence (void)
{
    ${DELAYFunctions.delayUs}(15);
    ${rfidSSI0PinSetting["setOutputLevelHigh"]}
    ${rfidSSI1PinSetting["setOutputLevelLow"]}
    ${rfidINTIPinSetting["setOutputLevelLow"]}
    ${DELAYFunctions.delayUs}(15);
    ${rfidINTIPinSetting["setOutputLevelHigh"]}
    ${DELAYFunctions.delayUs}(15);
}

</#if>
<#if (RFid_INTIPinKey != "")>
void RFID_ToggleIntI(void)
{
    ${rfidINTIPinSetting["setOutputLevelLow"]}   
    ${DELAYFunctions.delayMs}(10);
    ${rfidINTIPinSetting["setOutputLevelHigh"]}
    ${DELAYFunctions.delayMs}(10);
}

</#if>
<#if (RFid_INTOPinKey != "")>
bool RFID_GetIntO(void)
{
    return ${rfidINTOPinSetting["getInputValue"]};
}

</#if>
void RFID_SendCommand(uint8_t command, uint8_t dataLength, uint8_t* data)
{   
    // Send Command:    0x00
    uint8_t dataIndex = 0;
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    } 
    ${spiSSPinSettings["setOutputLevelLow"]} 
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x00);          // Control Byte 
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(command);
    if (dataLength)
    {
        ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(dataLength);
        for (dataIndex = 0; dataIndex < dataLength; dataIndex++)
        {
            ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(*data++);
        }
    }
    ${spiSSPinSettings["setOutputLevelHigh"]} 
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
}

void RFID_SoftwareReset(void)
{   
    // Reset:   0x01
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x01);          // Control Byte    
    ${spiSSPinSettings["setOutputLevelHigh"]} 
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();   
}

uint8_t RFID_ReadCommand(uint8_t* response)
{   
    // Read:    0x02
    uint8_t dataIndex = 0;
    uint8_t responseLength = 0x00;
    uint8_t responseByte = 0x00;
    CR95HF_Flagbits_t responseCode;
    responseCode.flagsBitMap = 0x00;
    
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    } 
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x02);          // Control Byte  
    responseCode.flagsBitMap = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(RFID_DUMMY_EXCHANGE);
    if ( (responseCode.flagsBitMap == RFID_ECHO) || (responseCode.flagsBitMap == 0x80) )     // Copy Response Codes that useful
    {
        *response++ = responseCode.flagsBitMap;
    }
    if ( (responseCode.flagReadDataReady) || (responseCode.flagsBitMap == 0x80) && (responseCode.flagsBitMap != RFID_ECHO))
    {
        responseLength = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(RFID_DUMMY_EXCHANGE);
        for (dataIndex = 0; dataIndex < responseLength; dataIndex++)
        {
            responseByte = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(RFID_DUMMY_EXCHANGE);
            *response++ = responseByte;
        }
    }
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return responseLength;
}

CR95HF_Flagbits_t RFID_PollCR95HF(void)
{   
    // Poll:    0x03
    CR95HF_Flagbits_t flagResult;
    while(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(0x03);          // Control Byte  
    flagResult.flagsBitMap = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(RFID_DUMMY_EXCHANGE);
    ${spiSSPinSettings["setOutputLevelHigh"]} 
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return flagResult;
}

void RFID_BlockingReadReadyPollingSoftware(void)
{
    CR95HF_Flagbits_t cr95HF_FlagResponse;
    cr95HF_FlagResponse.flagsBitMap = 0x00;

    while(!cr95HF_FlagResponse.flagReadDataReady)
    {
        cr95HF_FlagResponse = RFID_PollCR95HF();
    }
}

void RFID_BlockingReadReadyPollingHardware(void)
{
    while (${rfidINTOPinSetting["getInputValue"]})
    {
    }
}

bool RFID_IsReadReadyHardwarePollingNonBlocking(void)
{
    if (!${rfidINTOPinSetting["getInputValue"]})
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool RFID_IsReadReadySoftwarePollingNonBlocking(void)
{
    CR95HF_Flagbits_t cr95HF_FlagResponse;
    cr95HF_FlagResponse.flagsBitMap = 0x00;

    cr95HF_FlagResponse = RFID_PollCR95HF();
    
    if (cr95HF_FlagResponse.flagReadDataReady)
    {
        return true;
    }
    else
    {
        return false;
    }
}
/**
 End of File
 */