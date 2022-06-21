/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include "mcc.h"
#include "USBSPI_app.h"
#include "USBSPI_example.h"

uint8_t data;

void USBSPI_example(void){

    USBSPI_Initialize();

    while(1)
    {
        data = USBSPI_ExchangeByte(data);
    }

}

