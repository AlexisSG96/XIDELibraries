/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include <stdio.h>
#include "ammeter.h"
#include "ammeter_example.h"

/**
  Section: Example Code
 */

void Ammeter_example(void) {
    printf("The current measured is: %u mA \n\r", Ammeter_getmACurrent());
}
