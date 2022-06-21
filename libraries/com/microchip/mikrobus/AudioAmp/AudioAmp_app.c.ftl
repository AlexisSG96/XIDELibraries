 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifdef __XC
#include <xc.h>
#endif
#include "AudioAmp.h"
#include "${pinHeader}"
#include "drivers/${I2CFunctions["simpleheader"]}"

#define AUDIOAMP_ADDR               0x7C

#define CONTROL_REG_MODE            0x00
#define CONTROL_REG_DIAGNOSTIC      0x01
#define CONTROL_REG_FAULT_DETECT    0x02
#define CONTROL_REG_VOLUME_1        0X03
#define CONTROL_REG_VOLUME_2        0X04

#define DG_ILIMIT_FIXED             0x00
#define DG_ILIMIT_SUPPLY_DEPENDENT  0x02
#define DG_RESET_NORMAL             0x00
#define DG_RESET_RESET              0x04
#define DG_CONT_ONESHOT             0x00
#define DG_CONT_CONTINUOUS          0x08
#define DG_EN_DISABLE               0x00
#define DG_EN_ENABLE                0x10

uint8_t diagnosticControl = 0x00;
uint8_t modeControl = 0x00;

static void AudioAmp_write(uint8_t reg, uint8_t val){
    uint8_t reg_data = (reg << 5) | (val & 0x1F);
    ${I2CFunctions["writeNBytes"]}(AUDIOAMP_ADDR, &reg_data, 1);
}

static void setClearByte(bool check, uint8_t *target, uint8_t byte){
    *target = check ? (*target | byte) : (*target & !(byte));
}

/* Mode Selection functions */
void AudioAmp_setPowerState(bool enable){
    
    setClearByte(enable, &modeControl, 0x10);
    AudioAmp_write(CONTROL_REG_MODE, modeControl);
}
void AudioAmp_setInputStates(bool in1, bool in2){
    
    setClearByte(in1, &modeControl, 0x08);
    setClearByte(in2, &modeControl, 0x04);

    AudioAmp_write(CONTROL_REG_MODE, modeControl);
}

/* Diagnostic Selection Functions */

void AudioAmp_setILimit(bool supplyDependent){
    setClearByte(supplyDependent, &diagnosticControl, 0x02);
    AudioAmp_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}
void AudioAmp_setDiagnosticEnable(bool enabled){
    setClearByte(enabled, &diagnosticControl, 0x10);
    AudioAmp_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}
void AudioAmp_setContinuousDiagnosticMode(bool continuous){
    setClearByte(continuous, &diagnosticControl, 0x08);
    AudioAmp_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}
void AudioAmp_setDiagnosticReset(bool dgreset){
    setClearByte(dgreset, &diagnosticControl, 0x4);
    AudioAmp_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

/* Fault Functions */
bool AudioAmp_checkFault(void){
    return (!AudioAmp_FLT_PORT);
}

void AudioAmp_getFault(audioAmpFault_t *fault){
    uint8_t dev_fault = ${I2CFunctions["read1ByteRegister"]}(AUDIOAMP_ADDR, CONTROL_REG_FAULT_DETECT);
    
    fault->TSD = dev_fault & (0x01 << 4);
    fault->OCF = dev_fault & (0x01 << 3);
    fault->RAIL_SHT = dev_fault & (0x01 << 2);
    fault->OUTPUT_OPEN = dev_fault & (0x01 << 1);
    fault->OUTPUT_SHORT = dev_fault & 0x01;
}

void AudioAmp_setInput1Volume(uint8_t vol){
    AudioAmp_write(CONTROL_REG_VOLUME_1, vol & 0x1F);
}

void AudioAmp_setInput2Volume(uint8_t vol){
    AudioAmp_write(CONTROL_REG_VOLUME_2, vol & 0x1F);
}
