/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdio.h>
#include "GSR_example.h"
#include "GSR_driver.h"

/**
 * @brief  This is an Example function for reading GSR click
 * @param  None
 * @return None
 */
void  GSR_Example(void) 
{
    uint16_t rawGsrData = GSR_GetReading();
    printf("GSR click reading : %04X\r\n",rawGsrData);   
}