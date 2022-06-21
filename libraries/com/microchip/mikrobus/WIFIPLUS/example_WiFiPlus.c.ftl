/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "WiFiPlus_driver.h"
#include "EXAMPLE_WiFiPlus.h"
#include "drivers/${UARTFunctions["uartheader"]}"

//*********************************************************
//          Example Type Defines
//*********************************************************

//*********************************************************
//          Local Prototype Functions
//*********************************************************
static void EXAMPLE_blockingWait(uint16_t);
static void EXAMPLE_ReadyReceiveBuffer(void);
static char* EXAMPLE_GetResponse(void);
//*********************************************************
//          Local Variables
//*********************************************************
#define responseBufferSize  64
static uint8_t wifiPlusResponseIndex = 0;
static char wifiPlusResponseBuffer [responseBufferSize] = {0};
static char wifiPlusAckMessage [4] = {0};
static char wifiPlusIpAddress [4] = {0};
static char wifiPlusNetworkStatus [56] = {0};
//*********************************************************
//          Unique Application Variables
//*********************************************************
//*********************************************************
//          Accessible Example Functions
//*********************************************************
void EXAMPLE_startupWiFiPlus (void)                     // Call After System Init; Above while(1) Loop in Main.c
{   // Checks Basic Comms & Get Module IP Address
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(EXAMPLE_CaptureReceivedMessage);
    char* exampleRead;
    WiFiPlus_SetHwReset(false);
    EXAMPLE_blockingWait(50);   
    WiFiPlus_SetHwReset(true);
    EXAMPLE_blockingWait(200); 
    exampleRead = EXAMPLE_GetResponse();               // Read captured response with IP Address
    strncpy(wifiPlusIpAddress, exampleRead + 4, 4);    // Store for use/reference
    EXAMPLE_ReadyReceiveBuffer();                      // Ready for Next Message
    do 
    {
        WiFiPlus_SendCommand(0x0017, 0, 0);                // Request Version Info
        EXAMPLE_blockingWait(50);       
        exampleRead = EXAMPLE_GetResponse();               // Read captured Version Request response
        strncpy(wifiPlusAckMessage, exampleRead + 2, 4);   // Store Ack Message Bytes; Bytes [0],[1],[6] are for framing, so can be thrown away
        EXAMPLE_ReadyReceiveBuffer();                      // Ready for Next Message / OR Retry
    } while(wifiPlusAckMessage[1] == 0x80);                // 0x80 Represents an Command ACK
                                                           // Version Response give IP Address same as after Module HwReset Toggle. Ignore rest of message.
    WiFiPlus_SendCommand(0x0030, 0, 0);
    EXAMPLE_blockingWait(200);
    exampleRead = EXAMPLE_GetResponse();                   // Read captured Version Request response
    strncpy(wifiPlusNetworkStatus, exampleRead + 6, 56);    // Store Network Status Response Message; Bytes [0],[1],[63] are for framing, so can be thrown away
}

void EXAMPLE_CaptureReceivedMessage(void)       // Call in ISR EUSART RX after EUSART_Receive_ISR() 
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    uint8_t readByte = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if ( (wifiPlusResponseIndex < responseBufferSize) )
        wifiPlusResponseBuffer[wifiPlusResponseIndex++] = readByte;
}
//*********************************************************
//          Local Used Example Functions
//*********************************************************
static void EXAMPLE_ReadyReceiveBuffer (void)
{
    wifiPlusResponseIndex = 0;
    for (uint8_t position = 0; position < responseBufferSize; position++)
        wifiPlusResponseBuffer[position] = 0;
}
static char* EXAMPLE_GetResponse(void)
{
    return wifiPlusResponseBuffer;
}
static void EXAMPLE_blockingWait (uint16_t limit)
{
    for (uint16_t counter = 0; counter < limit; counter++)
        <#if (isAVR == "true")>
		_delay_ms(10);
		<#else>
		__delay_ms(10);
		</#if>
}
/**
 End of File
 */