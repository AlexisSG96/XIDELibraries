/*
<#include "MicrochipDisclaimer.ftl">
*/

/*
 To operate this example, use Microchip's MCP2210 SPI Terminal application to 
send data and to view the data being sent by the application. Download this
application here: 
http://ww1.microchip.com/downloads/en/DeviceDoc/MCP2210_SpiTerminal-v1.0.zip

Setting up the MCP2210 SPI Terminal environment:
- Choose if data will be sent in Hex Mode or otherwise.
- USB SPI click app supports SPI Mode 0 operation only.
- Set number of bytes to transfer.
- The Chip-Select line is connected to GP0. Set the rest of the General Purpose 
Pins as GPIO by clicking the button beside the GPIO option. 
- The CS Line is set to be Active Low. Uncheck the box setting ACTIVE state to
Logic 1.   
*/

#ifndef USBSPI_EXAMPLE_H
#define	USBSPI_EXAMPLE_H

void USBSPI_example(void);

#endif	/* USBSPI_EXAMPLE_H */
