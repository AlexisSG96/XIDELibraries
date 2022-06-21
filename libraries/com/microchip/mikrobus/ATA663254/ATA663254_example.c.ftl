/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "ATA663254_example.h"
#include "${linHeader}"

void ATA663254_example(void){
    // Set ATA663254 to Normal Mode
    ${ATA663254_EN_LAT} = 1;
    
    while (1){
        LIN_handler();
    }
}
