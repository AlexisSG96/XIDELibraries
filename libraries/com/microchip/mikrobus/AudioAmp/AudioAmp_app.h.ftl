 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef AUDIOAMP_CLICK_H
#define	AUDIOAMP_CLICK_H
#include <stdint.h>
#include <stdbool.h>

typedef struct audioAmpFault_t {
    bool TSD;
    bool OCF;
    bool RAIL_SHT;
    bool OUTPUT_OPEN;
    bool OUTPUT_SHORT;
} audioAmpFault_t;

void AudioAmp_setPowerState(bool enable);
void AudioAmp_setInputStates(bool in1, bool in2);

void AudioAmp_setILimit(bool supplyDependent);
void AudioAmp_setDiagnosticEnable(bool enabled);
void AudioAmp_setContinuousDiagnosticMode(bool continuous);
void AudioAmp_setDiagnosticReset(bool dgreset);

bool AudioAmp_checkFault(void);
void AudioAmp_getFault(audioAmpFault_t *fault);
void AudioAmp_setInput1Volume(uint8_t vol);
void AudioAmp_setInput2Volume(uint8_t vol);

#endif	/* AUDIOAMP_CLICK_H*/
