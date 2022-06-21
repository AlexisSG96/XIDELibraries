 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifdef __XC
#include <xc.h>
#endif
#include "StereoAmp.h"
#include "${pinHeader}"
#include "drivers/${I2CFunctions["simpleheader"]}"

#define AUDIOAMP_L_ADDR             0x7C
#define AUDIOAMP_R_ADDR             0x7D

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

static void StereoAmp_L_write(uint8_t reg, uint8_t val){
    uint8_t reg_data = (reg << 5) | (val & 0x1F);
    ${I2CFunctions["writeNBytes"]}(AUDIOAMP_L_ADDR, &reg_data, 1);
}

static void StereoAmp_R_write(uint8_t reg, uint8_t val){
    uint8_t reg_data = (reg << 5) | (val & 0x1F);
    ${I2CFunctions["writeNBytes"]}(AUDIOAMP_R_ADDR, &reg_data, 1);
}

static void setClearByte(bool check, uint8_t *target, uint8_t byte){
    *target = check ? (*target | byte) : (*target & !(byte));
}

/* Mode Selection functions */
void StereoAmp_setRightPowerState(bool enable){
    
    setClearByte(enable, &modeControl, 0x10);
    StereoAmp_R_write(CONTROL_REG_MODE, modeControl);
}

void StereoAmp_setLeftPowerState(bool enable){
    
    setClearByte(enable, &modeControl, 0x10);
    StereoAmp_L_write(CONTROL_REG_MODE, modeControl);
}

void StereoAmp_setLeftInputStates(bool in1, bool in2){
    
    setClearByte(in1, &modeControl, 0x08);
    setClearByte(in2, &modeControl, 0x04);

    StereoAmp_L_write(CONTROL_REG_MODE, modeControl);
}

void StereoAmp_setRightInputStates(bool in1, bool in2){
    
    setClearByte(in1, &modeControl, 0x08);
    setClearByte(in2, &modeControl, 0x04);

    StereoAmp_R_write(CONTROL_REG_MODE, modeControl);
}

/* Diagnostic Selection Functions */

void StereoAmp_setLeftILimit(bool supplyDependent){
    setClearByte(supplyDependent, &diagnosticControl, 0x02);
    StereoAmp_L_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setRightILimit(bool supplyDependent){
    setClearByte(supplyDependent, &diagnosticControl, 0x02);
    StereoAmp_R_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setLeftDiagnosticEnable(bool enabled){
    setClearByte(enabled, &diagnosticControl, 0x10);
    StereoAmp_L_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setRightDiagnosticEnable(bool enabled){
    setClearByte(enabled, &diagnosticControl, 0x10);
    StereoAmp_R_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setLeftContinuousDiagnosticMode(bool continuous){
    setClearByte(continuous, &diagnosticControl, 0x08);
    StereoAmp_L_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setRightContinuousDiagnosticMode(bool continuous){
    setClearByte(continuous, &diagnosticControl, 0x08);
    StereoAmp_R_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setLeftDiagnosticReset(bool dgreset){
    setClearByte(dgreset, &diagnosticControl, 0x4);
    StereoAmp_L_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

void StereoAmp_setRightDiagnosticReset(bool dgreset){
    setClearByte(dgreset, &diagnosticControl, 0x4);
    StereoAmp_R_write(CONTROL_REG_DIAGNOSTIC, diagnosticControl);
}

/* Fault Functions */
bool StereoAmp_checkLeftFault(void){
    return (!StereoAmp_FLL_PORT);
}

bool StereoAmp_checkRightFault(void){
    return (!StereoAmp_FLR_PORT);
}

void StereoAmp_getLeftFault(stereoAmpFault_t *fault){
    uint8_t dev_fault = i2c_read1ByteRegister(AUDIOAMP_L_ADDR, CONTROL_REG_FAULT_DETECT);
    
    fault->TSD = dev_fault & (0x01 << 4);
    fault->OCF = dev_fault & (0x01 << 3);
    fault->RAIL_SHT = dev_fault & (0x01 << 2);
    fault->OUTPUT_OPEN = dev_fault & (0x01 << 1);
    fault->OUTPUT_SHORT = dev_fault & 0x01;
}

void StereoAmp_getRightFault(stereoAmpFault_t *fault){
    uint8_t dev_fault = i2c_read1ByteRegister(AUDIOAMP_R_ADDR, CONTROL_REG_FAULT_DETECT);
    
    fault->TSD = dev_fault & (0x01 << 4);
    fault->OCF = dev_fault & (0x01 << 3);
    fault->RAIL_SHT = dev_fault & (0x01 << 2);
    fault->OUTPUT_OPEN = dev_fault & (0x01 << 1);
    fault->OUTPUT_SHORT = dev_fault & 0x01;
}

void StereoAmp_setLeftInput1Volume(uint8_t vol){
    StereoAmp_L_write(CONTROL_REG_VOLUME_1, vol & 0x1F);
}

void StereoAmp_setRightInput1Volume(uint8_t vol){
    StereoAmp_R_write(CONTROL_REG_VOLUME_1, vol & 0x1F);
}

void StereoAmp_setLeftInput2Volume(uint8_t vol){
    StereoAmp_L_write(CONTROL_REG_VOLUME_2, vol & 0x1F);
}

void StereoAmp_setRightInput2Volume(uint8_t vol){
    StereoAmp_R_write(CONTROL_REG_VOLUME_2, vol & 0x1F);
}
