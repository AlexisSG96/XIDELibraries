 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "fan3.h"
#include "drivers/${I2CFunctions["simpleheader"]}"

#define FAN_ADDRESS     0x20
#define DEV_CFG_REG     0x00
#define FAN_SPEED_REG   0x06
#define FAN_ENABLE      0x02

void Fan3_SetFanSpeed(FAN_SPEED newSpeed)
{
    ${I2CFunctions["write1ByteRegister"]}(FAN_ADDRESS,FAN_SPEED_REG,newSpeed);
}

void Fan3_Initialize(void)
{
    ${I2CFunctions["write1ByteRegister"]}(FAN_ADDRESS,DEV_CFG_REG,FAN_ENABLE);
    Fan3_SetFanSpeed(${InitFSVal});
}
