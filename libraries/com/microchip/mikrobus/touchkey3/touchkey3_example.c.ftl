/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include <stdio.h>
#include "touchkey3_example.h"
#include "touchkey3_driver.h"

/*  
 *  This example uses printf to send a message to the serial port at 9600 BAUD.
 *  There are 7 keys 1,2,3,4,5,6,7. When a key is touched, serial port will print the corresponding message.
*/	
key oldValue = 0;       
void TOUCHKEY3_example(void)
{
    key newValue;
 
    while(${intPinSettings["LAT"]}==1);      //Waiting for any activity on the touchkey3 (INT Pin)
    newValue = TOUCHKEY3_getButtonState();
    if(oldValue!=newValue)
    switch(newValue)
    {
        case KEY1 : printf("Touch detected on key 1\r\n");
                    oldValue = KEY1;
                    break;
        case KEY2 : printf("Touch detected on key 2\r\n");
                    oldValue = KEY2;
                    break;
        case KEY3 : printf("Touch detected on key 3\r\n");
                    oldValue = KEY3;
                    break;
        case KEY4 : printf("Touch detected on key 4\r\n");
                    oldValue = KEY4;
                    break;
        case KEY5 : printf("Touch detected on key 5\r\n");
                    oldValue = KEY5;
                    break;
        case KEY6 : printf("Touch detected on key 6\r\n");
                    oldValue = KEY6;
                    break;
        case KEY7 : printf("Touch detected on key 7\r\n");
                    oldValue = KEY7;
                    break;
        default:    printf("Error\r\n");
                    break;
        
    }
}
