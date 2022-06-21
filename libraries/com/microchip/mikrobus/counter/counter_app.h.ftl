/*
<#include "MicrochipDisclaimer.ftl">
*/
#include <stdint.h>
<#if spiSSPinSettings["spiSlaveSelectLat"] == "">
#warning "Please select a CS pin in MCC pin manager window."
</#if>
void        COUNTER_initialize(void);

void        COUNTER_Reset(void);
uint32_t    COUNTER_read(void);