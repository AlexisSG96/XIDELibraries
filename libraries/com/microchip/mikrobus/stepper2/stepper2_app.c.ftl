/*
<#include "MicrochipDisclaimer.ftl">
*/

#include stepper2_app.h
#include "drivers/${moduleFunctions["sampleHeader"]}"

#define CW   0
#define CCW  1

void stepper_Initialize(void) {
    ${RST_PIN_LAT} = 1;
    ${EN_PIN_LAT} = 1;
}

void stepper_step(void) {
    ${ST_PIN_LAT} = 1;
    NOP();
    ${ST_PIN_LAT} = 0;
}

void stepper_setDirectionCW(void) {
    ${DIR_PIN_LAT} = CW;
}

void stepper_setDirectionCCW(void) {
    ${DIR_PIN_LAT} = CCW;
}

void stepper_sleep(void) {
    ${SL_PIN_LAT} = 1;
}

void stepper_wake(void) {
    ${SL_PIN_LAT} = 0;
}

