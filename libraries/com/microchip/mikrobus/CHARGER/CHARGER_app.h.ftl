#include "../mcc.h"

#define MODULE_ENABLE   ${enableModule}

<#if (textSettings??)>
#define TEXT_SETTINGS   ${textSettings}
</#if>

<#if (comboSettings=="Option1")>
#define MODULE_DATA     0x11
<#elseif (comboSettings=="Option2")>
#define MODULE_DATA     0x22
<#elseif (comboSettings=="Option3")>
#define MODULE_DATA     0x33
<#elseif (comboSettings=="Option4")>
#define MODULE_DATA     0x44
</#if>

void CHARGER_Initialize(void);
uint8_t CHARGER_Application(void);