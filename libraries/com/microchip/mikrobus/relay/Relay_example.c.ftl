/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "Relay_app.h"
#include "${DELAYFunctions.delayHeader}"

void Relay_example(void)
{
    RELAY_RL1_Engage();
    RELAY_RL2_Disengage();
    ${DELAYFunctions.delayMs}(1000);

    RELAY_RL1_Disengage();
    RELAY_RL2_Engage();
    ${DELAYFunctions.delayMs}(1000);
}
