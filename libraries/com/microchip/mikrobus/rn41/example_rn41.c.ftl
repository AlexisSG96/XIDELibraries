/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <string.h>
#ifdef __XC
#include <xc.h>
#endif
#include "device_config.h"
#include "drivers/${UARTFunctions["uartheader"]}"
#include "bluetooth.h"
#include "EXAMPLE_Bluetooth.h"

/**
  Section: Bluetooth RN41 Click Example Code
 */
void BT_Example_1(void) {
    
    char txData[] = "This is RN-41 Example-1...!!!\r\n";
        
    BT_Setup("RN41_EX1");

    while(1)
    {
        BT_SendData(txData, strlen(txData));
        <#if (isAVR == "true")>
		_delay_ms(2000);
		<#else>
		__delay_ms(2000);
		</#if>
    }
}

void BT_Example_2(void) {
    
    char txData[50];
    
    BT_Setup("RN41_EX2");

    while(1)
    {
        if(BT_IsMessage)
        {
            sprintf(txData, "RN Click received: %c\r\n", BT_ReadByte());
            BT_SendData(txData, strlen(txData));
        }
    }
}