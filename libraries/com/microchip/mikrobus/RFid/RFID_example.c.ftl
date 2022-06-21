/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include "RFID_driver.h"
#include "${DELAYFunctions.delayHeader}"

//*********************************************************
//          Local Prototype Functions
//*********************************************************
static void EXAMPLE_Calibration(void);
static void EXAMPLE_Select_ISO_IEC_14443_A_Protocol(void);
static void EXAMPLE_IndexMod_Gain(void);
static void EXAMPLE_AutoFDet(void);
static bool EXAMPLE_TryEchoResponse(void);
static void EXAMPLE_blockingDelay(uint16_t);
//*********************************************************
//          Local Variables
//*********************************************************
static uint8_t lastNfcIdTag [5] = {0};
//*********************************************************
//          Accessible Example Functions
//*********************************************************

void RFID_EXAMPLE_Preparation(void)          // Call After System Init; Above while(1) Loop in Main.c
{   
    // Prepare CR95HF for Example
    while(!EXAMPLE_TryEchoResponse())
    {
        RFID_ToggleIntI();
    }
    EXAMPLE_Calibration();
    EXAMPLE_IndexMod_Gain();
    EXAMPLE_AutoFDet();
    EXAMPLE_Select_ISO_IEC_14443_A_Protocol();
}

bool RFID_EXAMPLE_CheckNFCTag(void)          // Call within while(1) loop in Main.c
{   
    // Read the tag ID
                            // [0]   [1]   
    uint8_t passedData [2] = {0x26, 0x07};
    uint8_t responseData [5] = {0};
    uint8_t responseSize = 0x00;
    RFID_SendCommand(RFID_SEND_RECV, sizeof(passedData), passedData);
    responseSize = RFID_ReadCommand(responseData);
    
                            // [0]   [1]   [2]   
    uint8_t passedData2 [3] = {0x93, 0x20, 0x08};
    RFID_SendCommand(RFID_SEND_RECV, sizeof(passedData2), passedData2);
    responseSize = RFID_ReadCommand(responseData);

    if(responseData[0] == 0x80)
    {
        memcpy(lastNfcIdTag, responseData + 1, 5);        // Copy Id for Use
        return true;
    }
    else
    {
        return false;
    }
}

uint8_t* RFID_EXAMPLE_GetTag(void)           // Call when EXAMPLE_CheckNFCTag returns true; Returns 5 Byte Array
{
    return lastNfcIdTag;
}

//*********************************************************
//          Local Used Example Functions
//*********************************************************
static void EXAMPLE_Calibration(void) 
{   
    // Calibrate CR95HF device
                            // [0]   [1]   [2]   [3]   [4]   [5]   [6]   [7]   [8]   [9]   [10]  [11]  [12]  [13]
    uint8_t passedData [14] = {0x03, 0xA1, 0x00, 0xF8, 0x01, 0x18, 0x00, 0x20, 0x60, 0x60, 0x00, 0x00, 0x3F, 0x01};
    uint8_t responseSize = 0x00;
    uint8_t responseData [1] = {0x00};

    // Calibrate
    // Calibration Data 1
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);             // CR95HF can hold Comms line; Delay makes sure CR95HF is actually Ready
    // Calibration Data 2
    passedData[11] = 0xFC;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
    // Calibration Data 3
    passedData[11] = 0x7C;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
    // Calibration Data 4
    passedData[11] = 0x3C;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
    // Calibration Data 5
    passedData[11] = 0x5C;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
    // Calibration Data 6
    passedData[11] = 0x6C;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
    // Calibration Data 7
    passedData[11] = 0x74;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
    // Calibration Data 8
    passedData[11] = 0x70;
    RFID_SendCommand(RFID_IDLE, sizeof(passedData), passedData);
    RFID_BlockingReadReadyPollingHardware();
    responseSize = RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
}

static void EXAMPLE_Select_ISO_IEC_14443_A_Protocol(void) 
{   
    // Select the RF communication protocol (ISO/IEC 14443-A)
                             // [0]   [1]
    uint8_t passedData [6] = {0x02, 0x00};
    uint8_t responseData [7] = {0};
    RFID_SendCommand(RFID_PROTOCOL_SELECT, sizeof(passedData), passedData);
    RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
}

static void EXAMPLE_IndexMod_Gain(void) 
{   
    // Configure IndexMod & Gain
                            // [0]   [1]   [2]   [3]   [4]   [5]
    uint8_t passedData [6] = {0x09, 0x04, 0x68, 0x01, 0x01, 0x50};
    uint8_t responseData [7] = {0};
    RFID_SendCommand(RFID_WRREG, sizeof(passedData), passedData);
    RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
}

static void EXAMPLE_AutoFDet(void) 
{   
    // Configure Auto FDet
                            // [0]   [1]   [2]   [3]   [4]   [5]
    uint8_t passedData [6] = {0x09, 0x04, 0x0A, 0x01, 0x02, 0xA1};
    uint8_t responseData [7] = {0};
    RFID_SendCommand(RFID_WRREG, sizeof(passedData), passedData);
    RFID_ReadCommand(responseData);
    EXAMPLE_blockingDelay(100);
}

static bool EXAMPLE_TryEchoResponse(void) 
{   
    // Do an Echo for Comms Validation
    uint8_t readResponse[1] = {0};
    RFID_SendCommand(RFID_ECHO, 0, 0);
    RFID_BlockingReadReadyPollingSoftware();     
    RFID_ReadCommand(readResponse);
    if (readResponse[0] == RFID_ECHO)
    {
        return true;
    }
    else
    {
        return false;
    }
}

static void EXAMPLE_blockingDelay(uint16_t limit)
{
    uint8_t counter = 0;
    for (counter = 0; counter < limit; counter++)
    {
        ${DELAYFunctions.delayMs}(10);
    }
}
/**
 End of File
 */