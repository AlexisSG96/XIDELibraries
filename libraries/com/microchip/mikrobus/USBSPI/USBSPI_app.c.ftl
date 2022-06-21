/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "USBSPI_app.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${pinHeader}"

void USBSPI_Initialize(void){
    ${SPIFunctions["initSpiSlaveHardware"]}(USBSPI);
    USBSPI_nCS_SetDigitalInput();
}

uint8_t USBSPI_ExchangeByte(uint8_t data){
    
    return ${SPIFunctions["exchangeByte"]}(data);
    
}

void USBSPI_ExchangeBlock(uint8_t *dataBlock, int blockSize){

    ${SPIFunctions["exchangeBlock"]}(dataBlock,blockSize);
}

void USBSPI_ReleaseBus(void){
    ${SPIFunctions["spiClose"]}();
}