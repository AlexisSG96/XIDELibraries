/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "rn4678_driver.h"
#include "EXAMPLE_rn4678.h"
#include "drivers/${UARTFunctions["uartheader"]}"

//*********************************************************
//          Local Defines/Variables used for Example
//*********************************************************
#define responseBufferSize  35
static uint8_t rn4678ResponseIndex = 0;
static char rn4678ResponseBuffer [responseBufferSize] = {0};
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
void EXAMPLE_useRN4678 (void)                       // Call After System Init; Above while(1) Loop in Main.c
{
    char* exampleRead;

    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(EXAMPLE_CaptureReceivedMessage);
    
    rn4678_ModuleWake(true);
    EXAMPLE_blockingWait(30);
    rn4678_ModuleWake(false);
    EXAMPLE_blockingWait(30);

    rn4678_SetHardwareReset(false);                   // Toggle Module HW Reset   
    EXAMPLE_blockingWait(30);
    rn4678_SetHardwareReset(true); 
    
    // TODO: Check if this module sends a response on reset
    EXAMPLE_blockingWait(6000);                     // Wait for Module Information Response             
    exampleRead = EXAMPLE_GetResponse();            // Read Response
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference

    EXAMPLE_ReadyReceiveBuffer();                   // Prepare for next message
    rn4678_SendString("$$$");
    EXAMPLE_blockingWait(500);
    exampleRead = EXAMPLE_GetResponse();
    strcpy(exampleReadStorage, exampleRead);

    EXAMPLE_ReadyReceiveBuffer();
    rn4678_SendString("V/r/n");
    EXAMPLE_blockingWait(500);
    exampleRead = EXAMPLE_GetResponse();            // Read Version String from Buffer
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference
    rn4678_SendString("---/r/n");
    EXAMPLE_blockingWait(500);
    exampleRead = EXAMPLE_GetResponse();
    strcpy(exampleReadStorage, exampleRead);
    EXAMPLE_ReadyReceiveBuffer();
}
void EXAMPLE_CaptureReceivedMessage(void)       // Call in ISR EUSART RX after EUSART_Receive_ISR() 
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    uint8_t readByte = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if ( (readByte != '\0') && (rn4678ResponseIndex < responseBufferSize) )
        rn4678ResponseBuffer[rn4678ResponseIndex++] = readByte;
}
//*********************************************************
//          Local Used Example Functions
//*********************************************************
static void EXAMPLE_ReadyReceiveBuffer (void)
{
    rn4678ResponseIndex = 0;
    for (uint8_t position = 0; position < responseBufferSize; position++)
        rn4678ResponseBuffer[position] = 0;
}
static char* EXAMPLE_GetResponse(void)
{
    return rn4678ResponseBuffer;
}
static void EXAMPLE_blockingWait (uint16_t limit)
{
    for (uint16_t counter = 0; counter < limit; counter++)
        <#if (isAVR == "true")>
		_delay_ms(1);
		<#else>
		__delay_ms(1);
		</#if>
}