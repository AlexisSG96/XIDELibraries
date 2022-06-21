/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "MCP73213.h"
#include "MCP73213_example.h"


/**
  Section: Example Code
 */

void MCP73213_example(void) {
    
    // Initialize the click with the charging current value (mA) set in MCC
    MCP73213_setChargingCurrent(MCP73213_INIT_VALUE);
}