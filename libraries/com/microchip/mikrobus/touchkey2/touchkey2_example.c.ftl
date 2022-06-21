/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "drivers/${UARTFunctions["uartheader"]}"
#include "touchkey2_example.h"
#include "touchkey2_driver.h"

/*  
 *  This example uses printf to send a message to the serial port at 9600 BAUD.
 *  There are 4 keys A,B,C and D. When a key is touched, serial port will print the corresponding key.
*/	
void TOUCHKEY2_example(void)
{
    uint8_t tmp;
    tmp = TOUCHKEY2_getButton();

    switch (tmp) {
        case 0x01:
            printf("Button A\r\n");
            break;
        case 0x02:
            printf("Button B\r\n");
            break;
        case 0x04:
            printf("Button C\r\n");
            break;
        case 0x08:
            printf("Button D\r\n");
            break;
    }
}
