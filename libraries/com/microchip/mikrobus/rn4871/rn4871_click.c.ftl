/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <string.h>
#include "mcc.h"
#include "rn4871_click.h"
#include "driver_rn4871.h"
#include "drivers/${UARTFunctions["uartheader"]}"
#include "device_config.h"

typedef enum { NO_RESPONSE, OK } rn4871_Responses_t;

volatile uint16_t rn_index = 0;
volatile uint8_t  rn_buffer[RN_BUFF_SIZE];

//*********************************************************
//          Local Function Prototypes
//*********************************************************
static void RN4871_CaptureReceivedMessage(void);
static void RN4871_RegisterISRCallback(void);

//*********************************************************
//          ISR Call back Function
//*********************************************************
static void RN4871_CaptureReceivedMessage()
{
    uint8_t data;
    
    ${UARTFunctions["functionName"]}[${uart_configuration}].RxDefaultISR();
    data = ${UARTFunctions["functionName"]}[${uart_configuration}].Read();
    if (rn_index < RN_BUFF_SIZE)
        rn_buffer[rn_index++] = data;
}

//*********************************************************
//          Other Functions
//*********************************************************
static void RN4871_RegisterISRCallback(void)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(RN4871_CaptureReceivedMessage);
}

void RN4871_Setup(const char *name)
{
    char nameString[32];

    RN4871_RegisterISRCallback();
    RN4871_Reset_Module();
    RN4871_sendAndWait("$$$", "CMD> ", 40);                // Exit data mode, enter command mode
    RN4871_sendAndWait("SS,C0\r\n", "AOK\r\n", 40);        // Enable default services
    RN4871_sendAndWait("SR,00000000\r\n", "AOK\r\n", 40);  // Set feature
    RN4871_sendAndWait("PS,180F\r\n", "AOK\r\n", 40);      // Set service UUID
    RN4871_sendAndWait("PC,2A19,10,05\r\n", "AOK\r\n", 40);// Define characteristic
    sprintf(nameString, "S-,%s\r\n", name);                // Prepare device name
    RN4871_sendAndWait(nameString, "AOK\r\n", 40);         // Set serialized device name
    RN4871_sendAndWait("R,1\r\n", "Rebooting", 40);        // Force a complete device reboot
    RN4871_sendAndWait("$$$", "CMD> ", 40);
    RN4871_sendAndWait("A\r\n", "AOK\r\n", 40);            // Start advertisement
    RN4871_sendAndWait("---\r\n", "END", 40);              // Exit command mode, enter into Data mode
    RN4871_ClearReceivedMessage();
}

void RN4871_Reset_Module(void)
{
    rn4871_ClearResetPin();    // Reset RN4871 module
    RN4871_blockingWait(1);
    rn4871_SetResetPin();
    RN4871_blockingWait(50);
}

void RN4871_ClearReceivedMessage(void)
{
    memset((void *)rn_buffer, 0, RN_BUFF_SIZE);
    rn_index = 0;
}

uint8_t RN4871_CheckResponse(const char *response)
{
    uint8_t ret = 0;
    if (strstr((const char *)rn_buffer, response))
        ret = 1;
    return ret;
}

void RN4871_blockingWait(uint16_t limit)
{
    for (uint16_t counter = 0; counter < limit; counter++)
        <#if (isAVR == "true")>
		_delay_ms(15);
		<#else>
		__delay_ms(15);
		</#if>
}
void RN4871_sendAndWait(const char *sendString, const char *response, uint16_t delay)
{
    do {
        RN4871_ClearReceivedMessage();
        rn4871_SendString(sendString);
        RN4871_blockingWait(delay);
    } while (RN4871_CheckResponse(response) == NO_RESPONSE);
}