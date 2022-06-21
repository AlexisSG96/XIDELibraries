 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef STEREOAMP_CLICK_H
#define	STEREOAMP_CLICK_H
#include <stdint.h>
#include <stdbool.h>

typedef struct stereoAmpFault_t {
    bool TSD;
    bool OCF;
    bool RAIL_SHT;
    bool OUTPUT_OPEN;
    bool OUTPUT_SHORT;
} stereoAmpFault_t;

void StereoAmp_setLeftPowerState(bool enable);
void StereoAmp_setRightPowerState(bool enable);
void StereoAmp_setLeftInputStates(bool in1, bool in2);
void StereoAmp_setRightInputStates(bool in1, bool in2);

void StereoAmp_setLeftILimit(bool supplyDependent);
void StereoAmp_setRightILimit(bool supplyDependent);
void StereoAmp_setLeftDiagnosticEnable(bool continuous);
void StereoAmp_setRightDiagnosticEnable(bool continuous);
void StereoAmp_setLeftDiagnosticReset(bool dgreset);
void StereoAmp_setRightDiagnosticReset(bool dgreset);

bool StereoAmp_checkLeftFault(void);
bool StereoAmp_checkRightFault(void);
void StereoAmp_getLeftFault(stereoAmpFault_t *fault);
void StereoAmp_getRightFault(stereoAmpFault_t *fault);
void StereoAmp_setLeftInput1Volume(uint8_t vol);
void StereoAmp_setRightInput1Volume(uint8_t vol);
void StereoAmp_setLeftInput2Volume(uint8_t vol);
void StereoAmp_setRightInput2Volume(uint8_t vol);

#endif


