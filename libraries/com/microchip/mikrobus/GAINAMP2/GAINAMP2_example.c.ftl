/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "GAINAMP2_example.h"
#include "GAINAMP2.h"

void GAINAMP2_example(void) {
    <#if (comboSettingsChannel=="0")>
    GAINAMP2_selectChannel(0);
    <#elseif (comboSettingsChannel=="1")>
    GAINAMP2_selectChannel(1);
    <#elseif (comboSettingsChannel=="2")>
    GAINAMP2_selectChannel(2);
    <#elseif (comboSettingsChannel=="3")>
    GAINAMP2_selectChannel(3);
    <#elseif (comboSettingsChannel=="4")>
    GAINAMP2_selectChannel(4);
    <#elseif (comboSettingsChannel=="5")>
    GAINAMP2_selectChannel(5);
    </#if>
    <#if (comboSettingsGain=="1x")>
    GAINAMP2_setGain(GAIN01);
    <#elseif (comboSettingsGain=="2x")>
    GAINAMP2_setGain(GAIN02);
    <#elseif (comboSettingsGain=="4x")>
    GAINAMP2_setGain(GAIN04);
    <#elseif (comboSettingsGain=="5x")>
    GAINAMP2_setGain(GAIN05);
    <#elseif (comboSettingsGain=="8x")>
    GAINAMP2_setGain(GAIN08);
    <#elseif (comboSettingsGain=="10x")>
    GAINAMP2_setGain(GAIN10);
    <#elseif (comboSettingsGain=="16x")>
    GAINAMP2_setGain(GAIN16);
    <#elseif (comboSettingsGain=="32x")>
    GAINAMP2_setGain(GAIN32);
    </#if>
}
