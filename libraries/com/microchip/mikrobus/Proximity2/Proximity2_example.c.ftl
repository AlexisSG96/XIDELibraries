/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <stdio.h>
#include "Proximity2.h"
#include "${DELAYFunctions.delayHeader}"

void Proximity2_Example(void) 
{
    while(1) 
    {
        <#if Proximity2_Mode_Key == "PROX Only" || Proximity2_Mode_Key == "ALS and PROX">
        uint8_t proxVal = Proximity2_Read_Proximity();
        printf("Proximity Value: %d\n",proxVal);
        </#if>

        <#if Proximity2_Mode_Key == "Standard ALS" || Proximity2_Mode_Key == "Green Only" || Proximity2_Mode_Key == "IR Only" || Proximity2_Mode_Key == "ALS and PROX">
        uint16_t alsVal = Proximity2_Read_Als();
        printf("Ambient Value: %d\n",alsVal);
        </#if>
        
        ${DELAYFunctions.delayMs}(500);
    }
}
