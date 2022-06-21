/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <math.h>
#include "brushless6.h"
#include "${PWMFunctions["pwmHeader"]}"

/*
 *      Speed   DutyCycle (T = 20 ms)
 *      -Max    5
 *      Off     7.5
 *      +Max    10
 */


static uint16_t toDutyValue(int8_t speed) {
    return round(((7.5 + speed * 5/254.0) / 100) * ${clockFactor} * (${periodRegister} + 1));
}

void BRUSHLESS6_setSpeed(int8_t speed) {
    ${PWMFunctions["LoadDutyValue"]}(toDutyValue(speed));
}

