/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "${pac1934Functions["pac1934header"]}"
#include "PAC1934_Click.h"
#include "PAC1934_Example.h"

float PAC1934_Example(void){
    PAC1934_ClickInit();
    
    float ENERGY1 = ${pac1934Functions["GetEnergy"]}(BUS_ID, PAC1934_ADDRESS, CH1, RSENSE);
    return ENERGY1;
}