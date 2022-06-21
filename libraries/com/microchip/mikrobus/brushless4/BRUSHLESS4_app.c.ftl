/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "brushless4.h"
#include "${PWMFunctions["pwmHeader"]}"

void BRUSHLESS4_setSpeed(uint8_t speed) {
    ${PWMFunctions["LoadDutyValue"]}((speed / 255.0) * ${clockFactor} * (${periodRegister} + 1));
}
