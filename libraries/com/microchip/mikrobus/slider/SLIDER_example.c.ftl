/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifdef __XC
#include <xc.h>
#endif
#include "${pinHeader}"
#include "slider_example.h"
#include "slider.h"

void SLIDER_example(void) {
    uint16_t pos = SLIDER_getPosition();
    SLIDER_setBar(pos);
}
