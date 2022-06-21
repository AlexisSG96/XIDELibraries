/*
<#include "MicrochipDisclaimer.ftl">
*/

/*
Notes on the USB-I2C Click Operation:

- This module only supports byte operations. Block read and write operations is 
not yet supported by MCC Foundation I2C Slave Drivers.

- This module works with the MCP2221 I2C/SMbus Utility terminal software which
can be downloaded at this link: http://ww1.microchip.com/downloads/en/DeviceDoc/MCP2221Terminal.zip

- The default 7bit address for the MCU is 0x50. 
*/

#include <stdio.h>
#include "${I2CFunctions["slaveheader"]}"
#include "USBI2C_app.h"
#include "USBI2C_example.h"

void USBI2C_SlaveRead(void);
void USBI2C_SlaveWrite(void);

volatile uint8_t data;

void USBI2C_example(void){
    USBI2C_Initialize();
    ${I2CFunctions["setReadIntHandler"]}(USBI2C_SlaveRead);
    ${I2CFunctions["setWriteIntHandler"]}(USBI2C_SlaveWrite);
}

void USBI2C_SlaveRead(void) {
    data = ${I2CFunctions["read"]}();
}

void USBI2C_SlaveWrite(void) {
    ${I2CFunctions["write"]}(data);
}

