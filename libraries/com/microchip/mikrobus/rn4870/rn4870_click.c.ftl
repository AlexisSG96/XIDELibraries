/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <string.h>
#include "mcc.h"
#include "rn4870_click.h"
#include "drivers/${UARTFunctions["uartheader"]}"

typedef enum { NO_RESPONSE, OK } rn4870_Responses_t;

#define RN_BUFF_SIZE 128
uint16_t rn_index = 0;
uint8_t  rn_buffer[RN_BUFF_SIZE];

//*********************************************************
//          Local Function Prototypes
//*********************************************************
static void RN4870_CaptureReceivedMessage(void);
static void RN4870_RegisterISRCallback(void);

//*********************************************************
//          ISR Call back Function
//*********************************************************
static void RN4870_CaptureReceivedMessage()
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
void RN4870_ClearResetPin(void)
{
    ${resetPinSettings["LAT"]} = 0;
}

void RN4870_SetResetPin()
{
    ${resetPinSettings["LAT"]} = 1;
}

void RN4870_InitLED_Set(bool level)
{
    ${ledPinSettings["LAT"]} = level;
}

void RN4870_SendString(const char *command)
{
    RN4870_SendBuffer(command, strlen(command));
}

void RN4870_SendBuffer(const char *buffer, uint8_t length)
{
    while (length--)
        RN4870_SendByte(*buffer++);
}

void RN4870_SendByte(uint8_t data)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].Write(data);
}

static void RN4870_RegisterISRCallback(void)
{
    ${UARTFunctions["functionName"]}[${uart_configuration}].SetRxISR(RN4870_CaptureReceivedMessage);
}

void RN4870_Setup(const char *name)
{
    char nameString[32];

	RN4870_RegisterISRCallback();
	RN4870_Reset_Module();
	RN4870_sendAndWait("$$$", "CMD> ", 40);
	RN4870_sendAndWait("SS,C0\r\n", "AOK\r\n", 40);
	RN4870_sendAndWait("SR,00000000\r\n", "AOK\r\n", 40);
	RN4870_sendAndWait("PS,180F\r\n", "AOK\r\n", 40);
	RN4870_sendAndWait("PC,2A19,10,05\r\n", "AOK\r\n", 40);
	sprintf(nameString, "S-,%s\r\n", name);
	RN4870_sendAndWait(nameString, "AOK\r\n", 40);
	RN4870_sendAndWait("R,1\r\n", "Rebooting", 40);
	RN4870_sendAndWait("$$$", "CMD> ", 40);
	RN4870_sendAndWait("A\r\n", "AOK\r\n", 40);
	RN4870_sendAndWait("---\r\n", "END", 40);
	RN4870_ClearReceivedMessage();
}

void RN4870_Reset_Module(void)
{
    RN4870_ClearResetPin();    // Reset RN4870 module
    RN4870_blockingWait(1);
    RN4870_SetResetPin();
    RN4870_blockingWait(50);
}

void RN4870_ClearReceivedMessage(void)
{
    memset((void *)rn_buffer, 0, RN_BUFF_SIZE);
    rn_index = 0;
}

void RN4870_ReadReceivedMessage(char *buff, uint16_t len)
{
	if (len > RN_BUFF_SIZE)
		len = RN_BUFF_SIZE;
	memcpy(buff, rn_buffer, len);
}

uint8_t RN4870_CheckResponse(const char *response)
{
    uint8_t ret = 0;
    if (strstr((const char *)rn_buffer, response))
        ret = 1;
    return ret;
}

void RN4870_blockingWait(uint16_t limit)
{
    for (uint16_t counter = 0; counter < limit; counter++)
        __delay_ms(15);
}
void RN4870_sendAndWait(const char *sendString, const char *response, uint16_t delay)
{
    do {
        RN4870_ClearReceivedMessage();
        RN4870_SendString(sendString);
        RN4870_blockingWait(delay);
    } while (RN4870_CheckResponse(response) == NO_RESPONSE);
}