 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "MIC24045_example.h"
#include "MIC24045.h"

void MIC_Example(){
    MIC_StepToVout(0x0, 10);
    MIC_StepToVout(0x80, 10);
}
