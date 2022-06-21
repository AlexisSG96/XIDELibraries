/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "GSM2_driver.h"
#include "EXAMPLE_GSM2.h"
#include "drivers/${UARTFunctions["uartheader"]}"

//*********************************************************
//          Local Defines/Variables used for Example
//*********************************************************
#define responseBufferSize  48
static uint8_t gsm2ResponseIndex = 0;
static char gsm2ResponseBuffer [responseBufferSize] = {0};
static char exampleReadStorage [responseBufferSize] = {0};
//*********************************************************
//          Local Prototype Functions
//*********************************************************
static void EXAMPLE_blockingWait(uint16_t);
static void EXAMPLE_ReadyReceiveBuffer(void);
static char* EXAMPLE_GetResponse(void);
//*********************************************************
//          Accessible Example Functions
//*********************************************************
void EXAMPLE_useGSM2 (void)
{
    char* exampleRead;
    GSM2_SetHardwareReset(true);                     // Toggle Module HW Reset   
    EXAMPLE_blockingWait(400);
    GSM2_SetHardwareReset(false); 
    EXAMPLE_blockingWait(400);                      // Wait for Module Information Response             
    exampleRead = EXAMPLE_GetResponse();            // Read Response
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference
    EXAMPLE_ReadyReceiveBuffer();                   // Prepare for next message
    GSM2_SendString("AT");                          // Send "AT" for Baud Rate Negotiation            
    EXAMPLE_blockingWait(400);                      // Wait
    exampleRead = EXAMPLE_GetResponse();            // Read 'OK' String from Buffer
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference
    EXAMPLE_ReadyReceiveBuffer();                   // Prepare for next message
    GSM2_SendString("ATE0");                        // Send "ATEO" to disable command ECHOs 
    EXAMPLE_blockingWait(400);                      // Wait
    exampleRead = EXAMPLE_GetResponse();            // Read 'Ok' String from Buffer
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference
    EXAMPLE_ReadyReceiveBuffer();                   // Prepare for next message
    GSM2_SendString("AT+GMI");                      // Send "AT+GMI" to request Module Info 
    EXAMPLE_blockingWait(400);                      // Wait
    exampleRead = EXAMPLE_GetResponse();            // Read "Info" response String from Buffer
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference
}
void EXAMPLE_CaptureReceivedMessage(void)       // Processed from ISR
{
    uint8_t readByte = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if ( (readByte != '\0') && (gsm2ResponseIndex < responseBufferSize) )
        gsm2ResponseBuffer[gsm2ResponseIndex++] = readByte;
}
//*********************************************************
//          Local Used Example Functions
//*********************************************************
static void EXAMPLE_ReadyReceiveBuffer (void)
{
    gsm2ResponseIndex = 0;
    for (uint8_t position = 0; position < responseBufferSize; position++)
        gsm2ResponseBuffer[position] = 0;
}
static char* EXAMPLE_GetResponse(void)
{
    return gsm2ResponseBuffer;
}
static void EXAMPLE_blockingWait (uint16_t limit)
{
    for (uint16_t counter = 0; counter < limit; counter++)
        <#if (isAVR == "true")>
		_delay_ms(15);
		<#else>
		__delay_ms(15);
		</#if>
}
/**
 End of File
 */