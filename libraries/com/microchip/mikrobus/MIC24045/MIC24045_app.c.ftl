 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "MIC24045.h"
#include "mcc.h"
#include "drivers/${I2CFunctions["simpleheader"]}"
#include "device_config.h"

#define ADDR 0b1010000

#define STAT 0x0
#define SETTING_1 0x1
#define SETTING_2 0x2
#define VOUT 0x3
#define COMMAND 0x4

uint8_t vout_current = 0;

void MIC_Write(uint8_t reg, uint8_t data) {
    ${I2CFunctions["write1ByteRegister"]}(ADDR, reg, data);
}

uint8_t MIC_ReadStatus(void) {
    return ${I2CFunctions["read1ByteRegister"]}(ADDR, STAT);
}

void MIC_Setting1(uint8_t ilim, uint8_t freq0) {
    uint8_t output = (ilim << 6) | (freq0 << 3);
    MIC_Write(SETTING_1, output);
}

void MIC_Setting2(uint8_t sudly, uint8_t mrg, uint8_t ss) {
    uint8_t output = (sudly << 6) | (mrg << 2) | (ss);
    MIC_Write(SETTING_2, output);
}

void MIC_StepToVout(uint8_t vout_desired, uint8_t delayMs) {
    MIC24045_EN_LAT = 1;
    while (vout_current < vout_desired) {
        <#if (isAVR == "true")>
		_delay_ms(delayMs);
		<#else>
		__delay_ms(10);
		</#if>
        vout_current++;
        MIC_Write(VOUT, vout_current);
    }
    while (vout_current > vout_desired) {
        <#if (isAVR == "true")>
		_delay_ms(delayMs);
		<#else>
		__delay_ms(10);
		</#if>
        vout_current--;
        MIC_Write(VOUT, vout_current);
    }
}

void MIC_GoToVout(uint8_t vout_desired) {
    vout_current = vout_desired;
    MIC24045_EN_LAT = 0;
    MIC_Write(VOUT, vout_desired);
    <#if (isAVR == "true")>
    _delay_ms(100);
    <#else>
    __delay_ms(100);
    </#if>
    MIC24045_EN_LAT = 1;
}

void MIC_ClearInterrupts(void) {
    MIC_Write(COMMAND, 1);
}
