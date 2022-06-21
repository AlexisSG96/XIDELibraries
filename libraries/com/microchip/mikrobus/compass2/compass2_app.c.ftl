/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "drivers/${I2CFunctions["simpleheader"]}"
#include "compass2.h"

#define COMPASS2_ADDRESS     0x0F    // 7-bit I2C Address 
#define REGISTER_WIA        0X00    // Register 0 address 
#define REGISTER_CONTROL    0x0A    // Control Register
#define REGISTER_STATUS     0x02    // Control Register
#define REGISTER_XL         0x03    // Control Register
#define REGISTER_XH         0x04    // Control Register
#define REGISTER_YL         0x05    // Control Register
#define REGISTER_YH         0x06    // Control Register
#define REGISTER_ZL         0x07    // Control Register
#define REGISTER_ZH         0x08    // Control Register

uint8_t COMPASS2_getStatus()
{
    return ${I2CFunctions["read1ByteRegister"]}(COMPASS2_ADDRESS, REGISTER_STATUS);
}

// This configures the AK8963 for single measurement mode 16 bit
void COMPASS2_setSingleMeasurementMode16bit(void)
{
    ${I2CFunctions["write1ByteRegister"]}(COMPASS2_ADDRESS, REGISTER_CONTROL, 0x11);
    
}

void COMPASS2_getBearing(COMPASS2_result_data_t*  bearing)
{
    COMPASS2_setSingleMeasurementMode16bit();
           
    if (COMPASS2_getStatus() & 0x01)
    {
        ${I2CFunctions["readDataBlock"]}(COMPASS2_ADDRESS, REGISTER_XL, bearing, 6);
    }
}

uint8_t COMPASS2_getDeviceId(void)
{
    return ${I2CFunctions["read1ByteRegister"]}(COMPASS2_ADDRESS, REGISTER_WIA);
}