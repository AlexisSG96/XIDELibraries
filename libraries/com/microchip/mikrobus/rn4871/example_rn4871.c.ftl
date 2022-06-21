/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <string.h>
#include "mcc.h"
#include "driver_rn4871.h"
#include "rn4871_click.h"
#include "drivers/${UARTFunctions["uartheader"]}"
#include "device_config.h"

#define CONNECTED 0x01
#define DISCONNECTED 0x00

uint8_t checkStatus(char *status)
{
    uint8_t ret;
    <#if (isAVR == "true")>
	_delay_ms(1000);
	<#else>
	__delay_ms(1000);
	</#if>
    ret = RN4871_CheckResponse(status);
    RN4871_ClearReceivedMessage();
    return ret;
}

/**
  Section: RN4871 Click Example Code
 */

void RN4871_Example(void)
{
    uint8_t        connected = 0, firstTime = 1;
    char           Name[]            = "RN4871";
    static uint8_t RN4871_Initialized = 0;

    if (!RN4871_Initialized) {
        RN4871_Setup(Name);
        RN4871_Initialized = 1;
    }
    connected = checkStatus("%CONNECT");
    while (connected) {
        if (RN4871_CheckResponse("%DISCONNECT")) {
            connected = 0;
            RN4871_ClearReceivedMessage();
            break;
        }
        if (firstTime) {
            RN4871_sendAndWait("$$$", "CMD> ", 40);
            firstTime = 0;
        }
        
        // rn4871_SendString("RN4871 Click\r\n");
        <#if (isAVR == "true")>
		// _delay_ms(1000);
	    <#else>
	    // __delay_ms(1000);
	    </#if>

       <#if (isAVR == "true")>
		_delay_ms(500);
		<#else>
		__delay_ms(500);
		</#if>
       rn4871_SendString("SHW,0076,19\r\n");
       <#if (isAVR == "true")>
		_delay_ms(500);
		<#else>
		__delay_ms(500);
		</#if>
       rn4871_SendString("SHW,0076,32\r\n");
       <#if (isAVR == "true")>
		_delay_ms(500);
		<#else>
		__delay_ms(500);
		</#if>
       rn4871_SendString("SHW,0076,4B\r\n");
       <#if (isAVR == "true")>
		_delay_ms(500);
		<#else>
		__delay_ms(500);
		</#if>
       rn4871_SendString("SHW,0076,64\r\n");
    }
}