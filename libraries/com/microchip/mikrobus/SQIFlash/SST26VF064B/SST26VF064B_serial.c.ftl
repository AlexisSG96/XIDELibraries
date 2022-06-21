/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "../${SPIFunctions["spiHeader"]}"
#include "../sqi_driver.h"
#include "SST26VF064B_serial.h"

bool SST26VF064B_spi_open(void) { return ${SPIFunctions["spiOpen"]}(${spi_configuration}); }
void SST26VF064B_spi_writeByte(uint8_t tx) { ${SPIFunctions["exchangeByte"]}(tx); }
uint8_t SST26VF064B_spi_readByte(void) { return ${SPIFunctions["exchangeByte"]}(0xFF); }

serial_t SST26VF064B_serial = {
    SST26VF064B_spi_writeByte, SST26VF064B_spi_readByte, ${SPIFunctions["writeBlock"]},
    ${SPIFunctions["readBlock"]}, SST26VF064B_spi_open, ${SPIFunctions["spiClose"]}
};

void SST26VF064B_serial_setSerialFunctionsToSPI(void) {
    SST26VF064B_serial.writeByte = SST26VF064B_spi_writeByte;
    SST26VF064B_serial.readByte = SST26VF064B_spi_readByte;
    SST26VF064B_serial.writeBlock = ${SPIFunctions["writeBlock"]};
    SST26VF064B_serial.readBlock = ${SPIFunctions["readBlock"]};
    SST26VF064B_serial.open = SST26VF064B_spi_open;
    SST26VF064B_serial.close = ${SPIFunctions["spiClose"]};
}

void SST26VF064B_serial_setSerialFunctionsToSQI(void) {
    SST26VF064B_serial.writeByte = sqi_writeByte;
    SST26VF064B_serial.readByte = sqi_readByte;
    SST26VF064B_serial.writeBlock = sqi_writeBlock;
    SST26VF064B_serial.readBlock = sqi_readBlock;
    SST26VF064B_serial.open = sqi_open;
    SST26VF064B_serial.close = sqi_close;
}
