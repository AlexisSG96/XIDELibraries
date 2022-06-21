/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "MCP25625_example.h"
#include "MCP25625_app.h"

/**
This example waits and retransmits the filtered CAN message except for Data0.
Data0 simply counts the number of receive messages.
*/

void MCP25625_example(void){
    
    uCAN_MSG txMessage;
    uCAN_MSG rxMessage;

    txMessage.frame.data0 = 0;

    while(1){
        if(MCP25625_CANReceive(&rxMessage)){
            txMessage.frame.idType = rxMessage.frame.idType;
            txMessage.frame.id = rxMessage.frame.id;
            txMessage.frame.dlc = rxMessage.frame.dlc;
            txMessage.frame.data0++;
            txMessage.frame.data1 = rxMessage.frame.data1;
            txMessage.frame.data2 = rxMessage.frame.data2;
            txMessage.frame.data3 = rxMessage.frame.data3;
            txMessage.frame.data4 = rxMessage.frame.data4;
            txMessage.frame.data5 = rxMessage.frame.data5;
            txMessage.frame.data6 = rxMessage.frame.data6;
            txMessage.frame.data7 = rxMessage.frame.data7;
            MCP25625_CANTransmit(&txMessage);
        }
    }  
}
