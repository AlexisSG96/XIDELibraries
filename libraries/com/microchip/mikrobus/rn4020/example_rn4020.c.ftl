/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "BLE2_driver.h"
#include "EXAMPLE_BLE2.h"
#include "drivers/${UARTFunctions["uartheader"]}"

//*********************************************************
//          Local Defines/Variables used for Example
//*********************************************************
#define responseBufferSize  31
static uint8_t rn4020ResponseIndex = 0;
static char rn4020ResponseBuffer [responseBufferSize] = {0};
static char exampleReadStorage [responseBufferSize] = {0};
//*********************************************************
//          Local Prototype Functions
//*********************************************************
static void EXAMPLE_blockingWait(uint16_t);
static void EXAMPLE_ReadyReceiveBuffer(void);
static char* EXAMPLE_GetResponse(void);
static char* EXAMPLE_sendAndWait(const char* sendString);
//*********************************************************
//          Accessible Example Functions
//*********************************************************
void EXAMPLE_sendMessageOverBLE2(const char *message){
    if(BLE2_isConnected()){
        BLE2_SendString(message);
    }
}

void EXAMPLE_sendBufferOverBLE2(uint8_t *buffer, uint8_t len)
{
    if(BLE2_isConnected()){
        BLE2_SendBuffer(buffer, len);
    }
}

void EXAMPLE_setupBLE2(const char* name)                       // Call After System Init; Above while(1) Loop in Main.c
{   
    char* exampleRead;
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(EXAMPLE_CaptureReceivedMessage);
    BLE2_WakeModule();                              // Wake Module using GPIO       
    EXAMPLE_blockingWait(20);                      // Wait for "CMD" Response              
    exampleRead = EXAMPLE_GetResponse();            // Read "CMD\r\n" from Buffer
    strcpy(exampleReadStorage, exampleRead);        // Store for use/reference
    EXAMPLE_ReadyReceiveBuffer();                   // Prepare for next message
    BLE2_EnterCommand_Mode();                       // Enter "Command Mode" via GPIO
    EXAMPLE_blockingWait(10);
    EXAMPLE_sendAndWait("SF,1\r\n");                // Factory Reset
    EXAMPLE_sendAndWait("SR,30000800\r\n");         // Setup Services
    BLE2_SendString("SN,");                         // Set Name
    BLE2_SendString(name);
    EXAMPLE_sendAndWait("\r\n");
    EXAMPLE_sendAndWait("R,1\r\n");                 // Reset
    EXAMPLE_blockingWait(20);
    BLE2_ExitCommand_Mode();                       // Exit "Command Mode" via GPIO
}

void EXAMPLE_CaptureReceivedMessage(void)           // Call in ISR EUSART RX after EUSART_Receive_ISR() 
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    uint8_t readByte = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if (rn4020ResponseIndex == responseBufferSize)
    {
        EXAMPLE_ReadyReceiveBuffer();
    }
    if (readByte != '\0' && rn4020ResponseIndex < responseBufferSize)
    {
        rn4020ResponseBuffer[rn4020ResponseIndex++] = readByte;
    }
}
//*********************************************************
//          Local Used Example Functions
//*********************************************************
static void EXAMPLE_ReadyReceiveBuffer (void)
{
    rn4020ResponseIndex = 0;
    for (uint8_t position = 0; position < responseBufferSize; position++)
    {
        rn4020ResponseBuffer[position] = 0;
    }
}
static char* EXAMPLE_GetResponse(void)
{
    return rn4020ResponseBuffer;
}
static void EXAMPLE_blockingWait (uint16_t limit)
{
    for (uint16_t counter = 0; counter < limit; counter++)
    {
        ${DELAYFunctions.delayMs}(15);
    }
}
static char* EXAMPLE_sendAndWait(const char* sendString)
{
    BLE2_SendString(sendString);
    EXAMPLE_blockingWait(4);                 // Wait for Response (~60ms)
    return EXAMPLE_GetResponse();            // Read String from Buffer
}