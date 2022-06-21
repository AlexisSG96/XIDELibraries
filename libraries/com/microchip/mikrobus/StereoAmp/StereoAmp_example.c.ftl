 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "StereoAmp_example.h"
#include "StereoAmp.h"

void StereoAmp_Example(void){
    StereoAmp_setLeftInputStates(true, false);
    StereoAmp_setRightInputStates(true, false);

    StereoAmp_setLeftPowerState(true);
    StereoAmp_setRightPowerState(true);

    StereoAmp_setLeftDiagnosticEnable(false);
    StereoAmp_setRightDiagnosticEnable(false);

    StereoAmp_setLeftInput1Volume(20);
    StereoAmp_setRightInput1Volume(20);
}
