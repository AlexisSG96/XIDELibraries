/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "ETH_example.h"

#include "TCPIPLibrary/udpv4.h"
#include "TCPIPLibrary/udpv4_port_handler_table.h"
#include "TCPIPLibrary/network.h"

#define IPV4_BROADCAST 0xFFFFFFFF

uint8_t udpData;
bool receivedMsg = false;


/*To use this example:
Add the following line to UDP_CallBackTable[] in udpv4_port_handler_table.c
    {65531, Demo_UDP_Receive},
    This will direct all UDP messages to port 65531 to the function Demo_UDP_Receive()
Also add the following function declaration into udpv4_port_handler_table.h
    void Demo_UDP_Receive(int length);
*/
void Demo_UDP_Receive(int length)
{
    //length holds the number of bytes received
    //this example, however, will only receive the first byte
    UDP_ReadBlock(&udpData, 1);
    receivedMsg = true;
}

void ETH_example(void)
{
    while(1)
    {
        //Network_Manage() needs to be periodically called to receive messages
        Network_Manage();
        if (receivedMsg)
        {
            //Broadcast the received message, onto the same UDP port
            if (UDP_Start(IPV4_BROADCAST, 65531, 65531) == SUCCESS)
            {
                UDP_Write8(udpData);
                UDP_Send();   
            }
            receivedMsg = false;
        }
    }
}