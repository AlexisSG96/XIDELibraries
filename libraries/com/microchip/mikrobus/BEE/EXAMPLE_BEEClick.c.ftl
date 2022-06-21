/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <string.h>
#include "mcc.h"
#include "device_config.h"
#include "DRIVER_BEEClick.h"
#include "EXAMPLE_BEEClick.h"

void BEE_Example_Transmitter(void)
{
    uint8_t txData[2] = {0,1};

    while(1)
    {
        BEE_Write(txData, 2);
        txData[0]++;
        txData[1]++;
        <#if (isAVR == "true")>
		_delay_ms(3000);
		<#else>
		__delay_ms(3000);
		</#if>        
    }
}

void BEE_Example_Receiver(void)
{
    uint8_t rxData[2] = {0,0};
    
    while(1)
    {
        //If an RX FIFO reception interrupt occurred
        if(${intPinSettings["PORT"]} == 0)    //Read the BEE_INT pin
        {            
            //Read data from RX FIFO
            if(BEE_Read(rxData, 2))
            {
                printf("Received: 0x%x, 0x%x\r\n", rxData[0], rxData[1]);
            }
        }
    }
}
