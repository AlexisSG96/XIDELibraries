/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdio.h>
#include "EERAM5V_example.h"
#include "EERAM5V_driver.h"


volatile  uint16_t initialAddress = 0x0304;
volatile  uint8_t blockWrite[] = {0,2,3,4,5,6,7,8};
volatile  uint8_t blockRead[8];

/**
 * @brief  this is an example function for EERAM 3.3 Volts click
 * @param  None
 * @return None
 */ 
void EERAM5V_Example(void)
{
    uint8_t i=0;   

    // Read the Data from EERAM    
    EERAM5V_ReadSram(initialAddress,&blockRead,4);
    printf("Read : initialAddress:%04X\r\n",initialAddress);
    for(i=0;i<4;i++)
        printf("%02X ",blockRead[i]);
    printf("\r\n");
    //Clear read block
    for(i=0;i<4;i++)
        blockRead[i] = 0x00;
    
    // Write the Data to EERAM     
    printf("Write : initialAddress:%04X\r\n",initialAddress);
    for(i=0;i<4;i++) 
        printf("%02X ",blockWrite[i]);
    printf("\r\n\r\n");
    
    EERAM5V_WriteSram(initialAddress,&blockWrite,4);
    blockWrite[0]=blockWrite[0] + 1;
}