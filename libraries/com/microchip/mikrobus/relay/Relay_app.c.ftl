/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "Relay_app.h"
#include "${portHeader}"

void RELAY_RL1_Engage(void)
{
    ${relay1Pin.setOutputLevelHigh}
}
void RELAY_RL1_Disengage(void)
{
    ${relay1Pin.setOutputLevelLow}
}
void RELAY_RL2_Engage(void)
{
    ${relay2Pin.setOutputLevelHigh}
}
void RELAY_RL2_Disengage(void)
{
    ${relay2Pin.setOutputLevelLow}
}