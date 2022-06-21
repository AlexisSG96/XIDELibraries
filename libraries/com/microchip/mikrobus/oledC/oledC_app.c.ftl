 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include <stdint.h>
#include <stdbool.h>
#include "oledC.h"
#include "${portHeader}"
#include "${SPIFunctions["spiHeader"]}"
#include "${DELAYFunctions.delayHeader}"

enum STREAMING_MODES 
{
    NOSTREAM, WRITESTREAM, READSTREAM
};
static uint8_t streamingMode = NOSTREAM;

static void startStreamingIfNeeded(OLEDC_COMMAND cmd);
static void stopStreaming(void);
static uint16_t exchangeTwoBytes(uint8_t byte1, uint8_t byte2);

oledc_color_t oledC_parseIntToRGB(uint16_t raw)
{
    oledc_color_t parsedColor;
    uint8_t byte1 = raw >> 8;
    uint8_t byte2 = raw & 0xFF;
    parsedColor.red = (byte1 >> 3);
    parsedColor.green = ((byte1 & 0x7) << 3) | (byte2 >> 5);
    parsedColor.blue = byte2 & 0x1F;
    return parsedColor;
}

uint16_t oledC_parseRGBToInt(uint8_t red, uint8_t green, uint8_t blue)
{
    red &= 0x1F;
    green &= 0x3F;
    blue &= 0x1F;
    uint8_t byte1;
    uint8_t byte2;
    byte1 = (red << 3) | (green >> 3);
    byte2 = (green << 5) | blue;
    return (((uint16_t)byte1) << 8) | byte2;
}

static void startStreamingIfNeeded(OLEDC_COMMAND cmd)
{
    if(cmd == OLEDC_CMD_WRITE_RAM || cmd == OLEDC_CMD_READ_RAM)
    {
        streamingMode = cmd == OLEDC_CMD_WRITE_RAM ? WRITESTREAM : READSTREAM;
    } 
    else 
    {
        streamingMode = NOSTREAM;
    }
}

static void stopStreaming(void)
{
    streamingMode = NOSTREAM;
}

static uint16_t exchangeTwoBytes(uint8_t byte1, uint8_t byte2)
{
    if(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
        return 0xFFFF;
    }
    byte1 = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(byte1);
    byte2 = ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(byte2);
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    return ((uint16_t)byte1) << 8 | byte2;
}

void oledC_sendCommand(OLEDC_COMMAND cmd, uint8_t *payload, uint8_t payload_size)
{
    if(!${SPIFunctions["functionName"]}[${spi_configuration}].spiOpen())
    {
        return;
    }
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${oledcDCPinSetting["setOutputLevelLow"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].exchangeByte(cmd);
    if(payload_size > 0)
    {
        ${oledcDCPinSetting["setOutputLevelHigh"]}
        ${SPIFunctions["functionName"]}[${spi_configuration}].writeBlock(payload, payload_size);
        ${oledcDCPinSetting["setOutputLevelLow"]}
    }
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${SPIFunctions["functionName"]}[${spi_configuration}].spiClose();
    startStreamingIfNeeded(cmd);
}

void oledC_setRowAddressBounds(uint8_t min, uint8_t max)
{
    uint8_t payload[2];
    payload[0] = min > 95 ? 95 : min;
    payload[1] = max > 95 ? 95 : max;
    oledC_sendCommand(OLEDC_CMD_SET_ROW_ADDRESS, payload, 2);
    
}

void oledC_setColumnAddressBounds(uint8_t min, uint8_t max)
{
    min = min > 95 ? 95 : min;
    max = max > 95 ? 95 : max;
    uint8_t payload[2];
    payload[0] = 16+min;
    payload[1] = max + 16;
    oledC_sendCommand(OLEDC_CMD_SET_COLUMN_ADDRESS, payload, 2);
}

void oledC_setSleepMode(bool on)
{
    oledC_sendCommand(on ? OLEDC_CMD_SET_SLEEP_MODE_ON : OLEDC_CMD_SET_SLEEP_MODE_OFF, NULL, 0);
}

void oledC_setDisplayOrientation(void) 
{
    uint8_t payload[1];
    payload[0] = 0x32;
    oledC_sendCommand(OLEDC_CMD_SET_REMAP_DUAL_COM_LINE_MODE, payload, 1);
    payload[0] = 0x20;
    oledC_sendCommand(OLEDC_CMD_SET_DISPLAY_START_LINE, payload, 1);
}

void oledC_startReadingDisplay(void)
{
    oledC_sendCommand(OLEDC_CMD_READ_RAM, NULL, 0);    
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${oledcDCPinSetting["setOutputLevelHigh"]}
}

void oledC_stopReadingDisplay(void)
{
    oledC_stopWritingDisplay();
}

uint16_t oledC_readColor(void)
{
    if(streamingMode != READSTREAM)
    {
        oledC_startReadingDisplay();
    }
    if(streamingMode != READSTREAM)
    {
        return 0xFFFF;
    }
    return exchangeTwoBytes(0xFF, 0xFF);
}

void oledC_startWritingDisplay(void)
{
    oledC_sendCommand(OLEDC_CMD_WRITE_RAM, NULL, 0);    
    ${spiSSPinSettings["setOutputLevelLow"]}
    ${oledcDCPinSetting["setOutputLevelHigh"]}
}

void oledC_stopWritingDisplay(void)
{
    ${spiSSPinSettings["setOutputLevelHigh"]}
    ${oledcDCPinSetting["setOutputLevelLow"]}
    stopStreaming();
}

void oledC_sendColor(uint8_t r, uint8_t g, uint8_t b)
{
    oledC_sendColorInt(oledC_parseRGBToInt(r,g,b));
}

void oledC_sendColorInt(uint16_t raw)
{
    if(streamingMode != WRITESTREAM)
    {
        oledC_startWritingDisplay();
    }
    if(streamingMode != WRITESTREAM)
    {
        return;
    }
    exchangeTwoBytes(raw >> 8, raw & 0x00FF);
}

void oledC_setup(void)
{
    ${oledcENPinSetting["setOutputLevelLow"]}
    ${oledcRSTPinSetting["setOutputLevelHigh"]}
    ${oledcRWPinSetting["setOutputLevelLow"]}
    ${DELAYFunctions.delayMs}(1);
    ${oledcRSTPinSetting["setOutputLevelLow"]}
    ${DELAYFunctions.delayUs}(2);
    ${oledcRSTPinSetting["setOutputLevelHigh"]}
    ${oledcENPinSetting["setOutputLevelHigh"]}
    ${DELAYFunctions.delayMs}(1);
    oledC_setSleepMode(false);
    ${DELAYFunctions.delayMs}(200);
    oledC_setColumnAddressBounds(0, 95);
    oledC_setRowAddressBounds(0, 95);
    oledC_setDisplayOrientation();
}
