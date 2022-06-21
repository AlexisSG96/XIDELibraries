 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "AudioAmp_example.h"
#include "AudioAmp.h"

void AudioAmp_Example(void){
    AudioAmp_setInputStates(true, true);
    AudioAmp_setPowerState(true);
    AudioAmp_setDiagnosticEnable(false);
    AudioAmp_setInput1Volume(20);
    AudioAmp_setInput2Volume(20);
}
