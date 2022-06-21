/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "DAC3.h"
#include "drivers/${I2CFunctions["simpleheader"]}"

void DAC3_Set(uint16_t dacValue)
{
    ${I2CFunctions["write1ByteRegister"]}(0x60,(dacValue>>8),dacValue);
}

void DAC3_SetNonvolatile(uint16_t dacValue)
{
    ${I2CFunctions["write2ByteRegister"]}(0x60,0x60,dacValue);
}

uint16_t DAC3_Read(uint16_t *dacNonvolatile)
{   
    uint16_t dacVolatile;
    struct {uint8_t volStatus, volatileVoltByte1, volatileVoltByte2, nvStatus, nonvolatileVoltByte1, nonvolatileVoltByte2; } data;
    
    ${I2CFunctions["readNBytes"]}(0x60, &data, sizeof(data));

    //First byte holds D11:D04
    //Second byte holds D3:D0 padded with 4 0s on the end
    dacVolatile =  (data.volatileVoltByte1 << 4) + (data.volatileVoltByte2 >> 4);
    
    if(dacNonvolatile)
    {
        *dacNonvolatile = (data.nonvolatileVoltByte1 << 4) + (data.nonvolatileVoltByte2 >> 4);
    }
    return dacVolatile;
}