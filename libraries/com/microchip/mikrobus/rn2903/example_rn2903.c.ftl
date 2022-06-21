/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "LoRa2_driver.h"
#include "EXAMPLE_LoRa2.h"
#include "drivers/${UARTFunctions["uartheader"]}"

//*********************************************************
//          Local Defines/Variables used for Example
//*********************************************************
#define responseBufferSize  35
static uint8_t rn2903ResponseIndex = 0;
static char rn2903ResponseBuffer [responseBufferSize] = {0};
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
void EXAMPLE_useRN2903 (void)                           // Call After System Init; Above while(1) Loop in Main.c
{
    char* exampleRead;
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(EXAMPLE_CaptureReceivedMessage);
    LoRa2_SetHardwareReset(false);                      // Toggle Module HW Reset   
    EXAMPLE_blockingWait(2);
    LoRa2_SetHardwareReset(true);
    EXAMPLE_blockingWait(400);                          // Wait for Module Information Response             
    exampleRead = EXAMPLE_GetResponse();                // Read Response
    strcpy(exampleReadStorage, exampleRead);            // Store for use/reference
    EXAMPLE_ReadyReceiveBuffer();                       // Prepare for next message
    LoRa2_SendString("sys factoryRESET");               // Send "sys" Command: "factoryRESET"            
    EXAMPLE_blockingWait(400);                          // Wait
    exampleRead = EXAMPLE_GetResponse();                // Read Version String from Buffer
    strcpy(exampleReadStorage, exampleRead);            // Store for use/reference
}
void EXAMPLE_CaptureReceivedMessage(void)       // Call in ISR EUSART RX after EUSART_Receive_ISR() 
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    uint8_t readByte = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if ( (readByte != '\0') && (rn2903ResponseIndex < responseBufferSize) )
        rn2903ResponseBuffer[rn2903ResponseIndex++] = readByte;
}
//*********************************************************
//          Local Used Example Functions
//*********************************************************
static void EXAMPLE_ReadyReceiveBuffer (void)
{
    rn2903ResponseIndex = 0;
    for (uint8_t position = 0; position < responseBufferSize; position++)
        rn2903ResponseBuffer[position] = 0;
}
static char* EXAMPLE_GetResponse(void)
{
    return rn2903ResponseBuffer;
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