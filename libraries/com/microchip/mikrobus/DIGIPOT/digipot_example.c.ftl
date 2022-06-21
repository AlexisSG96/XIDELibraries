/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "digipot.h"
#include "digipot_example.h"

/**
  Section: Example Code
 */

void DigiPot_example(void) {
    
    // Initialize the click with the resistance value (ohms) set in MCC
    DigiPot_setResistance(DIGIPOT_INIT_VALUE);
}
